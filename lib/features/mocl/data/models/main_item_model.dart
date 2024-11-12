import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/features/mocl/data/models/model_mapper.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

part 'main_item_model.freezed.dart';
part 'main_item_model.g.dart';

@freezed
class MainItemModel with _$MainItemModel {
  const factory MainItemModel({
    // ignore: invalid_annotation_target
    @JsonKey(name: 'no')
    required int orderBy,
    required String board,
    required int type,
    // ignore: invalid_annotation_target
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
