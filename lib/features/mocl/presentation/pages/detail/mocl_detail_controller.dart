import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_detail.dart';

import '../../../domain/entities/mocl_result.dart';
import '../../../domain/entities/mocl_user_info.dart';
import '../mocl_routes.dart';

class DetailController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final GetDetail _getDetail;
  final ListItem _listItem = Get.arguments;
  final RxString _appBarTitle = ''.obs;
  final RxDouble _appBarHeight = 60.0.obs;
  bool isReadFlag = false;

  DetailController({required GetDetail getDetail}) : _getDetail = getDetail;

  final _detailStreamController = StreamController<Result>.broadcast();

  Stream<Result> get detailStream => _detailStreamController.stream;

  UserInfo get userInfo => _listItem.userInfo;

  String get time => _listItem.time;

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
    _appBarTitle.value = _listItem.title;
    isReadFlag = _listItem.isRead;
    getDetail(_listItem);
  }

  String getHexColor(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
  }

  void getDetail(ListItem item) async {
    _detailStreamController.add(ResultLoading());
    var result = await _getDetail(item);
    if (result is ResultSuccess) {
      var details = result as ResultSuccess<Details>;
      _appBarTitle.value = details.data.title;
      // _appBarHeight.value = calculateTitleHeight();
      log('appBarTitle = ${details.data.title}');
    }
    _detailStreamController.add(result);
  }

  String getAppbarSmallTitle() => _listItem.boardTitle;

  RxString getAppbarTitle() => _appBarTitle;

  RxDouble getAppbarHeight() => _appBarHeight;

  void setReadFlag() {
    isReadFlag = true;
    Get.parameters[Routes.DETAIL] = 'read';
  }

  void reload() {
    scrollController.jumpTo(0);
    getDetail(_listItem);
  }

  double calculateTitleHeight() {
    var context = Get.context;
    if (context == null) return 30;

    final textPainter = TextPainter(
      text: TextSpan(
        text: _appBarTitle.value, // 텍스트 가져오기
        style: Theme.of(context).textTheme.labelMedium, // 텍스트 스타일 적용
      ),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    )..layout(
        minWidth: 0, maxWidth: MediaQuery.of(context).size.width - 24 - 16 * 2);

    final titleHeight = textPainter.height + 4;
    log('titleHeight = $titleHeight');

    return math.max(30, titleHeight) + 30; // 텍스트 높이 반환
  }
}
