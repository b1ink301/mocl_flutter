import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/ppomppu/ppomppu_parser.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() {
  setUpAll(() {
    timeago.setLocaleMessages('ko', timeago.KoMessages());
  });

  Future<Details> detailOf(String path) async {
    const parser = PpomppuParser();
    final result = await parser.detail(
      Response(
        data: File(path).readAsStringSync(),
        requestOptions: RequestOptions(path: ''),
      ),
    );
    return result.fold((failure) => fail('파싱 실패: $failure'), (d) => d);
  }

  group('PpomppuParser detail 코멘트', () {
    test('클라이언트 렌더링(initialCommentData) 코멘트를 읽는다', () async {
      final details = await detailOf(
        'test/fixtures/ppomppu/bbs_view_sort_asc.html',
      );

      expect(details.comments, hasLength(27));

      final first = details.comments.first;
      expect(first.userInfo.nickName, isNotEmpty);
      expect(first.bodyHtml, isNotEmpty);
      // 닉네임 HTML(`<b><a><i class="nlevel">`)에서 글자만 남아야 한다.
      expect(first.userInfo.nickName, isNot(contains('<')));
      expect(first.info, isNotEmpty);
    });

    test('게시판이 최신순으로 내려줘도 작성순으로 정렬한다', () async {
      final details = await detailOf(
        'test/fixtures/ppomppu/bbs_view_sort_desc.html',
      );

      expect(details.comments, hasLength(7));
      final ids = details.comments.map((c) => c.id).toList();
      final sorted = [...ids]..sort();
      expect(ids, sorted);
      expect(details.comments.first.id, 15712238);
      expect(details.comments.last.id, 15713296);
    });

    test('추천 수와 작성 시각을 채운다', () async {
      final details = await detailOf(
        'test/fixtures/ppomppu/bbs_view_sort_desc.html',
      );

      final voted = details.comments.firstWhere((c) => c.likeCount.isNotEmpty);
      expect(voted.likeCount, '1');
      expect(details.comments.first.time, '2026-09-16 09:47');
    });

    test('본문과 제목도 함께 파싱된다', () async {
      final details = await detailOf(
        'test/fixtures/ppomppu/bbs_view_sort_desc.html',
      );

      expect(details.title, isNotEmpty);
      expect(details.bodyHtml, isNotEmpty);
      expect(details.userInfo.nickName, isNotEmpty);
    });
    test('답글은 부모 코멘트 바로 밑에 붙는다', () async {
      // 실제 페이지와 같은 형태의 최소 HTML. 서버가 최신순으로 내려주고
      // 답글(depth=1)이 부모보다 뒤에 오는 상황을 재현한다.
      const html =
          '<html><body><div class="bbs view"><h4>제목</h4>'
          '<div id="KH_Content">본문</div><script>'
          'var initialCommentData = {"comments":['
          '{"no":30,"depth":0,"parent":0,"name":"<b>다</b>",'
          '"memo":"<p>셋째</p>","meta":{"time_display":"2026-09-17 03:00"}},'
          '{"no":20,"depth":1,"parent":10,"name":"<b>나</b>",'
          '"memo":"<p>답글 }; 조심</p>","meta":{"time_display":"2026-09-17 02:00"}},'
          '{"no":10,"depth":0,"parent":0,"name":"<b>가</b>",'
          '"memo":"<p>첫째</p>","meta":{"time_display":"2026-09-17 01:00"}}'
          '],"total_comment":3,"total_page":1,"c_page":1};'
          '</script></div></body></html>';

      const parser = PpomppuParser();
      final result = await parser.detail(
        Response(
          data: html,
          requestOptions: RequestOptions(path: ''),
        ),
      );
      final details = result.fold((f) => fail('파싱 실패: $f'), (d) => d);

      expect(details.comments.map((c) => c.id).toList(), [10, 20, 30]);
      expect(details.comments.map((c) => c.isReply).toList(), [
        false,
        true,
        false,
      ]);
      // 코멘트 본문에 `};` 가 들어가도 JSON 을 끝까지 잘라내야 한다.
      expect(details.comments[1].bodyHtml, contains('};'));
      expect(details.comments[2].userInfo.nickName, '다');
    });
  });
}
