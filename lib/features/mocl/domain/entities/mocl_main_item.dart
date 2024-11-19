import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

part 'mocl_main_item.freezed.dart';

@freezed
class MainItem with _$MainItem {
  const factory MainItem({
    required SiteType siteType,
    required String board,
    required int type,
    required String text,
    required String url,
    required int orderBy,
    @Default(false) bool hasItem,
    @Default('') String icon,
  }) = _MainItem;

  factory MainItem.fromJson(
    Map<String, dynamic> json,
    SiteType siteType,
    int orderBy,
  ) =>
      MainItem(
        siteType: siteType,
        board: json["cafeUrl"],
        type: 0,
        text: json["mobileCafeName"],
        url: json["cafeId"].toString(),
        icon: json["cafeIconImageUrl"],
        orderBy: orderBy,
      );
}
