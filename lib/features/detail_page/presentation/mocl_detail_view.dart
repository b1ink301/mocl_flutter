import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_user_info.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_api.dart'
    show userAgentMobile;
import 'package:mocl_flutter/core/presentation/widgets/nick_image_widget.dart';
import 'package:mocl_flutter/core/util/utilities.dart';
import 'package:mocl_flutter/features/detail_page/presentation/state/detail_event_mixin.dart';
import 'package:mocl_flutter/features/detail_page/presentation/state/detail_state_mixin.dart';
import 'package:mocl_flutter/features/detail_page/presentation/widgets/detail_scope.dart';
import 'package:sliver_tools/sliver_tools.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/presentation/widgets/plain_divider_widget.dart';
import '../../../core/presentation/widgets/plain_icon.dart';
import '../../../core/presentation/widgets/plain_text.dart';

const _kHeaderHeight = 48.0;

class DetailView extends ConsumerWidget with DetailState, DetailEvent {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final smallTextStyle = DetailStyleScope.of(context).$1.smallTextStyle;
    return detailState(ref).maybeMap(
      data: (state) =>
          _DetailView(detail: state.value, onRefresh: () => handleRefresh(ref)),
      error: (state) => SliverFillRemaining(
        hasScrollBody: false,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Center(
            child: PlainText(state.error.toString(), style: smallTextStyle),
          ),
        ),
      ),
      orElse: () => const _LoadingView(),
    );
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    final smallTextStyle = DetailStyleScope.of(context).$1.smallTextStyle;
    return SliverFillRemaining(
      hasScrollBody: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        spacing: 8,
        children: [
          const LoadingWidget(),
          PlainText('로딩 중...', style: smallTextStyle),
        ],
      ),
    );
  }
}

class _DetailView extends StatelessWidget with DetailEvent {
  final Details detail;
  final VoidCallback onRefresh;

  const _DetailView({required this.detail, required this.onRefresh});

  @override
  Widget build(BuildContext context) {
    final scaffoldBackgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final (styles, hexColor) = DetailStyleScope.of(context);
    final TextStyle bodySmall = styles.smallTextStyle;
    final TextStyle bodyMedium = styles.titleTextStyle;
    final totalComments =
        detail.extraData?['totalComments'] as int? ?? detail.comments.length;

    final bottom = MediaQuery.of(context).padding.bottom;

    return SliverPadding(
      padding: const EdgeInsets.only(left: 16, right: 8),
      sliver: MultiSliver(
        children: [
          SliverPersistentHeader(
            pinned: true,
            delegate: _HeaderSectionDelegate(
              detail: detail,
              bodyMedium: bodySmall,
              backgroundColor: scaffoldBackgroundColor,
            ),
          ),
          const _SpaceWidget(),
          // 본문은 RepaintBoundary로 감싸 스크롤 시 불필요한 페인팅 방지
          RepaintBoundary(
            child: _Body(
              detail: detail,
              hexColor: hexColor,
              bodyMedium: bodyMedium,
              onTapUrl: (url) => url.openUrl(context),
            ),
          ),
          const _SpaceWidget(),
          if (detail.comments.isNotEmpty) ...[
            const PlainDividerWidget(indent: 0, endIndent: 0),
            _CommentHeader(
              commentCount: detail.comments.length,
              totalCount: totalComments,
              bodyMedium: bodySmall,
            ),
            const PlainDividerWidget(indent: 0, endIndent: 0),
            _CommentList(
              comments: detail.comments,
              bodySmall: bodySmall,
              bodyMedium: bodyMedium,
              hexColor: hexColor,
              openUrl: (String url) => url.openUrl(context),
            ),
          ],
          const PlainDividerWidget(indent: 0, endIndent: 0),
          _RefreshButton(onRefresh: onRefresh, bodyMedium: bodyMedium),
          const PlainDividerWidget(indent: 0, endIndent: 0),
          if (bottom > 0)
            SliverPadding(padding: EdgeInsets.only(bottom: bottom)),
        ],
      ),
    );
  }
}

class _CommentList extends StatelessWidget {
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
  Widget build(BuildContext context) => SliverList.separated(
    addSemanticIndexes: false,
    separatorBuilder: (_, index) =>
        const PlainDividerWidget(indent: 0, endIndent: 0),
    itemCount: comments.length,
    itemBuilder: (_, int index) {
      final comment = comments[index];
      return _CommentItem(
        comment: comment,
        bodySmall: bodySmall,
        bodyMedium: bodyMedium,
        hexColor: hexColor,
        depth: comment.isReply ? 1 : 0,
        openUrl: openUrl,
      );
    },
  );
}

class _SpaceWidget extends StatelessWidget {
  const _SpaceWidget();

  @override
  Widget build(BuildContext context) =>
      const SliverPadding(padding: EdgeInsets.only(top: 10));
}

class _HeaderSectionDelegate extends SliverPersistentHeaderDelegate {
  final Details detail;
  final TextStyle? bodyMedium;
  final Color backgroundColor;

