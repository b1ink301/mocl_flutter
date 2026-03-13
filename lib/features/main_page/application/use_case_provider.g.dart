// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'use_case_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getMainList)
final getMainListProvider = GetMainListProvider._();

final class GetMainListProvider
    extends $FunctionalProvider<GetMainList, GetMainList, GetMainList>
    with $Provider<GetMainList> {
  GetMainListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getMainListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getMainListHash();

  @$internal
  @override
  $ProviderElement<GetMainList> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetMainList create(Ref ref) {
    return getMainList(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetMainList value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetMainList>(value),
    );
  }
}

String _$getMainListHash() => r'28994813c73d773f49afb893a5f2214c20f499e5';

@ProviderFor(setMainList)
final setMainListProvider = SetMainListProvider._();

final class SetMainListProvider
    extends $FunctionalProvider<SetMainList, SetMainList, SetMainList>
    with $Provider<SetMainList> {
  SetMainListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setMainListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setMainListHash();

  @$internal
  @override
  $ProviderElement<SetMainList> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SetMainList create(Ref ref) {
    return setMainList(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SetMainList value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SetMainList>(value),
    );
  }
}

String _$setMainListHash() => r'4432ed48bff99233be22afbbbc8423e81a224dee';
