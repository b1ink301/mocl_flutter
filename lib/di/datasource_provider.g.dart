// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datasource_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(appDatabase)
const appDatabaseProvider = AppDatabaseProvider._();

final class AppDatabaseProvider
    extends $FunctionalProvider<Database, Database, Database>
    with $Provider<Database> {
  const AppDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appDatabaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appDatabaseHash();

  @$internal
  @override
  $ProviderElement<Database> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  Database create(Ref ref) {
    return appDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Database value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Database>(value),
    );
  }
}

String _$appDatabaseHash() => r'337a2efcc40cfdba8a9cddb8e65c137e060ccbac';

@ProviderFor(sharedPreferences)
const sharedPreferencesProvider = SharedPreferencesProvider._();

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  const SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'7467c5c92fd904c96335ccc198d72f69e80a168b';

@ProviderFor(localDatabase)
const localDatabaseProvider = LocalDatabaseProvider._();

final class LocalDatabaseProvider
    extends $FunctionalProvider<LocalDatabase, LocalDatabase, LocalDatabase>
    with $Provider<LocalDatabase> {
  const LocalDatabaseProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localDatabaseProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localDatabaseHash();

  @$internal
  @override
  $ProviderElement<LocalDatabase> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  LocalDatabase create(Ref ref) {
    return localDatabase(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalDatabase value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalDatabase>(value),
    );
  }
}

String _$localDatabaseHash() => r'f553251e91d46b94f90cf62f331b18fcdb8d3690';

@ProviderFor(mainDatasource)
const mainDatasourceProvider = MainDatasourceProvider._();

final class MainDatasourceProvider
    extends $FunctionalProvider<MainDataSource, MainDataSource, MainDataSource>
    with $Provider<MainDataSource> {
  const MainDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mainDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mainDatasourceHash();

  @$internal
  @override
  $ProviderElement<MainDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MainDataSource create(Ref ref) {
    return mainDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MainDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MainDataSource>(value),
    );
  }
}

String _$mainDatasourceHash() => r'9b27f07587919fae29b30659c37c0b130624fe33';

@ProviderFor(listDatasource)
const listDatasourceProvider = ListDatasourceProvider._();

final class ListDatasourceProvider
    extends $FunctionalProvider<ListDataSource, ListDataSource, ListDataSource>
    with $Provider<ListDataSource> {
  const ListDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$listDatasourceHash();

  @$internal
  @override
  $ProviderElement<ListDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ListDataSource create(Ref ref) {
    return listDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ListDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ListDataSource>(value),
    );
  }
}

String _$listDatasourceHash() => r'a27ab280c35535a8f2a62e640ed4de6671b77332';

@ProviderFor(detailDatasource)
const detailDatasourceProvider = DetailDatasourceProvider._();

final class DetailDatasourceProvider
    extends
        $FunctionalProvider<
          DetailDataSource,
          DetailDataSource,
          DetailDataSource
        >
    with $Provider<DetailDataSource> {
  const DetailDatasourceProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'detailDatasourceProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$detailDatasourceHash();

  @$internal
  @override
  $ProviderElement<DetailDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DetailDataSource create(Ref ref) {
    return detailDatasource(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DetailDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DetailDataSource>(value),
    );
  }
}

String _$detailDatasourceHash() => r'6b99a4b9d8d63e1c902884a501243e3d041194e1';

@ProviderFor(clienParser)
const clienParserProvider = ClienParserProvider._();

final class ClienParserProvider
    extends
        $FunctionalProvider<
          (BaseParser, BaseApi),
          (BaseParser, BaseApi),
          (BaseParser, BaseApi)
        >
    with $Provider<(BaseParser, BaseApi)> {
  const ClienParserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'clienParserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$clienParserHash();

  @$internal
  @override
  $ProviderElement<(BaseParser, BaseApi)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  (BaseParser, BaseApi) create(Ref ref) {
    return clienParser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((BaseParser, BaseApi) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(BaseParser, BaseApi)>(value),
    );
  }
}

String _$clienParserHash() => r'1d2accc05d821d5aebf99799c624c898e1e2564f';

@ProviderFor(damoangParser)
const damoangParserProvider = DamoangParserProvider._();

