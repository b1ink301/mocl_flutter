// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_update_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appUpdatePromptStore)
final appUpdatePromptStoreProvider = AppUpdatePromptStoreProvider._();

final class AppUpdatePromptStoreProvider
    extends
        $FunctionalProvider<
          AppUpdatePromptStore,
          AppUpdatePromptStore,
          AppUpdatePromptStore
        >
    with $Provider<AppUpdatePromptStore> {
  AppUpdatePromptStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appUpdatePromptStoreProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appUpdatePromptStoreHash();

  @$internal
  @override
  $ProviderElement<AppUpdatePromptStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  AppUpdatePromptStore create(Ref ref) {
    return appUpdatePromptStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppUpdatePromptStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppUpdatePromptStore>(value),
    );
  }
}

String _$appUpdatePromptStoreHash() =>
    r'097fa9d0ada5922ee127b0558f2702cea838e1c8';

/// iOS 용 App Store 버전 확인기(iTunes lookup API).
///
/// 조회 엔진으로만 쓴다. 패키지의 `UpgradeAlert` 는 `package:flutter/material`
/// 다이얼로그라 앱의 `material_ui` 테마 · 지역화를 보지 못하므로, 안내
/// 다이얼로그는 `AppUpdateGate` 가 직접 그리고 미룸 기록도
/// [AppUpdatePromptStore] 로 Android 와 같이 관리한다.

@ProviderFor(upgrader)
final upgraderProvider = UpgraderProvider._();

/// iOS 용 App Store 버전 확인기(iTunes lookup API).
///
/// 조회 엔진으로만 쓴다. 패키지의 `UpgradeAlert` 는 `package:flutter/material`
/// 다이얼로그라 앱의 `material_ui` 테마 · 지역화를 보지 못하므로, 안내
/// 다이얼로그는 `AppUpdateGate` 가 직접 그리고 미룸 기록도
/// [AppUpdatePromptStore] 로 Android 와 같이 관리한다.

final class UpgraderProvider
    extends $FunctionalProvider<Upgrader, Upgrader, Upgrader>
    with $Provider<Upgrader> {
  /// iOS 용 App Store 버전 확인기(iTunes lookup API).
  ///
  /// 조회 엔진으로만 쓴다. 패키지의 `UpgradeAlert` 는 `package:flutter/material`
  /// 다이얼로그라 앱의 `material_ui` 테마 · 지역화를 보지 못하므로, 안내
  /// 다이얼로그는 `AppUpdateGate` 가 직접 그리고 미룸 기록도
  /// [AppUpdatePromptStore] 로 Android 와 같이 관리한다.
  UpgraderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'upgraderProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$upgraderHash();

  @$internal
  @override
  $ProviderElement<Upgrader> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Upgrader create(Ref ref) {
    return upgrader(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Upgrader value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Upgrader>(value),
    );
  }
}

String _$upgraderHash() => r'0a2b23a2b4215cb1a27cc542945606910d6c12e9';

/// 스토어 버전과 비교한 업데이트 상태.
///
/// - Android: Play 인앱 업데이트. 유연 업데이트로 백그라운드에서 받은 뒤
///   다 받으면 [AppUpdatePhase.downloaded] 가 되고, [install] 로 재시작한다.
/// - iOS: App Store 버전과 비교만 하고, 새 버전이면 안내 다이얼로그를 띄울지
///   알려준다. 업데이트는 App Store 상세 화면으로 보내서 한다.

@ProviderFor(AppUpdateNotifier)
final appUpdateProvider = AppUpdateNotifierProvider._();

/// 스토어 버전과 비교한 업데이트 상태.
///
/// - Android: Play 인앱 업데이트. 유연 업데이트로 백그라운드에서 받은 뒤
///   다 받으면 [AppUpdatePhase.downloaded] 가 되고, [install] 로 재시작한다.
/// - iOS: App Store 버전과 비교만 하고, 새 버전이면 안내 다이얼로그를 띄울지
///   알려준다. 업데이트는 App Store 상세 화면으로 보내서 한다.
final class AppUpdateNotifierProvider
    extends $NotifierProvider<AppUpdateNotifier, AppUpdateStatus> {
  /// 스토어 버전과 비교한 업데이트 상태.
  ///
  /// - Android: Play 인앱 업데이트. 유연 업데이트로 백그라운드에서 받은 뒤
  ///   다 받으면 [AppUpdatePhase.downloaded] 가 되고, [install] 로 재시작한다.
  /// - iOS: App Store 버전과 비교만 하고, 새 버전이면 안내 다이얼로그를 띄울지
  ///   알려준다. 업데이트는 App Store 상세 화면으로 보내서 한다.
  AppUpdateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appUpdateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appUpdateNotifierHash();

  @$internal
  @override
  AppUpdateNotifier create() => AppUpdateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(AppUpdateStatus value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<AppUpdateStatus>(value),
    );
  }
}

String _$appUpdateNotifierHash() => r'9aa1094b7c2efda5bfbe564ce2721d7b021bf9a7';

/// 스토어 버전과 비교한 업데이트 상태.
///
/// - Android: Play 인앱 업데이트. 유연 업데이트로 백그라운드에서 받은 뒤
///   다 받으면 [AppUpdatePhase.downloaded] 가 되고, [install] 로 재시작한다.
/// - iOS: App Store 버전과 비교만 하고, 새 버전이면 안내 다이얼로그를 띄울지
///   알려준다. 업데이트는 App Store 상세 화면으로 보내서 한다.

abstract class _$AppUpdateNotifier extends $Notifier<AppUpdateStatus> {
  AppUpdateStatus build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AppUpdateStatus, AppUpdateStatus>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AppUpdateStatus, AppUpdateStatus>,
              AppUpdateStatus,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
