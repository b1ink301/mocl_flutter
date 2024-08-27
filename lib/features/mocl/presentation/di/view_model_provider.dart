import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/use_case_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/list_view_model.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/main_dlg_view_model.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/main_view_model.dart';

import '../pages/detail/detail_view_model.dart';

final mainViewModelProvider =
    ChangeNotifierProvider.autoDispose<MainViewModel>((ref) {
  final getMainList = ref.watch(getMainListProvider);
  final getSiteType = ref.watch(getSiteTypeProvider);
  final setSiteType = ref.watch(setSiteTypeProvider);
  final setMainList = ref.watch(setMainListProvider);

  return MainViewModel(
    getMainList: getMainList,
    getSiteType: getSiteType,
    setSiteType: setSiteType,
    setMainList: setMainList,
  );
});

final mainDlgViewModelProvider =
    ChangeNotifierProvider.autoDispose<MainDlgViewModel>((ref) {
  final getSiteType = ref.watch(getSiteTypeProvider);
  final getMainListFromJson = ref.watch(getMainListFromJsonProvider);

  return MainDlgViewModel(
    getMainListFromJson: getMainListFromJson,
    getSiteType: getSiteType,
  );
});

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

final detailViewModelProvider = ChangeNotifierProvider.autoDispose
    .family<DetailViewModel, ReadableListItem>((ref, item) {
  final getDetail = ref.watch(getDetailProvider);
  return DetailViewModel(
    listItem: item,
    getDetail: getDetail,
  );
});
