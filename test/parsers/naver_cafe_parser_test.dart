import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/naver_cafe/naver_cafe_parser.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() {
  setUpAll(() {
    timeago.setLocaleMessages('ko', timeago.KoMessages());
  });

  group('NaverCafeParser detail', () {
    late Map<String, dynamic> fixture;

    setUpAll(() {
      fixture = jsonDecode(
        File('test/fixtures/naver_cafe_market_detail.json').readAsStringSync(),
      ) as Map<String, dynamic>;
    });

    test('중고거래 글은 설명과 상품 사진을 본문으로 만든다', () async {
      const parser = NaverCafeParser();

      final result = await parser.detail(
        Response(
          data: <dynamic>[fixture, fixture],
          requestOptions: RequestOptions(path: ''),
        ),
      );
      final details = result.fold(
        (failure) => fail('파싱 실패: $failure'),
        (details) => details,
      );

      expect(details.title, '낫싱폰2 12/512 화이트 팝니다');
      // contentHtml 이 비어 있어도 본문이 만들어져야 한다.
      expect(details.bodyHtml, contains('400,000원'));
      expect(details.bodyHtml, contains('판매중'));
      expect(details.bodyHtml, contains('기기단품 상태 좋아요<br>박스랑 구성품 없고'));
      expect(
        details.bodyHtml,
        contains('<img src="https://nflea-phinf.pstatic.net/A/IMG_6070.jpeg"'),
      );
      expect(
        details.bodyHtml,
        contains('<img src="https://nflea-phinf.pstatic.net/B/IMG_6073.jpeg"'),
      );
    });

    test('일반 글은 contentHtml 을 그대로 쓴다', () async {
      const parser = NaverCafeParser();
      final normal = jsonDecode(jsonEncode(fixture)) as Map<String, dynamic>;
      (normal['result']['article'] as Map)['contentHtml'] = '<p>일반 글 본문</p>';
      normal['result'].remove('nfleaProduct');

      final result = await parser.detail(
        Response(
          data: <dynamic>[normal, normal],
          requestOptions: RequestOptions(path: ''),
        ),
      );
      final details = result.fold(
        (failure) => fail('파싱 실패: $failure'),
        (details) => details,
      );

      expect(details.bodyHtml, '<p>일반 글 본문</p>');
    });

    test('읽기 권한이 없으면(4005) 권한 실패와 서버 사유를 돌려준다', () async {
      const parser = NaverCafeParser();
      final denied = <String, dynamic>{
        'result': {'errorCode': '4005', 'reason': '게시글을 읽기 위한 레벨이 부족합니다.'},
      };
      final commentError = <String, dynamic>{
        'errorCode': '9999',
        'errorMessage': '오류가 발생하였습니다.',
      };

      final result = await parser.detail(
        Response(
          data: <dynamic>[denied, commentError],
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final failure = result.fold((failure) => failure, (_) => null);
      expect(failure, isA<PermissionFailure>());
      expect(failure!.message, '게시글을 읽기 위한 레벨이 부족합니다.');
    });

    test('댓글 API 만 실패하면(9999) 본문은 그대로 보여준다', () async {
      const parser = NaverCafeParser();
      final normal = jsonDecode(jsonEncode(fixture)) as Map<String, dynamic>;
      (normal['result']['article'] as Map)['contentHtml'] = '<p>본문</p>';

      final result = await parser.detail(
        Response(
          data: <dynamic>[
            normal,
            <String, dynamic>{
              'errorCode': '9999',
              'errorMessage': '오류가 발생하였습니다.',
            },
          ],
          requestOptions: RequestOptions(path: ''),
        ),
      );
      final details = result.fold(
        (failure) => fail('파싱 실패: $failure'),
        (details) => details,
      );

      expect(details.bodyHtml, '<p>본문</p>');
      expect(details.comments, isEmpty);
    });
  });
}
