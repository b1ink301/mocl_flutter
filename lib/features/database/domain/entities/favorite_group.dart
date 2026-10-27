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

/// 그룹 안에서 같은 부모(네이버 카페 등)의 게시판을 한 번 더 묶은 소구획.
///
/// 부모 이름을 행마다 부제로 반복하면 같은 글자를 여러 번 읽게 되고 행 높이도
/// 들쭉날쭉해진다. 반복되는 값은 행의 속성이 아니라 묶음의 이름이므로 소제목
/// 으로 올린다. [parentBoard] 가 비어 있으면 부모가 없는(또는 혼자인) 낱개
/// 묶음이라 소제목 없이 평평하게 그린다.
typedef FavoriteSubSection = ({
  String key,
  String parentBoard,
  String parentText,
  String icon,
  SiteType? siteType,
  List<FavoriteData> items,
});

/// 소구획 키. 카페가 달라도 이름이 같을 수 있어 사이트까지 붙인다.
String subSectionKeyOf(SiteType siteType, String parentBoard) =>
    '${siteType.name}_$parentBoard';

/// 그룹의 항목들을 부모별 소구획으로 묶는다.
///
/// - 부모가 같은 항목이 2개 이상일 때만 소제목을 만든다(혼자면 소제목이 짐이다)
/// - 순서는 '그 부모가 처음 나온 자리'를 따른다. 사용자가 정한 순서를 크게
///   흔들지 않으면서 같은 카페끼리 모인다
/// - 소구획이 아닌 항목들은 이웃한 낱개 묶음으로 합친다
List<FavoriteSubSection> subSectionsOf(List<FavoriteData> items) {
  // 1) 부모별로 몇 개인지 먼저 센다(2개 미만은 소구획으로 올리지 않는다).
  final Map<String, int> counts = {};
  for (final FavoriteData item in items) {
    if (item.parentBoard.isEmpty) continue;
    final String key = subSectionKeyOf(item.siteType, item.parentBoard);
    counts[key] = (counts[key] ?? 0) + 1;
  }

  final List<FavoriteSubSection> result = [];
  final Map<String, int> indexOfKey = {};

  for (final FavoriteData item in items) {
    final String key = item.parentBoard.isEmpty
        ? ''
        : subSectionKeyOf(item.siteType, item.parentBoard);
    // 혼자인 부모는 낱개로 떨어뜨린다.
    final String bucket = (counts[key] ?? 0) >= 2 ? key : '';

    final int? at = indexOfKey[bucket];
    if (at != null && (bucket.isNotEmpty || at == result.length - 1)) {
      result[at].items.add(item);
      continue;
    }

    result.add((
      key: bucket,
      parentBoard: bucket.isEmpty ? '' : item.parentBoard,
      parentText: bucket.isEmpty ? '' : item.parentText,
      icon: bucket.isEmpty ? '' : item.icon,
      siteType: bucket.isEmpty ? null : item.siteType,
      items: <FavoriteData>[item],
    ));
    indexOfKey[bucket] = result.length - 1;
  }

  return result;
}

/// 사이트에 대응하는 기본 그룹. ID 는 사이트 이름이라 그룹 이름을 바꿔도
/// 같은 사이트의 게시판은 계속 그 그룹으로 들어간다.
FavoriteGroup siteGroupOf(SiteType siteType, int orderBy) =>
    FavoriteGroup(id: siteType.name, name: siteType.title, orderBy: orderBy);
