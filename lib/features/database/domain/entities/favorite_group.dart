import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_category.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';

part 'favorite_group.freezed.dart';
part 'favorite_group.g.dart';

/// 즐겨찾기 게시판을 묶는 그룹. sembast 의 전역 `favorite_groups` 스토어에 저장된다.
/// 최초 실행 시 [kSiteCategories] 를 기본 그룹으로 시드하고, 이후 사용자가
/// 이름 변경 / 추가 / 삭제 / 순서 변경을 할 수 있다.
/// [FavoriteData.group] 이 이 그룹의 [id] 를 참조한다.
@freezed
abstract class FavoriteGroup with _$FavoriteGroup {
  const factory({
    required String id,
    required String name,
    required int orderBy,
  }) = _FavoriteGroup;

  factory fromJson(Map<String, dynamic> json) => _$FavoriteGroupFromJson(json);
}

/// 그룹과 그 그룹에 속한 즐겨찾기 게시판 묶음. 메인 화면이 이 단위로 그려진다.
typedef FavoriteSection = ({FavoriteGroup group, List<FavoriteData> items});

/// 기본 그룹 시드 값. 사이트 카테고리 정의를 그대로 그룹으로 옮긴다.
List<FavoriteGroup> defaultFavoriteGroups() => [
  for (int i = 0; i < kSiteCategories.length; i++)
    FavoriteGroup(
      id: kSiteCategories[i].id,
      name: kSiteCategories[i].label,
      orderBy: i,
    ),
];
