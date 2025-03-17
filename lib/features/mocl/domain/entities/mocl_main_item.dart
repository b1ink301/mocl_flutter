import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

part 'mocl_main_item.freezed.dart';

part 'mocl_main_item.g.dart';

@freezed
abstract class MainItem with _$MainItem {
  const factory MainItem({
    required SiteType siteType,
    required String board,
    required String text,
    required String url,
    required int orderBy,
    @Default(0) int type,
    @Default(false) bool hasItem,
    @Default('') String icon,
  }) = _MainItem;

  factory MainItem.fromJson(Map<String, Object?> json) =>
      _$MainItemFromJson(json);

  factory MainItem.empty() => MainItem(
        siteType: SiteType.damoang,
        board: '',
        text: '',
        url: '',
        orderBy: 1,
      );
}
