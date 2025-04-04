import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_list.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/readable_flag.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/nick_image_widget.dart';

part 'list_page_cubit.freezed.dart';
part 'list_page_state.dart';

@injectable
class ListPageCubit extends Cubit<ListPageState> {
  final GetList _getList;
  final MainItem _mainItem;
  final ReadableFlag _readableFlag;

  final List<ListItem> _list = [];

  List<ListItem> get list => List.unmodifiable(_list);

  ListItem getItem(int index) => _list.elementAt(index);

  int _lastId = -1;
  int _page = 1;
  bool _isLoading = false;

  bool get hasReachedMax => _hasReachedMax;
  bool _hasReachedMax = false;

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
    _hasReachedMax =
        _mainItem.siteType == SiteType.clien && _mainItem.board == 'recommend';
    _page = _mainItem.siteType == SiteType.clien ? 0 : 1;
  }

  Future<void> refresh() async {
    _lastId = -1;
    _list.clear();
    _initPage();
    await fetchPage();
  }

  void onTap(BuildContext context, int index) {
    final item = _list[index];
    final extra = [_mainItem.siteType, item];
    _readableFlag.id = -1;
    GoRouter.of(context).push(Routes.detail, extra: extra).then((_) {
      if (_readableFlag.id == item.id && !item.isRead) {
        _updateItemReadStatus(index);
      }
    });
  }

  void _updateItemReadStatus(int index) {
    emit(state.copyWith(isLoading: true));
    _list[index] = _list[index].copyWith(isRead: true);
    emit(state.copyWith(isLoading: false));
  }

  Future<void> fetchPage() async {
    if (_isLoading) {
      return;
    }
    _isLoading = true;
    // emit(state.copyWith(isLoading: true));
    try {
      final params =
          GetListParams(mainItem: _mainItem, page: _page, lastId: _lastId);
      final Result<List<ListItem>> result = await _getList(params);
      result.whenOrNull(
        success: (data) {
          if (data is List<ListItem>) {
            if (data.isNotEmpty) {
              _lastId = data.last.id;
              _list.addAll(data);
            }
            _page++;
            emit(state.copyWith(count: _list.length, isLoading: false));
          }
        },
        failure: (failure) {
          emit(state.copyWith(error: failure.message, isLoading: false));
        },
      );
    } catch (e) {
      emit(state.copyWith(error: e.toString(), isLoading: false));
    } finally {
      _isLoading = false;
    }
  }

  void _preloadNextPageImages(List<ListItem> items) async {
    final urls = items
        .map((item) => item.userInfo.nickImage)
        .where((url) => url.isNotEmpty && url.startsWith('http'))
        .toList();

    await NickImageWidget.preloadImages(urls);
  }
}
