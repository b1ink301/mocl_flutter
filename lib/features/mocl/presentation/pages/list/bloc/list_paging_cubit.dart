import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
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

@injectable
class ListPagingCubit extends Cubit<PagingState<int, ReadableListItem>> {
  final GetList _getList;
  final MainItem _mainItem;
  final ReadableFlag _readableFlag;

  LastId _lastId = LastId.empty();

  ListPagingCubit(
    this._getList,
    this._readableFlag,
    @factoryParam this._mainItem,
  ) : super(PagingState());

  String get smallTitle => _mainItem.siteType.title;

  String get title => _mainItem.text;

  int _initPage() => _mainItem.siteType == SiteType.clien ? 0 : 1;

  Future<void> refresh() async {
    _lastId = LastId.empty();
    emit(PagingState());
  }

  void onTap(BuildContext context, ReadableListItem model) {
    final List<Object> extra = [_mainItem.siteType, model.item];
    _readableFlag.id = -1;

    GoRouter.of(context).push(Routes.detail, extra: extra).then((_) {
      if (!context.mounted) {
        return;
      }
      if (_readableFlag.id == model.item.id && model.isUnread) {
        model.markAsRead();
      }
    });
  }

  Future<void> fetchPage() async {
    if (state.isLoading || !state.hasNextPage) {
      return;
    }
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final page = state.keys?.last ?? _initPage();

      final GetListParams params = GetListParams(
        mainItem: _mainItem,
        page: page,
        lastId: _lastId,
        sortType: SortType.recent,
      );

      final Result<List<ListItem>> result = await _getList(params);
      switch (result) {
        case ResultSuccess<List<ListItem>>():
          final List<ReadableListItem> newItems = result.data
              .whereType<ListItem>()
              .map(_toReadableListItem)
              .toList();

          if (newItems.isNotEmpty) {
            _lastId = LastId(intId: result.data.last.id);
          }

          final bool hasReachedMax = _mainItem.siteType == SiteType.clien &&
              _mainItem.board == 'recommend';

          emit(state.copyWith(
            pages: [...?state.pages, newItems],
            keys: [...?state.keys, (page + 1)],
            hasNextPage: !hasReachedMax,
            isLoading: false,
          ));
          break;
        case ResultFailure<List<ListItem>>():
          emit(state.copyWith(
            error: result.failure.message,
            isLoading: false,
          ));
          break;

        default:
          break;
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }

  ReadableListItem _toReadableListItem(ListItem item) => ReadableListItem(
        item: item,
        isRead: ValueNotifier(item.isRead),
      );
}
