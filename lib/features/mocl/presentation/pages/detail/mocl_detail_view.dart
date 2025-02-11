import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mocl_flutter/core/util/utilities.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_user_info.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/providers/detail_providers.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_providers.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/nick_image_widget.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class DetailView extends ConsumerWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(detailsNotifierProvider).maybeMap(
            data: (AsyncData<Details> state) =>
                _DetailView(detail: state.value),
            error: (AsyncError<Details> state) => SliverFillRemaining(
              hasScrollBody: false,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Center(
                  child: MessageWidget(message: state.error.toString()),
                ),
              ),
            ),
            orElse: () => const SliverToBoxAdapter(
              child: Column(
                children: [LoadingWidget(), DividerWidget()],
              ),
            ),
          );
}

class _DetailView extends ConsumerWidget {
  final Details detail;

  const _DetailView({required this.detail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final String hexColor = theme.indicatorColor.stringHexColor;
    final TextStyle? bodySmall = theme.textTheme.bodySmall;
    final TextStyle? bodyMedium = theme.textTheme.bodyMedium;

    return SliverPadding(
      padding: const EdgeInsets.only(left: 16, right: 8),
      sliver: MultiSliver(
        children: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _HeaderSectionDelegate(detail: detail),
          ),
          const _SpaceWidget(),
          _Body(
            detail: detail,
            hexColor: hexColor,
            bodyMedium: bodyMedium,
            onTapUrl: (url) async =>
                await ref.read(openUrlProvider(context, url)),
          ),
          const _SpaceWidget(),
          if (detail.comments.isNotEmpty)
            _Comments(
              hexColor: hexColor,
              comments: detail.comments,
              bodySmall: bodySmall,
              bodyMedium: bodyMedium,
              openUrl: (url) async =>
                  await ref.read(openUrlProvider(context, url)),
            ),
          const _DividerWidget(),
          _RefreshButton(
              onRefresh: () =>
                  ref.read(detailsNotifierProvider.notifier).refresh(),
              bodyMedium: bodyMedium),
          const _DividerWidget(),
        ],
      ),
    );
  }
}

class _SpaceWidget extends StatelessWidget {
  const _SpaceWidget();

  @override
  Widget build(BuildContext context) => const SliverPadding(
        padding: EdgeInsets.only(top: 10),
      );
}

class _DividerWidget extends StatelessWidget {
  const _DividerWidget();

  @override
  Widget build(BuildContext context) =>
      const SliverToBoxAdapter(child: Divider(indent: 0, endIndent: 0));
}

class _HeaderSectionDelegate extends SliverPersistentHeaderDelegate {
  final Details detail;

  const _HeaderSectionDelegate({required this.detail});

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
    final TextStyle bodySmall = Theme.of(context).textTheme.bodySmall!;
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final List<Widget>? likeView = _buildLikeView(context, bodySmall);

    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          color: backgroundColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (detail.userInfo.nickImage.isNotEmpty &&
                        detail.userInfo.nickImage.startsWith('http'))
                      NickImageWidget(url: detail.userInfo.nickImage),
                    Flexible(
                      child: PlatformText(detail.info, style: bodySmall),
                    ),
                  ],
                ),
              ),
              if (likeView != null) ...likeView,
            ],
          ),
        ),
        const DividerWidget(indent: 0, endIndent: 0),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant _HeaderSectionDelegate oldDelegate) =>
      oldDelegate.detail != detail;

  @override
  double get maxExtent => Platform.isIOS ? 44 : 45;

  @override
  double get minExtent => Platform.isIOS ? 44 : 45;
}

class _Body extends StatelessWidget {
  final Details detail;
  final String hexColor;
  final TextStyle? bodyMedium;
  final void Function(String url) onTapUrl;

  const _Body({
    required this.detail,
    required this.hexColor,
    required this.bodyMedium,
    required this.onTapUrl,
  });

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: HtmlWidget(
            detail.bodyHtml,
            onLoadingBuilder: (_, __, ___) => const LoadingWidget(),
            customStylesBuilder: (element) {
              if (element.localName == 'a') {
                return {'color': hexColor, 'text-decoration': 'underline'};
              }
              return null;
            },
            textStyle: bodyMedium,
            renderMode: RenderMode.column,
            onTapUrl: (url) async {
              onTapUrl(url);
              return true;
            },
            onTapImage: (data) => onTapUrl(data.sources.first.url),
          ),
        ),
      );
}

