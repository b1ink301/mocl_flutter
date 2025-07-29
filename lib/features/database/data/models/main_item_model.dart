import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/data/models/model_mapper.dart';

part 'main_item_model.freezed.dart';
part 'main_item_model.g.dart';

@freezed
abstract class MainItemModel with _$MainItemModel {
  const factory MainItemModel({
    @JsonKey(name: 'no')
    required int orderBy,
    required String board,
    required int type,
    @JsonKey(name: 'title')
    required String text,
    required String url,
    SiteType? siteType,
  }) = _MainItemData;

  factory MainItemModel.fromJson(Map<String, Object?> json) =>
      _$MainItemModelFromJson(json);

  // @override
  // Map<String, dynamic> toJson() => _$MainItemDataToJson(this);
}

extension MainItemDataExtention on MainItemModel {
  MainItem toEntity(SiteType siteType) => MainItemMapper.toEntity(
        this,
        siteType,
      );
}
