// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_config_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 이번 실행에서 쓰는 원격 설정. `main.dart` 가 부팅 때 저장소에서 읽어 덮어쓴다.
///
/// 실행 중에는 바뀌지 않는다. 새로 받은 설정은 다음 실행부터 적용된다 —
/// 실행 중에 사이트 UA 를 바꾸면 이미 만든 클라이언트 · 쿠키와 어긋날 수 있다.

@ProviderFor(remoteConfig)
final remoteConfigProvider = RemoteConfigProvider._();

/// 이번 실행에서 쓰는 원격 설정. `main.dart` 가 부팅 때 저장소에서 읽어 덮어쓴다.
///
/// 실행 중에는 바뀌지 않는다. 새로 받은 설정은 다음 실행부터 적용된다 —
/// 실행 중에 사이트 UA 를 바꾸면 이미 만든 클라이언트 · 쿠키와 어긋날 수 있다.

final class RemoteConfigProvider
    extends $FunctionalProvider<RemoteConfig, RemoteConfig, RemoteConfig>
    with $Provider<RemoteConfig> {
  /// 이번 실행에서 쓰는 원격 설정. `main.dart` 가 부팅 때 저장소에서 읽어 덮어쓴다.
  ///
  /// 실행 중에는 바뀌지 않는다. 새로 받은 설정은 다음 실행부터 적용된다 —
  /// 실행 중에 사이트 UA 를 바꾸면 이미 만든 클라이언트 · 쿠키와 어긋날 수 있다.
  RemoteConfigProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'remoteConfigProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$remoteConfigHash();

  @$internal
  @override
  $ProviderElement<RemoteConfig> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  RemoteConfig create(Ref ref) {
    return remoteConfig(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RemoteConfig value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RemoteConfig>(value),
    );
  }
}

String _$remoteConfigHash() => r'a0b8734de482072becd3895bf8ff7e6af70f2ee7';
