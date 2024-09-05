import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_list.dart';
import 'package:mocl_flutter/features/mocl/presentation/base/base_view_model.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';

class ListViewModel extends BaseStateViewModel<Result> {
  final MainItem _mainItem;
  final GetList _getList;

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  int _currentPage = 1;
  int _lastId = -1;

  ListViewModel({
    required MainItem mainItem,
    required GetList getList,
  })  : _mainItem = mainItem,
        _getList = getList,
        super(ResultLoading()) {
    _fetchPage();
  }

  String get smallTitle => _mainItem.siteType.title;

  String get title => _mainItem.text;

  Future<void> refresh() async {
    _currentPage = 1;
    _lastId = -1;
    await _fetchPage();
  }

  Future<void> fetchNextPage() async {
    if (!_isLoading) {
      _currentPage++;
      await _fetchPage();
    }
  }

  Future<void> _fetchPage() async {
    log('_fetchPage _currentPage=$_currentPage');

    _isLoading = true;

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

        state = ResultSuccess(data: newItems);

        // state.maybeWhen(data: (previousList) {
        //   final data = List<ReadableListItem>.from(previousList)
        //     ..addAll(newItems);
        //   state = AsyncValue.data(data);
        // }, orElse: () {
        //   state = AsyncValue.data(newItems);
        // });

        if (newItems.isNotEmpty) {
          _lastId = newItems.last.item.id;
        }
      } else {
        state = result;
      }
    } catch (e) {
      state = ResultFailure(failure: GetListFailure(message: e.toString()));
    } finally {
      _isLoading = false;
    }
  }

  Future<void> handleItemTap(
      BuildContext context, ReadableListItem item) async {
    await context.push(Routes.DETAIL, extra: item);
  }
}
