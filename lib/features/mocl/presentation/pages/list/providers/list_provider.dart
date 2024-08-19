import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/mocl_list_item.dart';
import '../../../../domain/entities/mocl_result.dart';
import '../../../../domain/usecases/get_list.dart';
import '../../../injection.dart';
import '../../../models/mocl_list_item_wrapper.dart';

part 'list_provider.g.dart';

@riverpod
class ListState extends _$ListState {
  late final MainItem _mainItem;
  final PagingController<int, ListItemWrapper> pagingController =
      PagingController(firstPageKey: 1);
  int lastId = -1;

  @override
  FutureOr<Result> build() => ResultLoading();

  void init(MainItem item) {
    _mainItem = item;
    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(pageKey);
    });
  }

  void refresh() => pagingController.refresh();

  void dispose() {
    pagingController.dispose();
  }

  void _fetchPage(int page) async {
    debugPrint('Fetching page: item=$_mainItem, page=$page, lastId=$lastId');

    final params =
        GetListParams(mainItem: _mainItem, page: page, lastId: lastId);

    try {
      final getList = getIt<GetList>();
      final result = await getList(params);

      if (result is ResultSuccess<List<ListItem>>) {
        debugPrint('Fetched items: ${result.data.length}');

        final list = result.data
            .map((item) => ListItemWrapper(
                  item: item,
                  isReadNotifier: ValueNotifier(item.isRead),
                ))
            .toList();

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
}
