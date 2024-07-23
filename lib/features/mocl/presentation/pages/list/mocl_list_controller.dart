import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_read_flag.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/mocl_list_item_wrapper.dart';

import '../../../domain/entities/mocl_main_item.dart';
import '../../../domain/entities/mocl_result.dart';
import '../../../domain/usecases/get_list.dart';

class ListController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final GetList _getList;
  final SetReadFlag _setReadFlag;
  final MainItem _mainItem = Get.arguments;
  final PagingController<int, ListItemWrapper> pagingController =
      PagingController(firstPageKey: 1);

  ListController({
    required GetList getList,
    required SetReadFlag setReadFlag,
  })  : _getList = getList,
        _setReadFlag = setReadFlag;

  String getAppbarTitle() => _mainItem.text;
  String getAppbarSmallTitle() => switch(_mainItem.siteType) {
    SiteType.clien => '클리앙',
    SiteType.damoang => '다모앙',
    _ => ''
  };

  @override
  void onInit() async {
    super.onInit();

    pagingController.addPageRequestListener((pageKey) {
      _fetchPage(_mainItem, pageKey);
    });
  }

  @override
  void dispose() {
    super.dispose();
    scrollController.dispose();
    pagingController.dispose();
  }

  void _fetchPage(MainItem item, int page) async {
    debugPrint('fetchPage item=$item, page=$page');
    var params = GetListParams(mainItem: item, page: page);
    var result = await _getList(params);
    debugPrint('fetchPage result=$result');

    if (result is ResultSuccess) {
      var data = result as ResultSuccess<List<ListItem>>;
      debugPrint('initMainList length=${data.data.length}');
      final isLastPage = result.data.isEmpty;
      var list = result.data
          .map(
            (item) => ListItemWrapper(
              item: item,
              isReadNotifier: ValueNotifier(item.isRead),
            ),
          )
          .toList();
      if (isLastPage) {
        pagingController.appendLastPage(list);
      } else {
        final nextPageKey = pagingController.nextPageKey! + 1;
        pagingController.appendPage(list, nextPageKey);
      }
    } else if (result is ResultFailure) {
      pagingController.error = result.failure;
    } else if (result is ResultLoading) {}
  }

  void setReadFlag(ListItemWrapper itemWrapper) async {
    itemWrapper.isReadNotifier.value = true;
    SetReadFlagParams params = SetReadFlagParams(
      siteType: _mainItem.siteType,
      boardId: itemWrapper.item.id,
    );
    await _setReadFlag(params);
  }

  void reload() => pagingController.refresh();
}
