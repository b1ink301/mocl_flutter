// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datasource_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(detailDatasource)
const detailDatasourceProvider = DetailDatasourceFamily._();

final class DetailDatasourceProvider
    extends
        $FunctionalProvider<
          DetailDataSource,
          DetailDataSource,
          DetailDataSource
        >
    with $Provider<DetailDataSource> {
  const DetailDatasourceProvider._({
    required DetailDatasourceFamily super.from,
    required SiteType super.argument,
  }) : super(
         retry: null,
         name: r'detailDatasourceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$detailDatasourceHash();

  @override
  String toString() {
    return r'detailDatasourceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<DetailDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DetailDataSource create(Ref ref) {
    final argument = this.argument as SiteType;
    return detailDatasource(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DetailDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DetailDataSource>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DetailDatasourceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$detailDatasourceHash() => r'ac93f38e54ee98446f887d811d54d807c95bcc9f';

final class DetailDatasourceFamily extends $Family
    with $FunctionalFamilyOverride<DetailDataSource, SiteType> {
  const DetailDatasourceFamily._()
    : super(
        retry: null,
        name: r'detailDatasourceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DetailDatasourceProvider call(SiteType siteType) =>
      DetailDatasourceProvider._(argument: siteType, from: this);

  @override
  String toString() => r'detailDatasourceProvider';
}
