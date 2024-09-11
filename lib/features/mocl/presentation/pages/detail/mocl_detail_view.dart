import 'dart:async';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_user_info.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/bloc/detail_view_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/nick_image_widget.dart';

class DetailView extends StatelessWidget {
  const DetailView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final child = _buildView();
    return Platform.isMacOS
        ? Listener(
            onPointerDown: (event) {
              if (event.buttons == kSecondaryMouseButton) {
                Navigator.of(context).pop();
              }
            },
            child: child,
          )
        : child;
  }

  Widget _buildView() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
        child: BlocBuilder<DetailViewBloc, DetailViewState>(
          buildWhen: (previous, current) => current is! DetailHeight,
          builder: (context, state) => state.maybeMap(
            success: (state) => _DetailView(detail: state.detail),
            failed: (state) => MessageWidget(message: state.message),
            orElse: () => const LoadingWidget(),
          ),
        ),
      );
}

class _DetailView extends StatelessWidget {
  final Details detail;

  const _DetailView({super.key, required this.detail});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hexColor = _getHexColor(theme.indicatorColor);
    final bodySmall = theme.textTheme.bodySmall;
    final bodyMedium = theme.textTheme.bodyMedium;

    final bloc = context.read<DetailViewBloc>();

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _Header(userInfo: bloc.userInfo, time: bloc.time),
          const Divider(),
          const SizedBox(height: 10),
          _Body(
              detail: detail,
              hexColor: hexColor,
              bodyMedium: bodyMedium,
              onTapUrl: bloc.openBrowser),
          const SizedBox(height: 10),
          Visibility(
            visible: detail.comments.isNotEmpty,
            child: _Comments(
              hexColor: hexColor,
              comments: detail.comments,
              bodySmall: bodySmall,
              bodyMedium: bodyMedium,
              openUrl: bloc.openBrowser,
            ),
          ),
          const Divider(),
          _RefreshButton(onRefresh: bloc.refresh, bodyMedium: bodyMedium),
        ],
      ),
    );
  }

  String _getHexColor(Color color) =>
      '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';
}

class _Header extends StatelessWidget {
  final UserInfo userInfo;
  final String time;

  const _Header({super.key, required this.userInfo, required this.time});

  @override
  Widget build(BuildContext context) {
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return SizedBox(
      height: 42,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            NickImageWidget(url: userInfo.nickImage),
            Text(userInfo.nickName, style: bodySmall),
            const SizedBox(width: 8),
            Text(time, style: bodySmall),
          ],
        ),
      ),
    );
  }
}

class _Body extends StatelessWidget {
  final Details detail;
  final String hexColor;
  final TextStyle? bodyMedium;
  final FutureOr<bool> Function(String url)? onTapUrl;

  const _Body({
    super.key,
    required this.detail,
    required this.hexColor,
    required this.bodyMedium,
    this.onTapUrl,
  });

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      detail.bodyHtml,
      customStylesBuilder: (element) {
        if (element.localName == 'a') {
          return {'color': hexColor, 'text-decoration': 'underline'};
        }
        return null;
      },
      textStyle: bodyMedium,
      renderMode: RenderMode.column,
      onTapUrl: onTapUrl,
    );
  }
}

class _Comments extends StatelessWidget {
  final String hexColor;
  final List<CommentItem> comments;
  final TextStyle? bodySmall;
  final TextStyle? bodyMedium;
  final FutureOr<bool> Function(String) openUrl;

  const _Comments({
    super.key,
    required this.hexColor,
    required this.comments,
    required this.bodySmall,
    required this.bodyMedium,
    required this.openUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const Divider(),
        _CommentHeader(commentCount: comments.length),
        const Divider(),
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
}

class _CommentHeader extends StatelessWidget {
  final int commentCount;

  const _CommentHeader({super.key, required this.commentCount});

  @override
  Widget build(BuildContext context) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium;
    return SizedBox(
      height: 42,
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          '댓글 ($commentCount)',
          style: bodyMedium?.copyWith(
            color: Theme.of(context).indicatorColor,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

class _CommentList extends StatelessWidget {
  final List<CommentItem> comments;
  final TextStyle? bodySmall;
  final TextStyle? bodyMedium;
  final String hexColor;
  final FutureOr<bool> Function(String) openUrl;

  const _CommentList({
    super.key,
    required this.comments,
    required this.bodySmall,
    required this.bodyMedium,
    required this.hexColor,
    required this.openUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: EdgeInsets.zero,
      separatorBuilder: (_, __) => const Divider(),
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: comments.length,
      itemBuilder: (context, index) => _CommentItem(
        comment: comments[index],
        bodySmall: bodySmall,
        bodyMedium: bodyMedium,
        hexColor: hexColor,
        openUrl: openUrl,
      ),
    );
  }
}

class _CommentItem extends StatelessWidget {
  final CommentItem comment;
  final TextStyle? bodySmall;
  final TextStyle? bodyMedium;
  final String hexColor;
  final FutureOr<bool> Function(String) openUrl;

  const _CommentItem({
    super.key,
    required this.comment,
    required this.bodySmall,
    required this.bodyMedium,
    required this.hexColor,
    required this.openUrl,
  });

  @override
  Widget build(BuildContext context) {
    final userInfo = comment.userInfo;
    final left = comment.isReply ? 16.0 : 0.0;

    return ListTile(
      key: Key(comment.id.toString()),
      contentPadding: EdgeInsets.only(left: left, top: 4, bottom: 4),
      title: Row(
        children: [
          NickImageWidget(url: userInfo.nickImage),
          Text(userInfo.nickName, style: bodySmall),
          const SizedBox(width: 8),
          Text(comment.time, style: bodySmall),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: HtmlWidget(
          comment.bodyHtml,
          textStyle: bodyMedium,
          customStylesBuilder: (element) {
            if (element.localName == 'a') {
              return {'color': hexColor, 'text-decoration': 'underline'};
            }
            return null;
          },
          onTapUrl: openUrl,
        ),
      ),
    );
  }
}

class _RefreshButton extends StatelessWidget {
  final VoidCallback onRefresh;
  final TextStyle? bodyMedium;

  const _RefreshButton(
      {super.key, required this.onRefresh, required this.bodyMedium});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onRefresh,
      child: Container(
        width: double.infinity,
        height: 58,
        alignment: Alignment.center,
        child: Text(
          '새로고침',
          style: bodyMedium?.copyWith(
            color: Theme.of(context).indicatorColor,
          ),
        ),
      ),
    );
  }
}
