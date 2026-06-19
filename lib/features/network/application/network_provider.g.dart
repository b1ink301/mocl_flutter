// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'network_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dio)
final dioProvider = DioProvider._();

final class DioProvider extends $FunctionalProvider<Dio, Dio, Dio>
    with $Provider<Dio> {
  DioProvider._()
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

String _$dioHash() => r'426f53783e39ce0a7f038449591bc45fc9b47b21';

@ProviderFor(cookieJar)
final cookieJarProvider = CookieJarProvider._();

final class CookieJarProvider
    extends $FunctionalProvider<CookieJar, CookieJar, CookieJar>
    with $Provider<CookieJar> {
  CookieJarProvider._()
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
final theQooApiClientProvider = TheQooApiClientProvider._();

final class TheQooApiClientProvider
    extends $FunctionalProvider<BaseApi, BaseApi, BaseApi>
    with $Provider<BaseApi> {
  TheQooApiClientProvider._()
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

String _$theQooApiClientHash() => r'a3b1448e260f1548b209deeb727b6a40116bd609';

@ProviderFor(ruliwebApiClient)
final ruliwebApiClientProvider = RuliwebApiClientProvider._();

final class RuliwebApiClientProvider
    extends $FunctionalProvider<BaseApi, BaseApi, BaseApi>
    with $Provider<BaseApi> {
  RuliwebApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ruliwebApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ruliwebApiClientHash();

  @$internal
  @override
  $ProviderElement<BaseApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BaseApi create(Ref ref) {
    return ruliwebApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BaseApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BaseApi>(value),
    );
  }
}

String _$ruliwebApiClientHash() => r'049c77d7ede03cf37547e87b8407782fc81f1145';

@ProviderFor(ppomppuApiClient)
final ppomppuApiClientProvider = PpomppuApiClientProvider._();

final class PpomppuApiClientProvider
    extends $FunctionalProvider<BaseApi, BaseApi, BaseApi>
    with $Provider<BaseApi> {
  PpomppuApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'ppomppuApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$ppomppuApiClientHash();

  @$internal
  @override
  $ProviderElement<BaseApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BaseApi create(Ref ref) {
    return ppomppuApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BaseApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BaseApi>(value),
    );
  }
}

String _$ppomppuApiClientHash() => r'2e8312e127bd7ddf0520be5226351897c48d5e13';

@ProviderFor(invenApiClient)
final invenApiClientProvider = InvenApiClientProvider._();

final class InvenApiClientProvider
    extends $FunctionalProvider<BaseApi, BaseApi, BaseApi>
    with $Provider<BaseApi> {
  InvenApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'invenApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$invenApiClientHash();

  @$internal
  @override
  $ProviderElement<BaseApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BaseApi create(Ref ref) {
    return invenApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BaseApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BaseApi>(value),
    );
  }
}

String _$invenApiClientHash() => r'2761ef15d823e04365e0dc952b051c04d4873d42';

@ProviderFor(bobaedreamApiClient)
final bobaedreamApiClientProvider = BobaedreamApiClientProvider._();

final class BobaedreamApiClientProvider
    extends $FunctionalProvider<BaseApi, BaseApi, BaseApi>
    with $Provider<BaseApi> {
  BobaedreamApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bobaedreamApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bobaedreamApiClientHash();

  @$internal
  @override
  $ProviderElement<BaseApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BaseApi create(Ref ref) {
    return bobaedreamApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BaseApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BaseApi>(value),
    );
  }
}

String _$bobaedreamApiClientHash() =>
    r'9e8e104a670e18a287422c9cddcf29b034c6530b';

@ProviderFor(cook82ApiClient)
final cook82ApiClientProvider = Cook82ApiClientProvider._();

final class Cook82ApiClientProvider
    extends $FunctionalProvider<BaseApi, BaseApi, BaseApi>
    with $Provider<BaseApi> {
  Cook82ApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'cook82ApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$cook82ApiClientHash();

  @$internal
  @override
  $ProviderElement<BaseApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BaseApi create(Ref ref) {
    return cook82ApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BaseApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BaseApi>(value),
    );
  }
}

String _$cook82ApiClientHash() => r'5a6f148252a2c636e48077975af34e6046d1134d';

@ProviderFor(dcinsideApiClient)
final dcinsideApiClientProvider = DcinsideApiClientProvider._();

final class DcinsideApiClientProvider
    extends $FunctionalProvider<BaseApi, BaseApi, BaseApi>
    with $Provider<BaseApi> {
  DcinsideApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dcinsideApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dcinsideApiClientHash();

  @$internal
  @override
  $ProviderElement<BaseApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BaseApi create(Ref ref) {
    return dcinsideApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BaseApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BaseApi>(value),
    );
  }
}

