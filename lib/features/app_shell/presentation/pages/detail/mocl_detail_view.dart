import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_user_info.dart';
import 'package:mocl_flutter/core/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/message_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/nick_image_widget.dart';
import 'package:mocl_flutter/core/util/utilities.dart';
import 'package:mocl_flutter/di/app_provider.dart';
import 'package:sliver_tools/sliver_tools.dart';

import 'detail_event_mixin.dart';
import 'detail_state_mixin.dart';

const _kHeaderHeight = 46.0;

class DetailView extends ConsumerWidget with DetailState {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      detailState(ref).maybeMap(
        data: (state) => _DetailView(detail: state.value),
        error: (state) => SliverFillRemaining(
          hasScrollBody: false,
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Center(
              child: MessageWidget(message: state.error.toString()),
            ),
          ),
        ),
        orElse: () => const SliverToBoxAdapter(
          child: Column(children: [LoadingWidget(), DividerWidget()]),
        ),
      );
}

class _DetailView extends ConsumerWidget with DetailEvent, AppFontState {
  final Details detail;

  const _DetailView({required this.detail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String hexColor = Theme.of(context).focusColor.stringHexColor;
    final (bodySmall, bodyMedium) = smallTitleAndTitleTextStyleSate(ref);
    final comments = detail.comments.isNotEmpty
        ? [
            const _DividerWidget(),
            _CommentHeader(
              commentCount: detail.comments.length,
              bodyMedium: bodyMedium,
            ),
            const _DividerWidget(),
            _CommentList(
              comments: detail.comments,
              bodySmall: bodySmall,
              bodyMedium: bodyMedium,
              hexColor: hexColor,
              openUrl: (String url) => url.openUrl(context),
            ),
          ]
        : null;

    return SliverSafeArea(
      top: false,
      sliver: SliverPadding(
        padding: const EdgeInsets.only(left: 16, right: 8),
        sliver: MultiSliver(
          children: [
            SliverPersistentHeader(
              pinned: false,
              delegate: _HeaderSectionDelegate(
                detail: detail,
                bodySmall: bodySmall,
                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
            const _SpaceWidget(),
            _Body(
              detail: detail,
              hexColor: hexColor,
              bodyMedium: bodyMedium,
              onTapUrl: (url) => url.openUrl(context),
            ),
            const _SpaceWidget(),
            ...?comments,
            const _DividerWidget(),
            _RefreshButton(
              onRefresh: () => handleRefresh(ref),
              bodyMedium: bodyMedium,
            ),
            const _DividerWidget(),
          ],
        ),
      ),
    );
  }
}

class _SpaceWidget extends StatelessWidget {
  const _SpaceWidget();

  @override
  Widget build(BuildContext context) =>
      const SliverPadding(padding: EdgeInsets.only(top: 10));
}

class _DividerWidget extends StatelessWidget {
  const _DividerWidget();

  @override
  Widget build(BuildContext context) =>
      const SliverToBoxAdapter(child: Divider(indent: 0, endIndent: 0));
}

class _HeaderSectionDelegate extends SliverPersistentHeaderDelegate {
  final Details detail;
  final TextStyle? bodySmall;
  final Color backgroundColor;

  const _HeaderSectionDelegate({
    required this.detail,
    required this.bodySmall,
    required this.backgroundColor,
  });

  List<Widget>? _buildLikeView(BuildContext context, TextStyle bodySmall) =>
      detail.likeCount.isNotEmpty && detail.likeCount != '0'
      ? [
          const SizedBox(width: 10),
          Icon(Icons.favorite_outline, color: bodySmall.color, size: 17),
          const SizedBox(width: 4),
          Text(detail.likeCount, style: bodySmall),
          const SizedBox(width: 10),
        ]
      : null;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final likeView = _buildLikeView(context, bodySmall!);
    final nickImage = detail.userInfo.nickImage;

    return Column(
      children: [
        Container(
          height: _kHeaderHeight,
          alignment: AlignmentGeometry.centerLeft,
          color: backgroundColor,
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (nickImage.isNotEmpty)
                      NickImageWidget(url: detail.userInfo.nickImage),
                    Flexible(
                      child: PlatformText(detail.info, style: bodySmall),
                    ),
                  ],
                ),
              ),
              ...?likeView,
            ],
          ),
        ),
        const DividerWidget(indent: 0, endIndent: 0),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant _HeaderSectionDelegate oldDelegate) =>
      oldDelegate.detail != detail || oldDelegate.bodySmall != bodySmall;

  @override
  double get maxExtent => _kHeaderHeight + 1;

  @override
  double get minExtent => _kHeaderHeight + 1;
}

class _Body extends StatelessWidget {
  final Details detail;
  final String hexColor;
  final TextStyle? bodyMedium;
  final FutureOr<bool> Function(String url) onTapUrl;

  const _Body({
    required this.detail,
    required this.hexColor,
    required this.bodyMedium,
    required this.onTapUrl,
  });

  @override
  Widget build(BuildContext context) => _HtmlWidget(
    key: ValueKey('body-${detail.time}'),
    html: detail.bodyHtml,
    textStyle: bodyMedium,
    hexColor: hexColor,
    openUrl: onTapUrl,
    // renderMode: RenderMode.sliverList,
  );
}

class _CommentHeader extends StatelessWidget {
  final int commentCount;
  final TextStyle? bodyMedium;

  const _CommentHeader({required this.commentCount, required this.bodyMedium});

  @override
  Widget build(BuildContext context) => SliverFixedExtentList(
    itemExtent: _kHeaderHeight,
    delegate: SliverChildListDelegate([
      Align(
        alignment: Alignment.centerLeft,
        child: PlatformText(
          '댓글 ($commentCount)',
          style: bodyMedium?.copyWith(color: Theme.of(context).focusColor),
        ),
      ),
    ]),
  );
}

