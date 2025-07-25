import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_user_info.dart';
import 'package:mocl_flutter/core/util/utilities.dart';
import 'package:mocl_flutter/di/app_provider.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/detail/providers/detail_providers.dart';
import 'package:mocl_flutter/core/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/message_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/nick_image_widget.dart';
import 'package:sliver_tools/sliver_tools.dart';

class DetailView extends ConsumerStatefulWidget {
  const DetailView({super.key});

  @override
  DetailViewState createState() => DetailViewState();
}

class DetailViewState extends ConsumerState<DetailView> {
  @override
  Widget build(BuildContext context) => ref
      .watch(detailsNotifierProvider)
      .maybeMap(
        data: (AsyncData<Details> state) => _DetailView(detail: state.value),
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
          child: Column(children: [LoadingWidget(), DividerWidget()]),
        ),
      );
}

class _DetailView extends ConsumerWidget {
  final Details detail;

  const _DetailView({required this.detail});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String hexColor = Theme.of(context).focusColor.stringHexColor;
    final bodySmall = MoclTextStyles.of(context).smallTextStyle;
    final TextStyle bodyMedium = MoclTextStyles.of(context).titleTextStyle;

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
              openUrl: (String url) =>
                  ref.read(openUrlProvider(context, url).future),
            ),
          ]
        : null;

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
            onTapUrl: (url) => ref.read(openUrlProvider(context, url).future),
          ),
          const _SpaceWidget(),
          ...?comments,
          const _DividerWidget(),
          _RefreshButton(
            onRefresh: ref.read(detailsNotifierProvider.notifier).refresh,
            bodyMedium: bodyMedium,
          ),
          const _DividerWidget(),
        ],
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
    final TextStyle bodySmall = Theme.of(
      context,
    ).textTheme.bodySmall!.copyWith(fontSize: 15.4);
    final Color backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final List<Widget>? likeView = _buildLikeView(context, bodySmall);

    return Column(
      children: [
        Container(
          height: 46,
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
      oldDelegate.detail != detail;

  @override
  double get maxExtent => 47;

  @override
  double get minExtent => 47;
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
    html: detail.bodyHtml,
    textStyle: bodyMedium,
    hexColor: hexColor,
    openUrl: onTapUrl,
    renderMode: RenderMode.sliverList,
  );
}

class _CommentHeader extends StatelessWidget {
  final int commentCount;
  final TextStyle? bodyMedium;

  const _CommentHeader({required this.commentCount, required this.bodyMedium});

  @override
  Widget build(BuildContext context) => SliverFixedExtentList(
    itemExtent: 46,
    delegate: SliverChildListDelegate([
      Align(
        alignment: Alignment.centerLeft,
        child: PlatformText(
          '댓글 ($commentCount)',
          style: bodyMedium?.copyWith(
            color: Theme.of(context).focusColor,
            fontSize: 15.4,
          ),
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
    separatorBuilder: (_, _) => const DividerWidget(indent: 0, endIndent: 0),
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

    return PlatformListTile(
      key: ValueKey(comment.id.toString()),
      material: (_, _) => MaterialListTileData(
        contentPadding: EdgeInsets.only(left: left, top: 2, bottom: 2),
      ),
      cupertino: (_, _) => CupertinoListTileData(
        padding: EdgeInsets.only(left: left, top: 8, bottom: 8),
      ),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (userInfo.nickImage.isNotEmpty)
            NickImageWidget(url: userInfo.nickImage),
          PlatformText(comment.info, style: bodySmall),
          ...?likeView,
        ],
      ),
      subtitle: comment.bodyHtml.isNotEmpty
          ? Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: _HtmlWidget(
                html: comment.bodyHtml,
                textStyle: bodyMedium,
                hexColor: hexColor,
                openUrl: openUrl,
              ),
            )
          : null,
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
      ? SizedBox.shrink()
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
  });

  @override
  Widget build(BuildContext context) => HtmlWidget(
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
