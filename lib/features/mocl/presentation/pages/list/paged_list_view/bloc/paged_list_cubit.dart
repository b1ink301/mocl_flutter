import 'dart:async';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_list.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';

part 'paged_list_cubit.freezed.dart';

part 'paged_list_state.dart';

@injectable
class PagedListCubit extends Cubit<PagedListState> {
  final GetList _getList;
  final MainItem _mainItem;
  final TextStyles _textStyles;
  int _lastId = -1;
  bool _isNoMore = false;

  final PagingController<int, ReadableListItem> pagingController =
      PagingController(firstPageKey: 1, invisibleItemsThreshold: 5,);

  PagedListCubit(
    this._getList,
    @factoryParam this._mainItem,
    @factoryParam this._textStyles,
  ) : super(const LoadingPage()) {
    _isNoMore =
        _mainItem.siteType == SiteType.clien && _mainItem.board == 'recommend';
    pagingController.addPageRequestListener(_fetchPage);
  }

  String get smallTitle => _mainItem.siteType.title;

  String get title => _mainItem.text;

  TextStyles get textStyles => _textStyles;

  void refresh() {
    _lastId = -1;
    pagingController.refresh();
  }

  void onTap(BuildContext context, ReadableListItem item) {
    final extra = [_mainItem.siteType, item];
    GoRouter.of(context).push(Routes.DETAIL, extra: extra);
  }

  void _fetchPage(int page) {
    final params = GetListParams(
      mainItem: _mainItem,
      page: page,
      lastId: _lastId,
    );

    _getList(params).then((result) {
      debugPrint('fetchPage result=${result.runtimeType}');
      if (result is ResultSuccess<List<ListItem>>) {
        final list = result.data.map(_toReadableListItem).toList();
        if (list.isNotEmpty) {
          _lastId = list.last.item.id;
        }
        if (_isNoMore) {
          pagingController.appendLastPage(list);
        } else {
          pagingController.appendPage(list, page + 1);
        }
      } else if (result is ResultFailure) {
        pagingController.error =
            ErrorPage(message: result.failure.toString(), page: page);
      }
    }).catchError((e) {
      pagingController.error = ErrorPage(message: e.toString(), page: page);
    });
  }

  ReadableListItem _toReadableListItem(ListItem item) => ReadableListItem(
        item: item,
        isRead: ValueNotifier(item.isRead),
      );

  @override
  Future<void> close() async {
    log('[PagedListCubit] close');
    pagingController.dispose();
    // _blocListingStateSubscription.cancel();
    super.close();
  }

  @override
  void emit(PagedListState state) {
    if (isClosed) return;
    super.emit(state);
  }
}