class _CommentList extends ConsumerWidget {
  final List<CommentItem> comments;
  final TextStyle? bodySmall;
  final TextStyle? bodyMedium;
  final String hexColor;
  final void Function(String) openUrl;

  const _CommentList({
    required this.comments,
    required this.bodySmall,
    required this.bodyMedium,
    required this.hexColor,
    required this.openUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => SliverList.separated(
    addSemanticIndexes: false,
    // addAutomaticKeepAlives: false,
    separatorBuilder: (_, _) => const DividerWidget(indent: 0, endIndent: 0),
    itemCount: comments.length,
    itemBuilder: (_, int index) => _CommentItem(
      comment: comments[index],
      bodySmall: bodySmall,
      bodyMedium: bodyMedium,
      hexColor: hexColor,
      depth: comments[index].isReply ? 1 : 0,
      openUrl: openUrl,
    ),
  );
}

class _CommentItem extends StatelessWidget {
  final CommentItem comment;
  final TextStyle? bodySmall;
  final TextStyle? bodyMedium;
  final String hexColor;
  final int depth;
  final void Function(String) openUrl;

  const _CommentItem({
    required this.comment,
    required this.bodySmall,
    required this.bodyMedium,
    required this.hexColor,
    required this.depth,
    required this.openUrl,
  });

  @override
  Widget build(BuildContext context) {
    final UserInfo userInfo = comment.userInfo;
    final double left = comment.isReply ? 16.0 : 0.0;

    final List<Widget>? likeView =
        comment.likeCount.isNotEmpty && comment.likeCount != '0'
        ? [
            const Spacer(),
            Icon(Icons.favorite_outline, color: bodySmall!.color, size: 17),
            const SizedBox(width: 4),
            PlatformText(comment.likeCount, style: bodySmall),
            const SizedBox(width: 4),
          ]
        : null;

    final isEmptyBody = comment.bodyHtml.isEmpty;

    final List<Widget> commentWidgets = [
      PlatformListTile(
        key: ValueKey('comment-${comment.id}'),
        material: (_, _) => MaterialListTileData(
          contentPadding: isEmptyBody
              ? EdgeInsets.only(left: left, top: 0, bottom: 0)
              : EdgeInsets.only(left: left, top: 2, bottom: 2),
        ),
        cupertino: (_, _) => CupertinoListTileData(
          padding: EdgeInsets.only(left: left, top: 8, bottom: 8),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (userInfo.nickImage.isNotEmpty)
              NickImageWidget(url: userInfo.nickImage),
            if (comment.info.isNotEmpty)
              PlatformText(comment.info, style: bodySmall),
            ...?likeView,
          ],
        ),
        subtitle: isEmptyBody
            ? null
            : Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: _HtmlWidget(
                  key: ValueKey('comment-body-${comment.id}'),
                  html: comment.bodyHtml,
                  textStyle: bodyMedium,
                  hexColor: hexColor,
                  openUrl: openUrl,
                ),
              ),
      ),
    ];

    if (comment.replies.isNotEmpty) {
      commentWidgets.addAll(
        comment.replies
            .map(
              (reply) => _CommentItem(
                comment: reply,
                bodySmall: bodySmall,
                bodyMedium: bodyMedium,
                hexColor: hexColor,
                openUrl: openUrl,
                depth: depth + 1, // 다음 깊이로 전달
              ),
            )
            .toList(),
      );
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: commentWidgets,
    );
  }
}

class _HtmlLoadingWidget extends StatelessWidget {
  final String src;
  final TextStyle? textStyle;
  final double? progress;

  const _HtmlLoadingWidget({
    super.key,
    required this.src,
    this.textStyle,
    this.progress,
  });

  @override
  Widget build(BuildContext context) => src.isEmpty || progress == null
      ? const SizedBox.shrink()
      : Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Column(
            children: [
              Text(src, style: textStyle),
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Theme.of(context).dividerTheme.color,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).focusColor,
                ),
              ),
            ],
          ),
        );
}

class _HtmlWidget extends StatelessWidget {
  final String html;
  final TextStyle? textStyle;
  final String hexColor;
  final void Function(String) openUrl;
  final RenderMode renderMode;

  const _HtmlWidget({
    required this.html,
    required this.textStyle,
    required this.hexColor,
    required this.openUrl,
    this.renderMode = RenderMode.column,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final htmlWidget = HtmlWidget(
      html,
      onLoadingBuilder: (context, element, progress) {
        final src = element.attributes['src'] ?? '';
        return _HtmlLoadingWidget(
          key: ValueKey(src),
          src: src,
          textStyle: textStyle?.copyWith(fontSize: 12),
          progress: progress,
        );
      },
      textStyle: textStyle,
      customStylesBuilder: (element) {
        if (element.localName == 'a') {
          return {'color': hexColor, 'text-decoration': 'underline'};
        }
        return null;
      },
      renderMode: renderMode,
      onTapImage: (data) => openUrl(data.sources.first.url),
    );

    if (kIsWeb || Platform.isMacOS) {
      return htmlWidget;
    } else {
      return SelectionArea(child: htmlWidget);
    }
  }
}

class _RefreshButton extends StatelessWidget {
  final VoidCallback onRefresh;
  final TextStyle? bodyMedium;

  const _RefreshButton({required this.onRefresh, required this.bodyMedium});

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
    child: InkWell(
      onTap: onRefresh,
      child: Container(
        width: double.infinity,
        height: 58,
        alignment: Alignment.center,
        child: PlatformText(
          '새로고침',
          style: bodyMedium?.copyWith(color: Theme.of(context).focusColor),
        ),
      ),
    ),
  );
}
