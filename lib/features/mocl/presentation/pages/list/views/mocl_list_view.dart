import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../../../domain/entities/mocl_list_item.dart';
import '../../../../domain/entities/mocl_user_info.dart';
import '../../../models/mocl_list_item_wrapper.dart';
import '../../../routes/mocl_app_pages.dart';
import '../../../widgets/image_widget.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/round_text_widget.dart';
import '../controllers/mocl_list_controller.dart';

class ListView extends StatefulWidget {
  const ListView({super.key});

  @override
  _ListViewState createState() => _ListViewState();
}

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
        itemBuilder: (context, item, index) => InkWell(
          child: ValueListenableBuilder(
              valueListenable: item.isReadNotifier,
              builder: (BuildContext context, value, Widget? child) =>
                  _buildListItem(
                    context,
                    item.item,
                    item.isReadNotifier.value ? readTextStyle : textStyle,
                    item.isReadNotifier.value
                        ? readSmallTextStyle
                        : smallTextStyle,
                    item.isReadNotifier.value
                        ? readBadgeTextStyle
                        : badgeTextStyle,
                  )),
          onTap: () async {
            await Get.toNamed(Routes.DETAIL, arguments: item.item);
            var isReadFlag = Get.findOrNull<bool>(tag: Routes.DETAIL);
            log('isReadFlag=$isReadFlag');
            if (isReadFlag != null) {
              _listController.setReadFlag(item);
              Get.delete<bool>(tag: Routes.DETAIL);
            }
          },
        ),
        newPageProgressIndicatorBuilder: (context) => const LoadingWidget(),
        firstPageProgressIndicatorBuilder: (context) => const LoadingWidget(),
      ),
      separatorBuilder: (context, index) => const Divider(
        indent: 16,
        endIndent: 4,
      ),
    );
  }

  Widget _buildListItem(
    BuildContext context,
    ListItem listItem,
    TextStyle? textStyle,
    TextStyle? smallTextStyle,
    TextStyle? badgeTextStyle,
  ) =>
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 8, 4, 8),
        child: Column(
          key: Key(listItem.id.toString()),
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              listItem.title,
              style: textStyle,
            ),
            const SizedBox(height: 8),
            _buildBottomView(
              context,
              listItem.userInfo,
              listItem.reply,
              listItem.time,
              smallTextStyle,
              badgeTextStyle,
            ),
          ],
        ),
      );

  Widget _buildBottomView(
    BuildContext context,
    UserInfo userInfo,
    String reply,
    String time,
    TextStyle? textStyle,
    TextStyle? badgeTextStyle,
  ) =>
      Row(
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
      );
}
