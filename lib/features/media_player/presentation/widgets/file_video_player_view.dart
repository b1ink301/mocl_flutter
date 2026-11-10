import 'package:chewie/chewie.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_text.dart';
import 'package:mocl_flutter/core/util/utilities.dart';
import 'package:mocl_flutter/features/detail_page/domain/video_link_resolver.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_api.dart'
    show userAgentMobile;
import 'package:mocl_shared/util/mocl_logger.dart';
import 'package:video_player/video_player.dart';

import 'media_playback.dart';

/// mp4 · m3u8 같은 영상 파일을 video_player + chewie 로 재생한다.
///
/// 플레이어가 라우터 위 층에 있어 Navigator 가 없으므로 chewie 의 전체화면 ·
/// 옵션 메뉴(둘 다 Navigator 로 띄움)는 끈다. 전체화면은 앱의 "가로로 보기" 로 한다.
class const FileVideoPlayerView({
  super.key,
  required final DirectVideoLink link,
  required final MediaPlayback playback,
  final String? referer,
}) extends StatefulWidget {
  @override
  State<FileVideoPlayerView> createState() => _FileVideoPlayerViewState();
}

class _FileVideoPlayerViewState() extends State<FileVideoPlayerView> {
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
    )..addListener(_onVideoChanged);
    widget.playback.audio.addListener(_applyAudio);
    _initialize();
  }

  Future<void> _initialize() async {
    try {
      await _video.initialize();
      if (!mounted) return;
      _applyAudio();
      final double ratio = _video.value.aspectRatio;
      final double aspectRatio = ratio.isFinite && ratio > 0 ? ratio : 16 / 9;
      widget.playback
        ..setAspectRatio(aspectRatio)
        ..attach(_toggle);
      setState(
        () => _chewie = ChewieController(
          videoPlayerController: _video,
          autoPlay: true,
          looping: false,
          aspectRatio: aspectRatio,
          allowFullScreen: false,
          showOptions: false,
          allowPlaybackSpeedChanging: false,
          // 음소거는 앱 위쪽 바의 버튼 하나로 한다(chewie 버튼은 볼륨을 따로 바꿔 어긋난다).
          allowMuting: false,
        ),
      );
    } catch (e, st) {
      MoclLogger.w(() => '[video] 재생 실패 ${widget.link.url}: $e\n$st');
      if (mounted) setState(() => _failed = true);
    }
  }

  void _applyAudio() {
    if (!_video.value.isInitialized) return;
    final ({double volume, bool muted}) audio = widget.playback.audio.value;
    _video.setVolume(audio.muted ? 0 : audio.volume);
  }

  void _onVideoChanged() => widget.playback.setPlaying(_video.value.isPlaying);

  void _toggle() {
    if (_video.value.isPlaying) {
      _video.pause();
    } else {
      _video.play();
    }
  }

  @override
  void dispose() {
    widget.playback
      ..audio.removeListener(_applyAudio)
      ..detach();
    _video.removeListener(_onVideoChanged);
    _chewie?.dispose();
    _video.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return Center(
        child: Column(
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
        ),
      );
    }
    final ChewieController? chewie = _chewie;
    if (chewie == null) return const LoadingWidget();
    return Chewie(controller: chewie);
  }
}
