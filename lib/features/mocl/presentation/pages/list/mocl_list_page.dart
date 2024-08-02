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
import '../mocl_routes.dart';
import 'mocl_list_controller.dart';

class ListPage extends GetView<ListController> {
  const ListPage({super.key});

  Widget _buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MessageWidget(
            message: controller.getAppbarSmallTitle(),
            fontSize: 12,
          ),
          const SizedBox(height: 4),
          MessageWidget(
            message: controller.getAppbarTitle(),
          ),
        ],
      );

  SliverAppBar _buildAppbar(BuildContext context) => SliverAppBar(
        title: _buildTitle(),
        automaticallyImplyLeading: false,
        toolbarHeight: 64,
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
              var isReadFlag =
                  await Get.toNamed(Routes.DETAIL, arguments: item.item);
              log('isReadFlag=$isReadFlag');
              if (isReadFlag != null && isReadFlag) {
                _listController.setReadFlag(item);
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
    var listItem = listItemWrapper.item;
    if (listItemWrapper.isReadNotifier.value) {
      textStyle = textStyle?.copyWith(color: Theme.of(context).highlightColor);
      smallTextStyle =
          smallTextStyle?.copyWith(color: Theme.of(context).highlightColor);
    }
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 12, 4, 12),
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
            textStyle: textStyle,
          ),
          const SizedBox(width: 8),
        ],
      );
}
