import 'dart:async';
import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_user_info.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/bloc/detail_view_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/nick_image_widget.dart';

class DetailView extends StatelessWidget {
  final ReadableListItem item;

  const DetailView({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context) {
    final child = _buildView();
    if (Platform.isMacOS) {
      return Listener(
        onPointerDown: (PointerDownEvent event) {
          if (event.buttons == kSecondaryMouseButton) {
            context.pop();
          }
        },
        child: child,
      );
    }
    return child;
  }

  String getHexColor(Color color) =>
      '#${color.value.toRadixString(16).padLeft(8, '0').substring(2).toUpperCase()}';

  Widget _buildView() => Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 8, 0),
        child: BlocBuilder<DetailViewBloc, DetailViewState>(
          buildWhen: (previous, current) => current is! DetailHeight,
          builder: (context, state) => state.maybeMap(
            success: (state) {
              final theme = Theme.of(context);
              final hexColor = getHexColor(theme.indicatorColor);
              final bodySmall = theme.textTheme.bodySmall;
              final bodyMedium = theme.textTheme.bodyMedium;

              return _buildDetailView(
                bodySmall,
                state,
                hexColor,
                bodyMedium,
                context,
              );
            },
            failed: (state) => MessageWidget(message: state.message),
            orElse: () => const LoadingWidget(),
          ),
        ),
      );

  Widget _buildDetailView(
    TextStyle? bodySmall,
    DetailSuccess state,
    String hexColor,
    TextStyle? bodyMedium,
    BuildContext context,
  ) {
    final bloc = context.read<DetailViewBloc>();
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(
            item.item.userInfo,
            item.item.time,
            bodySmall,
          ),
          const Divider(),
          const SizedBox(height: 10),
          _buildBody(
            state,
            hexColor,
            bodyMedium,
            bloc.openBrowser,
          ),
          const SizedBox(height: 10),
          _buildComments(
            context,
            hexColor,
            state.detail.comments,
            bodySmall,
            bodyMedium,
            bloc.refresh,
            bloc.openBrowser,
          ),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildBody(
    DetailSuccess state,
    String hexColor,
    TextStyle? bodyMedium,
    FutureOr<bool> Function(String url)? onTapUrl,
  ) =>
      HtmlWidget(
        state.detail.bodyHtml,
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
        onTapUrl: onTapUrl,
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
              NickImageWidget(
                url: userInfo.nickImage,
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
    String hexColor,
    List<CommentItem> comments,
    TextStyle? bodySmall,
    TextStyle? bodyMedium,
    void Function() refresh,
    FutureOr<bool> Function(String) openUrl,
  ) {
    Widget buildRefreshButton() => InkWell(
          onTap: refresh,
          child: Container(
            width: double.infinity, // 가로 꽉 채우기
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
                  onTapUrl: openUrl,
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
