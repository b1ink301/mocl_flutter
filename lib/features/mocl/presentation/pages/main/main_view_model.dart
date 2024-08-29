import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_main_list.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_main_list.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/base/base_view_model.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';

class MainViewModel extends BaseViewModel {
  final GetMainList _getMainList;
  final SetSiteType _setSiteType;
  final SetMainList _setMainList;

  MainViewModel({
    required GetMainList getMainList,
    required GetSiteType getSiteType,
    required SetSiteType setSiteType,
    required SetMainList setMainList,
  })  : _getMainList = getMainList,
        _setMainList = setMainList,
        _setSiteType = setSiteType {
    siteType = getSiteType(NoParams());
  }

  AsyncValue<List<MainItem>> _data = const AsyncValue.loading();

  AsyncValue<List<MainItem>> get data => _data;

  SiteType _siteType = SiteType.none;

  SiteType get siteType => _siteType;

  set siteType(SiteType newSiteType) {
    if (_siteType != newSiteType) {
      _siteType = newSiteType;
      _setSiteType(newSiteType);
      getList(_siteType);
    }
  }

  Future<void> reload() => getList(_siteType);

  String appBarTitle() => _siteType.title;

  Future<void> getList(SiteType siteType) async {
    _data = const AsyncLoading();
    notifyListeners();

    try {
      final result = await _getMainList(siteType);
      if (result is ResultSuccess<List<MainItem>>) {
        _data = AsyncData(result.data);
      } else if (result is ResultFailure) {
        _data = AsyncError(result, StackTrace.current);
      }
    } catch (error, stackTrace) {
      _data = AsyncError(error, stackTrace);
    } finally {
      notifyListeners();
    }
  }

  void changeSiteType(SiteType newSiteType) => siteType = newSiteType;

  void showSetListDlg(BuildContext context) async {
    final result = await context
        .push<List<MainItem>>('${Routes.MAIN}/${Routes.SET_MAIN_DLG}');
    if (result != null) {
      await _setList(result);
    }
  }

  Future<Result> _setList(List<MainItem> list) async {
    final params = SetMainParams(siteType: _siteType, list: list);
    final result = await _setMainList.call(params);
    await reload();
    return result;
  }
}
