// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(SizeCacheDirNotifier)
const sizeCacheDirNotifierProvider = SizeCacheDirNotifierProvider._();

final class SizeCacheDirNotifierProvider
    extends $AsyncNotifierProvider<SizeCacheDirNotifier, String> {
  const SizeCacheDirNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sizeCacheDirNotifierProvider',
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
    r'63c1b98de62c53109f7da034622abca628cb5375';

abstract class _$SizeCacheDirNotifier extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ShowNickImageNotifier)
const showNickImageNotifierProvider = ShowNickImageNotifierProvider._();

final class ShowNickImageNotifierProvider
    extends $NotifierProvider<ShowNickImageNotifier, bool> {
  const ShowNickImageNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showNickImageNotifierProvider',
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
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
