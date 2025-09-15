import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/data/models/main_item_model.dart';
import 'package:mocl_flutter/features/database/domain/entities/main_item_data.dart';

class MainItemMapper {
  MainItemMapper._();

  static MainItem toEntity(MainItemModel model, SiteType siteType) => MainItem(
    siteType: siteType,
    board: model.board,
    type: model.type,
    text: model.title,
    url: model.url,
    orderBy: model.no,
  );

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
