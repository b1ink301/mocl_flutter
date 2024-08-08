import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_read_flag.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/mocl_list_item_wrapper.dart';

import '../../../../domain/entities/mocl_main_item.dart';
import '../../../../domain/entities/mocl_result.dart';
import '../../../../domain/usecases/get_list.dart';
import '../../../routes/mocl_app_pages.dart';

class ListController extends GetxController {
  final GetList _getList;
  final SetReadFlag _setReadFlag;
  final MainItem _mainItem = Get.arguments;

  final RxList<ListItemWrapper> items = <ListItemWrapper>[].obs;
  final RxBool isLoadingMore = false.obs;

  int _currentPage = 1;
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
    _loadMoreItems();
  }

  bool checkLoadMoreItems(ScrollNotification scrollInfo) {
    // if (scrollInfo.metrics.pixels ==
    //     scrollInfo.metrics.maxScrollExtent) {
    //   controller.loadMoreItems();
    // }
    if (scrollInfo is ScrollUpdateNotification) {
      final metrics = scrollInfo.metrics;
      if (metrics.pixels >= metrics.maxScrollExtent - (3 * 70.0)) {
        _loadMoreItems();
      }
    }
    return true;
  }

  Future<void> _loadMoreItems() async {
    if (isLoadingMore.value) return;
    isLoadingMore.value = true;

    try {
      debugPrint(
          'fetchPage item=$_mainItem, page=$_currentPage, lastId=$lastId');
      var params = GetListParams(
          mainItem: _mainItem, page: _currentPage, lastId: lastId);
      var result = await _getList(params);

      if (result is ResultSuccess) {
        final data = result as ResultSuccess<List<ListItem>>;
        debugPrint('loadMoreItems length=${data.data.length}');
        final newWrappedItems = result.data
            .map(
              (item) => ListItemWrapper(
                item: item,
                isReadNotifier: ValueNotifier(item.isRead),
              ),
            )
            .toList();
        lastId = newWrappedItems.lastOrNull?.item.id ?? -1;
        items.addAll(newWrappedItems);
        _currentPage++;
      } else if (result is ResultFailure) {
      } else if (result is ResultLoading) {}
    } catch (e) {
      Get.log('Error loading more items: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  void setReadFlag(ListItemWrapper itemWrapper) async {
    if (itemWrapper.isReadNotifier.value == false) {
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
    _currentPage = 1;
    items.clear();
    _loadMoreItems();
  }

  void toDetail(ListItemWrapper item) async {
    final listItem = item.item
        .copyWith(boardTitle: '${_mainItem.siteType.title} > ${item.item.boardTitle}');
    await Get.toNamed(Routes.DETAIL, arguments: listItem);

    final isReadFlag = Get.findOrNull<bool>(tag: Routes.DETAIL);
    if (isReadFlag != null) {
      setReadFlag(item);
      Get.delete<bool>(tag: Routes.DETAIL);
    }
  }
}
