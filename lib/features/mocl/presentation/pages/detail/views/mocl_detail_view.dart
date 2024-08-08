import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';

import '../../../../domain/entities/mocl_details.dart';
import '../../../../domain/entities/mocl_user_info.dart';
import '../../../widgets/nick_image_widget.dart';
import '../../../widgets/loading_widget.dart';
import '../controllers/mocl_detail_controller.dart';

class DetailView extends StatefulWidget {
  const DetailView({super.key});

  @override
  State<StatefulWidget> createState() => _DetailViewState();
}

class _DetailViewState extends State<DetailView> {
  final DetailController _detailController = Get.find();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 4, 0),
    child: _detailController.obx(
          (data) {
            if (data == null) return const SizedBox.shrink();
            _detailController.setReadFlag();

            final theme = Theme.of(context);
            final hexColor = _detailController.getHexColor(theme.indicatorColor);
            final bodySmall = theme.textTheme.bodySmall;
            final bodyMedium = theme.textTheme.bodyMedium;

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(
                    _detailController.userInfo,
                    _detailController.time,
                    bodySmall,
                  ),
                  const Divider(),
                  const SizedBox(height: 10),
                  HtmlWidget(
                    data.data.bodyHtml,
                    customStylesBuilder: (element) {
                      if (element.localName == 'a') {
                        return {
                          'color': hexColor,
                          'text-decoration': 'underline',
                        };
                      }
                      return null;
                    },
                    textStyle: bodyMedium,
                    renderMode: RenderMode.column,
                    onTapUrl: (url) => _detailController.openBrowser(url),
                  ),
                  const SizedBox(height: 10),
                  _buildComments(
                    context,
                    hexColor,
                    data.data.comments,
                    bodySmall,
                    bodyMedium,
                  ),
                  const Divider(),
                ],
              ),
            );
          },
          onLoading: const LoadingWidget(),
          onError: (error) => Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text(
              '에러가 발생했습니다',
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).indicatorColor,
              ),
            ),
          ),
        ),
  );

  Widget _buildHeader(
    UserInfo userInfo,
    String time,
    TextStyle? bodySmall,
  ) =>
      SizedBox(
        height: 42,
        child: Center(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            children: [
              NickImageWidget(url: userInfo.nickImage),
              Text(
                userInfo.nickName,
                style: bodySmall,
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: bodySmall,
              ),
              const Spacer(),
            ],
          ),
        ),
      );

  Widget _buildComments(
    BuildContext context,
    String hexColor,
    List<CommentItem> comments,
    TextStyle? bodySmall,
    TextStyle? bodyMedium,
  ) {
    Widget buildRefreshButton() => InkWell(
          onTap: () => _detailController.reload(),
          child: Container(
            width: double.infinity, // 가로 꽉 채우기
            height: 56,
            alignment: Alignment.center,
            child: Text(
              '새로고침',
              style: bodyMedium?.copyWith(
                color: Theme.of(context).indicatorColor,
              ),
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
              style: bodyMedium?.copyWith(
                  color: Theme.of(context).indicatorColor, fontSize: 15),
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
            return ListTile(
              key: Key(comment.id.toString()),
              contentPadding: EdgeInsets.only(left: left, top: 4, bottom: 4),
              title: Row(
                children: [
                  NickImageWidget(url: userInfo.nickImage),
                  Text(
                    userInfo.nickName,
                    style: bodySmall,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    comment.time,
                    style: bodySmall,
                  ),
                  const Spacer(),
                ],
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: HtmlWidget(
                  comment.bodyHtml,
                  textStyle: bodyMedium,
                  customStylesBuilder: (element) {
                    if (element.localName == 'a') {
                      return {
                        'color': hexColor,
                        'text-decoration': 'underline',
                      };
                    }
                    return null;
                  },
                  onTapUrl: (url) => _detailController.openBrowser(url),
                ),
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
