import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';

/// AdMob 광고 단위 ID. 자리마다 단위를 나눠 콘솔에서 성과를 따로 본다.
///
/// 실제 ID 는 저장소에 두지 않고 빌드할 때 `--dart-define-from-file=ads.json` 으로
/// 넣는다(`ads.example.json` 참고). release 에서 값이 비어 있으면 Google 테스트 단위로
/// 떨어진다. debug · profile 은 값이 있어도 항상 테스트 단위를 쓴다.
/// (개발 중 실제 광고를 노출 · 클릭하면 계정이 정지될 수 있다)
abstract final class AdUnitIds() {
  static const String _listNative = String.fromEnvironment(
    'MOCL_ADMOB_LIST_NATIVE',
  );
  static const String _mainNative = String.fromEnvironment(
    'MOCL_ADMOB_MAIN_NATIVE',
  );
  static const String _detailNative = String.fromEnvironment(
    'MOCL_ADMOB_DETAIL_NATIVE',
  );

  /// Google 이 공개한 네이티브 광고 테스트 단위.
  static const String _testNative = 'ca-app-pub-3940256099942544/2247696110';

  /// 광고를 쓰는 플랫폼인지. 지금은 Android 만 지원한다(iOS 는 네이티브 팩토리가 없다).
  static bool get enabled => !kIsWeb && Platform.isAndroid;

  /// 게시판 목록의 글 사이.
  static String? get listNative => _pick(_listNative);

  /// 메인(담아 둔 게시판 목록)의 맨 아래.
  static String? get mainNative => _pick(_mainNative);

  /// 글 상세의 본문과 댓글 사이.
  static String? get detailNative => _pick(_detailNative);

  static String? _pick(String release) {
    if (!enabled) return null;
    return kReleaseMode && release.isNotEmpty ? release : _testNative;
  }
}
