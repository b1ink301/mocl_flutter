import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/core/domain/entities/last_id.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';
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

    test('홈 피드는 커뮤니티 이름을 태그로 단다', () async {
      final json = jsonDecode(
        File('test/fixtures/reddit_list.json').readAsStringSync(),
      );

      final items = await runParseListWorker(
        RedditParser.parseListInWorker,
        responseData: json as Object,
        baseUrl: 'https://www.reddit.com',
        boardTitle: RedditParser.homeTitle,
      );

      expect(items.first.category, 'r/flutterdev');
    });

    test('홈은 커뮤니티 경로 없이 첫 화면 피드 URL 을 만든다', () {
      const parser = RedditParser();
      expect(
        parser.urlByList(
          parser.baseUrl,
          RedditParser.homeTitle,
          1,
          SortType.recommend,
          const LastId(intId: -1),
        ),
        'https://api.reddit.com/best?limit=25',
      );
      expect(
        parser.urlByList(
          'https://www.reddit.com/r/flutterdev',
          'r/flutterdev',
          1,
          SortType.recent,
          const LastId(intId: -1),
        ),
        'https://api.reddit.com/r/flutterdev/new?limit=25',
      );
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

  group('RedditParser main', () {
    test('구독 커뮤니티를 이름순 게시판으로 바꾼다', () async {
      const parser = RedditParser();
      final result = await parser.main(
        Response(
          data: {
            'kind': 'Listing',
            'data': {
              'after': null,
              'children': [
                {
                  'kind': 't5',
                  'data': {
                    'display_name': 'linux',
                    'display_name_prefixed': 'r/linux',
                    'community_icon': 'https://styles.redditmedia.com/a.png?width=256&amp;s=1',
                    'icon_img': '',
                  },
                },
                {
                  'kind': 't5',
                  'data': {
                    'display_name': 'FlutterDev',
                    'display_name_prefixed': 'r/FlutterDev',
                    'community_icon': '',
                    'icon_img': 'https://b.thumbs.redditmedia.com/b.png',
                  },
                },
              ],
            },
          },
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final items = result.getOrElse((f) => fail('$f'));
      expect(items.map((e) => e.text), ['r/FlutterDev', 'r/linux']);
      expect(items[0].board, 'r/FlutterDev');
      expect(items[0].url, 'https://www.reddit.com/r/FlutterDev');
      expect(items[0].icon, 'https://b.thumbs.redditmedia.com/b.png');
      expect(
        items[1].icon,
        'https://styles.redditmedia.com/a.png?width=256&s=1',
      );
      expect(
        parser.urlByList(
          items[0].url,
          items[0].text,
          1,
          SortType.recommend,
          const LastId(intId: -1),
        ),
        'https://api.reddit.com/r/FlutterDev/hot?limit=25',
      );
    });
  });

  group('RedditParser detail', () {
    test('본문/댓글 트리를 파싱하고 more 노드는 제외한다', () async {
      final json = jsonDecode(
        File('test/fixtures/reddit_detail.json').readAsStringSync(),
      );
      const parser = RedditParser();

      final result = await parser.detail(
        Response(
          data: json,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      final details = result.fold(
        (failure) => fail('파싱 실패: $failure'),
        (details) => details,
      );

      expect(details.title, 'Post title');
      expect(details.likeCount, '99');
      expect(details.userInfo.nickName, 'op_user');
      expect(details.bodyHtml, '<div><p>body text</p></div>');

      // kind=more placeholder 는 제외되고, 대댓글은 부모 바로 뒤에 펼쳐진다.
      expect(details.comments, hasLength(2));
      final top = details.comments[0];
      expect(top.userInfo.nickName, 'commenter1');
      expect(top.bodyHtml, '<p>top comment</p>');
      expect(top.isReply, isFalse);
      final reply = details.comments[1];
      expect(reply.userInfo.nickName, 'commenter2');
      expect(reply.isReply, isTrue);
    });

    Future<String> bodyOf(Map<String, dynamic> post) async {
      const parser = RedditParser();
      final json = [
        {
          'data': {
            'children': [
              {
                'kind': 't3',
                'data': {
                  'title': 't',
                  'ups': 1,
                  'author': 'a',
                  'author_fullname': 't2_a',
                  'created': 1700000000.0,
                  'selftext_html': null,
                  ...post,
                },
              },
            ],
          },
        },
        {
          'data': {'children': <dynamic>[]},
        },
      ];
      final result = await parser.detail(
        Response(
          data: json,
          requestOptions: RequestOptions(path: ''),
        ),
      );
      return result.getOrElse((f) => fail('$f')).bodyHtml;
    }

    test('유튜브 링크 글은 iframe 과 원문 링크로 본문을 채운다', () async {
      final body = await bodyOf({
        'is_self': false,
        'url': 'https://www.youtube.com/watch?v=NKjfSB09bPw',
        'secure_media_embed': {
          'content': '&lt;iframe src="https://www.youtube.com/embed/NKjfSB09bPw?feature=oembed&amp;enablejsapi=1"&gt;&lt;/iframe&gt;',
        },
      });
      expect(
        body,
        contains('<iframe src="https://www.youtube.com/embed/NKjfSB09bPw'),
      );
      expect(
        body,
        contains('<a href="https://www.youtube.com/watch?v=NKjfSB09bPw">'),
      );
    });

    test('이미지 · 갤러리 · 레딧 동영상 글을 본문으로 만든다', () async {
      expect(
        await bodyOf({
          'is_self': false,
          'post_hint': 'image',
          'url': 'https://i.redd.it/a.jpg',
        }),
        '<p><img src="https://i.redd.it/a.jpg"></p>',
      );
      expect(
        await bodyOf({
          'is_self': false,
          'is_gallery': true,
          'url': 'https://www.reddit.com/gallery/x',
          'gallery_data': {
            'items': [
              {'media_id': 'b'},
              {'media_id': 'a'},
            ],
          },
          'media_metadata': {
            'a': {
              's': {'u': 'https://preview.redd.it/a.jpg?w=1&amp;s=2'},
            },
            'b': {
              's': {'u': 'https://preview.redd.it/b.jpg'},
            },
          },
        }),
        '<p><img src="https://preview.redd.it/b.jpg"></p>'
        '<p><img src="https://preview.redd.it/a.jpg?w=1&amp;s=2"></p>',
      );
      expect(
        await bodyOf({
          'is_self': false,
          'is_video': true,
          'url': 'https://v.redd.it/x',
          'secure_media': {
            'reddit_video': {
              'hls_url': 'https://v.redd.it/x/HLSPlaylist.m3u8?a=1&amp;b=2',
              'fallback_url': 'https://v.redd.it/x/DASH_720.mp4',
            },
          },
        }),
        '<video controls src="https://v.redd.it/x/HLSPlaylist.m3u8?a=1&amp;b=2"></video>',
      );
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
