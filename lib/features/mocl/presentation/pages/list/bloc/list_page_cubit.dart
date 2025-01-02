import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:go_router/go_router.dart';
import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_list.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/nick_image_widget.dart';

part 'list_page_state.dart';

part 'list_page_cubit.freezed.dart';

@injectable
class ListPageCubit extends Cubit<ListPageState> {
  final GetList _getList;
  final MainItem _mainItem;

  final List<ListItem> _list = [];

  List<ListItem> get list => List.unmodifiable(_list);

  int get listCount => _list.length;

  ListItem getItem(int index) => _list.elementAt(index);

  int _lastId = -1;
  int _page = 1;

  bool get hasReachedMax => _hasReachedMax;
  bool _hasReachedMax = false;

  ListPageCubit(
    this._getList,
    @factoryParam this._mainItem,
  ) : super(const LoadingList()) {
    _initPage();
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
    _hasReachedMax = false;
    await fetchPage();
  }

  void onTap(BuildContext context, ListItem item) {
    final extra = [_mainItem.siteType, item];
    GoRouter.of(context).push<bool>(Routes.detail, extra: extra).then((_) {

      debugPrint('onTap item.isRead=${item.isRead}');
      if (!item.isRead) {
        _updateItemReadStatus(item.id);
      }
    });
  }

  void _updateItemReadStatus(int itemId) async {
    final index = _list.indexWhere((item) => item.id == itemId);
    if (index != -1) {
      emit(const LoadingList());
      final updatedItem = _list[index].copyWith(isRead: true);
      _list[index] = updatedItem;
      await Future.delayed(Duration(milliseconds: 200));
      emit(const LoadedList());

      debugPrint('_updateItemReadStatus=$itemId');
    }
  }

  Future<void> fetchPage() async {
    emit(const LoadingList());
    try {
      final params = GetListParams(
        mainItem: _mainItem,
        page: _page,
        lastId: _lastId,
      );
      final Result<List<ListItem>> result = await _getList(params);

      result.whenOrNull(
        success: (data) {
          if (data is List<ListItem>) {
            if (data.isNotEmpty) {
              _lastId = data.last.id;
              _list.addAll(data);
              // _preloadNextPageImages(data);
            }
            _page++;
            emit(const LoadedList());
          }
        },
        failure: (failure) {
          emit(FailedList(failure.message));
        },
      );
    } catch (e) {
      emit(FailedList(e.toString()));
    }
  }

  void _preloadNextPageImages(List<ListItem> items) async {
    final urls = items
        .map((item) => item.userInfo.nickImage)
        .where((url) => url.isNotEmpty && url.startsWith('http'))
        .toList();

    await NickImageWidget.preloadImages(urls);
  }

  @override
  Future<void> close() async {
    _list.clear();
    super.close();
  }
}
