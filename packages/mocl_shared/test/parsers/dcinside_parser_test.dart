import 'dart:io';

import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:mocl_shared/entities/mocl_details.dart';
import 'package:mocl_shared/parser/dcinside/dcinside_parser.dart';

import '../helpers/parse_list_harness.dart';

Future<Details> _detail(String fixturePath) async {
  const parser = DcinsideParser();
  final result = await parser.detail(
    Response(
      data: File(fixturePath).readAsStringSync(),
      requestOptions: RequestOptions(path: ''),
    ),
  );
  return result.fold((failure) => fail('파싱 실패: $failure'), (d) => d);
}

void main() {
  group('DcinsideParser list', () {
    test('일반 갤러리는 ginfo 첫 li, 실베는 <b>[갤]</b> 에서 말머리를 읽는다', () async {
      final items = await runParseListWorker(
        DcinsideParser.parseListInWorker,
        responseData: File('test/fixtures/dcinside_list.html')
            .readAsStringSync(),
        baseUrl: 'https://m.dcinside.com',
      );

      expect(items, hasLength(3));
      expect(items[0].category, '질문❓');
      expect(items[0].title, '중고 시세 괜찮나요?');
      // 말머리 없는 갤러리는 첫 li 가 닉네임(list-nick)이다.
      expect(items[1].category, isEmpty);
      expect(items[2].category, '싱갤');
      expect(items[2].title, '실베 글 제목');
    });
  });

  group('DcinsideParser detail', () {
    test('말머리를 떼어 category 로 두고 제목 공백을 접는다', () async {
      final details = await _detail('test/fixtures/dcinside_detail.html');
      expect(details.category, '질문❓');
      expect(details.title, 's24울트라 중고 50중후반대면 ㄱㅊ?');
    });

    test('대괄호로 시작하는 제목은 말머리로 떼지 않는다', () async {
      final details = await _detail(
        'test/fixtures/dcinside_detail_no_category.html',
      );
      expect(details.category, isEmpty);
      expect(details.title, '[속보] 대괄호로 시작하는 제목');
    });
  });
}
