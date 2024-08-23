import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/use_case_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/views/list_view_model.dart';

final listViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<ListViewModel, MainItem>((ref, item) {
  final getList = ref.watch(getListProvider);
  final setReadFlag = ref.watch(setReadProvider);

  return ListViewModel(
    getList: getList,
    setReadFlag: setReadFlag,
    mainItem: item,
  );
});
