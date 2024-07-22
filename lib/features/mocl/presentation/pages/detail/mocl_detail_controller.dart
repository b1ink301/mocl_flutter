import 'dart:async';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_detail.dart';

import '../../../domain/entities/mocl_result.dart';
import '../../../domain/entities/mocl_user_info.dart';

class DetailController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final GetDetail _getDetail;
  final ListItem _listItem = Get.arguments;
  bool isReadFlag = false;

  DetailController({required GetDetail getDetail}) : _getDetail = getDetail;

  final _detailStreamController = StreamController<Result>.broadcast();

  Stream<Result> get detailStream => _detailStreamController.stream;
  UserInfo get userInfo => _listItem.userInfo;

  @override
  void onClose() {
    super.onClose();
    _detailStreamController.close();
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    log('onInit');
    isReadFlag = _listItem.isRead;
    getDetail(_listItem);
  }

  void getDetail(ListItem item) async {
    _detailStreamController.add(ResultLoading());
    var params = GetDetailParams(item: item);
    var result = await _getDetail(params);
    _detailStreamController.add(result);
  }

  String getAppbarSmallTitle() => _listItem.boardTitle;
  String getAppbarTitle() => _listItem.title;

  void setReadFlag() {
    isReadFlag = true;
  }
}
