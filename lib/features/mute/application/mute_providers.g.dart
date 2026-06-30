// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mute_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(muteRepository)
final muteRepositoryProvider = MuteRepositoryProvider._();

final class MuteRepositoryProvider
    extends $FunctionalProvider<MuteRepository, MuteRepository, MuteRepository>
    with $Provider<MuteRepository> {
  MuteRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'muteRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$muteRepositoryHash();

  @$internal
  @override
  $ProviderElement<MuteRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MuteRepository create(Ref ref) {
    return muteRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MuteRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MuteRepository>(value),
    );
  }
}

String _$muteRepositoryHash() => r'2a68a77ab05f774e4886dd5d976e055e2aae1464';

/// 전역 뮤트 규칙 목록. 리스트 빌드 시 watch 되어, 규칙이 바뀌면
/// 리스트가 재생성되며 필터가 다시 적용된다.

@ProviderFor(MuteRulesNotifier)
final muteRulesProvider = MuteRulesNotifierProvider._();

/// 전역 뮤트 규칙 목록. 리스트 빌드 시 watch 되어, 규칙이 바뀌면
/// 리스트가 재생성되며 필터가 다시 적용된다.
final class MuteRulesNotifierProvider
    extends $AsyncNotifierProvider<MuteRulesNotifier, List<MuteRule>> {
  /// 전역 뮤트 규칙 목록. 리스트 빌드 시 watch 되어, 규칙이 바뀌면
  /// 리스트가 재생성되며 필터가 다시 적용된다.
  MuteRulesNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'muteRulesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$muteRulesNotifierHash();

  @$internal
  @override
  MuteRulesNotifier create() => MuteRulesNotifier();
}

String _$muteRulesNotifierHash() => r'4139476a6221f5d89494fb94d8fc80bfe43fb466';

/// 전역 뮤트 규칙 목록. 리스트 빌드 시 watch 되어, 규칙이 바뀌면
/// 리스트가 재생성되며 필터가 다시 적용된다.

abstract class _$MuteRulesNotifier extends $AsyncNotifier<List<MuteRule>> {
  FutureOr<List<MuteRule>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<List<MuteRule>>, List<MuteRule>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<MuteRule>>, List<MuteRule>>,
              AsyncValue<List<MuteRule>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
