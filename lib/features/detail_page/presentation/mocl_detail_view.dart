import 'dart:async';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:go_router/go_router.dart';
import 'package:html/parser.dart' as html_parser;
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart' show Routes;
import 'package:mocl_flutter/features/detail_page/presentation/photo_view_dialog.dart'
    show GalleryArgs;
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

import '../../../core/presentation/widgets/author_info_text.dart';
import '../../../core/presentation/widgets/plain_divider_widget.dart';
import '../../../core/presentation/widgets/plain_icon.dart';
import '../../../core/presentation/widgets/plain_text.dart';

const _kHeaderHeight = 38.0;

/// 프로토콜 상대 경로(`//cdn.../x.webp`)는 스킴이 없어 뷰어가 로드하지 못하므로
/// https 로 정규화한다.
String _normalizeImageUrl(String url) =>
    url.startsWith('//') ? 'https:$url' : url;

/// [html] 본문 안의 모든 `<img>` src 를 등장 순서대로 수집해 정규화한다.
List<String> _extractImageUrls(String html) {
  try {
    return html_parser
        .parse(html)
        .querySelectorAll('img')
        .map((e) => e.attributes['src'] ?? '')
        .where((s) => s.isNotEmpty)
        .map(_normalizeImageUrl)
        .toList(growable: false);
  } catch (_) {
    return const [];
  }
}

/// 탭한 이미지를 기준으로 같은 본문의 모든 이미지를 좌우 스와이프할 수 있는
/// 갤러리 뷰어를 띄운다. 추출 목록에서 탭한 이미지를 찾지 못하면 해당 한 장만
/// 보여준다.
void _openGallery(
  BuildContext context,
  String html,
  String tappedUrl,
  String referer,
) {
  final String normalized = _normalizeImageUrl(tappedUrl);
  final List<String> urls = _extractImageUrls(html);
  final int found = urls.indexOf(normalized);
  final List<String> list = found >= 0 ? urls : [normalized];
  final int index = found >= 0 ? found : 0;

  context.push(
    Routes.viewPhotoDlgFull,
    extra: GalleryArgs(urls: list, index: index, referer: referer),
  );
}

class const DetailView({super.key})
    extends ConsumerWidget
    with DetailState, DetailEvent {
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

class const _LoadingView() extends StatelessWidget {
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

class const _DetailView({
  required final Details detail,
  required final VoidCallback onRefresh,
}) extends StatelessWidget with DetailEvent {
  @override
  Widget build(BuildContext context) {
    final (styles, hexColor) = DetailStyleScope.of(context);
    final TextStyle bodySmall = styles.smallTextStyle;
    final TextStyle bodyMedium = styles.titleTextStyle;
    final totalComments =
        detail.extraData?['totalComments'] as int? ?? detail.comments.length;

    final bottom = MediaQuery.of(context).padding.bottom;

    // 작성자 헤더는 앱바 확장 영역(DetailAppBar.bottom)으로 이동해 앱바와 함께
    // floating 된다. 여기서는 본문/댓글만 렌더한다.
    return MultiSliver(
      children: [
        SliverPadding(
          padding: const EdgeInsets.only(left: 16, right: 8),
          sliver: MultiSliver(
            children: [
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
                  authorId: detail.userInfo.id,
                  authorNick: detail.userInfo.nickName,
                  bodySmall: bodySmall,
                  bodyMedium: bodyMedium,
                  hexColor: hexColor,
                  openUrl: (String url) => url.openUrl(context),
                ),
              ],
              const PlainDividerWidget(indent: 0, endIndent: 0),
              _RefreshButton(onRefresh: onRefresh, textStyle: bodySmall),
              const PlainDividerWidget(indent: 0, endIndent: 0),
              if (bottom > 0)
                SliverPadding(padding: EdgeInsets.only(bottom: bottom)),
            ],
          ),
        ),
      ],
    );
  }
}

