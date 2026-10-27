import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/geek_news/geek_news_parser.dart';

import '../helpers/parse_list_harness.dart';

void main() {
  group('GeekNewsParser list', () {
    late String fixture;

    setUpAll(() {
      fixture = File('test/fixtures/geek_news_list.html').readAsStringSync();
    });

    test('신/구 마크업을 모두 파싱하고 id 없는 행은 건너뛴다', () async {
      final items = await runParseListWorker(
        GeekNewsParser.parseListInWorker,
        responseData: fixture,
        baseUrl: 'https://news.hada.io',
        readIds: const [21000],
      );

      expect(items, hasLength(2));

      final first = items[0];
      expect(first.id, 21001);
      expect(first.title, '긱뉴스 첫 번째 토픽');
      expect(first.category, '(example.com)');
      expect(first.like, '42');
      expect(first.reply, '7');
      expect(first.time, '3시간전');
      expect(first.url, 'https://news.hada.io/topic?id=21001');
      expect(first.userInfo.nickName, 'alice');
      expect(first.isRead, isFalse);

      // 구버전 마크업: h1 제목 + span[title] 시간 폴백
      final second = items[1];
      expect(second.id, 21000);
      expect(second.title, '구버전 마크업 토픽');
      expect(second.time, '2일전');
      expect(second.isRead, isTrue);
    });

    test('빈 HTML 이면 빈 목록을 반환한다', () async {
      final items = await runParseListWorker(
        GeekNewsParser.parseListInWorker,
        responseData: '<html><body></body></html>',
        baseUrl: 'https://news.hada.io',
      );
      expect(items, isEmpty);
    });
  });

  group('GeekNewsParser detail', () {
    test('본문/외부링크/댓글 depth 를 파싱한다', () async {
      final fixture = File('test/fixtures/geek_news_detail.html')
          .readAsStringSync();
      const parser = GeekNewsParser();

      final result = await parser.detail(
        Response(
          data: fixture,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final details = result.fold(
        (failure) => fail('파싱 실패: $failure'),
        (details) => details,
      );

      expect(details.title, '긱뉴스 상세 제목');
      expect(details.likeCount, '42');
      expect(details.time, '2026-06-10 12:00:00');
      expect(details.userInfo.nickName, 'alice');
      // 외부 링크가 본문 앞에 추가된다.
      expect(
        details.bodyHtml,
        startsWith('<p><a href="https://example.com/article">'),
      );
      expect(details.bodyHtml, contains('본문 <b>HTML</b> 내용'));

      expect(details.comments, hasLength(2));
      expect(details.comments[0].userInfo.nickName, 'carol');
      expect(details.comments[0].isReply, isFalse);
      expect(details.comments[1].userInfo.nickName, 'dave');
      expect(details.comments[1].isReply, isTrue);
      // 구버전 댓글 시간 마크업(a[href^=comment?id=]) 폴백
      expect(details.comments[1].time, '50분전');
    });
  });
}