  const _HeaderSectionDelegate({
    required this.detail,
    required this.bodyMedium,
    required this.backgroundColor,
  });

  List<Widget>? _buildLikeView(BuildContext context, TextStyle bodyMedium) =>
      detail.likeCount.isNotEmpty && detail.likeCount != '0'
      ? [
          const SizedBox(width: 10),
          PlainIcon(Icons.favorite_outline, color: bodyMedium.color!, size: 17),
          const SizedBox(width: 4),
          PlainText(detail.likeCount, style: bodyMedium),
          const SizedBox(width: 10),
        ]
      : null;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final likeView = _buildLikeView(context, bodyMedium!);
    final nickImage = detail.userInfo.nickImage;

    return Column(
      children: [
        Container(
          height: _kHeaderHeight,
          alignment: .centerLeft,
          color: backgroundColor,
          child: Row(
            children: [
              if (nickImage.isNotEmpty)
                NickImageWidget(url: detail.userInfo.nickImage),
              Expanded(child: PlainText(detail.info, style: bodyMedium!)),
              ...?likeView,
            ],
          ),
        ),
        const PlainDividerWidget(indent: 0, endIndent: 0),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant _HeaderSectionDelegate oldDelegate) =>
      oldDelegate.detail.info != detail.info ||
      oldDelegate.bodyMedium != bodyMedium ||
      oldDelegate.backgroundColor != backgroundColor;

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
    html: detail.bodyHtml,
    textStyle: bodyMedium,
    hexColor: hexColor,
    openUrl: onTapUrl,
    // renderMode: RenderMode.sliverList,
  );
}

class _CommentHeader extends StatelessWidget {
  final int commentCount;
  final int totalCount;
  final TextStyle? bodyMedium;

  const _CommentHeader({
    required this.commentCount,
    required this.totalCount,
    required this.bodyMedium,
  });

  @override
  Widget build(BuildContext context) {
    final focusColor = Theme.of(context).focusColor;
    final bodyMedium_ = bodyMedium!.copyWith(color: focusColor);

    final label = totalCount > commentCount
        ? '댓글 ($commentCount/$totalCount)'
        : '댓글 ($commentCount)';
    return SliverFixedExtentList(
      itemExtent: _kHeaderHeight,
      delegate: SliverChildListDelegate([
        Align(
          alignment: Alignment.centerLeft,
          child: PlainText(label, style: bodyMedium_),
        ),
      ]),
    );
  }
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
    // depth에 따른 들여쓰기 계산
    final double leftPadding = depth * 16.0;

    final List<Widget>? likeView =
        comment.likeCount.isNotEmpty && comment.likeCount != '0'
        ? [
            PlainIcon(
              Icons.favorite_outline,
              color: bodySmall!.color!,
              size: 17,
            ),
            const SizedBox(width: 4),
            PlainText(comment.likeCount, style: bodySmall!),
            const SizedBox(width: 4),
          ]
        : null;

    final isEmptyBody = comment.bodyHtml.trim().isEmpty;

    return Padding(
      padding: EdgeInsets.only(left: leftPadding, top: 12, bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (userInfo.nickImage.isNotEmpty)
                NickImageWidget(url: userInfo.nickImage),
              if (comment.info.isNotEmpty)
                Expanded(
                  child: PlainText(
                    comment.info,
                    style: bodySmall!,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ...?likeView,
            ],
          ),
          if (!isEmptyBody)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: _HtmlWidget(
                html: comment.bodyHtml,
                textStyle: bodyMedium,
                hexColor: hexColor,
                openUrl: openUrl,
              ),
            ),
        ],
      ),
    );
  }
}

class _HtmlLoadingWidget extends StatelessWidget {
  final String src;
  final TextStyle? textStyle;
  final double? progress;

  const _HtmlLoadingWidget({required this.src, this.textStyle, this.progress});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dividerColor = theme.dividerTheme.color;
    final focusColor = theme.focusColor;

    return src.isEmpty || progress == null
        ? const SizedBox.shrink()
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Column(
              children: [
                PlainText(src, style: textStyle!),
                LinearProgressIndicator(
                  value: progress,
                  backgroundColor: dividerColor,
                  valueColor: AlwaysStoppedAnimation<Color>(focusColor),
                ),
              ],
            ),
          );
  }
}

class _HtmlWidget extends ConsumerWidget with DetailState {
  final String html;
  final TextStyle? textStyle;
  final String hexColor;
  final void Function(String) openUrl;

