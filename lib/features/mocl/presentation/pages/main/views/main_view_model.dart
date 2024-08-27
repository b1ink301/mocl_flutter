import 'dart:developer';

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
  final GetSiteType _getSiteType;
  final SetSiteType _setSiteType;
  final SetMainList _setMainList;

  MainViewModel({
    required GetMainList getMainList,
    required GetSiteType getSiteType,
    required SetSiteType setSiteType,
    required SetMainList setMainList,
  })  : _getMainList = getMainList,
        _getSiteType = getSiteType,
        _setMainList = setMainList,
        _setSiteType = setSiteType {
    init();
  }

  AsyncValue<Result> _data = const AsyncValue.loading();

  AsyncValue<Result> get data => _data;

  SiteType _siteType = SiteType.none;

  SiteType get siteType => _siteType;

  set siteType(SiteType newSiteType) {
    log('siteType newSiteType=$newSiteType, _siteType=$_siteType');
    if (_siteType != newSiteType) {
      _siteType = newSiteType;
      _setSiteType(newSiteType);
      getList(_siteType);
      notifyListeners();
    }
  }

  void init() {
    siteType = _getSiteType(NoParams());
  }

  void reload() {
    getList(_siteType);
    notifyListeners();
  }

  String appBarTitle() => _siteType.title;

  Future<void> getList(SiteType siteType) async {
    _data = const AsyncValue.loading();
    notifyListeners();

    try {
      final result = await _getMainList(siteType);
      if (result is ResultSuccess<List<MainItem>>) {
        _data = AsyncValue.data(result);
      } else if (result is ResultFailure) {
        _data = AsyncValue.error(result, StackTrace.current);
      }
    } catch (error, stackTrace) {
      _data = AsyncValue.error(error, stackTrace);
    }

    notifyListeners();
  }

  void changeSiteType(SiteType newSiteType) {
    siteType = newSiteType;
  }

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
    reload();
    return result;
  }
}
