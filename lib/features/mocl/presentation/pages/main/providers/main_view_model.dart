import 'package:flutter/cupertino.dart';
import 'package:fpdart/fpdart.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
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
  FutureOr<List<MainItem>> build() async {
    _siteType = ref.watch(currentSiteTypeProvider);
    final getList = ref.read(getMainListProvider);
    final result = await getList(_siteType);
    return result.fold(
      (failure) => throw failure,
      (data) => data,
    );
  }

  void changeSiteType(SiteType newSiteType) {
    if (_siteType != newSiteType) {
      ref.read(currentSiteTypeProvider.notifier).changeSiteType(newSiteType);
      reload();
    }
  }

  void reload() {
    ref.invalidateSelf();
  }

  void handleAddButton(BuildContext context, SiteType newSiteType) async {
    final result = await context.push<List<MainItem>>(
      Routes.setMainDlgFull,
      extra: newSiteType,
    );
    if (context.mounted && result != null) {
      await _setList(result);
      reload();
    }
  }

  Future<Either> _setList(List<MainItem> list) async {
    final params = SetMainParams(siteType: _siteType, list: list);
    final setList = ref.read(setMainListProvider);
    return await setList.call(params);
  }
}