class const _CommentList({
  required final List<CommentItem> comments,

  /// 원글 작성자(OP) 식별용. 댓글 작성자가 이와 같으면 닉네임을 강조색으로 칠한다.
  required final String authorId,
  required final String authorNick,
  required final TextStyle? bodySmall,
  required final TextStyle? bodyMedium,
  required final String hexColor,
  required final void Function(String) openUrl,
}) extends StatelessWidget {
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
        isAuthor: _isOp(comment.userInfo, authorId, authorNick),
        bodySmall: bodySmall,
        bodyMedium: bodyMedium,
        hexColor: hexColor,
        depth: comment.isReply ? 1 : 0,
        openUrl: openUrl,
      );
    },
  );

  /// 댓글 작성자가 원글 작성자인지 판별. id 우선, 없으면 닉네임으로 비교.
  static bool _isOp(UserInfo u, String authorId, String authorNick) {
    if (authorId.isNotEmpty && u.id == authorId) return true;
    if (authorNick.isNotEmpty && u.nickName == authorNick) return true;
    return false;
  }
}

class const _SpaceWidget() extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      const SliverPadding(padding: EdgeInsets.only(top: 10));
}

class const _Body({
  required final Details detail,
  required final String hexColor,
  required final TextStyle? bodyMedium,
  required final FutureOr<bool> Function(String url) onTapUrl,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => _HtmlWidget(
    html: detail.bodyHtml,
    // 본문은 읽기 중심으로 행간을 넓혀(1.7) 가독성을 높인다.
    textStyle: bodyMedium?.copyWith(height: 1.7),
    hexColor: hexColor,
    openUrl: onTapUrl,
    // renderMode: RenderMode.sliverList,
  );
}

class const _CommentHeader({
  required final int commentCount,
  required final int totalCount,
  required final TextStyle? bodyMedium,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final focusColor = Theme.of(context).focusColor;
    // "댓글 N" 은 볼드 코랄 라벨로 강조해 본문/댓글 섹션 경계를 명확히 한다.
    final bodyMedium_ = bodyMedium!.copyWith(
      color: focusColor,
      fontWeight: FontWeight.w800,
    );

    final label = totalCount > commentCount
        ? '댓글 $commentCount/$totalCount'
        : '댓글 $commentCount';
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

class const _CommentItem({
  required final CommentItem comment,
  required final bool isAuthor,
  required final TextStyle? bodySmall,
  required final TextStyle? bodyMedium,
  required final String hexColor,
  required final int depth,
  required final void Function(String) openUrl,
}) extends StatelessWidget {
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
      padding: EdgeInsets.only(left: leftPadding, top: 16, bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (userInfo.nickImage.isNotEmpty)
                NickImageWidget(url: userInfo.nickImage),
              if (comment.info.isNotEmpty)
                Expanded(
                  child: AuthorInfoText(
                    info: comment.info,
                    nickName: userInfo.nickName,
                    isAuthor: isAuthor,
                    style: bodySmall!,
                  ),
                ),
              ...?likeView,
            ],
          ),
          if (!isEmptyBody)
            Padding(
              padding: const EdgeInsets.only(top: 10),
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

class const _HtmlLoadingWidget({
  required final String src,
  final TextStyle? textStyle,
  final double? progress,
}) extends StatelessWidget {
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

/// 본문 이미지 로드 실패 시 파일이름 + 재시도 버튼을 표시한다.
///
/// [CachedNetworkImage] 는 실패 결과도 캐시하므로, 재시도 시 캐시를 비운 뒤
/// [ValueKey] 를 바꿔 위젯을 재생성해 다시 요청하게 한다.
class const _RetryableCachedImage({
  required final String url,
  required final Map<String, String> headers,
  required final Widget Function(BuildContext context, double? progress)
  loadingBuilder,
  required final Widget Function(
    BuildContext context,
    dynamic error,
    VoidCallback onRetry,
  )
  errorBuilder,
}) extends StatefulWidget {
  @override
  State<_RetryableCachedImage> createState() => _RetryableCachedImageState();
}

class _RetryableCachedImageState() extends State<_RetryableCachedImage> {
  int _attempt = 0;

  Future<void> _retry() async {
    // 실패 캐시를 제거한 뒤 key 를 바꿔 재요청을 유도한다.
    await CachedNetworkImage.evictFromCache(widget.url);
    if (mounted) setState(() => _attempt++);
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      key: ValueKey(_attempt),
      imageUrl: widget.url,
      httpHeaders: widget.headers,
      fit: BoxFit.fill,
      errorWidget: (context, _, error) =>
          widget.errorBuilder(context, error, _retry),
      progressIndicatorBuilder: (context, _, progress) {
        final total = progress.totalSize;
        final v = total != null && total > 0
            ? progress.downloaded / total
            : null;
        return widget.loadingBuilder(context, v);
      },
    );
  }
}

/// 이미지 로드 실패 표시: 파일이름(기존 fwfh 위젯) + 재시도 버튼.
class const _HtmlImageErrorWidget({
  required final Widget filename,
  required final VoidCallback onRetry,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final focusColor = Theme.of(context).focusColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(child: filename),
          InkWell(
            onTap: onRetry,
            borderRadius: BorderRadius.circular(4.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: PlainIcon(Icons.refresh, size: 20, color: focusColor),
            ),
          ),
        ],
      ),
    );
  }
}

class const _HtmlWidget({
  required final String html,
  required final TextStyle? textStyle,
  required final String hexColor,
  required final void Function(String) openUrl,
}) extends ConsumerWidget with DetailState {
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
      factoryBuilder: () =>
          _MoclWidgetFactory(openUrl: openUrl, referer: referer),
      textStyle: textStyle,
      customStylesBuilder: (element) {
        if (element.localName == 'a') {
          return {'color': hexColor, 'text-decoration': 'underline'};
        }
        return null;
      },
      onTapImage: (data) {
        if (data.sources.isEmpty) return;
        _openGallery(context, html, data.sources.first.url, referer);
      },
    );

    if (kIsWeb || Platform.isMacOS) {
      return htmlWidget;
    } else {
      return SelectionArea(child: htmlWidget);
    }
  }
}

