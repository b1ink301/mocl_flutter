// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mainRepository)
const mainRepositoryProvider = MainRepositoryFamily._();

final class MainRepositoryProvider
    extends $FunctionalProvider<MainRepository, MainRepository, MainRepository>
    with $Provider<MainRepository> {
  const MainRepositoryProvider._({
    required MainRepositoryFamily super.from,
    required SiteType super.argument,
  }) : super(
         retry: null,
         name: r'mainRepositoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mainRepositoryHash();

  @override
  String toString() {
    return r'mainRepositoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<MainRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MainRepository create(Ref ref) {
    final argument = this.argument as SiteType;
    return mainRepository(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MainRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MainRepository>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MainRepositoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mainRepositoryHash() => r'04ed3460842e34821e481dd10b51381c08ee2382';

final class MainRepositoryFamily extends $Family
    with $FunctionalFamilyOverride<MainRepository, SiteType> {
  const MainRepositoryFamily._()
    : super(
        retry: null,
        name: r'mainRepositoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MainRepositoryProvider call(SiteType siteType) =>
      MainRepositoryProvider._(argument: siteType, from: this);

  @override
  String toString() => r'mainRepositoryProvider';
}
