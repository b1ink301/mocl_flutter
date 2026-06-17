import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';

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
    // 게시판 추가 다이얼로그에서 카테고리 그룹핑에 쓰는 표시 전용 값.
    // DB 에는 저장하지 않는다(매퍼가 매핑하지 않으면 기본값 '').
    @Default('') String category,
  }) = _MainItem;

  factory MainItem.fromJson(Map<String, dynamic> json) =>
      _$MainItemFromJson(json);

  factory MainItem.empty() => MainItem(
        siteType: SiteType.damoang,
        board: '',
        text: '',
        url: '',
        orderBy: 1,
      );
}
