import 'dart:async';

import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:mocl_flutter/app_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/boot_failure_app.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/util/boot_guard.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';
import 'package:mocl_flutter/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/ads/data/mobile_ads_bootstrap.dart';
import 'features/database/application/datasource_provider.dart';
import 'features/database/data/datasources/local/local_database.dart';
import 'features/settings_page/application/datasource_provider.dart';
import 'flavors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await BootGuard(
    prepare: _prepareApp,
    failureBuilder: ({Object? error, VoidCallback? onRetry}) =>
        BootFailureApp(error: error, onRetry: onRetry),
  ).start();
}

/// 오래된 읽음 기록의 보존 기간. 정리는 하루 한 번만 돈다.
const Duration _readHistoryTtl = Duration(days: 180);

/// `runApp` 에 넘길 앱을 만든다. 여기서 던지거나 멈추면 [BootGuard] 가
/// 스플래시 대신 실패 화면을 띄운다. 재시도 때 다시 불리므로 여러 번
/// 불려도 안전해야 한다.
Future<Widget> _prepareApp() async {
  await _initPlatform();

  F.appFlavor = Flavor.values.firstWhere(
    (element) => element.name == appFlavor,
  );

  // 이미지 캐시 상한. 기본값(1000장 / 100MB)은 이미지가 많은 게시물에서
  // 디코딩된 비트맵이 과도하게 쌓여 OOM 을 유발한다.
  PaintingBinding.instance.imageCache
    ..maximumSize = 100
    ..maximumSizeBytes = 40 << 20; // 40MB

  final sharedPrefs = await SharedPreferences.getInstance();
  final database = await openAppDatabase();
  final localDatabase = LocalDatabase(
    database: database,
    opener: openAppDatabase,
  );
  _schedulePruneReads(localDatabase);
  scheduleMobileAdsInit();

  return ProviderScope(
    retry: retry,
    observers: [if (kDebugMode) Logger()],
    overrides: [
      sharedPreferencesProvider.overrideWithValue(sharedPrefs),
      localDatabaseProvider.overrideWithValue(localDatabase),
    ],
    child: const AppWidget(),
  );
}

/// 화면 모드 · Crashlytics. 실패해도 앱은 떠야 하므로 여기서는 던지지 않는다.
Future<void> _initPlatform() async {
  try {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  } catch (e, st) {
    MoclLogger.e('화면 모드 설정 실패', error: e, stackTrace: st);
  }

  // 재시도로 다시 불려도 Firebase 는 한 번만 초기화한다.
  if (Firebase.apps.isNotEmpty) return;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    _installErrorReporting();
  } catch (e, st) {
    // 리포터 없이도 앱은 쓸 수 있다. (이때 MoclLogger.e 는 디버그 콘솔에만 남는다)
    MoclLogger.e('Firebase 초기화 실패', error: e, stackTrace: st);
  }
}

/// 읽음 기록 정리. 스토어 전체를 훑으므로 첫 화면이 뜨고 한숨 돌린 뒤에 돌린다.
void _schedulePruneReads(LocalDatabase localDatabase) {
  WidgetsBinding.instance.addPostFrameCallback((_) {
    Timer(const Duration(seconds: 5), () async {
      try {
        final int removed = await localDatabase.pruneReadsIfDue(
          ttl: _readHistoryTtl,
        );
        MoclLogger.d(() => '[pruneReads] removed=$removed');
      } catch (e, st) {
        MoclLogger.e('읽음 기록 정리 실패', error: e, stackTrace: st);
      }
    });
  });
}

/// 잡히지 않은 예외와 [MoclLogger.e] 로 남긴 에러를 Crashlytics 로 보낸다.
///
/// 디버그 빌드에서는 수집을 끄고 콘솔 출력만 남긴다. 릴리즈에서는 로그가
/// logcat 에 남지 않으므로, 여기서 수집하지 않으면 에러를 볼 방법이 없다.
void _installErrorReporting() {
  final FirebaseCrashlytics crashlytics = FirebaseCrashlytics.instance;
  unawaited(crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode));

  MoclLogger.onError =
      (Object error, StackTrace? stackTrace, {String? reason}) {
        unawaited(crashlytics.recordError(error, stackTrace, reason: reason));
      };

  FlutterError.onError = (FlutterErrorDetails details) {
    // 디버그에서는 프레임워크 기본 출력을 살린다. 릴리즈 콘솔에는 남기지 않는다.
    if (kDebugMode) FlutterError.presentError(details);
    crashlytics.recordFlutterFatalError(details);
  };
  PlatformDispatcher.instance.onError = (Object error, StackTrace stackTrace) {
    unawaited(crashlytics.recordError(error, stackTrace, fatal: true));
    // true 는 "처리됨" 이라 런타임이 아무것도 출력하지 않는다. 디버그에서는
    // false 를 돌려 콘솔에 찍히게 한다. (true 고정이 원인을 숨겼던 적이 있다)
    return !kDebugMode;
  };
}

final class Logger() extends ProviderObserver {
  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    MoclLogger.e(
      'Provider 실패: ${context.provider.name ?? context.provider.runtimeType}',
      error: error,
      stackTrace: stackTrace,
    );
  }
}

/// provider 가 실패했을 때 얼마 뒤 다시 시도할지. null 이면 재시도하지 않는다.
///
/// 재시도하는 동안 riverpod 은 상태를 `AsyncLoading(retrying: true)` 로 잡아두기
/// 때문에, 재시도 대상이면 마지막 시도가 끝날 때까지 화면에 오류가 아예 뜨지
/// 않고 '로딩 중'만 보인다. 그래서 다시 요청하면 결과가 달라질 수 있는
/// 일시적 오류(네트워크 단절 · 서버 5xx)에만 재시도하고, 권한 부족 · 로그인
/// 필요 · 파싱 실패처럼 결과가 확정된 실패는 즉시 화면에 보여준다.
Duration? retry(int retryCount, Object error) {
  if (retryCount >= 3) return null;
  if (error is ProviderException) return null;
  if (error is Failure && error is! NetworkFailure && error is! ServerFailure) {
    return null;
  }

  return Duration(milliseconds: 300 * (1 << retryCount)); // Exponential backoff
}
