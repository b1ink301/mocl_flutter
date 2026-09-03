import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';

part 'favorite_group.freezed.dart';
part 'favorite_group.g.dart';

/// 즐겨찾기 게시판을 묶는 그룹. sembast 의 전역 `favorite_groups` 스토어에 저장된다.
///
/// 게시판을 처음 담는 사이트마다 그 사이트 이름으로 그룹이 자동 생성되고
/// ([siteGroupOf]), 이후 사용자가 이름 변경 / 추가 / 삭제 / 순서 변경을 하거나
/// 다른 사이트 게시판을 끌어와 관심사별 그룹으로 재편할 수 있다.
/// [FavoriteData.group] 이 이 그룹의 [id] 를 참조한다.
@freezed
abstract class FavoriteGroup with _$FavoriteGroup {
  const factory({
    required String id,
    required String name,
    required int orderBy,
    // 접어둔 그룹인지. 앱을 다시 켜도 유지되도록 함께 저장한다.
    @Default(false) bool collapsed,
  }) = _FavoriteGroup;

  factory fromJson(Map<String, dynamic> json) => _$FavoriteGroupFromJson(json);
}

/// 그룹과 그 그룹에 속한 즐겨찾기 게시판 묶음. 메인 화면이 이 단위로 그려진다.
typedef FavoriteSection = ({FavoriteGroup group, List<FavoriteData> items});

/// 사이트에 대응하는 기본 그룹. ID 는 사이트 이름이라 그룹 이름을 바꿔도
/// 같은 사이트의 게시판은 계속 그 그룹으로 들어간다.
FavoriteGroup siteGroupOf(SiteType siteType, int orderBy) =>
    FavoriteGroup(id: siteType.name, name: siteType.title, orderBy: orderBy);
