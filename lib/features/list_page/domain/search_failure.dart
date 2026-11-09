import 'package:mocl_flutter/core/error/failures.dart';

/// 검색 페이징이 오류로 넘기는 값. 화면이 실패 종류(로그인 필요 등)를 알 수 있게
/// [Failure] 를 그대로 싣는다.
final class SearchFailure(final Failure failure) implements Exception {
  @override
  String toString() => failure.message;
}
