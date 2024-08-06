import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_read_flag.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/mocl_list_item_wrapper.dart';

import '../../../../domain/entities/mocl_main_item.dart';
import '../../../../domain/entities/mocl_result.dart';
import '../../../../domain/usecases/get_list.dart';

class ListController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final GetList _getList;
  final SetReadFlag _setReadFlag;
  final MainItem _mainItem = Get.arguments;
  final PagingController<int, ListItemWrapper> pagingController =
      PagingController(firstPageKey: 1);

  int lastId = -1;

  ListController({
    required GetList getList,
    required SetReadFlag setReadFlag,
  })  : _getList = getList,
        _setReadFlag = setReadFlag;

  String getAppbarTitle() => _mainItem.text;
  String getAppbarSmallTitle() => _mainItem.siteType.title;

  @override
  void onInit() {
    super.onInit();

    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    pagingController.dispose();
  }

  void _fetchPage(int page) async {
    debugPrint('fetchPage item=$_mainItem, page=$page, lastId=$lastId');
    var params = GetListParams(mainItem: _mainItem, page: page, lastId: lastId);
    var result = await _getList(params);

    if (result is ResultSuccess) {
      var data = result as ResultSuccess<List<ListItem>>;
      debugPrint('initMainList length=${data.data.length}');
      final isLastPage = result.data.isEmpty;
      var list = result.data
          .map(
            (item) => ListItemWrapper(
              item: item,
              isReadNotifier: ValueNotifier(item.isRead),
            ),
          )
          .toList();
      lastId = list.lastOrNull?.item.id ?? -1;
      if (isLastPage) {
        pagingController.appendLastPage(list);
      } else {
        final nextPageKey = pagingController.nextPageKey! + 1;
        pagingController.appendPage(list, nextPageKey);
      }
    } else if (result is ResultFailure) {
      pagingController.error = result.failure;
    } else if (result is ResultLoading) {
    }
  }

  void setReadFlag(ListItemWrapper itemWrapper) async {
    if(itemWrapper.isReadNotifier.value == false) {
      itemWrapper.isReadNotifier.value = true;
      SetReadFlagParams params = SetReadFlagParams(
        siteType: _mainItem.siteType,
        boardId: itemWrapper.item.id,
      );
      await _setReadFlag(params);
    }
  }

  void reload() {
    lastId = -1;
    pagingController.refresh();
  }
}
