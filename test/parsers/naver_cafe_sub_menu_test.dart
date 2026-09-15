import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/core/domain/entities/board_path.dart';
import 'package:mocl_flutter/core/domain/entities/last_id.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/naver_cafe/naver_cafe_parser.dart';

/// 카페(컨테이너). url 이 cafeId, board 가 cafeUrl 이다.
const MainItem _cafe = MainItem(
  siteType: SiteType.naverCafe,
  board: 'bbmania',
  text: '블랙베리 스마트폰 카페',
  url: '17654719',
  orderBy: 0,
  hasItem: true,
  icon: 'https://example.com/cafe.png',
);

Response<dynamic> _responseOf(String fixture) => Response<dynamic>(
  data: jsonDecode(File('test/fixtures/$fixture').readAsStringSync()),
  requestOptions: RequestOptions(path: ''),
);

Future<List<MainItem>> _subMenu(String fixture) async {
  const parser = NaverCafeParser();
  final result = await parser.subMenu(_responseOf(fixture), _cafe);
  return result.fold((failure) => fail('파싱 실패: $failure'), (items) => items);
}

void main() {
  group('NaverCafeParser.subMenu', () {
    test('게시판(menuType=B)만 담을 수 있는 항목으로 남긴다', () async {
      final List<MainItem> items = await _subMenu('naver_cafe_side_menu.json');

      // 전체글 1개 + 게시판 7개. 끝말잇기(M) · 등업신청현황(U) · 구분선(S) ·
      // 폴더(F) · 숨긴 게시판은 빠진다.
      expect(items.length, 8);
      expect(
        items.map((item) => item.text),
        containsAllInOrder(<String>['전체글', '공지사항']),
      );
      expect(items.map((item) => item.text), isNot(contains('끝말잇기')));
      expect(items.map((item) => item.text), isNot(contains('등업신청현황')));
      expect(items.map((item) => item.text), isNot(contains('qwerty폰')));
      expect(items.map((item) => item.text), isNot(contains('숨긴게시판')));
    });

    test('맨 앞에 카페 전체글을 넣고, 그 키는 카페 자신과 같다', () async {
      final List<MainItem> items = await _subMenu('naver_cafe_side_menu.json');
      final MainItem all = items.first;

      expect(all.text, '전체글');
      // 예전부터 담아온 '카페' 즐겨찾기와 키가 같아야 이미 담긴 것으로 보인다.
      expect(all.board, _cafe.board);
      expect(isSubBoard(all.board), isFalse);
      expect(all.hasItem, isFalse);
      expect(all.parentText, _cafe.text);
    });

    test('게시판 board 는 부모와의 합성 키다', () async {
      final List<MainItem> items = await _subMenu('naver_cafe_side_menu.json');
      final MainItem board = items.firstWhere(
        (item) => item.text == '공지사항',
      );

      expect(board.board, joinBoard('bbmania', '1'));
      expect(splitBoard(board.board).child, '1');
      // 목록 API 는 cafeId(url)로 조회하므로 부모의 url 을 물려받는다.
      expect(board.url, _cafe.url);
      expect(board.parentBoard, _cafe.board);
      expect(board.parentText, _cafe.text);
      expect(board.icon, _cafe.icon);
      expect(board.hasItem, isFalse);
    });

    test('폴더는 계층이 아니라 섹션 이름(category)으로 눕힌다', () async {
      final List<MainItem> items = await _subMenu('naver_cafe_side_menu.json');
      String categoryOf(String text) =>
          items.firstWhere((item) => item.text.startsWith(text)).category;

      // 폴더 바로 아래 게시판이 indent:false 로 오는 카페도 소속이 끊기지 않는다.
      expect(categoryOf('[qP]질문게시판'), 'qwerty폰');
      expect(categoryOf('[OS10]질문게시판'), 'OS10');
      // 구분선(S) 앞의 최상위 게시판은 폴더가 없다.
      expect(categoryOf('공지사항'), '');
      expect(categoryOf('자유게시판'), '');
    });

    test('메뉴 이름의 HTML 엔티티를 되돌린다', () async {
      final List<MainItem> items = await _subMenu('naver_cafe_side_menu.json');
      final Iterable<String> names = items.map((item) => item.text);

      expect(names, contains('개발관련Q&A'));
      expect(names, contains('[OS7>]질문게시판 (삭제금지)'));
    });

    test('로그인이 필요하면 NotLoginFailure 로 사유를 그대로 올린다', () async {
      const parser = NaverCafeParser();

      final result = await parser.subMenu(
        _responseOf('naver_cafe_side_menu_not_login.json'),
        _cafe,
      );

      final Failure failure = result.fold(
        (failure) => failure,
        (items) => fail('실패해야 한다'),
      );
      expect(failure, isA<NotLoginFailure>());
      expect(failure.message, '로그인이 필요한 기능입니다.');
    });

    test('응답 모양이 어긋나면 화면용 사유로 실패한다', () async {
      const parser = NaverCafeParser();

      final result = await parser.subMenu(
        Response<dynamic>(data: 'not json', requestOptions: RequestOptions()),
        _cafe,
      );

      expect(result.isLeft(), isTrue);
    });
  });

  group('NaverCafeParser.urlBySubMenu / urlByList', () {
    const parser = NaverCafeParser();

    test('하위 메뉴 목록은 cafeId 로 조회한다', () {
      expect(parser.urlBySubMenu(_cafe), contains('cafeId=17654719'));
    });

    test('합성 키면 search.menuid 를 붙인다', () {
      final String url = parser.urlByList(
        _cafe.url,
        joinBoard('bbmania', '110'),
        1,
        SortType.recent,
        const LastId(),
      );

      expect(url, contains('search.clubid=17654719'));
      expect(url, contains('search.menuid=110'));
    });

    test('카페 전체글이면 menuid 없이 카페 전체를 조회한다', () {
      final String url = parser.urlByList(
        _cafe.url,
        _cafe.board,
        1,
        SortType.recent,
        const LastId(),
      );

      expect(url, contains('search.clubid=17654719'));
      expect(url, isNot(contains('search.menuid')));
    });

    test('상세 URL 은 글에서 얻은 cafeId 를 그대로 쓴다(합성 키가 섞이지 않는다)', () {
      // 목록 파서가 ListItem.board 에 cafeId 를 담으므로 상세는 영향을 받지 않는다.
      expect(
        parser.urlByDetail('', '17654719', 616962),
        'https://apis.naver.com/cafe-web/cafe-articleapi/v3/cafes/17654719/articles/616962',
      );
    });
  });

  group('boardPath', () {
    test('합성과 분리가 짝을 이룬다', () {
      expect(splitBoard(joinBoard('bbmania', '110')).parent, 'bbmania');
      expect(splitBoard(joinBoard('bbmania', '110')).child, '110');
    });

    test('합성 키가 아니면 자식이 없다', () {
      expect(splitBoard('park').child, isNull);
      expect(isSubBoard('park'), isFalse);
    });

    test('구분자만 있는 값은 합성 키로 보지 않는다', () {
      expect(splitBoard('/park').child, isNull);
      expect(splitBoard('park/').child, isNull);
    });
  });
}
