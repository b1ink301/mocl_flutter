import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/mocl_list_item.dart';
import '../../../../domain/entities/mocl_result.dart';
import '../../../../domain/usecases/get_list.dart';
import '../../../models/readable_list_item.dart';

part 'list_provider.g.dart';

@riverpod
class ListState extends _$ListState {
  late MainItem _mainItem;

  int _lastId = -1;
  int _currentPage = 1;
  bool _isLoadingMore = false;

  @override
  FutureOr<List<ReadableListItem>> build() {
    return [];
  }

  void init(MainItem item) {
    log('[ListState] init=$item');

    state = const AsyncValue.loading();
    _mainItem = item;
    _loadMoreItems();
  }

  void refresh() {
    state = const AsyncValue.loading();
    _lastId = -1;
    _currentPage = 1;
    _isLoadingMore = false;
    _loadMoreItems();
  }

  void dispose() {
    // pagingController.dispose();
  }

  Future<void> _fetchPage(int page) async {
    if (_isLoadingMore) return;
    _isLoadingMore = true;
    debugPrint('Fetching page: item=$_mainItem, page=$page, lastId=$_lastId');

    final params =
        GetListParams(mainItem: _mainItem, page: page, lastId: _lastId);

    try {
      final getList = ref.read(getListProvider);
      final result = await getList(params);

      if (result is ResultSuccess<List<ListItem>>) {
        debugPrint('Fetched items: ${result.data.length}');

        final list = result.data
            .map((item) => ReadableListItem(
                  item: item,
                  isRead: item.isRead,
                ))
            .toList();

        _updatePagingController(list, page);
      } else if (result is ResultFailure) {
        debugPrint('Error fetching page: ${result.failure}');
        // pagingController.error = result.failure;
        state =
            AsyncValue.error(Exception('ResultFailure'), StackTrace.current);
      }
    } catch (e) {
      debugPrint('Unexpected error: $e');
      // pagingController.error = e;
      state = AsyncValue.error(e, StackTrace.current);
    } finally {
      _isLoadingMore = false;
    }
  }

  void _loadMoreItems() async => await _fetchPage(_currentPage);

  bool checkLoadMoreItems(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      _loadMoreItems();
    }
    return true;
  }

  // UI 업데이트를 위한 함수
  void _updatePagingController(List<ReadableListItem> list, int page) {
    if (list.isNotEmpty) {
      _lastId = list.last.item.id;
    }

    state.maybeWhen(data: (previousList) {
      final data = List<ReadableListItem>.from(previousList)..addAll(list);
      state = AsyncValue.data(data);
    }, orElse: () {
      state = AsyncValue.data(list);
    });

    _currentPage++;
  }
}

final isReadProvider = StateProvider((ref) => false);

@Riverpod(keepAlive: true)
class IsReadState extends _$IsReadState {
  @override
  bool build() => ref.watch(isReadProvider);

  void setRead() {
    ref.read(isReadProvider.notifier).state = true;
  }

  void clear() {
    ref.read(isReadProvider.notifier).state = false;
  }
}
