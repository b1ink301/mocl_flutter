import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/util/orientation_policy.dart';
import 'package:mocl_flutter/core/util/utilities.dart';
import 'package:mocl_flutter/features/detail_page/domain/video_link_resolver.dart';
import 'package:url_launcher/url_launcher.dart';

import '../domain/media_session.dart';
import 'state/media_player_event_mixin.dart';
import 'state/media_player_state_mixin.dart';
import 'widgets/file_video_player_view.dart';
import 'widgets/media_playback.dart';
import 'widgets/youtube_player_view.dart';

/// 앱 화면(라우터) 위 한 층에 동영상 플레이어를 띄운다. `MaterialApp.router` 의 builder 에서 감싼다.
///
/// 플레이어를 라우트로 두면 뒤로 가는 순간 재생이 끝나서, 게시판을 보며 영상을 볼 수 없다.
/// 여기서는 펼침(화면 전체) ↔ 미니(떠 있는 작은 창)를 **같은 위젯의 크기 · 위치만** 바꿔서
/// 오간다. 웹뷰 · ExoPlayer 같은 플랫폼 뷰는 다른 부모로 옮기면 다시 만들어져 재생이 끊긴다.
///
/// 펼친 동안은 Navigator 에 보이지 않는 라우트(`_GuardRoute`)를 하나 얹는다. 뒤로가기 버튼 ·
/// 시스템 뒤로가기 제스처가 아래 화면을 닫지 않고 이 라우트를 닫게 하고, 닫히면 미니로 접는다.
class const MediaPlayerHost({
  super.key,
  required final GlobalKey<NavigatorState> navigatorKey,
  required final Widget child,
}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<MediaPlayerHost> createState() => _MediaPlayerHostState();
}

class _MediaPlayerHostState()
    extends ConsumerState<MediaPlayerHost>
    with MediaPlayerState, MediaPlayerEvent {
  // 라우터 위라 Navigator 의 Overlay 를 쓸 수 없다. 툴팁 등이 쓸 Overlay 를 따로 둔다.
  // 빈 곳은 터치를 받지 않아 아래 앱 화면으로 그대로 간다.
  final OverlayEntry _entry = OverlayEntry(
    builder: (_) => const _PlayerLayer(),
  );

  Route<void>? _guard;

  void _onSessionChanged(MediaSession? previous, MediaSession? next) {
    final bool wasLandscape = previous?.landscape ?? false;
    final bool landscape = next?.landscape ?? false;
    if (wasLandscape != landscape) {
      OrientationPolicy.instance.setLandscapeOverride(landscape);
    }

    final bool expanded = next?.expanded ?? false;
    if (expanded && _guard == null) {
      _pushGuard();
    } else if (!expanded && _guard != null) {
      _removeGuard();
    }
  }

  void _pushGuard() {
    final NavigatorState? navigator = widget.navigatorKey.currentState;
    if (navigator == null) return;
    final _GuardRoute route = _GuardRoute();
    _guard = route;
    navigator.push(route).then((_) {
      // 뒤로가기로 닫혔다(접기 버튼 등으로 이쪽에서 치운 경우는 _guard 가 이미 비어 있다).
      if (!mounted || !identical(_guard, route)) return;
      _guard = null;
      minimizePlayer(ref);
    });
  }

  void _removeGuard() {
    final Route<void>? route = _guard;
    _guard = null;
    if (route != null && route.isActive) route.navigator?.removeRoute(route);
  }

  @override
  Widget build(BuildContext context) {
    listenMediaSession(ref, _onSessionChanged);
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        Positioned.fill(child: Overlay(initialEntries: [_entry])),
      ],
    );
  }
}

/// 펼친 플레이어 아래에 얹는 보이지 않는 라우트. 뒤로가기를 받아 미니로 접는 데만 쓴다.
/// 테마의 전환(예측형 뒤로가기)을 타지 않게 [PageRouteBuilder] 로 만든다.
final class _GuardRoute() extends PageRouteBuilder<void> {
  this
    : super(
        settings: const RouteSettings(name: 'media_player'),
        opaque: false,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
        pageBuilder: (_, _, _) => const SizedBox.shrink(),
      );
}