String _$dcinsideApiClientHash() => r'7b4995872b6d4bc38551df845d319046de1902a1';

@ProviderFor(dogdripApiClient)
final dogdripApiClientProvider = DogdripApiClientProvider._();

final class DogdripApiClientProvider
    extends $FunctionalProvider<BaseApi, BaseApi, BaseApi>
    with $Provider<BaseApi> {
  DogdripApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'dogdripApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$dogdripApiClientHash();

  @$internal
  @override
  $ProviderElement<BaseApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BaseApi create(Ref ref) {
    return dogdripApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BaseApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BaseApi>(value),
    );
  }
}

String _$dogdripApiClientHash() => r'4eb013504fda099d7241f02c26224a33573020bb';

@ProviderFor(mlbparkApiClient)
final mlbparkApiClientProvider = MlbparkApiClientProvider._();

final class MlbparkApiClientProvider
    extends $FunctionalProvider<BaseApi, BaseApi, BaseApi>
    with $Provider<BaseApi> {
  MlbparkApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mlbparkApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mlbparkApiClientHash();

  @$internal
  @override
  $ProviderElement<BaseApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BaseApi create(Ref ref) {
    return mlbparkApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BaseApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BaseApi>(value),
    );
  }
}

String _$mlbparkApiClientHash() => r'a691bbe5deafe3ad6b5912bf4716d8481e184ffd';

@ProviderFor(instizApiClient)
final instizApiClientProvider = InstizApiClientProvider._();

final class InstizApiClientProvider
    extends $FunctionalProvider<BaseApi, BaseApi, BaseApi>
    with $Provider<BaseApi> {
  InstizApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'instizApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$instizApiClientHash();

  @$internal
  @override
  $ProviderElement<BaseApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BaseApi create(Ref ref) {
    return instizApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BaseApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BaseApi>(value),
    );
  }
}

String _$instizApiClientHash() => r'66b8b2e81039726075dd332b9d261b630aa8da0c';

@ProviderFor(arcaliveApiClient)
final arcaliveApiClientProvider = ArcaliveApiClientProvider._();

final class ArcaliveApiClientProvider
    extends $FunctionalProvider<BaseApi, BaseApi, BaseApi>
    with $Provider<BaseApi> {
  ArcaliveApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'arcaliveApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$arcaliveApiClientHash();

  @$internal
  @override
  $ProviderElement<BaseApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BaseApi create(Ref ref) {
    return arcaliveApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BaseApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BaseApi>(value),
    );
  }
}

String _$arcaliveApiClientHash() => r'f68fe5be8c34774978a4d4778c1172cdb3926c03';

@ProviderFor(clienApiClient)
final clienApiClientProvider = ClienApiClientProvider._();

final class ClienApiClientProvider
    extends $FunctionalProvider<BaseApi, BaseApi, BaseApi>
    with $Provider<BaseApi> {
  ClienApiClientProvider._()
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
final damoangApiClientProvider = DamoangApiClientProvider._();

final class DamoangApiClientProvider
    extends $FunctionalProvider<BaseApi, BaseApi, BaseApi>
    with $Provider<BaseApi> {
  DamoangApiClientProvider._()
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
final naverCafeApiClientProvider = NaverCafeApiClientProvider._();

final class NaverCafeApiClientProvider
    extends $FunctionalProvider<BaseApi, BaseApi, BaseApi>
    with $Provider<BaseApi> {
  NaverCafeApiClientProvider._()
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
final redditApiClientProvider = RedditApiClientProvider._();

final class RedditApiClientProvider
    extends $FunctionalProvider<BaseApi, BaseApi, BaseApi>
    with $Provider<BaseApi> {
  RedditApiClientProvider._()
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

@ProviderFor(geekNewsApiClient)
final geekNewsApiClientProvider = GeekNewsApiClientProvider._();

final class GeekNewsApiClientProvider
    extends $FunctionalProvider<BaseApi, BaseApi, BaseApi>
    with $Provider<BaseApi> {
  GeekNewsApiClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'geekNewsApiClientProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$geekNewsApiClientHash();

  @$internal
  @override
  $ProviderElement<BaseApi> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  BaseApi create(Ref ref) {
    return geekNewsApiClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BaseApi value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BaseApi>(value),
    );
  }
}

String _$geekNewsApiClientHash() => r'd81b05a79ef57be9630dea51327e79fe03398ea5';

@ProviderFor(meecoApiClient)
final meecoApiClientProvider = MeecoApiClientProvider._();

final class MeecoApiClientProvider
    extends $FunctionalProvider<BaseApi, BaseApi, BaseApi>
    with $Provider<BaseApi> {
  MeecoApiClientProvider._()
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
