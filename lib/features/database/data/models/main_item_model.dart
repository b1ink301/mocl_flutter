import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/data/models/model_mapper.dart';

part 'main_item_model.freezed.dart';
part 'main_item_model.g.dart';

@freezed
abstract class MainItemModel with _$MainItemModel {
  const factory({
    required int no,
    required String board,
    required int type,
    required String title,
    required String url,
    SiteType? siteType,
    // 하위 메뉴를 가진 컨테이너인지. board_link.json 에 없으면 false.
    @Default(false) bool hasItem,
    // 2단 게시판을 정적으로 정의할 때의 하위 목록. 없으면 빈 목록이라
    // 기존 board_link.json 과 그대로 호환된다.
    @Default(<MainItemModel>[]) List<MainItemModel> children,
  }) = _MainItemData;

  factory fromJson(Map<String, dynamic> json) => _$MainItemModelFromJson(json);

  // @override
  // Map<String, dynamic> toJson() => _$MainItemDataToJson(this);
}

extension MainItemDataExtention on MainItemModel {
  MainItem toEntity(SiteType siteType) =>
      MainItemMapper.toEntity(this, siteType);
}
