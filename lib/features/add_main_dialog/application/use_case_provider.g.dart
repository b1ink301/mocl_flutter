// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'use_case_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getMainListFromJson)
final getMainListFromJsonProvider = GetMainListFromJsonProvider._();

final class GetMainListFromJsonProvider
    extends
        $FunctionalProvider<
          GetMainListFromJson,
          GetMainListFromJson,
          GetMainListFromJson
        >
    with $Provider<GetMainListFromJson> {
  GetMainListFromJsonProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getMainListFromJsonProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getMainListFromJsonHash();

  @$internal
  @override
  $ProviderElement<GetMainListFromJson> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GetMainListFromJson create(Ref ref) {
    return getMainListFromJson(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetMainListFromJson value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetMainListFromJson>(value),
    );
  }
}

String _$getMainListFromJsonHash() =>
    r'f87b5b6e91136d65bf2f8c9f4c4e07a6b3cd4df2';
