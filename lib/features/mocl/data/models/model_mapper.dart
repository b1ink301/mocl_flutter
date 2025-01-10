import 'package:mocl_flutter/features/mocl/data/models/main_item_model.dart';
import 'package:mocl_flutter/features/mocl/data/db/entities/main_item_data.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

class MainItemMapper {
  MainItemMapper._();

  static MainItem toEntity(MainItemModel model, SiteType siteType) => MainItem(
        siteType: siteType,
        board: model.board,
        type: model.type,
        text: model.text,
        url: model.url,
        orderBy: model.orderBy,
      );

  static MainItemModel toModel(MainItemData data) => MainItemModel(
        siteType: data.siteType,
        board: data.board,
        type: data.type,
        text: data.text,
        url: data.url,
        orderBy: data.orderBy,
      );

  static MainItem fromDbToEntity(MainItemData data) =>
      data.toMainItemModel().toEntity(data.siteType);

  static MainItemData fromModelToEntity(MainItemModel model) => MainItemData(
        siteType: model.siteType ?? SiteType.damoang,
        board: model.board,
        type: model.type,
        text: model.text,
        url: model.url,
        orderBy: model.orderBy,
      );

  static MainItemModel fromEntityToModel(MainItem entity) => MainItemModel(
        siteType: entity.siteType,
        board: entity.board,
        type: entity.type,
        text: entity.text,
        url: entity.url,
        orderBy: entity.orderBy,
      );
}
