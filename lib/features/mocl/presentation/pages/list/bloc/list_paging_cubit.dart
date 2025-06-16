import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/last_id.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/sort_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_list.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/bloc/list_item_cubit.dart';

@injectable
class ListPagingCubit extends Cubit<PagingState<int, ListItemCubit>> {
  final GetList _getList;
  final MainItem _mainItem;

  LastId _lastId = LastId.empty();

  ListPagingCubit(this._getList, @factoryParam this._mainItem)
    : super(PagingState());

  String get smallTitle => _mainItem.siteType.title;

  String get title => _mainItem.text;

  int _initPage() => _mainItem.siteType == SiteType.clien ? 0 : 1;

  Future<void> refresh() async {
    _lastId = LastId.empty();
    emit(PagingState());
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
          final List<ListItemCubit> newItems = result.data
              .map((item) => ListItemCubit(item))
              .toList();
          if (newItems.isNotEmpty) {
            _lastId = LastId(
              intId: result.data.last.id,
              stringId: result.data.last.url,
            );
          }
          final bool hasReachedMax =
              _mainItem.siteType == SiteType.clien &&
              _mainItem.board == 'recommend';
          emit(
            state.copyWith(
              pages: [...?state.pages, newItems],
              keys: [...?state.keys, (page + 1)],
              hasNextPage: !hasReachedMax,
              isLoading: false,
            ),
          );
          break;

        case ResultFailure<List<ListItem>>():
          emit(state.copyWith(error: result.failure.message, isLoading: false));
          break;

        case ResultLoading():
          break;
      }
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    }
  }
}
