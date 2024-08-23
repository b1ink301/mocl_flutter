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

final isLoadingMoreProvider = StateProvider<bool>((ref) => false);

@riverpod
class ListState extends _$ListState {
  late MainItem _mainItem;

  int _lastId = -1;
  int _currentPage = 1;

  @override
  Future<List<ReadableListItem>?> build({required MainItem item}) {
    state = const AsyncValue.loading();
    _mainItem = item;
    return _fetchPage(1);
  }

  void refresh() {
    state = const AsyncValue.loading();
    _lastId = -1;
    _currentPage = 1;
    ref.read(isLoadingMoreProvider.notifier).state = false;
    loadMoreItems();
  }

  Future<List<ReadableListItem>?> _fetchPage(int page) async {
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
                  isRead: ValueNotifier(item.isRead),
                ))
            .toList();
        _currentPage = page + 1;

        return list;
      } else if (result is ResultFailure) {
        debugPrint('Error fetching page: ${result.failure}');
        state =
            AsyncValue.error(Exception('ResultFailure'), StackTrace.current);
      }
    } catch (e) {
      debugPrint('Unexpected error: $e');
      state = AsyncValue.error(e, StackTrace.current);
    }
    return null;
  }

  void loadMoreItems() async {
    final isLoadingMore = ref.read(isLoadingMoreProvider);
    if (isLoadingMore) return;
    ref.read(isLoadingMoreProvider.notifier).state = true;
    _fetchPage(_currentPage).then((data) {
      if (data != null) {
        _updatePagingController(data);
      }
      ref.read(isLoadingMoreProvider.notifier).state = false;
    }, onError: (error) {
      ref.read(isLoadingMoreProvider.notifier).state = false;
    });
  }

  bool checkLoadMoreItems(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
      loadMoreItems();
    }
    return true;
  }

  // UI 업데이트를 위한 함수
  void _updatePagingController(List<ReadableListItem> list) {
    if (list.isNotEmpty) {
      _lastId = list.last.item.id;
    }
    state.maybeWhen(data: (previousList) {
      if (previousList != null) {
        final data = List<ReadableListItem>.from(previousList)..addAll(list);
        state = AsyncValue.data(data);
      } else {
        state = AsyncValue.data(list);
      }
    }, orElse: () {
      state = AsyncValue.data(list);
    });
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
