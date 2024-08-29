import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_list.dart';
import 'package:mocl_flutter/features/mocl/presentation/base/base_view_model.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';

class ListViewModel extends BaseViewModel {
  final MainItem _mainItem;
  final GetList _getList;

  AsyncValue<List<ReadableListItem>> _items = const AsyncLoading();

  AsyncValue<List<ReadableListItem>> get items => _items;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  int _currentPage = 1;
  int _lastId = -1;

  ListViewModel({
    required MainItem mainItem,
    required GetList getList,
  })  : _mainItem = mainItem,
        _getList = getList {
    _fetchPage();
  }

  String get smallTitle => _mainItem.siteType.title;

  String get title => _mainItem.text;

  Future<void> refresh() async {
    _currentPage = 1;
    _lastId = -1;
    _items = const AsyncLoading();
    notifyListeners();
    await _fetchPage();
  }

  Future<void> fetchNextPage() async {
    if (!_isLoading) {
      _currentPage++;
      await _fetchPage();
    }
  }

  Future<void> _fetchPage() async {
    _isLoading = true;
    notifyListeners();

    final params =
        GetListParams(mainItem: _mainItem, page: _currentPage, lastId: _lastId);

    try {
      final result = await _getList(params);

      if (result is ResultSuccess<List<ListItem>>) {
        final newItems = result.data
            .map((item) => ReadableListItem(
                  item: item,
                  isRead: ValueNotifier(item.isRead),
                ))
            .toList();

        _items.addAll(newItems);

        if (newItems.isNotEmpty) {
          _lastId = newItems.last.item.id;
        }
      } else if (result is ResultFailure) {
        // Handle error
      }
    } catch (e) {
      // Handle unexpected error
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> handleItemTap(
      BuildContext context, ReadableListItem item) async {
    await context.push(Routes.DETAIL, extra: item);
  }
}
