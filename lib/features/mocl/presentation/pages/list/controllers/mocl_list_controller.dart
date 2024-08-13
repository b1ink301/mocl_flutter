import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_read_flag.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/mocl_list_item_wrapper.dart';

import '../../../../domain/entities/mocl_main_item.dart';
import '../../../../domain/entities/mocl_result.dart';
import '../../../../domain/usecases/get_list.dart';
import '../../../routes/mocl_app_pages.dart';

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

  String get appbarTitle => _mainItem.text;
  String get appbarSmallTitle => siteType.title;
  SiteType get siteType => _mainItem.siteType;

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

  Future<void> _fetchPage(int page) async {
    debugPrint('Fetching page: item=$_mainItem, page=$page, lastId=$lastId');
    var params = GetListParams(mainItem: _mainItem, page: page, lastId: lastId);

    try {
      var result = await _getList(params);

      if (result is ResultSuccess<List<ListItem>>) {
        debugPrint('Fetched items: ${result.data.length}');

        // 백그라운드 isolate에서 데이터 처리
        final list = await compute(_processListItems, result.data);

        // 메인 쓰레드로 돌아와서 UI 업데이트
        _updatePagingController(list, page);
      } else if (result is ResultFailure) {
        debugPrint('Error fetching page: ${result.failure}');
        pagingController.error = result.failure;
      }
    } catch (e) {
      debugPrint('Unexpected error: $e');
      pagingController.error = e;
    }
  }

  // 백그라운드에서 실행될 함수
  static List<ListItemWrapper> _processListItems(List<ListItem> items) {
    return items
        .map((item) => ListItemWrapper(
              item: item,
              isReadNotifier: ValueNotifier(item.isRead),
            ))
        .toList();
  }

  // UI 업데이트를 위한 함수
  void _updatePagingController(List<ListItemWrapper> list, int page) {
    if (list.isNotEmpty) {
      lastId = list.last.item.id;
    }

    final isLastPage = list.isEmpty;
    if (isLastPage) {
      pagingController.appendLastPage(list);
    } else {
      final nextPageKey = page + 1;
      pagingController.appendPage(list, nextPageKey);
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
    pagingController.refresh();
  }

  void toDetail(ListItemWrapper item) async {
    final listItem = item.item.copyWith(
        boardTitle: '${_mainItem.siteType.title} > ${item.item.boardTitle}');
    await Get.toNamed(Routes.DETAIL, arguments: listItem);

    final isReadFlag = Get.findOrNull<bool>(tag: Routes.DETAIL);
    if (isReadFlag != null) {
      setReadFlag(item);
      Get.delete<bool>(tag: Routes.DETAIL);
    }
  }
}
