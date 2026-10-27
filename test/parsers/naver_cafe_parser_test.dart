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

  group('NaverCafeParser detail 미디어', () {
    Future<String> bodyOf(String fixturePath) async {
      final json = jsonDecode(File(fixturePath).readAsStringSync());
      final result = await const NaverCafeParser().detail(
        Response(
          data: <dynamic>[json, json],
          requestOptions: RequestOptions(path: ''),
        ),
      );
      return result.fold(
        (failure) => fail('파싱 실패: $failure'),
        (details) => details.bodyHtml,
      );
    }

    test('스크랩 글은 원문 본문(이미지)과 원문 링크를 붙인다', () async {
      final body = await bodyOf('test/fixtures/naver_cafe_scrap_detail.json');

      expect(
        body,
        contains(
          '<img src="https://cafeptthumb-phinf.pstatic.net/MjAyNjA5MjhfOTkg/',
        ),
      );
      expect(body, contains('아앗..'));
      expect(body, contains('https://cafe.naver.com/anycallusershow/5272287'));
    });

    test('동영상은 썸네일 자리표시자로 바꾸고 vid/inkey 를 싣는다', () async {
      final body = await bodyOf('test/fixtures/naver_cafe_video_detail.json');

      expect(body, contains('안녕하세요'));
      expect(body, contains('감사합니다~'));
      expect(body, isNot(contains('se-module-video')));
      expect(NaverCafeParser.videoRefsOf(body), [
        (
          vid: 'CBE7DC2BBD5B4D4037D41D86645858D78A44',
          inkey: 'V128c8d9670109a3cd0c0b915120ecaa4c9cf',
        ),
      ]);
      expect(
        body,
        contains(
          'src="https://phinf.pstatic.net/image.nmv/cafe_2026_09_27_3433/nqEtS6DYsE_03.jpg"',
        ),
      );
    });

    test('재생 주소를 받은 영상만 video 로 바꾸고 썸네일은 poster 로 옮긴다', () async {
      final body = await bodyOf('test/fixtures/naver_cafe_video_detail.json');

      final html = NaverCafeParser.applyVideoSources(body, {
        'CBE7DC2BBD5B4D4037D41D86645858D78A44':
            'https://b01-kr-naver-vod.pstatic.net/a.mp4?_lsu_sa_=x&y=1',
      });

      expect(html, contains('<video'));
      expect(
        html,
        contains(
          'src="https://b01-kr-naver-vod.pstatic.net/a.mp4?_lsu_sa_=x&amp;y=1"',
        ),
      );
      expect(
        html,
        contains(
          'poster="https://phinf.pstatic.net/image.nmv/cafe_2026_09_27_3433/nqEtS6DYsE_03.jpg"',
        ),
      );
      expect(html, contains('width="1080"'));
      expect(html, contains('height="1920"'));
      expect(NaverCafeParser.videoRefsOf(html), isEmpty);
    });

    test('재생 정보에서 720p 이하 중 가장 높은 화질을 고른다', () {
      Map<String, dynamic> item(String name, int w, int h) => {
        'encodingOption': {'name': name, 'width': w, 'height': h},
        'source': 'https://vod/$name.mp4',
      };

      expect(
        NaverCafeParser.videoSourceOf({
          'videos': {
            'list': [
              item('480p', 480, 854),
              item('1080p', 1080, 1920),
              item('720p', 720, 1280),
              item('270p', 270, 480),
            ],
          },
        }),
        'https://vod/720p.mp4',
      );
      // 720p 이하가 없으면 가장 작은 것을 쓴다.
      expect(
        NaverCafeParser.videoSourceOf({
          'videos': {
            'list': [item('1080p', 1080, 1920)],
          },
        }),
        'https://vod/1080p.mp4',
      );
      expect(NaverCafeParser.videoSourceOf({'errorCode': 'x'}), isNull);
    });
  });
}
