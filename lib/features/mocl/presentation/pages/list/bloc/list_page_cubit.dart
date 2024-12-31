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

part 'list_page_state.dart';

part 'list_page_cubit.freezed.dart';

@injectable
class ListPageCubit extends Cubit<ListPageState> {
  final GetList _getList;
  final MainItem _mainItem;

  int _lastId = -1;
  int _page = 1;

  bool get hasReachedMax => _hasReachedMax;
  bool _hasReachedMax = false;

  final List<ReadableListItem> _list = [];

  List<ReadableListItem> get list => List.unmodifiable(_list);

  int get listCount => _list.length;

  ReadableListItem getItem(int index) => _list.elementAt(index);

  ListPageCubit(
    this._getList,
    @factoryParam this._mainItem,
    // @factoryParam this._textStyles,
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

  void onTap(BuildContext context, ReadableListItem item) {
    final extra = [_mainItem.siteType, item];
    GoRouter.of(context).push(Routes.detail, extra: extra);
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
            final list =
            data.whereType<ListItem>().map(_toReadableListItem).toList();

            if (list.isNotEmpty) {
              _lastId = list.last.item.id;
              _list.addAll(list);
            }
            _page++;

            emit(const LoadedList());
          } else {
            emit(FailedList('Unexpected data type: ${data.runtimeType}'));
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

  ReadableListItem _toReadableListItem(ListItem item) => ReadableListItem(
        item: item,
        isRead: ValueNotifier(item.isRead),
      );

  @override
  Future<void> close() async {
    _list.clear();
    super.close();
  }
}
