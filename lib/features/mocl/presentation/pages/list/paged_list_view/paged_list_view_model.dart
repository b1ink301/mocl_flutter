import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/get_list.dart';
import 'package:mocl_flutter/features/mocl/presentation/base/base_view_model.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';

class PagedListViewModel extends BaseViewModel {
  final MainItem _mainItem;
  final GetList _getList;
  late final PagingController<int, ReadableListItem> pagingController;

  int _lastId = -1;
  bool _isClienRecommend = false;

  PagedListViewModel({
    required MainItem mainItem,
    required GetList getList,
  })  : _mainItem = mainItem,
        _getList = getList {
    _isClienRecommend =
        _mainItem.siteType == SiteType.clien && _mainItem.board == 'recommend';
    pagingController = PagingController(firstPageKey: 1)
      ..addPageRequestListener(_fetchPage);
  }

  String get smallTitle => _mainItem.siteType.title;

  String get title => _mainItem.text;

  TextStyles getTextStyles(BuildContext context) =>
      TextStyles.getTextStyles(context);

  void refresh() {
    _lastId = -1;
    pagingController.refresh();
  }

  @override
  void dispose() {
    pagingController.dispose();
    super.dispose();
  }

  void _fetchPage(int page) {
    log('Fetching page: item=$_mainItem, page=$page, lastId=$_lastId');

    final params =
        GetListParams(mainItem: _mainItem, page: page, lastId: _lastId);

    _getList(params).then((result) {
      if (result is ResultSuccess<List<ListItem>>) {
        log('Fetched items: ${result.data.length}');
        final list = result.data.map(_toReadableListItem).toList();
        _updatePagingController(list, page);
      } else if (result is ResultFailure) {
        debugPrint('Error fetching page: ${result.failure}');
        pagingController.error = result.failure;
      }
    }).catchError((e) => pagingController.error = e);
  }

  ReadableListItem _toReadableListItem(ListItem item) => ReadableListItem(
        item: item,
        isRead: ValueNotifier(item.isRead),
      );

  void _updatePagingController(List<ReadableListItem> list, int page) {
    if (list.isNotEmpty) {
      _lastId = list.last.item.id;
    }

    if (_isClienRecommend) {
      pagingController.appendLastPage(list);
    } else {
      pagingController.appendPage(list, page + 1);
    }
  }

  void handleItemTap(BuildContext context, ReadableListItem item) {
    context.push(Routes.DETAIL, extra: item);
  }
}
