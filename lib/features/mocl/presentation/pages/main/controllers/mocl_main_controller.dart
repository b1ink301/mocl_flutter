import 'dart:async';
import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_main_list.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_main_list_from_json.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_main_list.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';

import '../../../../domain/entities/mocl_main_item.dart';
import '../../../../domain/entities/mocl_result.dart';
import '../../../../domain/entities/mocl_site_type.dart';

class MainController extends GetxController with StateMixin<List<MainItem>> {
  final GetMainList _getMainList;
  final SetMainList _setMainList;
  final GetMainListFromJson _getMainListFromJson;
  final SetSiteType _setSiteType;
  final GetSiteType _getSiteType;
  late final Rx<SiteType> siteType;

  MainController({
    required GetMainList getMainList,
    required SetMainList setMainList,
    required GetMainListFromJson getMainListFromJson,
    required SetSiteType setSiteType,
    required GetSiteType getSiteType,
  })  : _getMainList = getMainList,
        _setMainList = setMainList,
        _getMainListFromJson = getMainListFromJson,
        _setSiteType = setSiteType,
        _getSiteType = getSiteType;

  // final _mainListStreamController = StreamController<Result>.broadcast();
  // Stream<Result> get mainListStream => _mainListStreamController.stream;
  // Stream<Result> getList() async* {
  //   yield* mainListStream;
  // }

  final Rx<Result> _data = Rx<Result>(ResultLoading());

  Rx<Result> get data => _data;

  String siteName() => siteType.value.title;

  @override
  void onInit() async {
    super.onInit();
    siteType = _getSiteType(NoParams()).obs;
  }

  @override
  void onReady() {
    super.onReady();
    initMainList();
  }

  void initMainList() async {
    change(LoadingStatus());
    // _data.value = ResultLoading();
    // _mainListStreamController.add(ResultLoading());
    var result = await _getMainList(siteType.value);

    if (result is ResultSuccess<List<MainItem>>) {
      debugPrint('initMainList length=${result.data.length}');
      if (result.data.isEmpty) {
        change(EmptyStatus());
      } else {
        change(SuccessStatus(result.data));
      }
    } else if (result is ResultFailure) {
      change(ErrorStatus(result));
    }
    // _mainListStreamController.add(result);
  }

  Future<List<int>> setList(
    List<MainItem> selectedItems,
  ) async {
    var params = SetMainParams(siteType: siteType.value, list: selectedItems);
    var result = await _setMainList(params);

    if (result is ResultSuccess<List<int>>) {
      initMainList();
      return Future.value(result.data);
    }

    return Future.value(List.empty());
  }

  Stream<Result> getListFromJson() async* {
    yield* _getMainListFromJson(siteType.value);
  }

  // @override
  // void dispose() {
  //   // closeSteam();
  //   super.dispose();
  // }

  // void closeSteam() => _mainListStreamController.close();

  void gotoListPage(MainItem item) => Get.toNamed(
        Routes.LIST,
        arguments: item,
      );

  Future<void> changeSite(SiteType siteType) async {
    log('changeSite=$siteType');
    if (this.siteType.value != siteType) {
      this.siteType.value = siteType;
      _setSiteType(siteType);
      initMainList();
    }
  }
}
