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
  final GetList _getList;
  final SetReadFlag _setReadFlag;
  final MainItem _mainItem = Get.arguments;

  final RxList<ListItemWrapper> items = <ListItemWrapper>[].obs;
  final RxBool isLoading = false.obs;
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
    loadMoreItems();
  }

  Future<void> loadMoreItems() async {
    if (isLoading.value) return;
    isLoading.value = true;

    try {
      debugPrint('fetchPage item=$_mainItem, page=$_currentPage, lastId=$lastId');
      var params = GetListParams(mainItem: _mainItem, page: _currentPage, lastId: lastId);
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
      } else if (result is ResultLoading) {
      }
    } catch (e) {
      // 에러 처리
      Get.log('Error loading more items: $e');
    } finally {
      isLoading.value = false;
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
    items.clear();
    _currentPage = 1;
    loadMoreItems();
  }
}
