import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';

part 'favorite_data.freezed.dart';
part 'favorite_data.g.dart';

/// 즐겨찾기한 게시판. sembast 의 전역 `favorites` 스토어에 JSON 으로 저장된다.
/// 사이트 경계를 넘어 자주 가는 게시판을 한 곳에 모으며, 메인 화면이 곧 이
/// 목록이다. [group] 이 소속 그룹(FavoriteGroup.id)을, [orderBy] 가 그룹 안에서의
/// 표시 순서를 정한다. [toMainItem] 으로 리스트 진입용 MainItem 을 복원한다.
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
    @Default('') String group,
    @Default(0) int orderBy,
  }) = _FavoriteData;

  factory fromJson(Map<String, dynamic> json) => _$FavoriteDataFromJson(json);

  factory fromMainItem(
    MainItem item,
    int savedAt, {
    String group = '',
    int orderBy = 0,
  }) => FavoriteData(
    siteType: item.siteType,
    board: item.board,
    text: item.text,
    url: item.url,
    type: item.type,
    icon: item.icon,
    savedAt: savedAt,
    group: group,
    orderBy: orderBy,
  );

  MainItem toMainItem() => MainItem(
    siteType: siteType,
    board: board,
    text: text,
    url: url,
    orderBy: orderBy,
    type: type,
    icon: icon,
  );
}
