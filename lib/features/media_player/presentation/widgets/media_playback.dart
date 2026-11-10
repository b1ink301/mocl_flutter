import 'package:flutter/foundation.dart';

/// 플레이어(유튜브 웹뷰 · 영상 파일)와 미니 창 버튼을 잇는 연결.
///
/// 플레이어가 재생 상태 · 화면 비율을 알려 주고, 미니 창의 재생/정지 버튼은
/// [toggle] 로 플레이어를 조작한다. 소리(볼륨 · 음소거)는 [audio] 를 플레이어가 듣고 적용한다.
final class MediaPlayback() extends ChangeNotifier {
  /// 플레이어에 적용할 소리. 값이 바뀌면 플레이어가 듣고 바로 반영한다.
  final ValueNotifier<({double volume, bool muted})> audio = ValueNotifier((
    volume: 1,
    muted: false,
  ));

  bool _playing = false;
  double? _aspectRatio;
  VoidCallback? _onToggle;
  bool _disposed = false;

  bool get playing => _playing;

  /// 알 수 없으면 null(유튜브는 16:9 로 본다).
  double? get aspectRatio => _aspectRatio;

  /// 재생/정지를 조작할 수 있는지(플레이어가 준비됐는지).
  bool get canToggle => _onToggle != null;

  void attach(VoidCallback onToggle) {
    _onToggle = onToggle;
    _notify();
  }

  void detach() {
    _onToggle = null;
    _playing = false;
  }

  void setPlaying(bool playing) {
    if (_playing == playing) return;
    _playing = playing;
    _notify();
  }

  void setAspectRatio(double ratio) {
    if (!ratio.isFinite || ratio <= 0 || _aspectRatio == ratio) return;
    _aspectRatio = ratio;
    _notify();
  }

  void toggle() => _onToggle?.call();

  // 세션을 바꾸면 옛 플레이어가 정리되기 전에 버려진다. 그 사이 웹뷰 콜백이 와도 괜찮게.
  void _notify() {
    if (!_disposed) notifyListeners();
  }

  @override
  void dispose() {
    _disposed = true;
    _onToggle = null;
    audio.dispose();
    super.dispose();
  }
}
