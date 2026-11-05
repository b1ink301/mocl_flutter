import 'dart:io';

import 'package:dio/dio.dart';
import 'package:test/test.dart';
import 'package:mocl_shared/parser/clien/clien_parser.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../helpers/parse_list_harness.dart';

void main() {
  setUpAll(() {
    timeago.setLocaleMessages('ko', timeago.KoMessages());
  });

  // 날짜 파싱은 공용 유틸로 통합됨 → parser_date_time_test.dart 참조
  group('ClienParser list', () {
    late String fixture;

    setUpAll(() {
      fixture = File('test/fixtures/clien_list.html').readAsStringSync();
    });

    test('목록을 파싱하고 공지는 제외한다', () async {
      final items = await runParseListWorker(
        ClienParser.parseListInWorker,
        responseData: fixture,
        baseUrl: 'https://m.clien.net',
        readIds: const [19000000],
      );

      expect(items, hasLength(2));

      final first = items[0];
      expect(first.id, 19000001);
      expect(first.title, '첫 번째 글 제목');
      expect(first.reply, '12');
      expect(first.category, '잡담');
      expect(first.board, 'park');
      expect(first.url, 'https://m.clien.net/service/board/park/19000001');
      expect(first.like, '5');
      expect(first.hit, '1234');
      expect(first.hasImage, isTrue);
      expect(first.userInfo.nickName, '홍길동');
      expect(first.isRead, isFalse);

      final second = items[1];
      expect(second.id, 19000000);
      // nickname 엘리먼트가 없으면 img alt 로 폴백한다.
      expect(second.userInfo.nickName, '이미지닉네임');
      expect(second.hasImage, isFalse);
      expect(second.isRead, isTrue);
    });

    test('lastId 이후(같거나 큰) id 는 건너뛴다', () async {
      final items = await runParseListWorker(
        ClienParser.parseListInWorker,
        responseData: fixture,
        baseUrl: 'https://m.clien.net',
        lastId: 19000001,
      );
      expect(items.map((e) => e.id), [19000000]);
    });

    test('빈 HTML 이면 빈 목록을 반환한다', () async {
      final items = await runParseListWorker(
        ClienParser.parseListInWorker,
        responseData: '<html><body></body></html>',
        baseUrl: 'https://m.clien.net',
      );
      expect(items, isEmpty);
    });
  });

  group('ClienParser detail', () {
    test('본문/댓글/메타데이터를 파싱한다', () async {
      final fixture = File('test/fixtures/clien_detail.html')
          .readAsStringSync();
      const parser = ClienParser(false);

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

      expect(details.title, '상세 글 제목');
      expect(details.csrf, 'csrf-token-123');
      expect(details.viewCount, '4321');
      expect(details.likeCount, '42');
      expect(details.userInfo.nickName, '글쓴이닉');
      expect(details.bodyHtml, contains('본문 내용입니다.'));
      // input/button 은 본문에서 제거된다.
      expect(details.bodyHtml, isNot(contains('지워질 버튼')));
      expect(details.bodyHtml, isNot(contains('<input')));

      // 삭제된 댓글은 제외되어 2개만 남는다.
      expect(details.comments, hasLength(2));
      expect(details.comments[0].userInfo.nickName, '댓글러1');
      expect(details.comments[0].isReply, isFalse);
      expect(details.comments[0].likeCount, '3');
      expect(details.comments[0].bodyHtml, contains('첫 번째 댓글'));
      expect(details.comments[1].isReply, isTrue);
      // 비로그인 페이지(IS_LOGIN 없음)는 댓글을 쓸 수 없는 상태로 본다.
      expect(details.isLoggedIn, isFalse);
    });

    test('IS_LOGIN 을 false 로 선언만 하고 다시 대입하지 않으면 비로그인', () async {
      final fixture = File('test/fixtures/clien_detail.html')
          .readAsStringSync()
          .replaceFirst('<body>', '''<body>
<script>
  let IS_LOGIN = false;
  let sessionUserId = '';
</script>''');
      const parser = ClienParser(false);
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
      expect(details.isLoggedIn, isFalse);
    });

    test('댓글 쓰기에 필요한 CSRF · 로그인 · 게시판 값과 댓글 번호를 읽는다', () async {
      final fixture = File('test/fixtures/clien_detail.html')
          .readAsStringSync()
          .replaceFirst('<body>', '''<body>
<script>
  let IS_LOGIN = false;
  let sessionUserId = '';

    IS_LOGIN = true;
    sessionUserId = "writer_id";
  \$.ajaxSetup({
    beforeSend: function(xhr, settings) {
      xhr.setRequestHeader("X-CSRF-TOKEN", "ajax-csrf-456");
    }
  });
</script>
<input type="hidden" value="writer_id" id="writer">
<input type="hidden" value="writer_id" id="loginUserId">
<input type="hidden" value="park" id="boardCd">
<input type="hidden" value="19000001" id="boardSn">''')
          .replaceFirst(
            'data-author-id="commenter1"',
            'data-author-id="commenter1" data-comment-sn="111"',
          )
          .replaceFirst(
            'data-author-id="commenter2"',
            'data-author-id="commenter2" data-comment-sn="112"',
          );
      const parser = ClienParser(false);

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

      // 로그아웃 폼 값보다 ajaxSetup 의 값을 먼저 쓴다.
      expect(details.csrf, 'ajax-csrf-456');
      expect(details.isLoggedIn, isTrue);
      expect(details.commentParams, {
        'boardCd': 'park',
        'boardSn': '19000001',
        'writer': 'writer_id',
      });
      expect(details.comments[0].commentId, '111');
      expect(details.comments[0].parentCommentId, isEmpty);
      // 대댓글의 부모는 바로 위 원댓글이다.
      expect(details.comments[1].commentId, '112');
      expect(details.comments[1].parentCommentId, '111');
    });
  });
}