final class DamoangParserProvider
    extends
        $FunctionalProvider<
          (BaseParser, BaseApi),
          (BaseParser, BaseApi),
          (BaseParser, BaseApi)
        >
    with $Provider<(BaseParser, BaseApi)> {
  const DamoangParserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'damoangParserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$damoangParserHash();

  @$internal
  @override
  $ProviderElement<(BaseParser, BaseApi)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  (BaseParser, BaseApi) create(Ref ref) {
    return damoangParser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((BaseParser, BaseApi) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(BaseParser, BaseApi)>(value),
    );
  }
}

String _$damoangParserHash() => r'7810acc45aabf36c95175ef69845f4f32544397b';

@ProviderFor(meecoParser)
const meecoParserProvider = MeecoParserProvider._();

final class MeecoParserProvider
    extends
        $FunctionalProvider<
          (BaseParser, BaseApi),
          (BaseParser, BaseApi),
          (BaseParser, BaseApi)
        >
    with $Provider<(BaseParser, BaseApi)> {
  const MeecoParserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'meecoParserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$meecoParserHash();

  @$internal
  @override
  $ProviderElement<(BaseParser, BaseApi)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  (BaseParser, BaseApi) create(Ref ref) {
    return meecoParser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((BaseParser, BaseApi) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(BaseParser, BaseApi)>(value),
    );
  }
}

String _$meecoParserHash() => r'32e5757f9698eec13fc506f1b1390539783c48fd';

@ProviderFor(naverCafeParser)
const naverCafeParserProvider = NaverCafeParserProvider._();

final class NaverCafeParserProvider
    extends
        $FunctionalProvider<
          (BaseParser, BaseApi),
          (BaseParser, BaseApi),
          (BaseParser, BaseApi)
        >
    with $Provider<(BaseParser, BaseApi)> {
  const NaverCafeParserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'naverCafeParserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$naverCafeParserHash();

  @$internal
  @override
  $ProviderElement<(BaseParser, BaseApi)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  (BaseParser, BaseApi) create(Ref ref) {
    return naverCafeParser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((BaseParser, BaseApi) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(BaseParser, BaseApi)>(value),
    );
  }
}

String _$naverCafeParserHash() => r'5bfa50b1fae5c9aba8d239e60989dc733d113ec9';

@ProviderFor(redditParser)
const redditParserProvider = RedditParserProvider._();

final class RedditParserProvider
    extends
        $FunctionalProvider<
          (BaseParser, BaseApi),
          (BaseParser, BaseApi),
          (BaseParser, BaseApi)
        >
    with $Provider<(BaseParser, BaseApi)> {
  const RedditParserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'redditParserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$redditParserHash();

  @$internal
  @override
  $ProviderElement<(BaseParser, BaseApi)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  (BaseParser, BaseApi) create(Ref ref) {
    return redditParser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((BaseParser, BaseApi) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(BaseParser, BaseApi)>(value),
    );
  }
}

String _$redditParserHash() => r'7592d9d287aa94d6fc3cae3aed8979fbf9aee524';

@ProviderFor(theqooParser)
const theqooParserProvider = TheqooParserProvider._();

final class TheqooParserProvider
    extends
        $FunctionalProvider<
          (BaseParser, BaseApi),
          (BaseParser, BaseApi),
          (BaseParser, BaseApi)
        >
    with $Provider<(BaseParser, BaseApi)> {
  const TheqooParserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'theqooParserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$theqooParserHash();

  @$internal
  @override
  $ProviderElement<(BaseParser, BaseApi)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  (BaseParser, BaseApi) create(Ref ref) {
    return theqooParser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((BaseParser, BaseApi) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(BaseParser, BaseApi)>(value),
    );
  }
}

String _$theqooParserHash() => r'b778a69f9de06e2bb95a94bb39c47461b23853c7';

@ProviderFor(currentParser)
const currentParserProvider = CurrentParserProvider._();

final class CurrentParserProvider
    extends
        $FunctionalProvider<
          (BaseParser, BaseApi),
          (BaseParser, BaseApi),
          (BaseParser, BaseApi)
        >
    with $Provider<(BaseParser, BaseApi)> {
  const CurrentParserProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentParserProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentParserHash();

  @$internal
  @override
  $ProviderElement<(BaseParser, BaseApi)> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  (BaseParser, BaseApi) create(Ref ref) {
    return currentParser(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue((BaseParser, BaseApi) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<(BaseParser, BaseApi)>(value),
    );
  }
}

String _$currentParserHash() => r'5c61f20a79e46ee41ab76fb69162b4e8f743d4da';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
