import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_main_list.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_main_list_from_json.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_main_list.dart';

import '../../../domain/entities/mocl_main_item.dart';
import '../../../domain/entities/mocl_result.dart';
import '../../../domain/entities/mocl_site_type.dart';
import '../mocl_routes.dart';

class MainController extends GetxController {
  final GetMainList _getMainList;
  final SetMainList _setMainList;
  final GetMainListFromJson _getMainListFromJson;

  final SiteType siteType = GetStorage().read('SiteType') ?? SiteType.Damoang;

  MainController({
    required GetMainList getMainList,
    required SetMainList setMainList,
    required GetMainListFromJson getMainListFromJson,
  })  : _getMainList = getMainList,
        _setMainList = setMainList,
        _getMainListFromJson = getMainListFromJson;

  final _mainListStreamController = StreamController<Result>.broadcast();

  Stream<Result> get mainListStream => _mainListStreamController.stream;

  Stream<Result> getList() async* {
    yield* mainListStream;
  }

  String siteName() {
    var title = switch (siteType) {
      SiteType.Clien => '클리앙',
      SiteType.Damoang => '다모앙',
      SiteType.None => 'None',
    };
    return title;
  }

  @override
  void onInit() async {
    super.onInit();

    initMainList(siteType);
  }

  void initMainList(SiteType siteType) async {
    _mainListStreamController.add(ResultLoading());
    var params = GetMainParams(siteType: siteType);
    var result = await _getMainList(params) as ResultSuccess<List<MainItem>>;
    debugPrint('initMainList length=${result.data.length}');
    _mainListStreamController.add(result);
  }

  Future<List<int>> setList(
    SiteType siteType,
    List<MainItem> selectedItems,
  ) async {
    var params = SetMainParams(siteType: siteType, list: selectedItems);
    var result = await _setMainList(params);

    if (result is ResultSuccess<List<int>>) {
      initMainList(siteType);
      return Future.value(result.data);
    }

    return Future.value(List.empty());
  }

  Stream<Result> getListFromJson(SiteType siteType) async* {
    // await Future.delayed(const Duration(seconds: 1));
    yield* _getMainListFromJson(GetMainParams(siteType: siteType));
  }

  @override
  void dispose() {
    closeSteam();
    super.dispose();
  }

  void closeSteam() {
    debugPrint('closeSteam');
    _mainListStreamController.close();
  }

  void gotoListPage(MainItem item) => Get.toNamed(
        Routes.LIST,
        arguments: item,
      );
}
