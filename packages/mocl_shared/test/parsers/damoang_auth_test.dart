import 'dart:convert';

import 'package:test/test.dart';
import 'package:mocl_shared/parser/damoang/damoang_parser.dart';

/// SvelteKit `__data.json` 첫 줄. 레이아웃 노드의 값은 devalue 처럼 인덱스로 가리킨다.
String _layout({required bool loggedIn, String? token, String? csrf}) =>
    jsonEncode({
      'type': 'data',
      'nodes': [
        {
          'type': 'data',
          'data': [
            {'isLoggedIn': 1, 'accessToken': 2, 'csrfToken': 3, 'user': 4},
            loggedIn,
            token,
            csrf,
            null,
          ],
        },
        {
          'type': 'data',
          'data': [
            {'post': 1},
            {'title': 2},
            '제목',
          ],
        },
      ],
    });

void main() {
  group('DamoangParser.parseAuth', () {
    test('로그인 상태면 accessToken 과 csrfToken 을 꺼낸다', () {
      final (loggedIn, token, csrf) = DamoangParser.parseAuth(
        _layout(loggedIn: true, token: 'jwt-abc', csrf: 'csrf-xyz'),
      );
      expect(loggedIn, isTrue);
      expect(token, 'jwt-abc');
      expect(csrf, 'csrf-xyz');
    });

    test('비로그인이면 토큰이 null 로 와도 빈 값으로 돌려준다', () {
      final (loggedIn, token, csrf) = DamoangParser.parseAuth(
        _layout(loggedIn: false),
      );
      expect(loggedIn, isFalse);
      expect(token, isEmpty);
      expect(csrf, isEmpty);
    });

    test('형태가 다르면 비로그인으로 본다', () {
      expect(DamoangParser.parseAuth('not json'), (false, '', ''));
      expect(DamoangParser.parseAuth('{"type":"data","nodes":[]}'), (
        false,
        '',
        '',
      ));
    });
  });
}
