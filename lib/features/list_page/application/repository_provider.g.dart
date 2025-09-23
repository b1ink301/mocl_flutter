// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(listRepository)
const listRepositoryProvider = ListRepositoryFamily._();

final class ListRepositoryProvider
    extends $FunctionalProvider<ListRepository, ListRepository, ListRepository>
    with $Provider<ListRepository> {
  const ListRepositoryProvider._({
    required ListRepositoryFamily super.from,
    required SiteType super.argument,
  }) : super(
         retry: null,
         name: r'listRepositoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$listRepositoryHash();

  @override
  String toString() {
    return r'listRepositoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<ListRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ListRepository create(Ref ref) {
    final argument = this.argument as SiteType;
    return listRepository(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ListRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ListRepository>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ListRepositoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$listRepositoryHash() => r'8103da95af7b46ba4a9d99bfd15f0800a198ac23';

final class ListRepositoryFamily extends $Family
    with $FunctionalFamilyOverride<ListRepository, SiteType> {
  const ListRepositoryFamily._()
    : super(
        retry: null,
        name: r'listRepositoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ListRepositoryProvider call(SiteType siteType) =>
      ListRepositoryProvider._(argument: siteType, from: this);

  @override
  String toString() => r'listRepositoryProvider';
}
