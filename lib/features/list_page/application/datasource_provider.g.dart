// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datasource_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(listDatasource)
const listDatasourceProvider = ListDatasourceFamily._();

final class ListDatasourceProvider
    extends $FunctionalProvider<ListDataSource, ListDataSource, ListDataSource>
    with $Provider<ListDataSource> {
  const ListDatasourceProvider._({
    required ListDatasourceFamily super.from,
    required SiteType super.argument,
  }) : super(
         retry: null,
         name: r'listDatasourceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$listDatasourceHash();

  @override
  String toString() {
    return r'listDatasourceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<ListDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ListDataSource create(Ref ref) {
    final argument = this.argument as SiteType;
    return listDatasource(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ListDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ListDataSource>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is ListDatasourceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$listDatasourceHash() => r'4ba2012024c995f9d3e64dab792203a31d28d287';

final class ListDatasourceFamily extends $Family
    with $FunctionalFamilyOverride<ListDataSource, SiteType> {
  const ListDatasourceFamily._()
    : super(
        retry: null,
        name: r'listDatasourceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ListDatasourceProvider call(SiteType siteType) =>
      ListDatasourceProvider._(argument: siteType, from: this);

  @override
  String toString() => r'listDatasourceProvider';
}
