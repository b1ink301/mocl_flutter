import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:in_app_update/in_app_update.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';
import 'package:mocl_flutter/features/settings_page/application/datasource_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:upgrader/upgrader.dart';

import '../data/app_update_prompt_store.dart';
import '../domain/app_update_status.dart';

part 'app_update_providers.g.dart';

/// Play Console 에서 이 값 이상으로 올린 업데이트는 전체 화면(즉시) 업데이트로
/// 받는다. 우선순위는 Play Developer API 로만 정할 수 있고 기본값은 0 이다.
const int _immediatePriority = 4;

@riverpod
AppUpdatePromptStore appUpdatePromptStore(Ref ref) =>
    AppUpdatePromptStore(ref.watch(sharedPreferencesProvider));

/// iOS 용 App Store 버전 확인기(iTunes lookup API).
///
/// 조회 엔진으로만 쓴다. 패키지의 `UpgradeAlert` 는 `package:flutter/material`
/// 다이얼로그라 앱의 `material_ui` 테마 · 지역화를 보지 못하므로, 안내
/// 다이얼로그는 `AppUpdateGate` 가 직접 그리고 미룸 기록도
/// [AppUpdatePromptStore] 로 Android 와 같이 관리한다.
@Riverpod(keepAlive: true)
Upgrader upgrader(Ref ref) {
  final Upgrader upgrader = Upgrader(
    // 한국 스토어 기준으로 조회한다. 단말 지역이 달라도 같은 결과를 본다.
    countryCode: 'KR',
    languageCode: 'ko',
    // 다시 확인하는 시점은 우리가 정한다(앱 실행 · 설정에서 수동 확인).
    checkOnResume: false,
    debugLogging: kDebugMode,
  );
  ref.onDispose(upgrader.dispose);
  return upgrader;
}

/// 스토어 버전과 비교한 업데이트 상태.
///
/// - Android: Play 인앱 업데이트. 유연 업데이트로 백그라운드에서 받은 뒤
///   다 받으면 [AppUpdatePhase.downloaded] 가 되고, [install] 로 재시작한다.
/// - iOS: App Store 버전과 비교만 하고, 새 버전이면 안내 다이얼로그를 띄울지
///   알려준다. 업데이트는 App Store 상세 화면으로 보내서 한다.
@Riverpod(keepAlive: true)
class AppUpdateNotifier() extends _$AppUpdateNotifier {
  StreamSubscription<InstallStatus>? _installStatus;

  /// 유연 업데이트를 시작했는지. 플러그인이 시작할 때마다 리스너를 하나씩
  /// 더 붙이므로 사용자가 거절하기 전까지는 다시 시작하지 않는다.
  bool _flexibleStarted = false;

  @override
  AppUpdateStatus build() {
    ref.onDispose(() => _installStatus?.cancel());
    return const AppUpdateStatus();
  }

  bool get _isAndroid => defaultTargetPlatform == TargetPlatform.android;

  bool get _isIOS => defaultTargetPlatform == TargetPlatform.iOS;

  /// 앱이 뜬 뒤 한 번 부른다. 같은 버전은 [AppUpdatePromptStore.interval]
  /// 동안 다시 묻지 않는다.
  ///
  /// Android 는 Play 가 자체 시트를 띄우므로 늘 false 다. iOS 는 안내
  /// 다이얼로그를 띄워야 하면 true 를 돌려준다.
  Future<bool> checkOnLaunch() async {
    if (_isAndroid) {
      await _checkPlay(manual: false);
      return false;
    }
    if (!_isIOS) return false;

    await _checkAppStore();
    final String? version = state.storeVersion;
    if (state.phase != AppUpdatePhase.available || version == null) {
      return false;
    }
    final AppUpdatePromptStore prompts = ref.read(appUpdatePromptStoreProvider);
    if (!prompts.shouldPrompt(version)) return false;
    await prompts.markPrompted(version);
    return true;
  }

  /// 설정 화면에서 직접 확인한다. 미룸 기간을 무시하고 바로 묻는다.
  /// 확인 결과(최신 · 확인 불가)를 돌려준다.
  Future<AppUpdatePhase> checkManually() async {
    if (state.phase == AppUpdatePhase.checking) return state.phase;
    if (_isAndroid) {
      await _checkPlay(manual: true);
    } else if (_isIOS) {
      await _checkAppStore();
    }
    return state.phase;
  }

  /// 받은 업데이트를 설치한다. Android 는 앱이 재시작되고, iOS 는 App Store
  /// 상세 화면으로 보낸다.
  Future<void> install() async {
    try {
      if (_isAndroid) {
        switch (state.phase) {
          case AppUpdatePhase.downloaded:
            await InAppUpdate.completeFlexibleUpdate();
          case AppUpdatePhase.available:
            await _checkPlay(manual: true);
          default:
            break;
        }
      } else if (_isIOS) {
        await ref.read(upgraderProvider).sendUserToAppStore();
      }
    } catch (e, st) {
      MoclLogger.e('앱 업데이트 설치 실패', error: e, stackTrace: st);
    }
  }

