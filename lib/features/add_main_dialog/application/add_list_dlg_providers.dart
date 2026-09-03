import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_category.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/add_main_dialog/presentation/models/checkable_main_item.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_group.dart';
import 'package:mocl_flutter/features/favorite/application/favorite_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'use_case_provider.dart';

part 'add_list_dlg_providers.g.dart';

/// 게시판 선택 다이얼로그의 검색어. 다이얼로그가 닫히면 자동으로 초기화된다.
@riverpod
class AddListSearchQuery() extends _$AddListSearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}

/// 선택한 게시판을 담을 즐겨찾기 그룹. 기본값은 그 사이트가 속한 카테고리라,
/// 사용자가 아무것도 고르지 않아도 정리된 상태로 쌓인다.
/// (그룹 이름이 바뀌어도 ID 로 찾으므로 유지되고, 그룹이 지워졌으면 첫 그룹)
@riverpod
class AddTargetGroup() extends _$AddTargetGroup {
  @override
  Future<String> build() async {
    final List<FavoriteGroup> groups = await ref.watch(
      favoriteGroupsProvider.future,
    );
    if (groups.isEmpty) return '';

    final SiteType siteType = ref.watch(currentSiteTypeProvider);
    final String preferred = defaultCategoryIdOf(siteType);
    final bool exists = groups.any((group) => group.id == preferred);
    return exists ? preferred : groups.first.id;
  }

  void select(String groupId) => state = AsyncData(groupId);
}

@riverpod
class AddListDlgNotifier() extends _$AddListDlgNotifier {
  @override
  FutureOr<List<CheckableMainItem>> build() async {
    state = const AsyncValue.loading();

    final siteType = ref.watch(currentSiteTypeProvider);
    final getMainListFromJson = ref.watch(getMainListFromJsonProvider);
    final result = await getMainListFromJson(siteType);

    // 이미 즐겨찾기에 있는 게시판은 체크된 상태로 보여준다.
    // (favoritesProvider 를 watch 하면 추가 직후 목록이 다시 로딩되므로
    //  스냅샷만 필요한 여기서는 저장소를 직접 한 번 읽는다)
    final List<FavoriteData> favorites = await ref
        .read(favoriteRepositoryProvider)
        .getAll();
    final Set<String> saved = {
      for (final FavoriteData favorite in favorites)
        if (favorite.siteType == siteType) favorite.board,
    };

    return result.fold(
      (failure) => throw failure,
      (data) => data
          .map(
            (item) => CheckableMainItem(
              mainItem: item,
              isChecked: saved.contains(item.board),
            ),
          )
          .toList(),
    );
  }

  /// 검색으로 목록이 필터링되면 화면상의 인덱스와 전체 목록의 인덱스가
  /// 어긋나므로, 항목 자체로 위치를 찾아 갱신한다.
  void onChanged(bool isChecked, MainItem item) {
    final list = state.value;
    if (list == null) return;
    final index = list.indexWhere((e) => e.mainItem == item);
    if (index < 0) return;
    list[index] = list[index].copyWith(isChecked: isChecked);
  }

  List<MainItem> selectedItems() => state.value == null
      ? const []
      : state.value!
            .where((CheckableMainItem item) => item.isChecked)
            .map((CheckableMainItem item) => item.mainItem)
            .toList();
}
