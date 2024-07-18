import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/features/mocl/data/models/mocl_model_mapper.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

part 'mocl_main_item_data.freezed.dart';
part 'mocl_main_item_data.g.dart';

@freezed
class MainItemData with _$MainItemData {
  const factory MainItemData({
    @JsonKey(name: 'no')
    required int orderBy,
    required String board,
    required int type,
    @JsonKey(name: 'title')
    required String text,
    required String url,
    SiteType? siteType,
  }) = _MainItemData;

  factory MainItemData.fromJson(Map<String, Object?> json) =>
      _$MainItemDataFromJson(json);

  // @override
  // Map<String, dynamic> toJson() => _$MainItemDataToJson(this);
}

extension MainItemDataExtention on MainItemData {
  MainItem toMainItem(SiteType siteType) => MainItemMapper.toMainItem(
        this,
        siteType,
      );
}
