import 'dart:io';

import 'package:dio/dio.dart';
import 'package:mocl_shared/entities/mocl_details.dart';
import 'package:mocl_shared/parser/nate/nate_parser.dart';
import 'package:test/test.dart';

/// 2026-11 개편된 네이트판 글 페이지(Tailwind · JSON-LD)와 전체 댓글 페이지(옛 마크업).
/// 픽스처는 실제 구조를 따라 만든 가짜 글이다.
void main() {
  late String article;
  late String replies;

  setUpAll(() {
    article = File('test/fixtures/nate_detail.html').readAsStringSync();
    replies = File('test/fixtures/nate_reply.html').readAsStringSync();
  });

  Future<Details> parse(Object data) async {
    final result = await const NateParser().detail(
      Response(
        data: data,
        requestOptions: RequestOptions(path: ''),
      ),
    );
    return result.fold((f) => fail('파싱 실패: $f'), (d) => d);
  }

  test('새 화면: 헤더 다음 칸에서 본문을 읽고 광고 · 스크립트는 뺀다', () async {
    final Details d = await parse(article);
    expect(d.title, '테스트 글 제목');
    expect(d.bodyHtml, contains('본문 첫 문단'));
    expect(d.bodyHtml, contains('<img src="https://example.com/a.jpg">'));
    expect(d.bodyHtml, isNot(contains('script')));
    expect(d.bodyHtml, isNot(contains('adsbygoogle')));
    expect(d.bodyHtml, isNot(contains('#태그')), reason: '태그 목록은 본문이 아니다');
  });

  test('작성자 · 시각 · 조회 · 추천은 구조화 데이터와 헤더에서', () async {
    final Details d = await parse(article);
    expect(d.userInfo.nickName, '글쓴이');
    expect(d.time, '2026.11.04 15:09');
    expect(d.viewCount, '22105');
    expect(d.likeCount, '11');
  });

  test('댓글 페이지가 없으면 구조화 데이터의 베스트 댓글', () async {
    final Details d = await parse(article);
    expect(d.comments.map((c) => c.bodyHtml), ['베스트 댓글 하나', '베스트 댓글 둘']);
    expect(d.comments.first.info, '[베플] 11.05 10:28');
    expect(d.comments.first.userInfo.nickName, '베플1');
  });

  test('[글, 댓글 페이지] 로 받으면 전체 댓글을 쓴다(빈 댓글 · 버튼 글자 제외)', () async {
    final Details d = await parse([article, replies]);
    expect(d.comments.map((c) => c.bodyHtml), ['베스트 댓글 하나', '일반 댓글']);
    expect(d.comments.first.info, '[베플] 2026.11.05 10:28');
    expect(d.comments.last.userInfo.nickName, '댓글러');
    expect(d.comments.last.info, '2026.11.05 11:00');
  });

  test('본문 마크업을 못 찾으면 구조화 데이터 글자를 이스케이프해 보여 준다', () async {
    final String noBody = article.replaceFirst(
      RegExp(r'<div class="flex flex-col gap-5.*?</ul>\s*</div>', dotAll: true),
      '',
    );
    final Details d = await parse(noBody);
    expect(d.bodyHtml, '<p>첫 줄입니다.</p><p>둘째 줄 &lt;b&gt;태그&lt;/b&gt;</p>');
  });
}
