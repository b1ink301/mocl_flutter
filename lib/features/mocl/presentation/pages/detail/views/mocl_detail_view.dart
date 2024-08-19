import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/providers/detail_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/providers/main_provider.dart';

import '../../../../domain/entities/mocl_details.dart';
import '../../../../domain/entities/mocl_list_item.dart';
import '../../../../domain/entities/mocl_site_type.dart';
import '../../../../domain/entities/mocl_user_info.dart';
import '../../../widgets/loading_widget.dart';
import '../../../widgets/nick_image_widget.dart';

class DetailView extends ConsumerStatefulWidget {
  final ListItem listItem;

  const DetailView({super.key, required this.listItem});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _DetailViewState();
}

class _DetailViewState extends ConsumerState<DetailView> {
  @override
  Widget build(BuildContext context) {
    if (Platform.isMacOS) {
      return Listener(
        onPointerDown: (PointerDownEvent event) {
          if (event.buttons == kSecondaryMouseButton) {
            context.pop();
          }
        },
        child: _buildView(context),
      );
    }
    return _buildView(context);
  }

  String getHexColor(Color color) =>
      '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

  Widget _buildView(BuildContext context) {
    final resultAsync = ref.watch(detailStateProvider(widget.listItem));
    final siteType = ref.read(currentSiteTypeProvider);

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
      child: resultAsync.when(
        data: (data) {
          final theme = Theme.of(context);
          final hexColor = getHexColor(theme.indicatorColor);
          final bodySmall = theme.textTheme.bodySmall;
          final bodyMedium = theme.textTheme.bodyMedium;

          if (data is ResultSuccess<Details>) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(
                    siteType,
                    widget.listItem.userInfo,
                    widget.listItem.time,
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
                    // onTapUrl: (url) => _detailController.openBrowser(url),
                  ),
                  const SizedBox(height: 10),
                  _buildComments(
                    context,
                    siteType,
                    hexColor,
                    data.data.comments,
                    bodySmall,
                    bodyMedium,
                  ),
                  const Divider(),
                ],
              ),
            );
          } else {
            return const SizedBox.shrink();
          }
        },
        error: (err, stack) {
          return const SizedBox.shrink();
        },
        loading: () {
          return const LoadingWidget();
        },
      ),
    );
  }

  Widget _buildHeader(
    SiteType siteType,
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
              NickImageWidget(
                url: userInfo.nickImage,
                siteType: siteType,
              ),
              Text(
                userInfo.nickName,
                style: bodySmall,
              ),
              const SizedBox(width: 8),
              Text(
                time,
                style: bodySmall,
              ),
            ],
          ),
        ),
      );

  Widget _buildComments(
    BuildContext context,
    SiteType siteType,
    String hexColor,
    List<CommentItem> comments,
    TextStyle? bodySmall,
    TextStyle? bodyMedium,
  ) {
    Widget buildRefreshButton() => InkWell(
          // onTap: () => _detailController.reload(),
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
                  NickImageWidget(
                    url: userInfo.nickImage,
                    siteType: siteType,
                  ),
                  Text(
                    userInfo.nickName,
                    style: bodySmall,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    comment.time,
                    style: bodySmall,
                  ),
                  // const Spacer(),
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
                  // onTapUrl: (url) => _detailController.openBrowser(url),
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
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) =>
      Center(
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
            const SizedBox(width: 8),
            Text(
              _userInfo.nickName,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            // const Spacer(),
            // Text('comment.time'),
            const Spacer(),
          ],
        ),
      );

  @override
  double get maxExtent => 42;

  @override
  double get minExtent => 42;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
