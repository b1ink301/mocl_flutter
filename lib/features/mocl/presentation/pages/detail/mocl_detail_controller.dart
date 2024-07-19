import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_detail.dart';

import '../../../domain/entities/mocl_result.dart';
import '../../../domain/entities/mocl_user_info.dart';

class DetailController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final GetDetail _getDetail;
  final ListItem _listItem = Get.arguments;

  DetailController({required GetDetail getDetail}) : _getDetail = getDetail;

  final _detilStreamController = StreamController<Result>.broadcast();

  Stream<Result> get deailStream => _detilStreamController.stream;
  UserInfo get userInfo => _listItem.userInfo;

  @override
  void onClose() {
    super.onClose();
    _detilStreamController.close();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    getDetail(_listItem);
  }

  void getDetail(ListItem item) async {
    _detilStreamController.add(ResultLoading());
    var params = GetDetailParams(item: item);
    var result = await _getDetail(params);
    _detilStreamController.add(result);
  }

  String getAppbarSmallTitle() => _listItem.boardTitle;
  String getAppbarTitle() => _listItem.title;
}
