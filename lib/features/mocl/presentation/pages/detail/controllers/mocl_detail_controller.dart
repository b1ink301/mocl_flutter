import 'dart:async';
import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_detail.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../domain/entities/mocl_result.dart';
import '../../../../domain/entities/mocl_user_info.dart';
import '../../../routes/mocl_app_pages.dart';

class DetailController extends GetxController
    with StateMixin<ResultSuccess<Details>> {
  final ScrollController scrollController = ScrollController();
  final GetDetail _getDetail;
  final ListItem _listItem = Get.arguments;
  final RxString _appBarTitle = ''.obs;
  final RxDouble _appBarHeight = 64.0.obs;
  final SiteType siteType;

  DetailController({required GetDetail getDetail, required this.siteType}) : _getDetail = getDetail;

  UserInfo get userInfo => _listItem.userInfo;

  String get time => _listItem.time;

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
  }

  @override
  void onInit() {
    super.onInit();
    _appBarTitle.value = _listItem.title;
    _appBarHeight.value = _calculateTitleHeight();
  }

  @override
  void onReady() {
    super.onReady();
    getDetail(_listItem);
  }

  String getHexColor(Color color) =>
      '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

  void getDetail(ListItem item) async {
    change(LoadingStatus());
    final result = await _getDetail(item);
    if (result is ResultSuccess) {
      final details = result as ResultSuccess<Details>;
      if (_appBarTitle.value != details.data.title) {
        _appBarTitle.value = details.data.title;
        _appBarHeight.value = _calculateTitleHeight();
      }
      change(SuccessStatus(details));
      log('appBarTitle = ${details.data.title}');
    } else if (result is ResultFailure) {
      change(ErrorStatus(result));
    }
  }

  String getAppbarSmallTitle() => _listItem.boardTitle;

  RxString get appbarTitle => _appBarTitle;

  RxDouble get appBarHeight => _appBarHeight;

  void setReadFlag() => Get.put<bool>(true, tag: Routes.DETAIL);

  void reload() {
    scrollController.jumpTo(0);
    getDetail(_listItem);
  }

  void openBrowserByMenu() => openBrowser(_listItem.url);

  Future<bool> openBrowser(String url) async {
    final Uri uri = Uri.parse(url);
    return await launchUrl(uri);
  }

  double _calculateTitleHeight() {
    var context = Get.context;
    if (context == null) return 34;

    final textPainter = TextPainter(
      text: TextSpan(
        text: _appBarTitle.value,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    )..layout(
        minWidth: 0,
        maxWidth:
            MediaQuery.of(context).size.width - (24 * 2 + 16 * 4 + 16 + 4));

    final titleHeight = textPainter.height;
    log('titleHeight = $titleHeight');

    return math.max(30, titleHeight) + 34; // 텍스트 높이 반환
  }
}
