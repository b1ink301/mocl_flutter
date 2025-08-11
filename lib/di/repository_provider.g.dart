// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(settingsRepository)
const settingsRepositoryProvider = SettingsRepositoryProvider._();

final class SettingsRepositoryProvider
    extends
        $FunctionalProvider<
          SettingsRepository,
          SettingsRepository,
          SettingsRepository
        >
    with $Provider<SettingsRepository> {
  const SettingsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsRepositoryHash();

  @$internal
  @override
  $ProviderElement<SettingsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SettingsRepository create(Ref ref) {
    return settingsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SettingsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SettingsRepository>(value),
    );
  }
}

String _$settingsRepositoryHash() =>
    r'0aa2f865e2e10f90a8f7d686625346b1656fe96e';

@ProviderFor(mainRepository)
const mainRepositoryProvider = MainRepositoryProvider._();

final class MainRepositoryProvider
    extends $FunctionalProvider<MainRepository, MainRepository, MainRepository>
    with $Provider<MainRepository> {
  const MainRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mainRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mainRepositoryHash();

  @$internal
  @override
  $ProviderElement<MainRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MainRepository create(Ref ref) {
    return mainRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MainRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MainRepository>(value),
    );
  }
}

String _$mainRepositoryHash() => r'a4b1cfaecbb6a058768f02bac50979010225a3c3';

@ProviderFor(listRepository)
const listRepositoryProvider = ListRepositoryProvider._();

final class ListRepositoryProvider
    extends $FunctionalProvider<ListRepository, ListRepository, ListRepository>
    with $Provider<ListRepository> {
  const ListRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$listRepositoryHash();

  @$internal
  @override
  $ProviderElement<ListRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ListRepository create(Ref ref) {
    return listRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ListRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ListRepository>(value),
    );
  }
}

String _$listRepositoryHash() => r'92566b90779daaa31d25bfca1940bfeeed495e09';

@ProviderFor(detailRepository)
const detailRepositoryProvider = DetailRepositoryProvider._();

final class DetailRepositoryProvider
    extends
        $FunctionalProvider<
          DetailRepository,
          DetailRepository,
          DetailRepository
        >
    with $Provider<DetailRepository> {
  const DetailRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'detailRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$detailRepositoryHash();

  @$internal
  @override
  $ProviderElement<DetailRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DetailRepository create(Ref ref) {
    return detailRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DetailRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DetailRepository>(value),
    );
  }
}

String _$detailRepositoryHash() => r'3eb74036ad8c1ca8154561117fc6596e1239912c';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
