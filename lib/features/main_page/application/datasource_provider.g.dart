// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'datasource_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mainDatasource)
final mainDatasourceProvider = MainDatasourceFamily._();

final class MainDatasourceProvider
    extends $FunctionalProvider<MainDataSource, MainDataSource, MainDataSource>
    with $Provider<MainDataSource> {
  MainDatasourceProvider._({
    required MainDatasourceFamily super.from,
    required SiteType super.argument,
  }) : super(
         retry: null,
         name: r'mainDatasourceProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mainDatasourceHash();

  @override
  String toString() {
    return r'mainDatasourceProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<MainDataSource> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MainDataSource create(Ref ref) {
    final argument = this.argument as SiteType;
    return mainDatasource(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MainDataSource value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MainDataSource>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MainDatasourceProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mainDatasourceHash() => r'b45b4b891936ed14c2e59638038042ec955a5fa7';

final class MainDatasourceFamily extends $Family
    with $FunctionalFamilyOverride<MainDataSource, SiteType> {
  MainDatasourceFamily._()
    : super(
        retry: null,
        name: r'mainDatasourceProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MainDatasourceProvider call(SiteType siteType) =>
      MainDatasourceProvider._(argument: siteType, from: this);

  @override
  String toString() => r'mainDatasourceProvider';
}
