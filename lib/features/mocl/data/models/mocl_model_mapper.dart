import 'package:mocl_flutter/features/mocl/data/models/mocl_main_item_data.dart';
import 'package:mocl_flutter/features/mocl/data/models/mocl_main_item_entity.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

class MainItemMapper {
  MainItemMapper._();

  static MainItem toMainItem(
    MainItemData model,
    SiteType siteType,
  ) =>
      MainItem(
        siteType: siteType,
        board: model.board,
        type: model.type,
        text: model.text,
        url: model.url,
        orderBy: model.orderBy,
      );

  static MainItemData toMainItemData(
    MainItemEntity entity,
  ) =>
      MainItemData(
        siteType: entity.siteType,
        board: entity.board,
        type: entity.type,
        text: entity.text,
        url: entity.url,
        orderBy: entity.orderBy,
      );

  static MainItem fromEntityToMainItem(
    MainItemEntity entity,
  ) =>
      entity.toMainItemModel().toMainItem(entity.siteType);

  static MainItemEntity fromMainItemToMainItemEntity(
    MainItemData item,
  ) {
    var entity = MainItemEntity();
    entity.siteType = item.siteType ?? SiteType.none;
    entity.board = item.board;
    entity.type = item.type;
    entity.text = item.text;
    entity.url = item.url;
    entity.orderBy = item.orderBy;

    return entity;
  }

  static MainItemData fromMainItemToMainItemData(
    MainItem item,
  ) =>
      MainItemData(
        siteType: item.siteType,
        board: item.board,
        type: item.type,
        text: item.text,
        url: item.url,
        orderBy: item.orderBy,
      );
}
