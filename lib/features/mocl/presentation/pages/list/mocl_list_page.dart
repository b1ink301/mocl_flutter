import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

import '../../../domain/entities/mocl_user_info.dart';
import '../mocl_routes.dart';
import 'mocl_list_controller.dart';

class ListPage extends GetView<ListController> {
  final MainItem _mainItem;

  ListPage({
    super.key,
    required MainItem mainItem,
  }) : _mainItem = mainItem {
    controller.setMainItem(_mainItem);
  }

  Widget buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MessageWidget(
            message: '다모앙',
            fontSize: 12,
          ),
          MessageWidget(
            message: _mainItem.text,
          ),
        ],
      );

  SliverAppBar buildAppbar(BuildContext context) => SliverAppBar(
        title: buildTitle(),
        expandedHeight: 50.0,
        automaticallyImplyLeading: false,
        elevation: 18,
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
            _ListView(mainItem: _mainItem),
          ],
        ),
      );
}

class _ListView extends StatefulWidget {
  final MainItem mainItem;

  const _ListView({super.key, required this.mainItem});

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
      PagedSliverList<int, ListItem>.separated(
        pagingController: _listController.pagingController,
        builderDelegate: PagedChildBuilderDelegate<ListItem>(
          itemBuilder: (context, item, index) => InkWell(
            child: buildListItem(context, item),
            onTap: () => Get.toNamed(Routes.DETAIL, arguments: item),
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
    ListItem listItem,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 4, 4, 4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            listItem.title.trim(),
            textAlign: TextAlign.start,
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 8),
          buildBottomView(
            context,
            listItem.userInfo,
            listItem.reply,
          ),
        ],
      ),
    );
  }

  Widget buildBottomView(
    BuildContext context,
    UserInfo userInfo,
    String reply,
  ) =>
      Row(
        children: [
          CachedNetworkImage(
            imageUrl: userInfo.nickImage,
            fit: BoxFit.contain,
            width: 18,
          ),
          const Spacer(),
          Text(userInfo.nickName),
          const Spacer(
            flex: 40,
          ),
          buildRoundText(context, reply),
          const Spacer(),
        ],
      );
}

Widget buildRoundText(BuildContext context, String text) {
  if (text.isEmpty) return const SizedBox.shrink();
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
    decoration: BoxDecoration(
      color: Theme.of(context).primaryColor,
      borderRadius: BorderRadius.circular(10), // 둥근 타원형 모양 설정
    ),
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 11,
      ),
    ),
  );
}
