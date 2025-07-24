import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/di/app_provider.dart';
import 'package:mocl_flutter/di/use_case_provider.dart';
import 'package:mocl_flutter/features/app_shell/presentation/models/checkable_main_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_list_dlg_providers.g.dart';

@riverpod
class AddListDlgNotifier extends _$AddListDlgNotifier {
  @override
  FutureOr<List<CheckableMainItem>> build() async {
    state = const AsyncValue.loading();

    final siteType = ref.watch(currentSiteTypeNotifierProvider);
    final getMainListFromJson = ref.read(getMainListFromJsonProvider);
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

  void onChanged(bool isChecked, int index) {
    if (state.value != null) {
      state.value![index] = state.value![index].copyWith(isChecked: isChecked);
    }
  }

  List<MainItem> selectedItems() => state.value == null
      ? const []
      : state.value!
            .where((CheckableMainItem item) => item.isChecked)
            .map((CheckableMainItem item) => item.mainItem)
            .toList();
}
