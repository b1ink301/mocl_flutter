import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

/// AdMob 광고 단위 ID.
///
/// release 만 실제 단위를 쓰고, debug · profile 은 Google 테스트 단위로 테스트
/// 광고를 띄운다. (개발 중 실제 광고를 노출 · 클릭하면 계정이 정지될 수 있다)
/// 빌드할 때 `--dart-define=MOCL_ADMOB_LIST_NATIVE=…` 로 바꿔 끼울 수 있다.
abstract final class AdUnitIds() {
  static const String _listNativeOverride = String.fromEnvironment(
    'MOCL_ADMOB_LIST_NATIVE',
  );

  /// 목록 네이티브 광고(실제).
  static const String _listNativeRelease =
      'ca-app-pub-0000000000000000/0000000000';

  /// Google 이 공개한 네이티브 광고 테스트 단위.
  static const String _testNative = 'ca-app-pub-3940256099942544/2247696110';

  /// 목록 사이에 넣는 네이티브 광고. 광고를 쓰지 않으면 null.
  /// 지금은 Android 만 지원한다(iOS 는 네이티브 팩토리가 없다).
  static String? get listNative {
    if (kIsWeb || !Platform.isAndroid) return null;
    if (_listNativeOverride.isNotEmpty) return _listNativeOverride;
    return kReleaseMode ? _listNativeRelease : _testNative;
  }
}
