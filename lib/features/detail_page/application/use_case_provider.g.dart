// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'use_case_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getDetail)
const getDetailProvider = GetDetailProvider._();

final class GetDetailProvider
    extends $FunctionalProvider<GetDetail, GetDetail, GetDetail>
    with $Provider<GetDetail> {
  const GetDetailProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'getDetailProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$getDetailHash();

  @$internal
  @override
  $ProviderElement<GetDetail> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetDetail create(Ref ref) {
    return getDetail(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetDetail value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetDetail>(value),
    );
  }
}

String _$getDetailHash() => r'02d7c131080e1cc739795aa3d56be69dfc3fbac8';

@ProviderFor(setReadFlag)
const setReadFlagProvider = SetReadFlagProvider._();

final class SetReadFlagProvider
    extends $FunctionalProvider<SetReadFlag, SetReadFlag, SetReadFlag>
    with $Provider<SetReadFlag> {
  const SetReadFlagProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'setReadFlagProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$setReadFlagHash();

  @$internal
  @override
  $ProviderElement<SetReadFlag> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SetReadFlag create(Ref ref) {
    return setReadFlag(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SetReadFlag value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SetReadFlag>(value),
    );
  }
}

String _$setReadFlagHash() => r'8e4671d0a3f31775d0aedb5958f12ff4c14febbb';
