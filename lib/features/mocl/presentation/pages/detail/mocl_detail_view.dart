import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mocl_flutter/core/util/utilities.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/presentation/injection.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/bloc/detail_view_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/detail_view_util.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';
import 'package:sliver_tools/sliver_tools.dart';

class DetailView extends StatelessWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DetailViewBloc, DetailViewState>(
        builder: (context, state) => switch (state) {
          DetailSuccess() => _DetailView(detail: state.detail),
          DetailFailed() => SliverFillRemaining(
            hasScrollBody: false,
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Center(child: MessageWidget(message: state.message)),
            ),
          ),
          _ => const SliverToBoxAdapter(
            child: Column(children: [LoadingWidget(), DividerWidget()]),
          ),
        },
      );
}

class _DetailView extends StatelessWidget {
  final Details detail;

  const _DetailView({required this.detail});

  @override
  Widget build(BuildContext context) => SliverPadding(
    padding: const EdgeInsets.only(left: 15, right: 8),
    sliver: MultiSliver(
      children: [
        SliverPersistentHeader(
          pinned: true,
          delegate: _HeaderSectionDelegate(detail: detail),
        ),
        SliverToBoxAdapter(child: _DetailContent(detail: detail)),
      ],
    ),
  );
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
          alignment: AlignmentDirectional.centerStart,
          height: 45,
          color: backgroundColor,
          child: Row(
            children: [
              Expanded(child: Text(detail.info, style: bodySmall)),
              if (likeView != null) ...likeView,
            ],
          ),
        ),
        const DividerWidget(indent: 0, endIndent: 0),
      ],
    );
  }

  @override
  double get maxExtent => 46;

  @override
  double get minExtent => 46;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}

class _DetailContent extends StatelessWidget {
  final Details detail;

  const _DetailContent({required this.detail});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final String hexColor = theme.focusColor.stringHexColor;
    final TextStyle? bodySmall = theme.textTheme.bodySmall;
    final TextStyle? bodyMedium = theme.textTheme.bodyMedium;
    final DetailViewBloc bloc = context.read<DetailViewBloc>();
    final DetailViewUtil util = getIt<DetailViewUtil>();

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        _Body(
          detail: detail,
          hexColor: hexColor,
          bodyMedium: bodyMedium,
          onTapUrl: (url) => util.openUrl(context, url),
        ),
        const SizedBox(height: 10),
        if (detail.comments.isNotEmpty)
          _Comments(
            hexColor: hexColor,
            comments: detail.comments,
            bodySmall: bodySmall,
            bodyMedium: bodyMedium,
            openUrl: (url) => util.openUrl(context, url),
          ),
        const Divider(),
        _RefreshButton(onRefresh: bloc.refresh, bodyMedium: bodyMedium),
        const Divider(),
      ],
    );
  }
}

class _Body extends StatelessWidget {
  final Details detail;
  final String hexColor;
  final TextStyle? bodyMedium;
  final FutureOr<bool> Function(String url)? onTapUrl;

  const _Body({
    required this.detail,
    required this.hexColor,
    required this.bodyMedium,
    this.onTapUrl,
  });

  @override
  Widget build(BuildContext context) => HtmlWidget(
    detail.bodyHtml,
    onLoadingBuilder: (_, _, _) => const LoadingWidget(),
    // onErrorBuilder: (context, element, error) {
    //   debugPrint('element.innerHtml=${element.innerHtml}');
    //   return HtmlWidget(element.innerHtml);
    // },
    customStylesBuilder: (element) {
      if (element.localName == 'a') {
        return {'color': hexColor, 'text-decoration': 'underline'};
      }
      // else if (element.localName == 'div') {
      //   if (element.innerHtml.startsWith("https://")) {
      //     return {'color': hexColor, 'text-decoration': 'underline'};
      //   }
      // }
      return null;
    },
    // customWidgetBuilder: (element) {
    //     debugPrint('element.innerHtml=${element.innerHtml}');
    //
    //   if (element.localName == 'a' ||
    //       element.localName == 'div' &&
    //           element.innerHtml.startsWith("https://")) {
    //
    //     return GestureDetector(
    //       onTap: () => onTapUrl?.call(element.innerHtml),
    //       child: Text(
    //         element.innerHtml,
    //         style: bodyMedium?.copyWith(
    //           color: Theme.of(context).indicatorColor,
    //           decoration: TextDecoration.underline,
    //         ),
    //       ),
    //     );
    //   }
    //
    //   return HtmlWidget(
    //     element.innerHtml,
    //     textStyle: bodyMedium,
    //     onTapUrl: onTapUrl,
    //     onTapImage: (data) => onTapUrl?.call(data.sources.first.url),
    //   );
    // },
    textStyle: bodyMedium,
    renderMode: RenderMode.column,
    onTapUrl: onTapUrl,
    onTapImage: (data) => onTapUrl?.call(data.sources.first.url),
  );
}

