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

/// 하위 메뉴는 '지금 고른 사이트'가 아니라 부모 항목이 속한 사이트로 조회한다.
/// (레일을 옮겨도 이미 받아둔 하위 목록이 엉키지 않는다)

@ProviderFor(getSubMenuList)
final getSubMenuListProvider = GetSubMenuListFamily._();

/// 하위 메뉴는 '지금 고른 사이트'가 아니라 부모 항목이 속한 사이트로 조회한다.
/// (레일을 옮겨도 이미 받아둔 하위 목록이 엉키지 않는다)

final class GetSubMenuListProvider
    extends $FunctionalProvider<GetSubMenuList, GetSubMenuList, GetSubMenuList>
    with $Provider<GetSubMenuList> {
  /// 하위 메뉴는 '지금 고른 사이트'가 아니라 부모 항목이 속한 사이트로 조회한다.
  /// (레일을 옮겨도 이미 받아둔 하위 목록이 엉키지 않는다)
  GetSubMenuListProvider._({
    required GetSubMenuListFamily super.from,
    required SiteType super.argument,
  }) : super(
         retry: null,
         name: r'getSubMenuListProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getSubMenuListHash();

  @override
  String toString() {
    return r'getSubMenuListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<GetSubMenuList> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  GetSubMenuList create(Ref ref) {
    final argument = this.argument as SiteType;
    return getSubMenuList(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GetSubMenuList value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GetSubMenuList>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetSubMenuListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getSubMenuListHash() => r'4f0bd911596b9a7f26a5d7c5b560c4d78d022e82';

/// 하위 메뉴는 '지금 고른 사이트'가 아니라 부모 항목이 속한 사이트로 조회한다.
/// (레일을 옮겨도 이미 받아둔 하위 목록이 엉키지 않는다)

final class GetSubMenuListFamily extends $Family
    with $FunctionalFamilyOverride<GetSubMenuList, SiteType> {
  GetSubMenuListFamily._()
    : super(
        retry: null,
        name: r'getSubMenuListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 하위 메뉴는 '지금 고른 사이트'가 아니라 부모 항목이 속한 사이트로 조회한다.
  /// (레일을 옮겨도 이미 받아둔 하위 목록이 엉키지 않는다)

  GetSubMenuListProvider call(SiteType siteType) =>
      GetSubMenuListProvider._(argument: siteType, from: this);

  @override
  String toString() => r'getSubMenuListProvider';
}
