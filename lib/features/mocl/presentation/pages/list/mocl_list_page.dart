import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

import '../../../domain/entities/mocl_user_info.dart';
import '../../models/mocl_list_item_wrapper.dart';
import '../mocl_routes.dart';
import 'mocl_list_controller.dart';

class ListPage extends GetView<ListController> {
  const ListPage({super.key});

  Widget buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MessageWidget(
            message: '다모앙',
            fontSize: 12,
          ),
          MessageWidget(
            message: controller.getAppbarTitle(),
          ),
        ],
      );

  SliverAppBar buildAppbar(BuildContext context) => SliverAppBar(
        title: buildTitle(),
        automaticallyImplyLeading: false,
        toolbarHeight: 60,
        floating: true,
        pinned: false,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.refresh),
          )
        ],
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        body: CustomScrollView(
          // physics: const BouncingScrollPhysics(),
          controller: controller.scrollController,
          slivers: <Widget>[
            buildAppbar(context),
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
  void initState() {
    super.initState();
  }

  @override
  PagedSliverList build(BuildContext context) =>
      PagedSliverList<int, ListItemWrapper>.separated(
        pagingController: _listController.pagingController,
        builderDelegate: PagedChildBuilderDelegate<ListItemWrapper>(
          itemBuilder: (context, item, index) => InkWell(
            child: ValueListenableBuilder(
                valueListenable: item.isReadNotifier,
                builder: (BuildContext context, value, Widget? child) =>
                    buildListItem(context, item)),
            onTap: () async {
              var isReadFlag =
                  await Get.toNamed(Routes.DETAIL, arguments: item.item);
              log('isReadFlag=$isReadFlag');
              if (isReadFlag && item.isReadNotifier.value == false) {
                _listController.setReadFlag(item);
              }
            },
          ),
        ),
        separatorBuilder: (context, index) => const Divider(
          indent: 16,
          endIndent: 4,
        ),
      );

  @override
  void dispose() {
    super.dispose();
  }

  Widget buildListItem(
    BuildContext context,
    ListItemWrapper listItemWrapper,
  ) {
    var textStyle = Theme.of(context).textTheme.bodyMedium;
    var listItem = listItemWrapper.item;
    if (listItemWrapper.isReadNotifier.value) {
      textStyle = textStyle?.copyWith(color: const Color(0xFF888888));
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 4, 12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            listItem.title.trim(),
            textAlign: TextAlign.start,
            style: textStyle,
          ),
          const SizedBox(height: 10),
          buildBottomView(
            context,
            listItem.userInfo,
            listItem.reply,
            listItem.time,
          ),
        ],
      ),
    );
  }

  Widget buildBottomView(
    BuildContext context,
    UserInfo userInfo,
    String reply,
    String time,
  ) =>
      Row(
        children: [
          CachedNetworkImage(
            imageUrl: userInfo.nickImage,
            fit: BoxFit.contain,
            width: 18,
          ),
          const SizedBox(width: 8),
          Text(
            userInfo.nickName,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(width: 8),
          Text(
            time,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const Spacer(),
          buildRoundText(context, reply),
          const SizedBox(width: 8),
        ],
      );
}

Widget buildRoundText(
  BuildContext context,
  String text,
) {
  if (text.isEmpty) return const SizedBox.shrink();
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
    decoration: BoxDecoration(
      border: Border.all(color: Theme.of(context).textTheme.labelSmall!.color!),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Text(
      text,
      style: Theme.of(context).textTheme.labelSmall,
    ),
  );
}
