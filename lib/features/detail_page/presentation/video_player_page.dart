import 'package:chewie/chewie.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';
import 'package:mocl_flutter/core/util/utilities.dart';
import 'package:mocl_flutter/features/detail_page/domain/video_link_resolver.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_api.dart'
    show userAgentMobile;
import 'package:url_launcher/url_launcher.dart';
import 'package:video_player/video_player.dart';

import '../../../core/presentation/widgets/plain_text.dart';

/// 동영상 플레이어 화면으로 넘기는 인자.
class const VideoPlayerArgs({
  required final VideoLink link,

  /// 영상 파일을 받을 때 실어 보낼 Referer(보통 지금 사이트 주소).
  /// 일부 CDN 은 사이트 도메인이 아니면 파일을 주지 않는다.
  final String? referer,
});

/// 본문 링크의 유튜브 · 영상 파일을 앱 안에서 재생하는 화면.
class const VideoPlayerPage({super.key, required final VideoPlayerArgs args})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final VideoLink link = args.link;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            tooltip: '브라우저로 열기',
            icon: const Icon(Icons.open_in_new),
            onPressed: () => _openExternally(link),
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: switch (link) {
            YouTubeLink() => _YouTubePlayer(link: link),
            DirectVideoLink() => _FileVideoPlayer(
              link: link,
              referer: args.referer,
            ),
          },
        ),
      ),
    );
  }

  /// 유튜브는 유튜브 앱으로, 파일은 브라우저로 연다.
  static Future<void> _openExternally(VideoLink link) async {
    switch (link) {
      case YouTubeLink():
        await launchUrl(
          Uri.parse(link.sourceUrl),
          mode: LaunchMode.externalApplication,
        );
      case DirectVideoLink():
        await link.sourceUrl.openBrowser();
    }
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 유튜브
// ─────────────────────────────────────────────────────────────────────────────

/// IFrame 임베드로 재생한다.
///
/// 웹뷰에 HTML 을 그냥 넣으면 페이지 origin 이 없어 Referer 가 빠지고, 유튜브가
/// "Error 153 (동영상 플레이어 구성 오류)" 로 막는다. 앱 id 형태의 https
/// baseUrl 을 줘서 Referer 가 실리게 한다(유튜브 임베드 안내가 권하는 형식).
class const _YouTubePlayer({required final YouTubeLink link})
    extends StatelessWidget {
  static const String _origin = 'https://kr.b1ink.mocl';

  String get _html {
    final String start = link.startSeconds > 0
        ? '&start=${link.startSeconds}'
        : '';
    return '''
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="width=device-width, initial-scale=1">
<style>
  html, body { margin: 0; height: 100%; background: #000; overflow: hidden; }
  iframe { position: absolute; inset: 0; width: 100%; height: 100%; border: 0; }
</style>
</head>
<body>
<iframe
  src="https://www.youtube.com/embed/${link.videoId}?autoplay=1&playsinline=1&rel=0$start&origin=$_origin"
  allow="autoplay; encrypted-media; picture-in-picture; fullscreen"
  referrerpolicy="strict-origin-when-cross-origin"
  allowfullscreen></iframe>
</body>
</html>''';
  }

  @override
  Widget build(BuildContext context) => InAppWebView(
    initialData: InAppWebViewInitialData(
      data: _html,
      baseUrl: WebUri(_origin),
      mimeType: 'text/html',
      encoding: 'utf-8',
    ),
    initialSettings: InAppWebViewSettings(
      javaScriptEnabled: true,
      mediaPlaybackRequiresUserGesture: false,
      allowsInlineMediaPlayback: true,
      iframeAllowFullscreen: true,
      useShouldOverrideUrlLoading: true,
      transparentBackground: true,
    ),
    // 플레이어 안의 유튜브 로고 · 추천 영상 등을 누르면 이 화면이 유튜브
    // 웹페이지로 바뀌어 버린다. 그런 이동은 막고 유튜브 앱으로 넘긴다.
    shouldOverrideUrlLoading: (controller, action) async {
      final WebUri? url = action.request.url;
      if (!action.isForMainFrame || url == null || url.host.isEmpty) {
        return NavigationActionPolicy.ALLOW;
      }
      if (url.toString().startsWith(_origin)) {
        return NavigationActionPolicy.ALLOW;
      }
      MoclLogger.d(() => '[youtube] 외부로 이동: $url');
      await launchUrl(url, mode: LaunchMode.externalApplication);
      return NavigationActionPolicy.CANCEL;
    },
  );
}

// ─────────────────────────────────────────────────────────────────────────────
// 영상 파일
// ─────────────────────────────────────────────────────────────────────────────

class const _FileVideoPlayer({
  required final DirectVideoLink link,
  final String? referer,
}) extends StatefulWidget {
  @override
  State<_FileVideoPlayer> createState() => _FileVideoPlayerState();
}

class _FileVideoPlayerState() extends State<_FileVideoPlayer> {
  late final VideoPlayerController _video;
  ChewieController? _chewie;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    final String? referer = widget.referer;
    _video = VideoPlayerController.networkUrl(
      Uri.parse(widget.link.url),
      httpHeaders: {
        'User-Agent': userAgentMobile,
        if (referer != null && referer.isNotEmpty) 'Referer': referer,
      },
    );
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _video.initialize();
      if (!mounted) return;
      final double ratio = _video.value.aspectRatio;
      setState(
        () => _chewie = ChewieController(
          videoPlayerController: _video,
          autoPlay: true,
          looping: false,
          aspectRatio: ratio.isFinite && ratio > 0 ? ratio : 16 / 9,
        ),
      );
    } catch (e, st) {
      MoclLogger.w(() => '[video] 재생 실패 ${widget.link.url}: $e\n$st');
      if (mounted) setState(() => _failed = true);
    }
  }

  @override
  void dispose() {
    _chewie?.dispose();
    _video.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        spacing: 12,
        children: [
          const PlainText(
            '영상을 재생할 수 없습니다',
            style: TextStyle(color: Colors.white),
          ),
          TextButton(
            onPressed: () => widget.link.url.openBrowser(),
            child: const Text('브라우저로 열기'),
          ),
        ],
      );
    }
    final ChewieController? chewie = _chewie;
    if (chewie == null) return const LoadingWidget();
    return Chewie(controller: chewie);
  }
}
