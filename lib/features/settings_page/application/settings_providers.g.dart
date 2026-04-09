// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(SizeCacheDirNotifier)
final sizeCacheDirProvider = SizeCacheDirNotifierProvider._();

final class SizeCacheDirNotifierProvider
    extends $AsyncNotifierProvider<SizeCacheDirNotifier, String> {
  SizeCacheDirNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sizeCacheDirProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sizeCacheDirNotifierHash();

  @$internal
  @override
  SizeCacheDirNotifier create() => SizeCacheDirNotifier();
}

String _$sizeCacheDirNotifierHash() =>
    r'f77b6a8dc60410542c39d9ee978a6847d3a88f0e';

abstract class _$SizeCacheDirNotifier extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(ShowNickImageNotifier)
final showNickImageProvider = ShowNickImageNotifierProvider._();

final class ShowNickImageNotifierProvider
    extends $NotifierProvider<ShowNickImageNotifier, bool> {
  ShowNickImageNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showNickImageProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showNickImageNotifierHash();

  @$internal
  @override
  ShowNickImageNotifier create() => ShowNickImageNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showNickImageNotifierHash() =>
    r'df73e91263c595ab4d2f898c1e71e19bf156f842';

abstract class _$ShowNickImageNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
