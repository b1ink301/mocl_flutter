import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_main_list.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/use_case_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_state.dart';

part 'main_view_model.freezed.dart';

part 'main_view_model.g.dart';

@riverpod
class MainViewModel extends _$MainViewModel {
  late SiteType _siteType;

  @override
  MainState build() {
    _siteType = ref.watch(currentSiteTypeProvider);
    _loadData();
    return MainStateInitial();
  }

  SiteType get siteType => _siteType;

  void changeSiteType(SiteType newSiteType) {
    if (siteType != newSiteType) {
      ref.read(currentSiteTypeProvider.notifier).changeSiteType(newSiteType);
      _loadData();
    }
  }

  Future<void> reload() async {
    await _loadData();
  }

  Future<void> _loadData() async {
    state = MainState.loading();

    try {
      final getList = ref.read(getMainListProvider);
      final result = await getList(_siteType);
      if (result is ResultSuccess<List<MainItem>>) {
        state = MainState.success(result.data);
      } else if (result is ResultFailure) {
        state = MainState.failure(result.toString());
      }
    } catch (error, _) {
      state = MainState.failure(error.toString());
    }
  }

  void handleAddButton(BuildContext context, SiteType newSiteType) async {
    final result = await context.push<List<MainItem>>(
      Routes.setMainDlgFull,
      extra: newSiteType,
    );
    if (context.mounted && result != null) {
      await _setList(result);
      await reload();
    }
  }

  Future<Result> _setList(List<MainItem> list) async {
    final params = SetMainParams(siteType: _siteType, list: list);
    final setList = ref.read(setMainListProvider);
    final result = await setList.call(params);
    return result;
  }
}
