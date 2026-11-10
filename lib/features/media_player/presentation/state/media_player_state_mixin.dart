import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/media_player_provider.dart';
import '../../domain/media_session.dart';

/// 동영상 플레이어 상태 조회. 위젯은 provider 대신 이 mixin 을 쓴다.
mixin class MediaPlayerState() {
  MediaSession? mediaSessionState(WidgetRef ref) =>
      ref.watch(mediaPlayerProvider);

  /// 세션이 바뀔 때(열기 · 접기 · 가로 보기 · 닫기) 부른다. build 안에서만.
  void listenMediaSession(
    WidgetRef ref,
    void Function(MediaSession? previous, MediaSession? next) listener,
  ) => ref.listen<MediaSession?>(mediaPlayerProvider, listener);

  /// 사용자가 맞춘 미니 플레이어 폭(dp). 없으면 null.
  double? miniPlayerWidthState(WidgetRef ref) =>
      ref.watch(miniPlayerWidthProvider);

  /// 플레이어 소리(볼륨 · 음소거).
  PlayerAudio playerAudioState(WidgetRef ref) => ref.watch(playerAudioProvider);
}
