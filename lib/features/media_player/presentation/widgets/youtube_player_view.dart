import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/features/detail_page/domain/video_link_resolver.dart';
import 'package:mocl_shared/util/mocl_logger.dart';
import 'package:url_launcher/url_launcher.dart';

import 'media_playback.dart';

/// 유튜브를 IFrame 임베드로 재생한다.
///
/// 웹뷰에 HTML 을 그냥 넣으면 페이지 origin 이 없어 Referer 가 빠지고, 유튜브가
/// "Error 153 (동영상 플레이어 구성 오류)" 로 막는다. 앱 id 형태의 https
/// baseUrl 을 줘서 Referer 가 실리게 한다(유튜브 임베드 안내가 권하는 형식).
///
/// 미니 창의 재생/정지는 IFrame Player API(`enablejsapi=1`)로 한다. API 를 못
/// 받아도(오프라인 등) 영상은 iframe 만으로 재생된다.
class const YouTubePlayerView({
  super.key,
  required final YouTubeLink link,
  required final MediaPlayback playback,
}) extends StatefulWidget {
  @override
  State<YouTubePlayerView> createState() => _YouTubePlayerViewState();
}

class _YouTubePlayerViewState() extends State<YouTubePlayerView> {
  static const String _origin = 'https://kr.b1ink.mocl';

  InAppWebViewController? _controller;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    widget.playback.audio.addListener(_applyAudio);
  }

  /// 유튜브 볼륨은 0~100 정수.
  void _applyAudio() {
    if (!_ready) return;
    final ({double volume, bool muted}) audio = widget.playback.audio.value;
    _controller?.evaluateJavascript(
      source: 'moclAudio(${(audio.volume * 100).round()}, ${audio.muted});',
    );
  }

  String get _html {
    final YouTubeLink link = widget.link;
    final String start = link.startSeconds > 0
        ? '&start=${link.startSeconds}'
        : '';
    // fs=0: 유튜브 자체 전체화면 버튼 대신 앱의 "가로로 보기" 를 쓴다.
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
<iframe id="yt"
  src="https://www.youtube.com/embed/${link.videoId}?autoplay=1&playsinline=1&rel=0&fs=0&enablejsapi=1$start&origin=$_origin"
  allow="autoplay; encrypted-media"
  referrerpolicy="strict-origin-when-cross-origin"></iframe>
<script>
  var player = null;
  function onYouTubeIframeAPIReady() {
    player = new YT.Player('yt', {
      events: {
        onReady: function () { window.flutter_inappwebview.callHandler('ytReady'); },
        onStateChange: function (e) { window.flutter_inappwebview.callHandler('ytState', e.data); }
      }
    });
  }
  function moclAudio(volume, muted) {
    if (!player || !player.setVolume) return;
    player.setVolume(volume);
    if (muted) { player.mute(); } else { player.unMute(); }
  }
  function moclToggle() {
    if (!player || !player.getPlayerState) return;
    var s = player.getPlayerState();
    if (s === 1 || s === 3) { player.pauseVideo(); } else { player.playVideo(); }
  }
</script>
<script src="https://www.youtube.com/iframe_api"></script>
</body>
</html>''';
  }

  @override
  void dispose() {
    widget.playback
      ..audio.removeListener(_applyAudio)
      ..detach();
    super.dispose();
  }

  void _toggle() => _controller?.evaluateJavascript(source: 'moclToggle();');

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
      useShouldOverrideUrlLoading: true,
      transparentBackground: true,
    ),
    onWebViewCreated: (controller) {
      _controller = controller;
      controller
        ..addJavaScriptHandler(
          handlerName: 'ytReady',
          callback: (_) {
            _ready = true;
            _applyAudio();
            widget.playback.attach(_toggle);
          },
        )
        ..addJavaScriptHandler(
          handlerName: 'ytState',
          callback: (List<dynamic> args) {
            // 1 재생 중 · 3 버퍼링(재생하려는 중)
            final Object? state = args.firstOrNull;
            widget.playback.setPlaying(state == 1 || state == 3);
          },
        );
    },
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