// ─────────────────────────────────────────────────────────────────────────────
// 플레이어 층
// ─────────────────────────────────────────────────────────────────────────────

const Duration _kAnim = Duration(milliseconds: 220);

/// 펼친 상태의 위쪽 바 높이.
const double _kBarHeight = 52;

/// 미니 창을 처음 놓을 때 화면 아래에서 비워 둘 높이(떠 있는 탭바 · 상세 아래 바).
const double _kBottomClearance = 84;

/// 미니 창과 화면 가장자리 사이.
const double _kMiniMargin = 10;

/// 두 손가락으로 줄일 수 있는 미니 창 최소 폭 · 늘릴 수 있는 최대 폭(dp).
const double _kMiniMinWidth = 140;
const double _kMiniMaxWidth = 640;

class const _PlayerLayer() extends ConsumerStatefulWidget {
  @override
  ConsumerState<_PlayerLayer> createState() => _PlayerLayerState();
}

class _PlayerLayerState()
    extends ConsumerState<_PlayerLayer>
    with MediaPlayerState, MediaPlayerEvent {
  MediaPlayback? _playback;
  int? _sessionId;

  /// 미니 창 왼쪽 위. null 이면 오른쪽 아래 기본 자리.
  Offset? _miniOffset;
  bool _dragging = false;

  /// 음량 슬라이더를 보이는지(펼친 상태에서 음량 버튼으로 켠다). 만지지 않으면 잠시 뒤 닫힌다.
  bool _showVolume = false;
  Timer? _volumeHideTimer;

  /// 두 손가락으로 크기를 바꾸는 중의 폭. 손을 떼면 저장하고 비운다.
  double? _pinchWidth;

  /// 이번 제스처에서 크기를 바꿨는지(바꿨으면 던져 닫기를 하지 않는다).
  bool _scaled = false;

  // 제스처 기준점. 손가락 수가 바뀌면 그 순간으로 다시 잡는다
  // (두 번째 손가락이 닿으면 scale 기준 · 중심점이 새로 시작된다).
  Rect _gestureStartRect = Rect.zero;
  Offset _gestureStartFocal = Offset.zero;
  int _gesturePointers = 0;

  @override
  void dispose() {
    _volumeHideTimer?.cancel();
    _playback?.dispose();
    super.dispose();
  }

  void _toggleVolumeSlider() {
    setState(() => _showVolume = !_showVolume);
    _scheduleVolumeHide();
  }

  void _scheduleVolumeHide() {
    _volumeHideTimer?.cancel();
    if (!_showVolume) return;
    _volumeHideTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) setState(() => _showVolume = false);
    });
  }

  MediaPlayback _playbackFor(MediaSession session) {
    final MediaPlayback? current = _playback;
    if (current != null && _sessionId == session.id) return current;
    current?.dispose();
    _sessionId = session.id;
    return _playback = MediaPlayback();
  }

  @override
  Widget build(BuildContext context) {
    final MediaSession? session = mediaSessionState(ref);
    if (session == null) {
      if (_playback != null) {
        _playback!.dispose();
        _playback = null;
        _sessionId = null;
      }
      return const SizedBox.shrink();
    }
    final MediaPlayback playback = _playbackFor(session);
    // 플레이어가 듣고 바로 적용한다(같은 값이면 알리지 않는다).
    playback.audio.value = playerAudioState(ref);
    if (!session.expanded) _showVolume = false;
    return ListenableBuilder(
      listenable: playback,
      builder: (context, _) => LayoutBuilder(
        builder: (context, constraints) =>
            _buildLayer(context, session, playback, constraints.biggest),
      ),
    );
  }

  Widget _buildLayer(
    BuildContext context,
    MediaSession session,
    MediaPlayback playback,
    Size size,
  ) {
    final EdgeInsets pad = MediaQuery.paddingOf(context);
    final bool expanded = session.expanded;
    final bool landscape = session.landscape;
    final double? savedWidth = miniPlayerWidthState(ref);
    final Rect miniRect = _miniRect(
      size,
      pad,
      playback.aspectRatio,
      savedWidth,
    );
    final Rect playerRect = !expanded
        ? miniRect
        : landscape
        ? Rect.fromLTRB(pad.left, 0, size.width - pad.right, size.height)
        : Rect.fromLTRB(
            pad.left,
            pad.top + _kBarHeight,
            size.width - pad.right,
            size.height - pad.bottom,
          );
    final Duration duration = _dragging ? Duration.zero : _kAnim;
    final ({double volume, bool muted}) audio = playback.audio.value;
    final bool showVolume = expanded && _showVolume;

    // 자식 순서 · 종류를 모드와 상관없이 고정한다. 바뀌면 플레이어가 다시 만들어진다.
    return Stack(
      fit: StackFit.expand,
      children: [
        // 펼쳤을 때 아래 앱 화면을 가리고 터치를 막는다. 아래로 휙 끌면 접는다.
        Positioned.fill(
          key: const ValueKey('media_backdrop'),
          child: IgnorePointer(
            ignoring: !expanded,
            child: AnimatedOpacity(
              opacity: expanded ? 1 : 0,
              duration: _kAnim,
              child: AnnotatedRegion<SystemUiOverlayStyle>(
                value: SystemUiOverlayStyle.light,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onVerticalDragEnd: (details) {
                    if ((details.primaryVelocity ?? 0) > 600) {
                      minimizePlayer(ref);
                    }
                  },
                  child: const ColoredBox(color: Colors.black),
                ),
              ),
            ),
          ),
        ),
        AnimatedPositioned.fromRect(
          key: const ValueKey('media_player'),
          rect: playerRect,
          duration: duration,
          curve: Curves.easeOutCubic,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(expanded ? 0 : 10),
              boxShadow: expanded
                  ? const []
                  : const [
                      BoxShadow(
                        color: Color(0x66000000),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(expanded ? 0 : 10),
              child: ColoredBox(
                color: Colors.black,
                // 미니에서는 플레이어 조작 대신 창 끌기 · 탭(펼치기)을 받는다.
                child: IgnorePointer(
                  ignoring: !expanded,
                  child: KeyedSubtree(
                    key: ValueKey(session.id),
                    child: _player(session, playback),
                  ),
                ),
              ),
            ),
          ),
        ),
        AnimatedPositioned.fromRect(
          key: const ValueKey('media_mini_controls'),
          rect: playerRect,
          duration: duration,
          curve: Curves.easeOutCubic,
          child: IgnorePointer(
            ignoring: expanded,
            child: AnimatedOpacity(
              opacity: expanded ? 0 : 1,
              duration: _kAnim,
              child: _MiniControls(
                playback: playback,
                onTap: () => expandPlayer(ref),
                onClose: () => closePlayer(ref),
                onScaleStart: (details) => setState(() {
                  _dragging = true;
                  _scaled = false;
                  _miniOffset = miniRect.topLeft;
                  _gestureStartRect = miniRect;
                  _gestureStartFocal = details.focalPoint;
                  _gesturePointers = details.pointerCount;
                }),
                onScaleUpdate: (details) => _onMiniScaleUpdate(
                  details,
                  size,
                  pad,
                  playback.aspectRatio,
                  savedWidth,
                ),
                onScaleEnd: (details) =>
                    _onMiniScaleEnd(size, pad, details.velocity, savedWidth),
              ),
            ),
          ),
        ),
        Positioned(
          key: const ValueKey('media_bar'),
          top: landscape ? 8 : pad.top,
          left: landscape ? null : pad.left,
          right: landscape ? pad.right + 8 : pad.right,
          height: _kBarHeight,
          child: IgnorePointer(
            ignoring: !expanded,
            child: AnimatedOpacity(
              opacity: expanded ? 1 : 0,
              duration: _kAnim,
              child: _ExpandedBar(
                link: session.link,
                landscape: landscape,
                silent: audio.muted || audio.volume == 0,
                onToggleMute: () => togglePlayerMute(ref),
                onToggleVolume: _toggleVolumeSlider,
                onMinimize: () => minimizePlayer(ref),
                onToggleLandscape: () => togglePlayerLandscape(ref),
                onClose: () => closePlayer(ref),
              ),
            ),
          ),
        ),
        Positioned(
          key: const ValueKey('media_volume'),
          top: (landscape ? 8 : pad.top) + _kBarHeight + 4,
          right: pad.right + 8,
          child: IgnorePointer(
            ignoring: !showVolume,
            child: AnimatedOpacity(
              opacity: showVolume ? 1 : 0,
              duration: _kAnim,
              child: _VolumePanel(
                volume: audio.muted ? 0 : audio.volume,
                onChanged: (v) {
                  setPlayerVolume(ref, v, save: false);
                  _scheduleVolumeHide();
                },
                onChangeEnd: (v) => setPlayerVolume(ref, v),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _player(MediaSession session, MediaPlayback playback) =>
      switch (session.link) {
        final YouTubeLink link => YouTubePlayerView(
          link: link,
          playback: playback,
        ),
        final DirectVideoLink link => FileVideoPlayerView(
          link: link,
          playback: playback,
          referer: session.referer,
        ),
      };

  /// 미니 창 폭 · 높이. 사용자가 맞춘 폭(없으면 화면 폭에 따른 기본값)을
  /// 화면 안에 들어가게 줄인다.
  Size _miniSize(
    Size size,
    EdgeInsets pad,
    double? aspectRatio,
    double? savedWidth,
  ) {
    final double ratio = (aspectRatio ?? 16 / 9).clamp(0.75, 2.0);
    final double defaultWidth = (size.width * (size.width >= 600 ? 0.32 : 0.46))
        .clamp(160, 360);
    final double maxWidth = [
      _kMiniMaxWidth,
      size.width - pad.horizontal - _kMiniMargin * 2,
      (size.height - pad.vertical - _kMiniMargin * 2) * ratio,
    ].reduce((a, b) => a < b ? a : b);
    final double width = (_pinchWidth ?? savedWidth ?? defaultWidth).clamp(
      _kMiniMinWidth,
      maxWidth < _kMiniMinWidth ? _kMiniMinWidth : maxWidth,
    );
    return Size(width, width / ratio);
  }

  /// 미니 창 자리. 화면 밖으로 나가지 않게 가둔다.
  Rect _miniRect(
    Size size,
    EdgeInsets pad,
    double? aspectRatio,
    double? savedWidth,
  ) {
    final Size mini = _miniSize(size, pad, aspectRatio, savedWidth);
    final double width = mini.width;
    final double height = mini.height;
    final double minX = pad.left + _kMiniMargin;
    final double maxX = size.width - pad.right - _kMiniMargin - width;
    final double minY = pad.top + _kMiniMargin;
    final double maxY = size.height - pad.bottom - _kMiniMargin - height;
    final Offset origin =
        _miniOffset ??
        Offset(maxX, size.height - pad.bottom - _kBottomClearance - height);
    return Rect.fromLTWH(
      origin.dx.clamp(minX, maxX < minX ? minX : maxX),
      origin.dy.clamp(minY, maxY < minY ? minY : maxY),
      width,
      height,
    );
  }

  /// 한 손가락: 옮기기. 두 손가락: 크기 바꾸기(창 가운데가 손가락 중심을 따라간다).
  void _onMiniScaleUpdate(
    ScaleUpdateDetails details,
    Size size,
    EdgeInsets pad,
    double? aspectRatio,
    double? savedWidth,
  ) {
    if (details.pointerCount != _gesturePointers) {
      // 손가락이 더해지거나 빠졌다. 지금 자리 · 크기를 새 기준으로.
      _gesturePointers = details.pointerCount;
      _gestureStartRect = _miniRect(size, pad, aspectRatio, savedWidth);
      _gestureStartFocal = details.focalPoint;
      return;
    }
    setState(() {
      if (details.pointerCount >= 2) {
        _scaled = true;
        _pinchWidth = _gestureStartRect.width * details.scale;
        final Size mini = _miniSize(size, pad, aspectRatio, savedWidth);
        final Offset center =
            _gestureStartRect.center +
            (details.focalPoint - _gestureStartFocal);
        _miniOffset = center - Offset(mini.width / 2, mini.height / 2);
      } else {
        _miniOffset =
            (_miniOffset ?? _gestureStartRect.topLeft) +
            details.focalPointDelta;
      }
    });
  }

  void _onMiniScaleEnd(
    Size size,
    EdgeInsets pad,
    Velocity velocity,
    double? savedWidth,
  ) {
    if (_scaled) {
      final double width = _miniSize(
        size,
        pad,
        _playback?.aspectRatio,
        savedWidth,
      ).width;
      _pinchWidth = null;
      saveMiniPlayerWidth(ref, width);
      // 크기를 바꾼 뒤에는 던지기로 보지 않는다(손을 떼는 순간 속도가 튄다).
      _onMiniDragEnd(size, pad, Velocity.zero, width);
      return;
    }
    _onMiniDragEnd(size, pad, velocity, savedWidth);
  }

  /// 놓으면 가까운(또는 던진 쪽) 옆 가장자리로 붙는다. 아래로 세게 던지면 닫는다.
  void _onMiniDragEnd(
    Size size,
    EdgeInsets pad,
    Velocity velocity,
    double? savedWidth,
  ) {
    final Offset v = velocity.pixelsPerSecond;
    if (v.dy > 1600 && v.dy > v.dx.abs()) {
      setState(() {
        _dragging = false;
        _miniOffset = null;
      });
      closePlayer(ref);
      return;
    }
    final Offset offset = _miniOffset ?? Offset.zero;
    final Rect rect = _miniRect(size, pad, _playback?.aspectRatio, savedWidth);
    final bool toRight = v.dx.abs() > 800
        ? v.dx > 0
        : rect.center.dx > size.width / 2;
    setState(() {
      _dragging = false;
      _miniOffset = Offset(
        toRight ? double.infinity : double.negativeInfinity,
        // 던진 만큼 조금 더 가게 한다.
        offset.dy + v.dy * 0.08,
      );
    });
  }
}

/// 미니 창 위 터치 층: 탭 → 펼치기, 끌기 → 옮기기, 두 손가락 → 크기, ✕ · 재생/정지 버튼.
class const _MiniControls({
  required final MediaPlayback playback,
  required final VoidCallback onTap,
  required final VoidCallback onClose,
  required final GestureScaleStartCallback onScaleStart,
  required final GestureScaleUpdateCallback onScaleUpdate,
  required final GestureScaleEndCallback onScaleEnd,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Semantics(
    identifier: 'media_mini',
    label: '동영상 미니 플레이어, 눌러서 크게 보기',
    button: true,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      // scale 은 한 손가락 끌기도 받는다(pan 과 같이 쓸 수 없다).
      onScaleStart: onScaleStart,
      onScaleUpdate: onScaleUpdate,
      onScaleEnd: onScaleEnd,
      child: Stack(
        children: [
          Positioned(
            top: 4,
            right: 4,
            child: _RoundButton(
              icon: Icons.close,
              label: '닫기',
              semanticsId: 'media_mini_close',
              onPressed: onClose,
            ),
          ),
          if (playback.canToggle)
            Positioned(
              left: 4,
              bottom: 4,
              child: _RoundButton(
                icon: playback.playing ? Icons.pause : Icons.play_arrow,
                label: playback.playing ? '일시 정지' : '재생',
                semanticsId: 'media_mini_play',
                onPressed: playback.toggle,
              ),
            ),
        ],
      ),
    ),
  );
}

class const _RoundButton({
  required final IconData icon,
  required final String label,
  required final String semanticsId,
  required final VoidCallback onPressed,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Semantics(
    identifier: semanticsId,
    label: label,
    button: true,
    excludeSemantics: true,
    child: GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: Color(0x8C000000),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 20, color: Colors.white),
      ),
    ),
  );
}

/// 펼친 플레이어 위쪽 버튼들. 가로 보기 중에는 오른쪽 위에 작게 겹쳐 놓는다.
class const _ExpandedBar({
  required final VideoLink link,
  required final bool landscape,

  /// 음소거이거나 볼륨 0.
  required final bool silent,
  required final VoidCallback onToggleMute,
  required final VoidCallback onToggleVolume,
  required final VoidCallback onMinimize,
  required final VoidCallback onToggleLandscape,
  required final VoidCallback onClose,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<Widget> buttons = [
      _barButton(
        icon: silent ? Icons.volume_off : Icons.volume_up,
        tooltip: silent ? '소리 켜기' : '음소거',
        semanticsId: 'media_mute',
        onPressed: onToggleMute,
      ),
      _barButton(
        icon: Icons.tune,
        tooltip: '음량 조절',
        semanticsId: 'media_volume',
        onPressed: onToggleVolume,
      ),
      _barButton(
        icon: landscape
            ? Icons.stay_current_portrait
            : Icons.stay_current_landscape,
        tooltip: landscape ? '세로로 보기' : '가로로 보기',
        semanticsId: 'media_landscape',
        onPressed: onToggleLandscape,
      ),
      if (!landscape)
        _barButton(
          icon: Icons.open_in_new,
          tooltip: '브라우저로 열기',
          semanticsId: 'media_open_external',
          onPressed: () => _openExternally(link),
        ),
      _barButton(
        icon: Icons.close,
        tooltip: '닫기',
        semanticsId: 'media_close',
        onPressed: onClose,
      ),
    ];
    final Widget minimize = _barButton(
      icon: Icons.keyboard_arrow_down,
      tooltip: '작게 보기',
      semanticsId: 'media_minimize',
      onPressed: onMinimize,
    );

    return Material(
      type: MaterialType.transparency,
      child: IconTheme(
        data: const IconThemeData(color: Colors.white),
        child: landscape
            ? DecoratedBox(
                decoration: BoxDecoration(
                  color: const Color(0x73000000),
                  borderRadius: BorderRadius.circular(_kBarHeight / 2),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [minimize, ...buttons],
                ),
              )
            : Row(children: [minimize, const Spacer(), ...buttons]),
      ),
    );
  }

  static Widget _barButton({
    required IconData icon,
    required String tooltip,
    required String semanticsId,
    required VoidCallback onPressed,
  }) => Semantics(
    identifier: semanticsId,
    child: IconButton(
      tooltip: tooltip,
      color: Colors.white,
      icon: Icon(icon),
      onPressed: onPressed,
    ),
  );

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

/// 음량 슬라이더(0~100%). 기기 볼륨 안에서 영상 소리만 바꾼다.
class const _VolumePanel({
  required final double volume,
  required final ValueChanged<double> onChanged,
  required final ValueChanged<double> onChangeEnd,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Semantics(
    identifier: 'media_volume_slider',
    child: Material(
      type: MaterialType.transparency,
      child: Container(
        padding: const EdgeInsets.only(left: 4, right: 14),
        decoration: BoxDecoration(
          color: const Color(0xB3000000),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 180,
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  activeTrackColor: Colors.white,
                  inactiveTrackColor: const Color(0x4DFFFFFF),
                  thumbColor: Colors.white,
                  overlayColor: const Color(0x29FFFFFF),
                ),
                child: Slider(
                  value: volume,
                  onChanged: onChanged,
                  onChangeEnd: onChangeEnd,
                  semanticFormatterCallback: (v) => '음량 ${(v * 100).round()}%',
                ),
              ),
            ),
            SizedBox(
              width: 40,
              child: Text(
                '${(volume * 100).round()}%',
                textAlign: TextAlign.end,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
