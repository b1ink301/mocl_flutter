import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';

import '../../../domain/entities/mocl_main_item.dart';
import '../../../domain/entities/mocl_result.dart';
import '../../../domain/usecases/get_list.dart';

class ListController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final GetList _getList;
  final MainItem _mainItem = Get.arguments;
  final PagingController<int, ListItem> pagingController =
      PagingController(firstPageKey: 1);

  ListController({required GetList getList}) : _getList = getList;

  String getAppbarTitle() => _mainItem.text;

  @override
  void onInit() async {
    super.onInit();

    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(_mainItem, pageKey);
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    pagingController.dispose();
  }

  void _fetchPage(MainItem item, int page) async {
    debugPrint('fetchPage item=$item, page=$page');
    var params = GetListParams(mainItem: item, page: page);
    var result = await _getList(params);
    debugPrint('fetchPage result=$result');

    if (result is ResultSuccess) {
      var data = result as ResultSuccess<List<ListItem>>;
      debugPrint('initMainList length=${data.data.length}');
      final isLastPage = result.data.isEmpty;
      if (isLastPage) {
        pagingController.appendLastPage(result.data);
      } else {
        final nextPageKey = pagingController.nextPageKey! + 1;
        pagingController.appendPage(result.data, nextPageKey);
      }
    } else if (result is ResultFailure) {
      pagingController.error = result.failure;
    } else if (result is ResultLoading) {
    }
  }
}
