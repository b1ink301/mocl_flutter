import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';

part 'favorite_data.freezed.dart';
part 'favorite_data.g.dart';

/// 즐겨찾기한 게시판. sembast 의 전역 `favorites` 스토어에 JSON 으로 저장된다.
/// 사이트 경계를 넘어 자주 가는 게시판을 한 곳에 모아, 드로어에서 사이트 전환
/// 없이 바로 진입할 수 있게 한다. [toMainItem] 으로 리스트 진입용 MainItem 을 복원한다.
@freezed
abstract class const FavoriteData._() with _$FavoriteData {
  const factory({
    required SiteType siteType,
    required String board,
    required String text,
    required String url,
    required int type,
    required String icon,
    required int savedAt,
  }) = _FavoriteData;

  factory fromJson(Map<String, dynamic> json) => _$FavoriteDataFromJson(json);

  factory fromMainItem(MainItem item, int savedAt) => FavoriteData(
    siteType: item.siteType,
    board: item.board,
    text: item.text,
    url: item.url,
    type: item.type,
    icon: item.icon,
    savedAt: savedAt,
  );

  MainItem toMainItem() => MainItem(
    siteType: siteType,
    board: board,
    text: text,
    url: url,
    orderBy: 0,
    type: type,
    icon: icon,
  );
}
