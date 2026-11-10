import 'package:mocl_flutter/features/detail_page/domain/video_link_resolver.dart';
import 'package:mocl_flutter/features/settings_page/application/datasource_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../data/mini_player_size_store.dart';
import '../data/player_volume_store.dart';
import '../domain/media_session.dart';

part 'media_player_provider.g.dart';

/// 앱 전체에서 하나뿐인 동영상 플레이어 상태. 없으면 null(플레이어 없음).
@Riverpod(keepAlive: true)
class MediaPlayerNotifier() extends _$MediaPlayerNotifier {
  int _nextId = 0;

  @override
  MediaSession? build() => null;

  /// 새 영상을 펼친 상태로 연다. 재생 중이던 영상은 닫는다(동시에 하나).
  void open(VideoLink link, {String? referer}) =>
      state = MediaSession(id: _nextId++, link: link, referer: referer);

  /// 미니 창으로 접는다. 가로 보기도 끈다.
  void minimize() {
    final MediaSession? session = state;
    if (session == null || !session.expanded) return;
    state = session.copyWith(expanded: false, landscape: false);
  }

  void expand() {
    final MediaSession? session = state;
    if (session == null || session.expanded) return;
    state = session.copyWith(expanded: true);
  }

  /// 가로로 보기 ↔ 세로. 펼친 상태에서만.
  void toggleLandscape() {
    final MediaSession? session = state;
    if (session == null || !session.expanded) return;
    state = session.copyWith(landscape: !session.landscape);
  }

  void close() => state = null;
}

@Riverpod(keepAlive: true)
MiniPlayerSizeStore miniPlayerSizeStore(Ref ref) =>
    MiniPlayerSizeStore(ref.watch(sharedPreferencesProvider));

/// 사용자가 맞춘 미니 플레이어 폭(dp). 아직 안 맞췄으면 null(화면 폭에 따른 기본값).
@Riverpod(keepAlive: true)
class MiniPlayerWidthNotifier() extends _$MiniPlayerWidthNotifier {
  @override
  double? build() => ref.watch(miniPlayerSizeStoreProvider).load();

  void save(double width) {
    if (state == width) return;
    state = width;
    ref.read(miniPlayerSizeStoreProvider).save(width);
  }
}

@Riverpod(keepAlive: true)
PlayerVolumeStore playerVolumeStore(Ref ref) =>
    PlayerVolumeStore(ref.watch(sharedPreferencesProvider));

/// 플레이어 소리. 볼륨(0~1)은 저장하고, 음소거는 앱이 떠 있는 동안만 둔다.
typedef PlayerAudio = ({double volume, bool muted});

@Riverpod(keepAlive: true)
class PlayerAudioNotifier() extends _$PlayerAudioNotifier {
  @override
  PlayerAudio build() =>
      (volume: ref.watch(playerVolumeStoreProvider).load(), muted: false);

  /// 볼륨을 바꾸면 음소거는 풀린다. 끄는 동안(슬라이더를 끄는 중)은 [save] 를 false 로.
  void setVolume(double volume, {bool save = true}) {
    final double v = volume.clamp(0, 1);
    state = (volume: v, muted: false);
    if (save) ref.read(playerVolumeStoreProvider).save(v);
  }

  /// 음소거 ↔ 해제. 볼륨이 0 인데 해제하면 들리게 볼륨을 조금 올린다.
  void toggleMute() {
    final PlayerAudio audio = state;
    if (audio.muted || audio.volume == 0) {
      setVolume(audio.volume == 0 ? 0.5 : audio.volume);
    } else {
      state = (volume: audio.volume, muted: true);
    }
  }
}
