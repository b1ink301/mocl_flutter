// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'media_player_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 앱 전체에서 하나뿐인 동영상 플레이어 상태. 없으면 null(플레이어 없음).

@ProviderFor(MediaPlayerNotifier)
final mediaPlayerProvider = MediaPlayerNotifierProvider._();

/// 앱 전체에서 하나뿐인 동영상 플레이어 상태. 없으면 null(플레이어 없음).
final class MediaPlayerNotifierProvider
    extends $NotifierProvider<MediaPlayerNotifier, MediaSession?> {
  /// 앱 전체에서 하나뿐인 동영상 플레이어 상태. 없으면 null(플레이어 없음).
  MediaPlayerNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mediaPlayerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mediaPlayerNotifierHash();

  @$internal
  @override
  MediaPlayerNotifier create() => MediaPlayerNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MediaSession? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MediaSession?>(value),
    );
  }
}

String _$mediaPlayerNotifierHash() =>
    r'd9fdde06086541dcd1334d8a08f2168d8fda069a';

/// 앱 전체에서 하나뿐인 동영상 플레이어 상태. 없으면 null(플레이어 없음).

abstract class _$MediaPlayerNotifier extends $Notifier<MediaSession?> {
  MediaSession? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MediaSession?, MediaSession?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MediaSession?, MediaSession?>,
              MediaSession?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(miniPlayerSizeStore)
final miniPlayerSizeStoreProvider = MiniPlayerSizeStoreProvider._();

final class MiniPlayerSizeStoreProvider
    extends
        $FunctionalProvider<
          MiniPlayerSizeStore,
          MiniPlayerSizeStore,
          MiniPlayerSizeStore
        >
    with $Provider<MiniPlayerSizeStore> {
  MiniPlayerSizeStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'miniPlayerSizeStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$miniPlayerSizeStoreHash();

  @$internal
  @override
  $ProviderElement<MiniPlayerSizeStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  MiniPlayerSizeStore create(Ref ref) {
    return miniPlayerSizeStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MiniPlayerSizeStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MiniPlayerSizeStore>(value),
    );
  }
}

String _$miniPlayerSizeStoreHash() =>
    r'c12ff8ad90d454cd3a39f18e13c91c4b8123d47f';

/// 사용자가 맞춘 미니 플레이어 폭(dp). 아직 안 맞췄으면 null(화면 폭에 따른 기본값).

@ProviderFor(MiniPlayerWidthNotifier)
final miniPlayerWidthProvider = MiniPlayerWidthNotifierProvider._();

/// 사용자가 맞춘 미니 플레이어 폭(dp). 아직 안 맞췄으면 null(화면 폭에 따른 기본값).
final class MiniPlayerWidthNotifierProvider
    extends $NotifierProvider<MiniPlayerWidthNotifier, double?> {
  /// 사용자가 맞춘 미니 플레이어 폭(dp). 아직 안 맞췄으면 null(화면 폭에 따른 기본값).
  MiniPlayerWidthNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'miniPlayerWidthProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$miniPlayerWidthNotifierHash();

  @$internal
  @override
  MiniPlayerWidthNotifier create() => MiniPlayerWidthNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double?>(value),
    );
  }
}

String _$miniPlayerWidthNotifierHash() =>
    r'356f7ef7c6b6ff3a115f87df7f22b9000e443c0b';

/// 사용자가 맞춘 미니 플레이어 폭(dp). 아직 안 맞췄으면 null(화면 폭에 따른 기본값).

abstract class _$MiniPlayerWidthNotifier extends $Notifier<double?> {
  double? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<double?, double?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double?, double?>,
              double?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(playerVolumeStore)
final playerVolumeStoreProvider = PlayerVolumeStoreProvider._();

final class PlayerVolumeStoreProvider
    extends
        $FunctionalProvider<
          PlayerVolumeStore,
          PlayerVolumeStore,
          PlayerVolumeStore
        >
    with $Provider<PlayerVolumeStore> {
  PlayerVolumeStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerVolumeStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerVolumeStoreHash();

  @$internal
  @override
  $ProviderElement<PlayerVolumeStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  PlayerVolumeStore create(Ref ref) {
    return playerVolumeStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlayerVolumeStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlayerVolumeStore>(value),
    );
  }
}

String _$playerVolumeStoreHash() => r'11d26c98e68272f8521f2fd39145361fd65a0458';

@ProviderFor(PlayerAudioNotifier)
final playerAudioProvider = PlayerAudioNotifierProvider._();

final class PlayerAudioNotifierProvider
    extends $NotifierProvider<PlayerAudioNotifier, PlayerAudio> {
  PlayerAudioNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'playerAudioProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$playerAudioNotifierHash();

  @$internal
  @override
  PlayerAudioNotifier create() => PlayerAudioNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PlayerAudio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PlayerAudio>(value),
    );
  }
}

String _$playerAudioNotifierHash() =>
    r'737ca019a88d24111d4e006e440560140700ead8';

abstract class _$PlayerAudioNotifier extends $Notifier<PlayerAudio> {
  PlayerAudio build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<PlayerAudio, PlayerAudio>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<PlayerAudio, PlayerAudio>,
              PlayerAudio,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
