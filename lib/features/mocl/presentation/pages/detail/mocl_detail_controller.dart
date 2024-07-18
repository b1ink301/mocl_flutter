import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_detail.dart';

import '../../../domain/entities/mocl_result.dart';

class DetailController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final GetDetail _getDetail;
  late final ListItem _listItem;

  DetailController({required GetDetail getDetail}) : _getDetail = getDetail;

  final _detilStreamController = StreamController<Result>.broadcast();

  Stream<Result> get deailStream => _detilStreamController.stream;

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

  }

  void getDetail(ListItem item) async {
    _detilStreamController.add(ResultLoading());
    var params = GetDetailParams(item: item);
    var result = await _getDetail(params);
    _detilStreamController.add(result);
  }

  void setListItem(ListItem listItem) {
    _listItem = listItem;

    getDetail(listItem);
  }

  String getAppbarTitle() => _listItem.title;
}
