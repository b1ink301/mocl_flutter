import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/features/mocl/data/models/main_item_model.dart';
import 'package:mocl_flutter/features/mocl/data/models/model_mapper.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

part 'main_item_data.freezed.dart';

part 'main_item_data.g.dart';

@freezed
abstract class MainItemData with _$MainItemData {
  const factory MainItemData({
    required String board,
    required String text,
    required String url,
    required SiteType siteType,
    required int orderBy,
    required int type,
  }) = _MainItemData;

  factory MainItemData.fromJson(Map<String, Object?> json) =>
      _$MainItemDataFromJson(json);
}

extension MainItemDataExtention on MainItemData {
  MainItemModel toMainItemModel() => MainItemMapper.toModel(this);
}
