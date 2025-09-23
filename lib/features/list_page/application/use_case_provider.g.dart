// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'use_case_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getListUseCase)
const getListUseCaseProvider = GetListUseCaseProvider._();

final class GetListUseCaseProvider
    extends $FunctionalProvider<GetList, GetList, GetList>
    with $Provider<GetList> {
  const GetListUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getListUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getListUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetList> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetList create(Ref ref) {
    return getListUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetList value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetList>(value),
    );
  }
}

String _$getListUseCaseHash() => r'0b1601eb453b888fda5613b0f1ea0acc3c0438dd';

@ProviderFor(getSearchListUseCase)
const getSearchListUseCaseProvider = GetSearchListUseCaseProvider._();

final class GetSearchListUseCaseProvider
    extends $FunctionalProvider<GetSearchList, GetSearchList, GetSearchList>
    with $Provider<GetSearchList> {
  const GetSearchListUseCaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getSearchListUseCaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getSearchListUseCaseHash();

  @$internal
  @override
  $ProviderElement<GetSearchList> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetSearchList create(Ref ref) {
    return getSearchListUseCase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetSearchList value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetSearchList>(value),
    );
  }
}

String _$getSearchListUseCaseHash() =>
    r'80ca2c1c43405807af43089d50877c1090e8a9b3';
