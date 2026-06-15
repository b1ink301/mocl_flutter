import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/base_parser.dart';

void main() {
  group('BaseParser.parserInfo', () {
    test('닉네임·시간·조회수 모두 있으면 ㆍ로 연결한다', () {
      final info = BaseParser.parserInfo(false, '닉네임', '3시간전', '123');
      expect(info, '닉네임ㆍ3시간전ㆍ123 읽음');
    });

    test('isShowNickImage=true 면 닉네임을 생략한다', () {
      final info = BaseParser.parserInfo(true, '닉네임', '3시간전', '123');
      expect(info, '3시간전ㆍ123 읽음');
    });

    test('빈 값은 건너뛴다', () {
      expect(BaseParser.parserInfo(false, '', '3시간전', ''), '3시간전');
      expect(BaseParser.parserInfo(false, '닉', '', ''), '닉');
      expect(BaseParser.parserInfo(false, '', '', '7'), '7 읽음');
      expect(BaseParser.parserInfo(false, '', '', ''), '');
    });

    test('한글 닉네임은 표시 폭 20(한글 10자) 초과 시 말줄임된다', () {
      final longKorean = '가나다라마바사아자차카'; // 11자 → 폭 22
      final info = BaseParser.parserInfo(false, longKorean, '', '');
      expect(info, '가나다라마바사아자차...');
    });

    test('영문 닉네임은 20자까지 그대로 둔다', () {
      final ascii20 = 'a' * 20;
      expect(BaseParser.parserInfo(false, ascii20, '', ''), ascii20);
      final ascii21 = 'a' * 21;
      expect(BaseParser.parserInfo(false, ascii21, '', ''), '${'a' * 20}...');
    });
  });
}