class _Comments extends StatelessWidget {
  final String hexColor;
  final List<CommentItem> comments;
  final TextStyle? bodySmall;
  final TextStyle? bodyMedium;
  final FutureOr<bool> Function(String) openUrl;

  const _Comments({
    required this.hexColor,
    required this.comments,
    required this.bodySmall,
    required this.bodyMedium,
    required this.openUrl,
  });

  @override
  Widget build(BuildContext context) => Column(
    children: [
      const SizedBox(height: 10),
      const Divider(),
      _CommentHeader(commentCount: comments.length, bodyMedium: bodyMedium),
      const Divider(),
      _CommentList(
        comments: comments,
        bodySmall: bodySmall,
        bodyMedium: bodyMedium,
        hexColor: hexColor,
        openUrl: openUrl,
      ),
    ],
  );
}

class _CommentHeader extends StatelessWidget {
  final int commentCount;
  final TextStyle? bodyMedium;

  const _CommentHeader({required this.commentCount, required this.bodyMedium});

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 42,
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        '댓글 ($commentCount)',
        style: bodyMedium?.copyWith(
          color: Theme.of(context).focusColor,
          fontSize: 15,
        ),
      ),
    ),
  );
}

class _CommentList extends StatelessWidget {
  final List<CommentItem> comments;
  final TextStyle? bodySmall;
  final TextStyle? bodyMedium;
  final String hexColor;
  final FutureOr<bool> Function(String) openUrl;

  const _CommentList({
    required this.comments,
    required this.bodySmall,
    required this.bodyMedium,
    required this.hexColor,
    required this.openUrl,
  });

  @override
  Widget build(BuildContext context) => ListView.separated(
    padding: EdgeInsets.zero,
    separatorBuilder: (_, _) => const Divider(),
    shrinkWrap: true,
    physics: const ClampingScrollPhysics(),
    itemCount: comments.length,
    itemBuilder: (_, index) => _CommentItem(
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
  final FutureOr<bool> Function(String) openUrl;

  const _CommentItem({
    required this.comment,
    required this.bodySmall,
    required this.bodyMedium,
    required this.hexColor,
    required this.openUrl,
  });

  @override
  Widget build(BuildContext context) {
    // final userInfo = comment.userInfo;
    final left = comment.isReply ? 16.0 : 0.0;

    final likeView = comment.likeCount.isNotEmpty && comment.likeCount != '0'
        ? [
            const Spacer(),
            Icon(Icons.favorite_outline, color: bodySmall!.color, size: 17),
            const SizedBox(width: 4),
            Text(comment.likeCount, style: bodySmall),
            const SizedBox(width: 4),
          ]
        : [];

    return ListTile(
      key: ValueKey(comment.id),
      contentPadding: EdgeInsets.only(left: left, top: 4, bottom: 4),
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(comment.info, style: bodySmall),
          ...likeView,
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: HtmlWidget(
          comment.bodyHtml,
          onLoadingBuilder: (context, element, progress) =>
              const LoadingWidget(),
          textStyle: bodyMedium,
          customStylesBuilder: (element) {
            if (element.localName == 'a') {
              return {'color': hexColor, 'text-decoration': 'underline'};
            }
            return null;
          },
          onTapUrl: openUrl,
          onTapImage: (data) => openUrl(data.sources.first.url),
        ),
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  final VoidCallback onRefresh;
  final TextStyle? bodyMedium;

  const _RefreshButton({required this.onRefresh, required this.bodyMedium});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onRefresh,
    child: Container(
      width: double.infinity,
      height: 58,
      alignment: Alignment.center,
      child: Text(
        '새로고침',
        style: bodyMedium?.copyWith(color: Theme.of(context).focusColor),
      ),
    ),
  );
}
