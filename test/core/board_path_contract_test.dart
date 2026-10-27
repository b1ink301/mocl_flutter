import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/core/domain/entities/board_path.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/data/models/main_item_model.dart';
import 'package:mocl_flutter/features/database/data/models/model_mapper.dart';

void main() {
  group('board 합성 키 전제', () {
    // 하위 메뉴는 board 를 '부모/자식' 합성 키로 저장한다. 큐레이션 목록의
    // board 값에 '/' 가 섞이면 그 게시판이 하위 메뉴로 오해된다.
    test('board_link.json 의 board 에는 구분자(/)가 없다', () {
      final List<String> offenders = [];

      for (final SiteType siteType in SiteType.values) {
        final File file = File(
          'assets/${siteType.name.toLowerCase()}/board_link.json',
        );
        if (!file.existsSync()) continue;

        final List<dynamic> boards =
            jsonDecode(file.readAsStringSync()) as List<dynamic>;
        for (final dynamic board in boards) {
          final String value = (board as Map)['board'].toString();
          if (isSubBoard(value)) {
            offenders.add('${siteType.name}: $value');
          }
        }
      }

      expect(offenders, isEmpty, reason: '합성 키와 충돌하는 board 값');
    });
  });

  group('MainItemModel children', () {
    test('children 이 없는 기존 목록은 그대로 단일 게시판이다', () {
      final MainItemModel model = MainItemModel.fromJson(const {
        'board': 'park',
        'title': '모두의공원',
        'type': 0,
        'url': 'https://m.clien.net/service/board/park',
        'no': 1,
      });

      expect(model.children, isEmpty);
      expect(model.hasItem, isFalse);
      expect(model.toEntity(SiteType.clien).hasItem, isFalse);
    });

    test('children 이 있으면 컨테이너가 되고 하위 게시판이 합성 키로 펼쳐진다', () {
      final MainItemModel model = MainItemModel.fromJson(const {
        'board': 'lol',
        'title': '리그오브레전드',
        'type': 0,
        'url': 'https://m.inven.co.kr/board/lol',
        'no': 0,
        'children': [
          {
            'board': '4625',
            'title': '자유게시판',
            'type': 0,
            'url': '',
            'no': 0,
          },
        ],
      });

      expect(model.toEntity(SiteType.inven).hasItem, isTrue);

      final List<MainItem> children = MainItemMapper.childrenToEntity(
        model,
        SiteType.inven,
      );
      expect(children.single.board, joinBoard('lol', '4625'));
      expect(children.single.parentBoard, 'lol');
      expect(children.single.parentText, '리그오브레전드');
      // 자식 url 이 비어 있으면 부모 url 을 물려받는다.
      expect(children.single.url, 'https://m.inven.co.kr/board/lol');
    });
  });
}
