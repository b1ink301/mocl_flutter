import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_list.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_read_flag.dart';
import 'package:mocl_flutter/features/mocl/presentation/base/base_view_model.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';

class ListViewModel extends BaseViewModel {
  final MainItem mainItem;
  final GetList getList;
  final SetReadFlag setReadFlag;

  final PagingController<int, ReadableListItem> pagingController =
      PagingController(firstPageKey: 1);

  int _lastId = -1;

  ListViewModel({
    required this.getList,
    required this.setReadFlag,
    required this.mainItem,
  }) {
    init();
  }

  void init() {
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  void refresh() {
    _lastId = -1;
    pagingController.refresh();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  void _fetchPage(int page) async {
    log('Fetching page: item=$mainItem, page=$page, lastId=$_lastId');

    final params =
        GetListParams(mainItem: mainItem, page: page, lastId: _lastId);

    try {
      final result = await getList(params);

      if (result is ResultSuccess<List<ListItem>>) {
        log('Fetched items: ${result.data.length}');

        final list = result.data
            .map((item) => ReadableListItem(
                  item: item,
                  isRead: ValueNotifier(item.isRead),
                ))
            .toList()
            .sublist(0, 10);

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

  void _updatePagingController(List<ReadableListItem> list, int page) {
    if (list.isNotEmpty) {
      _lastId = list.last.item.id;
    }

    final isLastPage = list.isEmpty;
    if (isLastPage) {
      pagingController.appendLastPage(list);
    } else {
      final nextPageKey = page + 1;
      pagingController.appendPage(list, nextPageKey);
    }
  }

  Future<void> handleItemTap(
      BuildContext context, ReadableListItem item) async {
    await context.push(Routes.DETAIL, extra: item.item);
    // var isRead = ref.watch(isReadStateProvider);
    // if (isRead) {
    //   await _markItemAsRead(ref, item);
    // }
    // log('[PagedChildBuilderDelegate] isRead = $isRead');
  }

  Future<void> _markItemAsRead(ReadableListItem item) async {
    item.markAsRead();
    var params =
        SetReadFlagParams(siteType: mainItem.siteType, boardId: item.item.id);
    await setReadFlag(params);
    // ref.read(isReadStateProvider.notifier).clear();
  }
}
