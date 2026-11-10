import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/media_player_provider.dart';

/// 동영상 플레이어 조작. 위젯은 provider 대신 이 mixin 을 쓴다.
mixin class MediaPlayerEvent() {
  void minimizePlayer(WidgetRef ref) =>
      ref.read(mediaPlayerProvider.notifier).minimize();

  void expandPlayer(WidgetRef ref) =>
      ref.read(mediaPlayerProvider.notifier).expand();

  void togglePlayerLandscape(WidgetRef ref) =>
      ref.read(mediaPlayerProvider.notifier).toggleLandscape();

  void closePlayer(WidgetRef ref) =>
      ref.read(mediaPlayerProvider.notifier).close();

  /// 두 손가락으로 맞춘 미니 플레이어 폭(dp)을 기억한다.
  void saveMiniPlayerWidth(WidgetRef ref, double width) =>
      ref.read(miniPlayerWidthProvider.notifier).save(width);

  /// 플레이어 볼륨(0~1). 슬라이더를 끄는 동안은 [save] 를 false 로 두고 놓을 때 저장한다.
  void setPlayerVolume(WidgetRef ref, double volume, {bool save = true}) =>
      ref.read(playerAudioProvider.notifier).setVolume(volume, save: save);

  void togglePlayerMute(WidgetRef ref) =>
      ref.read(playerAudioProvider.notifier).toggleMute();
}
