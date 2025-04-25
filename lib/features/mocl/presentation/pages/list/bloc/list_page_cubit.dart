import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/last_id.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/sort_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_list.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/readable_flag.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';

part 'list_page_cubit.freezed.dart';

part 'list_page_state.dart';

@injectable
class ListPageCubit extends Cubit<ListPageState> {
  final GetList _getList;
  final MainItem _mainItem;
  final ReadableFlag _readableFlag;

  final List<ReadableListItem> _list = [];

  // List<ListItem> get list => List.unmodifiable(_list);

  ReadableListItem getItem(int index) => _list.elementAt(index);

  LastId _lastId = LastId.empty();
  int _page = 1;
  bool _isLoading = false;

  ListPageCubit(
    this._getList,
    this._readableFlag,
    @factoryParam this._mainItem,
  ) : super(const ListPageState(isLoading: true)) {
    _initPage();
    fetchPage();
  }

  String get smallTitle => _mainItem.siteType.title;

  String get title => _mainItem.text;

  _initPage() {
    _page = _mainItem.siteType == SiteType.clien ? 0 : 1;
  }

  Future<void> refresh() async {
    _lastId = LastId.empty();
    _list.clear();
    _initPage();
    await fetchPage();
  }

  void onTap(BuildContext context, int index) {
    final ListItem item = _list[index].item;
    final List<Object> extra = [_mainItem.siteType, item];
    _readableFlag.id = -1;

    GoRouter.of(context).push(Routes.detail, extra: extra).then((_) {
      if (!context.mounted) {
        return;
      }
      if (_readableFlag.id == item.id && !item.isRead) {
        _updateItemReadStatus(index);
      }
    });
  }

  void _updateItemReadStatus(int index) {
    _list[index].markAsRead();
  }

  Future<void> fetchPage() async {
    if (_isLoading || state.hasReachedMax) {
      return;
    }
    _isLoading = true;
    // emit(state.copyWith(isLoading: true));
    try {
      final GetListParams params = GetListParams(
        mainItem: _mainItem,
        page: _page,
        lastId: _lastId,
        sortType: SortType.recent,
      );

      // final Result<List<ListItem>> result = await compute(_getList.call, params);
      final Result<List<ListItem>> result = await _getList(params);
      result.whenOrNull(
        success: (data) {
          if (data is List<ListItem>) {
            final list =
                data.whereType<ListItem>().map(_toReadableListItem).toList();

            if (list.isNotEmpty) {
              _list.addAll(list);
              _lastId = LastId(intId: data.last.id);
            }
            final bool hasReachedMax = _mainItem.siteType == SiteType.clien &&
                _mainItem.board == 'recommend';
            _page++;

            emit(state.copyWith(
              count: _list.length,
              isLoading: false,
              hasReachedMax: hasReachedMax,
            ));
          } else {
            emit(state.copyWith(
                error: 'data is not List<ListItem>', isLoading: false));
          }
        },
        failure: (failure) =>
            emit(state.copyWith(error: failure.message, isLoading: false)),
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    } finally {
      _isLoading = false;
    }
  }

  ReadableListItem _toReadableListItem(ListItem item) {
    return ReadableListItem(
      item: item,
      isRead: ValueNotifier(item.isRead),
    );
  }
}
