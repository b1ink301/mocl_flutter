import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../routes/mocl_app_pages.dart';
import '../controllers/mocl_list_controller.dart';
import 'mocl_cached_list_item.dart';

class ListView extends StatefulWidget {
  const ListView({super.key});

  @override
  _ListViewState createState() => _ListViewState();
}

class _ListViewState extends State<ListView> {
  final ScrollController _scrollController = ScrollController();
  final ListController _listController = Get.find();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _listController.loadMoreItems();
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Obx(
        () => SliverList.separated(
          itemBuilder: (BuildContext context, int index) {
            if (index < _listController.items.length) {
              final item = _listController.items[index];
              if (kDebugMode) {
                Get.log('SliverList index=$index');
              }
              return CachedListItem(
                key: ValueKey(item.item.id),
                item: item,
                onTap: () async {
                  await Get.toNamed(Routes.DETAIL, arguments: item.item);
                  var isReadFlag = Get.findOrNull<bool>(tag: Routes.DETAIL);
                  if (isReadFlag != null) {
                    _listController.setReadFlag(item);
                    Get.delete<bool>(tag: Routes.DETAIL);
                  }
                },
              );
            }
            // 로딩 인디케이터 표시
            if (index == _listController.items.length &&
                _listController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }
            return null;
          },
          separatorBuilder: (BuildContext context, int index) => const Divider(
            indent: 16,
            endIndent: 4,
          ),
          itemCount: _listController.items.length +
              (_listController.isLoading.value ? 1 : 0),
        ),
      );
}

/*
class _ListViewState extends State<ListView> {
  final ListController _listController = Get.find();

  @override
  PagedSliverList build(BuildContext context) {
    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium;
    final smallTextStyle = theme.textTheme.bodySmall;
    final badgeTextStyle = theme.textTheme.labelSmall;
    final color = theme.highlightColor;
    final readTextStyle = textStyle?.copyWith(color: color);
    final readSmallTextStyle = smallTextStyle?.copyWith(color: color);
    final readBadgeTextStyle = badgeTextStyle?.copyWith(color: color);

    return PagedSliverList<int, ListItemWrapper>.separated(
      pagingController: _listController.pagingController,
      builderDelegate: PagedChildBuilderDelegate<ListItemWrapper>(
        itemBuilder: (context, item, index) {
          if (kDebugMode) {
            Get.log('PagedSliverList index=$index, key=${item.item.id}');
          }
          return KeyedSubtree(
            key: Key(item.item.id.toString()),
            child: ValueListenableBuilder<bool>(
              valueListenable: item.isReadNotifier,
              builder: (BuildContext context, value, Widget? child) {
                if (kDebugMode) {
                  Get.log(
                      'ValueListenableBuilder value=$value, child=${child?.runtimeType}');
                }

                return ListTile(
                  dense: true,
                  contentPadding: const EdgeInsets.fromLTRB(16, 0, 4, 0),
                  title: Text(
                    item.item.title,
                    style: value ? readTextStyle : textStyle,
                  ),
                  subtitle: _buildBottomView(
                    context,
                    item.item.userInfo,
                    item.item.reply,
                    item.item.time,
                    value ? readSmallTextStyle : smallTextStyle,
                    value ? readBadgeTextStyle : badgeTextStyle,
                  ),
                  onTap: () async {
                    await Get.toNamed(Routes.DETAIL, arguments: item.item);
                    var isReadFlag = Get.findOrNull<bool>(tag: Routes.DETAIL);
                    log('isReadFlag=$isReadFlag');
                    if (isReadFlag != null) {
                      _listController.setReadFlag(item);
                      Get.delete<bool>(tag: Routes.DETAIL);
                    }
                  },
                );
              },
            ),
          );
        },
        // newPageProgressIndicatorBuilder: (context) => const LoadingWidget(),
        firstPageProgressIndicatorBuilder: (context) => const LoadingWidget(),
      ),
      separatorBuilder: (context, index) => const Divider(
        key: Key('divider'),
        indent: 16,
        endIndent: 4,
      ),
    );
  }

  Widget _buildBottomView(
    BuildContext context,
    UserInfo userInfo,
    String reply,
    String time,
    TextStyle? textStyle,
    TextStyle? badgeTextStyle,
  ) =>
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            ImageWidget(url: userInfo.nickImage),
            Text(
              userInfo.nickName,
              style: textStyle,
            ),
            const SizedBox(width: 8),
            Text(
              time,
              style: textStyle,
            ),
            const Spacer(),
            RoundTextWidget(
              text: reply,
              textStyle: badgeTextStyle,
            ),
            const SizedBox(width: 8),
          ],
        ),
      );
}*/
