import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

/// AdMob 광고 단위 ID. 자리마다 단위를 나눠 콘솔에서 성과를 따로 본다.
///
/// release 만 실제 단위를 쓰고, debug · profile 은 Google 테스트 단위로 테스트
/// 광고를 띄운다. (개발 중 실제 광고를 노출 · 클릭하면 계정이 정지될 수 있다)
/// 목록 단위는 빌드할 때 `--dart-define=MOCL_ADMOB_LIST_NATIVE=…` 로 바꿔 끼울 수 있다.
abstract final class AdUnitIds() {
  static const String _listNativeOverride = String.fromEnvironment(
    'MOCL_ADMOB_LIST_NATIVE',
  );

  /// Google 이 공개한 네이티브 광고 테스트 단위.
  static const String _testNative = 'ca-app-pub-3940256099942544/2247696110';

  /// 광고를 쓰는 플랫폼인지. 지금은 Android 만 지원한다(iOS 는 네이티브 팩토리가 없다).
  static bool get enabled => !kIsWeb && Platform.isAndroid;

  /// 게시판 목록의 글 사이.
  static String? get listNative => _pick(
    'ca-app-pub-0000000000000000/0000000000',
    override: _listNativeOverride,
  );

  /// 메인(담아 둔 게시판 목록)의 맨 아래.
  static String? get mainNative =>
      _pick('ca-app-pub-0000000000000000/0000000000');

  /// 글 상세의 본문과 댓글 사이.
  static String? get detailNative =>
      _pick('ca-app-pub-0000000000000000/0000000000');

  static String? _pick(String release, {String override = ''}) {
    if (!enabled) return null;
    if (override.isNotEmpty) return override;
    return kReleaseMode ? release : _testNative;
  }
}
