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
    r'9fcb8b122942cd89e86c0efc876f798902095587';

abstract class _$SizeCacheDirNotifier extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
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
        isAutoDispose: false,
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
    r'fc6dc85a955b55f366a00d166c0886aaada8624d';

abstract class _$ShowNickImageNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