  const _HtmlWidget({
    required this.html,
    required this.textStyle,
    required this.hexColor,
    required this.openUrl,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 이미지 Referer 는 "현재 보고 있는 사이트"의 baseUrl(파서 단일 출처)을 쓴다.
    // application provider 직접 참조 대신 DetailState mixin 을 통해 가져온다.
    final referer = imageRefererState(ref);

    final htmlWidget = HtmlWidget(
      html,
      onLoadingBuilder: (context, element, progress) {
        final src = element.attributes['src'] ?? '';
        return _HtmlLoadingWidget(
          src: src,
          textStyle: textStyle?.copyWith(fontSize: 12),
          progress: progress,
        );
      },
      factoryBuilder: () => _MoclWidgetFactory(openUrl: openUrl, referer: referer),
      textStyle: textStyle,
      customStylesBuilder: (element) {
        if (element.localName == 'a') {
          return {'color': hexColor, 'text-decoration': 'underline'};
        }
        return null;
      },
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
  Widget build(BuildContext context) {
    final focusColor = Theme.of(context).focusColor;
    final bodyMedium_ = bodyMedium!.copyWith(color: focusColor);

    return InkWell(
      onTap: onRefresh,
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: Center(child: PlainText('새로고침', style: bodyMedium_)),
      ),
    );
  }
}

/// YouTube iframe을 외부 앱으로 열고, 일반 미디어는 인라인 재생을 허용하는 WidgetFactory.
class _MoclWidgetFactory extends WidgetFactory {
  final void Function(String) openUrl;

  /// 본문 이미지 로드 시 보낼 Referer. 보통 현재 사이트의 baseUrl.
  /// (디시 등 일부 CDN 은 Referer 가 사이트 도메인이어야 이미지를 준다.)
  final String referer;

  _MoclWidgetFactory({required this.openUrl, required this.referer});

  /// fwfh 의 CachedNetworkImageFactory mixin 은 buildImageWidget 에서
  /// CachedNetworkImage 를 직접 만들며 httpHeaders 를 넣지 않아서, Referer 가
  /// 필요한 CDN(디시 등)은 403→alt(해시)만 보였다. 여기서 buildImageWidget 을
  /// 오버라이드해 현재 사이트의 Referer 와 앱 공용 모바일 UA 를 실어 로드한다.
  @override
  Widget? buildImageWidget(BuildTree tree, ImageSource src) {
    final String url = src.url;
    if (referer.isNotEmpty && url.startsWith(RegExp('https?://'))) {
      return CachedNetworkImage(
        imageUrl: url,
        httpHeaders: {'Referer': referer, 'User-Agent': userAgentMobile},
        fit: BoxFit.fill,
        errorWidget: (context, _, error) =>
            onErrorBuilder(context, tree, error, src) ??
            const SizedBox.shrink(),
        progressIndicatorBuilder: (context, _, progress) {
          final total = progress.totalSize;
          final v = total != null && total > 0
              ? progress.downloaded / total
              : null;
          return onLoadingBuilder(context, tree, v, src) ??
              const SizedBox.shrink();
        },
      );
    }
    return super.buildImageWidget(tree, src);
  }

  static final _youtubePattern = RegExp(
    r'youtube\.com|youtu\.be|youtube-nocookie\.com',
  );

  @override
  bool get webViewMediaPlaybackAlwaysAllow => true;

  @override
  Widget? buildWebView(
    BuildTree meta,
    String url, {
    double? height,
    Iterable<String>? sandbox,
    double? width,
  }) {
    // YouTube URL이면 썸네일 + 재생 버튼으로 표시하고 탭 시 외부 앱으로 오픈
    if (_youtubePattern.hasMatch(url)) {
      final videoId = _extractYouTubeId(url);
      final thumbnailUrl = videoId != null
          ? 'https://img.youtube.com/vi/$videoId/hqdefault.jpg'
          : null;

      final watchUrl = videoId != null
          ? 'https://www.youtube.com/watch?v=$videoId'
          : url;

      return GestureDetector(
        onTap: () => _launchYouTube(watchUrl),
        child: AspectRatio(
          aspectRatio: width != null && height != null && height > 0
              ? width / height
              : 16 / 9,
          child: Stack(
            alignment: Alignment.center,
            children: [
              if (thumbnailUrl != null)
                Image.network(
                  thumbnailUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  errorBuilder: (_, _, _) =>
                      Container(color: const Color(0xFF000000)),
                )
              else
                Container(color: const Color(0xFF000000)),
              const PlainIcon(
                Icons.play_circle_fill,
                size: 64,
                color: Color(0xCCFFFFFF),
              ),
            ],
          ),
        ),
      );
    }

    return super.buildWebView(
      meta,
      url,
      height: height,
      sandbox: sandbox,
      width: width,
    );
  }

  static String? _extractYouTubeId(String url) {
    // youtube.com/embed/VIDEO_ID, youtu.be/VIDEO_ID, youtube.com/watch?v=VIDEO_ID
    final patterns = [
      RegExp(r'youtube\.com/embed/([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtu\.be/([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtube\.com/watch\?v=([a-zA-Z0-9_-]{11})'),
      RegExp(r'youtube-nocookie\.com/embed/([a-zA-Z0-9_-]{11})'),
    ];
    for (final pattern in patterns) {
      final match = pattern.firstMatch(url);
      if (match != null) return match.group(1);
    }
    return null;
  }

  static Future<void> _launchYouTube(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
