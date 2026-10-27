import 'package:mocl_flutter/core/domain/entities/board_path.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/data/models/main_item_model.dart';
import 'package:mocl_flutter/features/database/domain/entities/main_item_data.dart';

class MainItemMapper._() {
  static MainItem toEntity(MainItemModel model, SiteType siteType) => MainItem(
    siteType: siteType,
    board: model.board,
    type: model.type,
    text: model.title,
    url: model.url,
    orderBy: model.no,
    // children 을 가진 항목은 '담기'가 아니라 '진입' 대상이다.
    hasItem: model.hasItem || model.children.isNotEmpty,
  );

  /// 정적 목록(board_link.json)의 `children` 을 하위 메뉴 [MainItem] 으로 펼친다.
  /// board 는 부모와의 합성 키가 되어 즐겨찾기 유일성을 유지한다.
  static List<MainItem> childrenToEntity(
    MainItemModel parent,
    SiteType siteType,
  ) => [
    for (final MainItemModel child in parent.children)
      MainItem(
        siteType: siteType,
        board: joinBoard(parent.board, child.board),
        type: child.type,
        text: child.title,
        url: child.url.isNotEmpty ? child.url : parent.url,
        orderBy: child.no,
        parentBoard: parent.board,
        parentText: parent.title,
      ),
  ];

  static MainItemModel toModel(MainItemData data) => MainItemModel(
    siteType: data.siteType,
    board: data.board,
    type: data.type,
    title: data.text,
    url: data.url,
    no: data.orderBy,
  );

  static MainItem fromDbToEntity(MainItemData data) =>
      data.toMainItemModel().toEntity(data.siteType);

  static MainItemData fromModelToEntity(MainItemModel model) => MainItemData(
    siteType: model.siteType ?? SiteType.damoang,
    board: model.board,
    type: model.type,
    text: model.title,
    url: model.url,
    orderBy: model.no,
  );

  static MainItemModel fromEntityToModel(MainItem entity) => MainItemModel(
    siteType: entity.siteType,
    board: entity.board,
    type: entity.type,
    title: entity.text,
    url: entity.url,
    no: entity.orderBy,
  );
}
