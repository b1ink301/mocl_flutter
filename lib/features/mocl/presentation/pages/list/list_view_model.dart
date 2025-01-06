import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_list.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/use_case_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/bloc/list_page_cubit.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'list_view_model.g.dart';

@riverpod
class ListViewModel extends _$ListViewModel {
  late MainItem _mainItem;

  ListPageState build(MainItem mainItem) {
    _mainItem = mainItem;
    _fetchPage();
    return ListPageState.loading();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  int _currentPage = 1;
  int _lastId = -1;

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

    if (state != ListPageState.loading()) {
      state = ListPageState.loading();
    }

    try {
      final getList = ref.read(getListProvider);
      final result = await getList(params);

      if (result is ResultSuccess<List<ListItem>>) {
        final newItems = result.data;
        state = ListPageState.loaded();

        // state.maybeWhen(data: (previousList) {
        //   final data = List<ReadableListItem>.from(previousList)
        //     ..addAll(newItems);
        //   state = AsyncValue.data(data);
        // }, orElse: () {
        //   state = AsyncValue.data(newItems);
        // });

        if (newItems.isNotEmpty) {
          _lastId = newItems.last.id;
        }
      } else {
        state = ListPageState.loaded();
      }
    } catch (e) {
      state = ListPageState.failed(e.toString());
    } finally {
      _isLoading = false;
    }
  }

  Future<void> handleItemTap(
      BuildContext context, ReadableListItem item) async {
    await context.push(Routes.detail, extra: item);
  }
}