class _Comments extends StatelessWidget {
  final String hexColor;
  final List<CommentItem> comments;
  final TextStyle? bodySmall;
  final TextStyle? bodyMedium;
  final void Function(String) openUrl;

  const _Comments({
    required this.hexColor,
    required this.comments,
    required this.bodySmall,
    required this.bodyMedium,
    required this.openUrl,
  });

  @override
  Widget build(BuildContext context) => MultiSliver(
        children: [
          const _SpaceWidget(),
          const _DividerWidget(),
          _CommentHeader(
            commentCount: comments.length,
            bodyMedium: bodyMedium,
          ),
          const _DividerWidget(),
          _CommentList(
            comments: comments,
            bodySmall: bodySmall,
            bodyMedium: bodyMedium,
            hexColor: hexColor,
            openUrl: openUrl,
          )
        ],
      );
}

class _CommentHeader extends StatelessWidget {
  final int commentCount;
  final TextStyle? bodyMedium;

  const _CommentHeader({
    required this.commentCount,
    required this.bodyMedium,
  });

  @override
  Widget build(BuildContext context) => SliverFixedExtentList(
      itemExtent: 42,
      delegate: SliverChildListDelegate([
        Align(
          alignment: Alignment.centerLeft,
          child: PlatformText(
            '댓글 ($commentCount)',
            style: bodyMedium?.copyWith(
              color: Theme.of(context).indicatorColor,
              fontSize: 15,
            ),
          ),
        ),
      ]));
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
  Widget build(BuildContext context, WidgetRef ref) =>
      SuperSliverList.separated(
        extentPrecalculationPolicy:
            ref.watch(extentPrecalculationPolicyProvider),
        layoutKeptAliveChildren: true,
        separatorBuilder: (_, __) =>
            const DividerWidget(indent: 0, endIndent: 0),
        itemCount: comments.length,
        itemBuilder: (_, int index) => _CommentItem(
          comment: comments[index],
          bodySmall: bodySmall,
          bodyMedium: bodyMedium,
          hexColor: hexColor,
          openUrl: openUrl,
        ),
      );
}

class _CommentItem extends StatelessWidget {
  final CommentItem comment;
  final TextStyle? bodySmall;
  final TextStyle? bodyMedium;
  final String hexColor;
  final void Function(String) openUrl;

  const _CommentItem({
    required this.comment,
    required this.bodySmall,
    required this.bodyMedium,
    required this.hexColor,
    required this.openUrl,
  });

  @override
  Widget build(BuildContext context) {
    final UserInfo userInfo = comment.userInfo;
    final double left = comment.isReply ? 16.0 : 0.0;

    final List<Widget> likeView =
        comment.likeCount.isNotEmpty && comment.likeCount != '0'
            ? [
                const Spacer(),
                Icon(Icons.favorite_outline, color: bodySmall!.color, size: 17),
                const SizedBox(width: 4),
                PlatformText(comment.likeCount, style: bodySmall),
                const SizedBox(width: 4),
              ]
            : const <Widget>[];

    return PlatformListTile(
      key: ValueKey(comment.id.toString()),
      material: (_, __) => MaterialListTileData(
        contentPadding: EdgeInsets.only(left: left, top: 4, bottom: 4),
      ),
      cupertino: (_, __) => CupertinoListTileData(
        padding: EdgeInsets.only(left: left, top: 8, bottom: 8),
      ),
      // contentPadding: EdgeInsets.only(left: left, top: 4, bottom: 4),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (userInfo.nickImage.isNotEmpty)
            NickImageWidget(url: userInfo.nickImage),
          PlatformText(comment.info, style: bodySmall),
          ...likeView,
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: HtmlWidget(
          comment.bodyHtml,
          onLoadingBuilder: (
            context,
            element,
            progress,
          ) =>
              const LoadingWidget(),
          textStyle: bodyMedium,
          customStylesBuilder: (element) {
            if (element.localName == 'a') {
              return {'color': hexColor, 'text-decoration': 'underline'};
            }
            return null;
          },
          onTapUrl: (url) async {
            openUrl(url);
            return true;
          },
          onTapImage: (data) => openUrl(data.sources.first.url),
        ),
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  final VoidCallback onRefresh;
  final TextStyle? bodyMedium;

  const _RefreshButton({
    required this.onRefresh,
    required this.bodyMedium,
  });

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
              style: bodyMedium?.copyWith(
                color: Theme.of(context).indicatorColor,
              ),
            ),
          ),
        ),
      );
}
