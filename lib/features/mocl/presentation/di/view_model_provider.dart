

// part 'view_model_provider.g.dart';

// final mainViewModelNotifierProvider =
//     StateNotifierProvider.autoDispose<MainViewModel, MainState>((ref) {
//   final getMainList = ref.watch(getMainListProvider);
//   final setMainList = ref.watch(setMainListProvider);
//
//   return MainViewModel(
//     getMainList: getMainList,
//     setMainList: setMainList,
//   );
// });

// @riverpod
// class MainViewModelNotifier extends _$MainViewModelNotifier {
//   @override
//   MainViewModel build() {
//     final getMainList = ref.watch(getMainListProvider);
//     final setMainList = ref.watch(setMainListProvider);
//
//     return MainViewModel(
//       getMainList: getMainList,
//       setMainList: setMainList,
//     );
//   }
// }

// @riverpod
// class MainDlgViewModel extends _$MainDlgViewModel {
//   @override
//   main_dlg_view_model.MainDlgViewModel build() {
//     final getSiteType = ref.watch(getSiteTypeProvider);
//     final getMainListFromJson = ref.watch(getMainListFromJsonProvider);
//
//     return main_dlg_view_model.MainDlgViewModel(
//       getMainListFromJson: getMainListFromJson,
//       getSiteType: getSiteType,
//     );
//   }
// }

// final listViewModelProvider = StateNotifierProvider.autoDispose
//     .family<ListViewModel, Result, MainItem>((ref, item) {
//   final getList = ref.watch(getListProvider);
//
//   return ListViewModel(
//     getList: getList,
//     mainItem: item,
//   );
// });
//
// final detailViewModelProvider = ChangeNotifierProvider.autoDispose
//     .family<DetailViewModel, ReadableListItem>((ref, item) {
//   final getDetail = ref.watch(getDetailProvider);
//   final setReadFlag = ref.watch(setReadProvider);
//   final getSiteType = ref.watch(getSiteTypeProvider);
//
//   return DetailViewModel(
//     listItem: item,
//     getDetail: getDetail,
//     setReadFlag: setReadFlag,
//     getSiteType: getSiteType,
//   );
// });
