import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/base_parser.dart';

void main() {
  group('BaseParser.parserInfo', () {
    // 닉네임은 더 이상 info 에 포함하지 않는다(UserInfo.nickName 으로 분리 렌더).
    // parserInfo 는 시간ㆍ조회수만 조합한다.
    test('시간·조회수를 ㆍ로 연결한다', () {
      expect(BaseParser.parserInfo('3시간전', '123'), '3시간전ㆍ123 읽음');
    });

    test('시간만 있으면 시간만 반환한다', () {
      expect(BaseParser.parserInfo('3시간전', ''), '3시간전');
    });

    test('조회수만 있으면 "N 읽음" 을 반환한다', () {
      expect(BaseParser.parserInfo('', '7'), '7 읽음');
    });

    test('모두 비어 있으면 빈 문자열을 반환한다', () {
      expect(BaseParser.parserInfo('', ''), '');
    });
  });
}
