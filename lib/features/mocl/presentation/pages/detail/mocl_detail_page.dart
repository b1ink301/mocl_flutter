import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_user_info.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../domain/entities/mocl_result.dart';
import '../../widgets/message_widget.dart';
import 'mocl_detail_controller.dart';

class DetailPage extends GetView<DetailController> {
  const DetailPage({super.key});

  Widget _buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          MessageWidget(
            message: controller.getAppbarSmallTitle(),
            fontSize: 13,
          ),
          MessageWidget(
            message: controller.getAppbarTitle(),
          ),
        ],
      );

  SliverAppBar _buildAppbar(BuildContext context) {
    return SliverAppBar(
      title: _buildTitle(),
      flexibleSpace: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return const FlexibleSpaceBar(
            title: SizedBox.shrink(),
            collapseMode: CollapseMode.none,
          );
        },
      ),
      toolbarHeight: 40 + _calculateTitleHeight(context),
      automaticallyImplyLeading: false,
      // elevation: 8,
      floating: true,
      pinned: false,
      actions: [
        IconButton(
          onPressed: () => controller.reload(),
          icon: const Icon(Icons.refresh),
        )
      ],
    );
  }

  double _calculateTitleHeight(BuildContext context) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: controller.getAppbarTitle(), // 텍스트 가져오기
        style: Theme.of(context).textTheme.bodyMedium, // 텍스트 스타일 적용
      ),
      maxLines: 2, // 최대 3줄
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: MediaQuery.of(context).size.width - 60);

    final titleHeight = textPainter.height;
    log('titleHeight = $titleHeight');
    return titleHeight; // 텍스트 높이 반환
  }

  @override
  Widget build(BuildContext context) => PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          log('onPopInvoked=$didPop');
          if (didPop) return;

          Get.back<bool>(result: controller.isReadFlag);
        },
        child: Scaffold(
          body: CustomScrollView(
            controller: controller.scrollController,
            slivers: <Widget>[
              _buildAppbar(context),
              // SliverPersistentHeader(
              //   pinned: false,
              //   delegate: HeaderDelegate(
              //     userInfo: controller.userInfo,
              //   ),
              // ),
              // const SliverToBoxAdapter(
              //   child: Divider(
              //     indent: 16,
              //     endIndent: 4,
              //   ),
              // ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(18, 0, 4, 0),
                  child: _DetailView(),
                ),
              ),
            ],
          ),
        ),
      );
}

class _DetailView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _DetailViewState();
}

class _DetailViewState extends State<_DetailView> {
  final DetailController detailController = Get.find();

  @override
  Widget build(BuildContext context) => StreamBuilder<Result>(
      stream: detailController.detailStream.asBroadcastStream(),
      builder: (BuildContext context, AsyncSnapshot<Result> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        if (snapshot.hasData && snapshot.data is ResultSuccess) {
          var result = snapshot.data as ResultSuccess<Details>;
          detailController.setReadFlag();
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(detailController.userInfo),
                const Divider(),
                const SizedBox(height: 10),
                HtmlWidget(
                  result.data.bodyHtml,
                  textStyle: Theme.of(context).textTheme.bodyMedium,
                  onTapUrl: (url) async {
                    final Uri uri = Uri.parse(url);
                    if (!await launchUrl(uri)) {
                      throw Exception('Could not launch $uri');
                    }
                    return true;
                  },
                ),
                const SizedBox(height: 10),
                _buildComments(
                  context,
                  result.data.comments,
                ),
                const Divider(),
              ],
            ),
          );
        } else {
          return const Padding(
            padding: EdgeInsets.only(top: 16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );

  Widget _buildHeader(UserInfo userInfo) {
    return SizedBox(
      height: 42,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            CachedNetworkImage(
              imageUrl: userInfo.nickImage,
              fit: BoxFit.contain,
              width: 18,
            ),
            const Spacer(),
            Text(
              userInfo.nickName,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            // const Spacer(),
            // Text('comment.time'),
            const Spacer(
              flex: 30,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComments(
    BuildContext context,
    List<CommentItem> comments,
  ) {
    Widget buildRefreshButton() => SizedBox(
          height: 56,
          child: Center(
            child: Text(
              '새로고침',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        );

    if (comments.isEmpty) {
      return Column(children: [
        const Divider(),
        buildRefreshButton(),
      ]);
    }

    return Column(
      children: [
        const SizedBox(height: 10),
        const Divider(),
        SizedBox(
          height: 42,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              '댓글 (${comments.length})',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ),
        const Divider(),
        ListView.separated(
          padding: EdgeInsets.zero,
          separatorBuilder: (context, index) => const Divider(),
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          itemCount: comments.length,
          itemBuilder: (BuildContext context, int index) {
            var comment = comments[index];
            var userInfo = comment.userInfo;
            var left = comment.isReply ? 16.0 : 0.0;
            return Padding(
              padding: EdgeInsets.only(left: left, top: 12, bottom: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                        comment.time,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      const Spacer(),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  HtmlWidget(
                    comment.bodyHtml,
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    onTapUrl: (url) async {
                      final Uri uri = Uri.parse(url);
                      if (!await launchUrl(uri)) {
                        throw Exception('Could not launch $uri');
                      }
                      return true;
                    },
                  ),
                ],
              ),
            );
          },
        ),
        const Divider(),
        buildRefreshButton(),
      ],
    );
  }
}

class HeaderDelegate extends SliverPersistentHeaderDelegate {
  final UserInfo _userInfo;

  HeaderDelegate({required UserInfo userInfo}) : _userInfo = userInfo;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Center(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        children: [
          const SizedBox(width: 16),
          CachedNetworkImage(
            imageUrl: _userInfo.nickImage,
            fit: BoxFit.contain,
            width: 18,
          ),
          const Spacer(),
          Text(
            _userInfo.nickName,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          // const Spacer(),
          // Text('comment.time'),
          const Spacer(
            flex: 30,
          ),
        ],
      ),
    );
  }

  @override
  double get maxExtent => 42;

  @override
  double get minExtent => 42;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
