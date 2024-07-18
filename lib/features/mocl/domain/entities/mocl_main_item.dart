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
    @Default(false)
    bool hasItem,
  }) = _MainItem;
}