class const _RefreshButton({
  required final VoidCallback onRefresh,
  required final TextStyle? textStyle,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final focusColor = Theme.of(context).focusColor;
    final textStyle = this.textStyle!.copyWith(color: focusColor);

    return InkWell(
      onTap: onRefresh,
      child: SizedBox(
        width: double.infinity,
        height: 58,
        child: Center(child: PlainText('새로고침', style: textStyle)),
      ),
    );
  }
}

/// YouTube iframe을 외부 앱으로 열고, 일반 미디어는 인라인 재생을 허용하는 WidgetFactory.
class _MoclWidgetFactory({
  required final void Function(String) openUrl,

  /// 본문 이미지 로드 시 보낼 Referer. 보통 현재 사이트의 baseUrl.
  /// (디시 등 일부 CDN 은 Referer 가 사이트 도메인이어야 이미지를 준다.)
  required final String referer,
}) extends WidgetFactory {
  /// fwfh 의 CachedNetworkImageFactory mixin 은 buildImageWidget 에서
  /// CachedNetworkImage 를 직접 만들며 httpHeaders 를 넣지 않아서, Referer 가
  /// 필요한 CDN(디시 등)은 403→alt(해시)만 보였다. 여기서 buildImageWidget 을
  /// 오버라이드해 현재 사이트의 Referer 와 앱 공용 모바일 UA 를 실어 로드한다.
  @override
  Widget? buildImageWidget(BuildTree tree, ImageSource src) {
    final String url = src.url;
    if (referer.isNotEmpty && url.startsWith(RegExp('https?://'))) {
      return _RetryableCachedImage(
        url: url,
        headers: {'Referer': referer, 'User-Agent': userAgentMobile},
        loadingBuilder: (context, v) =>
            onLoadingBuilder(context, tree, v, src) ?? const SizedBox.shrink(),
        errorBuilder: (context, error, onRetry) => _HtmlImageErrorWidget(
          filename:
              onErrorBuilder(context, tree, error, src) ??
              const SizedBox.shrink(),
          onRetry: onRetry,
        ),
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
