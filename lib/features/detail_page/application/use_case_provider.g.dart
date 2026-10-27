// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'use_case_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(getDetail)
final getDetailProvider = GetDetailFamily._();

final class GetDetailProvider
    extends $FunctionalProvider<GetDetail, GetDetail, GetDetail>
    with $Provider<GetDetail> {
  GetDetailProvider._({
    required GetDetailFamily super.from,
    required SiteType super.argument,
  }) : super(
         retry: null,
         name: r'getDetailProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getDetailHash();

  @override
  String toString() {
    return r'getDetailProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<GetDetail> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetDetail create(Ref ref) {
    final argument = this.argument as SiteType;
    return getDetail(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetDetail value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetDetail>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetDetailProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getDetailHash() => r'7c70969bbd3ef88ed61a0d4fa80df24846ac8a52';

final class GetDetailFamily extends $Family
    with $FunctionalFamilyOverride<GetDetail, SiteType> {
  GetDetailFamily._()
    : super(
        retry: null,
        name: r'getDetailProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetDetailProvider call(SiteType siteType) =>
      GetDetailProvider._(argument: siteType, from: this);

  @override
  String toString() => r'getDetailProvider';
}

@ProviderFor(setReadFlag)
final setReadFlagProvider = SetReadFlagFamily._();

final class SetReadFlagProvider
    extends $FunctionalProvider<SetReadFlag, SetReadFlag, SetReadFlag>
    with $Provider<SetReadFlag> {
  SetReadFlagProvider._({
    required SetReadFlagFamily super.from,
    required SiteType super.argument,
  }) : super(
         retry: null,
         name: r'setReadFlagProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$setReadFlagHash();

  @override
  String toString() {
    return r'setReadFlagProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<SetReadFlag> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SetReadFlag create(Ref ref) {
    final argument = this.argument as SiteType;
    return setReadFlag(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SetReadFlag value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SetReadFlag>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is SetReadFlagProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$setReadFlagHash() => r'1ee13066c59948659ee6e990494fc77f360253c2';

final class SetReadFlagFamily extends $Family
    with $FunctionalFamilyOverride<SetReadFlag, SiteType> {
  SetReadFlagFamily._()
    : super(
        retry: null,
        name: r'setReadFlagProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SetReadFlagProvider call(SiteType siteType) =>
      SetReadFlagProvider._(argument: siteType, from: this);

  @override
  String toString() => r'setReadFlagProvider';
}
