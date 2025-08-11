// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(dio)
const dioProvider = DioProvider._();

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  const DioProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dioProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dioHash();

  @$internal
  @override
  $ProviderElement<Dio> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Dio create(Ref ref) {
    return dio(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$dioHash() => r'088d5c03610503c2407a8d7429b0e9f3ee76406f';

@ProviderFor(cookieJar)
const cookieJarProvider = CookieJarProvider._();

final class CookieJarProvider
    extends $FunctionalProvider<CookieJar, CookieJar, CookieJar>
    with $Provider<CookieJar> {
  const CookieJarProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cookieJarProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cookieJarHash();

  @$internal
  @override
  $ProviderElement<CookieJar> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  CookieJar create(Ref ref) {
    return cookieJar(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(CookieJar value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<CookieJar>(value),
    );
  }
}

String _$cookieJarHash() => r'faac22de9751ccb26d253ff2ac40f660f01b425c';

@ProviderFor(theQooApiClient)
const theQooApiClientProvider = TheQooApiClientProvider._();

final class TheQooApiClientProvider
    extends $FunctionalProvider<BaseApi, BaseApi, BaseApi>
    with $Provider<BaseApi> {
  const TheQooApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'theQooApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$theQooApiClientHash();

  @$internal
  @override
  $ProviderElement<BaseApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BaseApi create(Ref ref) {
    return theQooApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BaseApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BaseApi>(value),
    );
  }
}

String _$theQooApiClientHash() => r'40d23b310e0c900ff4b974cf8862674ebbf2fa30';

@ProviderFor(clienApiClient)
const clienApiClientProvider = ClienApiClientProvider._();

final class ClienApiClientProvider
    extends $FunctionalProvider<BaseApi, BaseApi, BaseApi>
    with $Provider<BaseApi> {
  const ClienApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clienApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clienApiClientHash();

  @$internal
  @override
  $ProviderElement<BaseApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BaseApi create(Ref ref) {
    return clienApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BaseApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BaseApi>(value),
    );
  }
}

String _$clienApiClientHash() => r'69e9a26c04d4586719c1d033537496c6deca13dd';

@ProviderFor(damoangApiClient)
const damoangApiClientProvider = DamoangApiClientProvider._();

final class DamoangApiClientProvider
    extends $FunctionalProvider<BaseApi, BaseApi, BaseApi>
    with $Provider<BaseApi> {
  const DamoangApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'damoangApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$damoangApiClientHash();

  @$internal
  @override
  $ProviderElement<BaseApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BaseApi create(Ref ref) {
    return damoangApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BaseApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BaseApi>(value),
    );
  }
}

String _$damoangApiClientHash() => r'9f9a1416fb9d3d2075c7f50f6e2b31cee94722f8';

@ProviderFor(naverCafeApiClient)
const naverCafeApiClientProvider = NaverCafeApiClientProvider._();

final class NaverCafeApiClientProvider
    extends $FunctionalProvider<BaseApi, BaseApi, BaseApi>
    with $Provider<BaseApi> {
  const NaverCafeApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'naverCafeApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$naverCafeApiClientHash();

  @$internal
  @override
  $ProviderElement<BaseApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BaseApi create(Ref ref) {
    return naverCafeApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BaseApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BaseApi>(value),
    );
  }
}

String _$naverCafeApiClientHash() =>
    r'e42004228c11a05a2f0e9649b0590afd09db7b43';

@ProviderFor(redditApiClient)
const redditApiClientProvider = RedditApiClientProvider._();

final class RedditApiClientProvider
    extends $FunctionalProvider<BaseApi, BaseApi, BaseApi>
    with $Provider<BaseApi> {
  const RedditApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'redditApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$redditApiClientHash();

  @$internal
  @override
  $ProviderElement<BaseApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BaseApi create(Ref ref) {
    return redditApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BaseApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BaseApi>(value),
    );
  }
}

String _$redditApiClientHash() => r'5bde1814ef36148bc3234c729b9814a760080332';

@ProviderFor(meecoApiClient)
const meecoApiClientProvider = MeecoApiClientProvider._();

final class MeecoApiClientProvider
    extends $FunctionalProvider<BaseApi, BaseApi, BaseApi>
    with $Provider<BaseApi> {
  const MeecoApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'meecoApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$meecoApiClientHash();

  @$internal
  @override
  $ProviderElement<BaseApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BaseApi create(Ref ref) {
    return meecoApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BaseApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BaseApi>(value),
    );
  }
}

String _$meecoApiClientHash() => r'70b0f3b891f308fb00fbad934dbf4b3cee9997ad';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