  Future<void> _checkPlay({required bool manual}) async {
    state = state.copyWith(phase: AppUpdatePhase.checking);

    final AppUpdateInfo info;
    try {
      info = await InAppUpdate.checkForUpdate();
    } on PlatformException catch (e) {
      // Play 에서 설치하지 않은 빌드(debug · 사이드로드)는 -10(앱 소유자 없음)
      // 으로 실패한다. 정상적인 상황이라 Crashlytics 로 보내지 않는다.
      MoclLogger.w(() => '[appUpdate] Play 확인 불가: ${e.code} ${e.message}');
      state = const AppUpdateStatus(phase: AppUpdatePhase.unavailable);
      return;
    }
    MoclLogger.d(() => '[appUpdate] $info');

    final String? version = info.availableVersionCode?.toString();
    switch (info.installStatus) {
      // 지난 실행에서 받아 둔 업데이트가 설치를 기다리고 있다.
      case InstallStatus.downloaded:
        state = AppUpdateStatus(
          phase: AppUpdatePhase.downloaded,
          storeVersion: version,
        );
        return;
      case InstallStatus.pending:
      case InstallStatus.downloading:
        _listenInstallStatus();
        state = AppUpdateStatus(
          phase: AppUpdatePhase.downloading,
          storeVersion: version,
        );
        return;
      default:
        break;
    }

    if (info.updateAvailability != UpdateAvailability.updateAvailable ||
        version == null) {
      state = const AppUpdateStatus(phase: AppUpdatePhase.upToDate);
      return;
    }

    state = AppUpdateStatus(
      phase: AppUpdatePhase.available,
      storeVersion: version,
    );

    final AppUpdatePromptStore prompts = ref.read(appUpdatePromptStoreProvider);
    if (!manual && !prompts.shouldPrompt(version)) {
      MoclLogger.d(() => '[appUpdate] $version 은 최근에 안내해서 건너뛴다');
      return;
    }
    await prompts.markPrompted(version);

    final bool urgent = info.updatePriority >= _immediatePriority;
    if ((urgent || !info.flexibleUpdateAllowed) &&
        info.immediateUpdateAllowed) {
      await _startImmediate();
    } else if (info.flexibleUpdateAllowed) {
      await _startFlexible();
    }
  }

  /// 전체 화면 업데이트. 성공하면 Play 가 앱을 재시작하므로 돌아오지 않는다.
  Future<void> _startImmediate() async {
    try {
      final AppUpdateResult result = await InAppUpdate.performImmediateUpdate();
      MoclLogger.d(() => '[appUpdate] immediate: $result');
    } on PlatformException catch (e) {
      MoclLogger.w(() => '[appUpdate] 즉시 업데이트 실패: ${e.code}');
    }
  }

  /// Play 의 동의 시트를 띄우고, 동의하면 백그라운드에서 받는다.
  Future<void> _startFlexible() async {
    if (_flexibleStarted) return;
    _flexibleStarted = true;
    _listenInstallStatus();

    try {
      // 다 받거나(success) 사용자가 거절할 때 끝난다.
      final AppUpdateResult result = await InAppUpdate.startFlexibleUpdate();
      MoclLogger.d(() => '[appUpdate] flexible: $result');
      if (result == AppUpdateResult.success) {
        state = state.copyWith(phase: AppUpdatePhase.downloaded);
        return;
      }
    } on PlatformException catch (e) {
      MoclLogger.w(() => '[appUpdate] 유연 업데이트 실패: ${e.code} ${e.message}');
    }
    _flexibleStarted = false;
    if (state.phase != AppUpdatePhase.downloaded) {
      state = state.copyWith(phase: AppUpdatePhase.available);
    }
  }

  void _listenInstallStatus() {
    _installStatus ??= InAppUpdate.installUpdateListener.listen(
      (InstallStatus status) {
        final AppUpdatePhase? phase = switch (status) {
          InstallStatus.pending ||
          InstallStatus.downloading => AppUpdatePhase.downloading,
          InstallStatus.downloaded => AppUpdatePhase.downloaded,
          InstallStatus.failed ||
          InstallStatus.canceled => AppUpdatePhase.available,
          _ => null,
        };
        if (phase != null && phase != state.phase) {
          state = state.copyWith(phase: phase);
        }
      },
      onError: (Object e, StackTrace st) =>
          MoclLogger.w(() => '[appUpdate] 설치 상태 수신 실패: $e'),
    );
  }

  Future<void> _checkAppStore() async {
    state = state.copyWith(phase: AppUpdatePhase.checking);
    try {
      final Upgrader upgrader = ref.read(upgraderProvider);
      await upgrader.initialize();
      await upgrader.updateVersionInfo();
      final String? storeVersion = upgrader.currentAppStoreVersion;
      if (storeVersion == null) {
        // App Store 에 없거나(미출시 · 번들 ID 불일치) 네트워크 실패.
        state = const AppUpdateStatus(phase: AppUpdatePhase.unavailable);
      } else if (upgrader.isUpdateAvailable()) {
        state = AppUpdateStatus(
          phase: AppUpdatePhase.available,
          storeVersion: storeVersion,
        );
      } else {
        state = AppUpdateStatus(
          phase: AppUpdatePhase.upToDate,
          storeVersion: storeVersion,
        );
      }
    } catch (e, st) {
      MoclLogger.w(() => '[appUpdate] App Store 확인 실패: $e\n$st');
      state = const AppUpdateStatus(phase: AppUpdatePhase.unavailable);
    }
  }
}
