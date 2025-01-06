import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_list.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/use_case_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'list_page_state.dart';

part 'list_view_model.freezed.dart';

part 'list_view_model.g.dart';

@riverpod
class ListViewModel extends _$ListViewModel {
  late MainItem _item;

  final List<ListItem> _list = [];

  List<ListItem> get currentData => List.unmodifiable(_list);

  void initialize(MainItem item) {
    _item = item;
  }

  @override
  ListPageState build() {
    final page = ref.watch(_currentPageProvider);
    _fetchPage(page);
    return ListPageState.loading();
  }

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  int get listCount => _list.length;

  ListItem getItem(int index) => _list.elementAt(index);

  int _lastId = -1;

  String get smallTitle => _item.siteType.title;

  String get title => _item.text;

  Future<void> refresh() async {
    _lastId = -1;
    ref.invalidateSelf();
  }

  Future<void> fetchNextPage() async {
    if (!_isLoading) {
      ref.read(_currentPageProvider.notifier).nextPage();
    }
  }

  Future<void> _fetchPage(int page) async {
    log('_fetchPage page=$page');

    _isLoading = true;

    final params = GetListParams(mainItem: _item, page: page, lastId: _lastId);

    try {
      final getList = ref.read(getListProvider);
      final result = await getList(params);
      result.fold((failure) {
        state = FailedList(failure.message);
      }, (data) {
        if (data.isNotEmpty) {
          _lastId = data.last.id;
          _list.addAll(data);
        }
        state = const LoadedList();
      });
    } finally {
      _isLoading = false;
    }
  }

  Future<void> handleItemTap(BuildContext context, ListItem item) async {
    final extra = [_item.siteType, item];

    GoRouter.of(context).push(Routes.detail, extra: extra).then((_) {
      if (context.mounted) {
        final readId = ref.read(readableStateProvider);
        if (readId == item.id && !item.isRead) {
          _updateItemReadStatus(item.id);
        }
      }
    });
  }

  void _updateItemReadStatus(int itemId) async {
    final index = _list.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      state = const LoadingList();
      final updatedItem = _list[index].copyWith(isRead: true);
      _list[index] = updatedItem;
      state = const LoadedList();
    }
  }
}

@riverpod
class _CurrentPage extends _$CurrentPage {
  @override
  int build() => 1;

  void nextPage() => state++;
}
