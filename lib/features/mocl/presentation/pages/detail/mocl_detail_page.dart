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

  Widget buildTitle() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const MessageWidget(
            message: '다모앙',
            fontSize: 13,
          ),
          MessageWidget(
            message: controller.getAppbarTitle(),
          ),
        ],
      );

  SliverAppBar buildAppbar(BuildContext context) => SliverAppBar(
        title: buildTitle(),
        // expandedHeight: 50.0,
        automaticallyImplyLeading: false,
        // elevation: 8,
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
          controller: controller.scrollController,
          slivers: <Widget>[
            buildAppbar(context),
            SliverPersistentHeader(
              pinned: false,
              delegate: HeaderDelegate(userInfo: controller.userInfo),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(18, 0, 4, 0),
                child: _DetailView(),
              ),
            ),
          ],
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
  Widget build(BuildContext context) {
    return StreamBuilder<Result>(
      stream: detailController.deailStream.asBroadcastStream(),
      builder: (BuildContext context, AsyncSnapshot<Result> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator()); // 로딩 중 표시
        }
        if (snapshot.hasData && snapshot.data is ResultSuccess) {
          var result = snapshot.data as ResultSuccess<Details>;
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 10),
                const Divider(),
                HtmlWidget(
                  result.data.bodyHtml,
                  textStyle: const TextStyle(fontSize: 16),
                  onTapUrl: (url) async {
                    final Uri uri = Uri.parse(url);
                    if (!await launchUrl(uri)) {
                      throw Exception('Could not launch $uri');
                    }
                    return true;
                  },
                ),
                const SizedBox(height: 10),
                buildComments(result.data.comments),
              ],
            ),
          );
        } else {
          return const MessageWidget(message: 'message');
        }
      },
    );
  }

  Widget buildComments(List<CommentItem> comments) {
    if (comments.isEmpty) return const SizedBox.shrink();
    return Column(
      children: [
        const Divider(),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text('댓글 (${comments.length})'),
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
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
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
                      const Spacer(),
                      Text(userInfo.nickName),
                      const Spacer(),
                      Text(comment.time),
                      const Spacer(
                        flex: 30,
                      ),
                    ],
                  ),
                  const SizedBox(height: 10.0),
                  HtmlWidget(
                    comment.bodyHtml,
                    textStyle: const TextStyle(fontSize: 16),
                  ),
                ],
              ),
            );
          },
        ),
        const Divider(),
        const SizedBox(
          height: 56,
          child: Center(child: Text('새로고침')),
        ),
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
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 4, 0),
      child: Row(
        children: [
          CachedNetworkImage(
            imageUrl: _userInfo.nickImage,
            fit: BoxFit.contain,
            width: 18,
          ),
          const Spacer(),
          Text(_userInfo.nickName),
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
  double get maxExtent => 40;

  @override
  double get minExtent => 40;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
