import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

import '../../../domain/entities/mocl_user_info.dart';
import '../../models/mocl_list_item_wrapper.dart';
import '../../widgets/image_widget.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/round_text_widget.dart';
import '../../routes/mocl_app_pages.dart';
import 'mocl_list_controller.dart';

class ListPage extends GetView<ListController> {
  const ListPage({super.key});

  Widget _buildTitle(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MessageWidget(
            message: controller.getAppbarSmallTitle(),
            textStyle:
                Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 11),
          ),
          const SizedBox(height: 4),
          MessageWidget(
            textStyle: Theme.of(context).textTheme.labelMedium,
            message: controller.getAppbarTitle(),
          ),
        ],
      );

  SliverAppBar _buildAppbar(BuildContext context) => SliverAppBar(
        title: _buildTitle(context),
        automaticallyImplyLeading: false,
        toolbarHeight: 60,
        floating: true,
        pinned: false,
        actions: [
          IconButton(
            onPressed: () => controller.reload(),
            icon: const Icon(Icons.refresh),
          )
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          controller: controller.scrollController,
          slivers: <Widget>[
            _buildAppbar(context),
            const _ListView(),
          ],
        ),
      );
}

class _ListView extends StatefulWidget {
  const _ListView();

  @override
  _ListViewState createState() => _ListViewState();
}

class _ListViewState extends State<_ListView> {
  final ListController _listController = Get.find();

  @override
  PagedSliverList build(BuildContext context) =>
      PagedSliverList<int, ListItemWrapper>.separated(
        pagingController: _listController.pagingController,
        builderDelegate: PagedChildBuilderDelegate<ListItemWrapper>(
          itemBuilder: (context, item, index) => InkWell(
            child: ValueListenableBuilder(
                valueListenable: item.isReadNotifier,
                builder: (BuildContext context, value, Widget? child) =>
                    _buildListItem(context, item)),
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

  Widget _buildListItem(
    BuildContext context,
    ListItemWrapper listItemWrapper,
  ) {
    var textStyle = Theme.of(context).textTheme.bodyMedium;
    var smallTextStyle = Theme.of(context).textTheme.bodySmall;
    var badgeTextStyle = Theme.of(context).textTheme.labelSmall;
    var listItem = listItemWrapper.item;
    if (listItemWrapper.isReadNotifier.value) {
      var color = Theme.of(context).highlightColor;
      textStyle = textStyle?.copyWith(color: color);
      badgeTextStyle = badgeTextStyle?.copyWith(color: color);
      smallTextStyle = smallTextStyle?.copyWith(color: color);
    }
    return Padding(
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
  }

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
