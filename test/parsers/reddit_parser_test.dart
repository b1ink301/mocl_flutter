import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/reddit/reddit_parser.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../helpers/parse_list_harness.dart';

void main() {
  setUpAll(() {
    timeago.setLocaleMessages('ko', timeago.KoMessages());
  });

  group('RedditParser list', () {
    test('JSON 목록을 파싱하고 HTML 엔티티를 디코딩한다', () async {
      final json = jsonDecode(
        File('test/fixtures/reddit_list.json').readAsStringSync(),
      );

      final items = await runParseListWorker(
        RedditParser.parseListInWorker,
        responseData: json as Object,
        baseUrl: 'https://www.reddit.com',
      );

      expect(items, hasLength(2));

      final first = items[0];
      expect(first.title, 'First post & title');
      expect(first.category, 'Discussion');
      expect(first.reply, '15');
      expect(first.board, 'flutterdev');
      expect(first.url, 'abc123'); // 상세 URL 조립에 쓰이는 post id
      expect(first.userInfo.nickName, 'reddit_user1');
    });

    test('children 이 없으면 빈 목록을 반환한다', () async {
      final items = await runParseListWorker(
        RedditParser.parseListInWorker,
        responseData: {'data': <String, dynamic>{}},
        baseUrl: 'https://www.reddit.com',
      );
      expect(items, isEmpty);
    });
  });

  group('RedditParser detail', () {
    test('본문/댓글 트리를 파싱하고 more 노드는 제외한다', () async {
      final json = jsonDecode(
        File('test/fixtures/reddit_detail.json').readAsStringSync(),
      );
      const parser = RedditParser();

      final result = await parser.detail(
        Response(data: json, requestOptions: RequestOptions(path: '')),
      );

      final details = result.fold(
        (failure) => fail('파싱 실패: $failure'),
        (details) => details,
      );

      expect(details.title, 'Post title');
      expect(details.likeCount, '99');
      expect(details.userInfo.nickName, 'op_user');
      expect(details.bodyHtml, '<div><p>body text</p></div>');

      // kind=more placeholder 는 제외되고 t1 댓글만 남는다.
      expect(details.comments, hasLength(1));
      final top = details.comments[0];
      expect(top.userInfo.nickName, 'commenter1');
      expect(top.bodyHtml, '<p>top comment</p>');
      expect(top.isReply, isFalse);
      expect(top.replies, hasLength(1));
      expect(top.replies[0].userInfo.nickName, 'commenter2');
      expect(top.replies[0].isReply, isTrue);
    });

    test('빈 응답이면 Details.empty 를 반환한다', () async {
      const parser = RedditParser();
      final result = await parser.detail(
        Response(data: null, requestOptions: RequestOptions(path: '')),
      );
      expect(result.isRight(), isTrue);
    });
  });
}
