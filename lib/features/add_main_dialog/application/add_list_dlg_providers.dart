import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/add_main_dialog/presentation/models/checkable_main_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'use_case_provider.dart';

part 'add_list_dlg_providers.g.dart';

/// 게시판 선택 다이얼로그의 검색어. 다이얼로그가 닫히면 자동으로 초기화된다.
@riverpod
class AddListSearchQuery extends _$AddListSearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}

@riverpod
class AddListDlgNotifier extends _$AddListDlgNotifier {
  @override
  FutureOr<List<CheckableMainItem>> build() async {
    state = const AsyncValue.loading();

    final siteType = ref.watch(currentSiteTypeProvider);
    final getMainListFromJson = ref.watch(getMainListFromJsonProvider);
    final result = await getMainListFromJson(siteType);

    return result.fold(
      (failure) => throw failure,
      (data) => data
          .map(
            (item) =>
                CheckableMainItem(mainItem: item, isChecked: item.hasItem),
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
