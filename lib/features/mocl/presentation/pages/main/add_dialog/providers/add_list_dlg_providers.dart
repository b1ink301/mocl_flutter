import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_main_list_from_json.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/use_case_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/checkable_main_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'add_list_dlg_providers.g.dart';

@riverpod
class AddListDlgNotifier extends _$AddListDlgNotifier {
  @override
  FutureOr<List<CheckableMainItem>> build() async {
    state = const AsyncValue.loading();

    final SiteType siteType = ref.read(currentSiteTypeNotifierProvider);
    final GetMainListFromJson getMainListFromJson =
        ref.read(getMainListFromJsonProvider);
    final Either<Failure, List<MainItem>> result =
        await getMainListFromJson(siteType);

    return result.fold(
      (Failure failure) => throw failure,
      (List<MainItem> data) => data
          .map((MainItem item) =>
              CheckableMainItem(mainItem: item, isChecked: item.hasItem))
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
