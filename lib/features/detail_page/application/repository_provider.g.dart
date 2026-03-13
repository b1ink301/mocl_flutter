// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(detailRepository)
final detailRepositoryProvider = DetailRepositoryFamily._();

final class DetailRepositoryProvider
    extends
        $FunctionalProvider<
          DetailRepository,
          DetailRepository,
          DetailRepository
        >
    with $Provider<DetailRepository> {
  DetailRepositoryProvider._({
    required DetailRepositoryFamily super.from,
    required SiteType super.argument,
  }) : super(
         retry: null,
         name: r'detailRepositoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$detailRepositoryHash();

  @override
  String toString() {
    return r'detailRepositoryProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<DetailRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  DetailRepository create(Ref ref) {
    final argument = this.argument as SiteType;
    return detailRepository(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(DetailRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<DetailRepository>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DetailRepositoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$detailRepositoryHash() => r'bc370fcf11b540d58978748f7f72f1eda6b8a8d3';

final class DetailRepositoryFamily extends $Family
    with $FunctionalFamilyOverride<DetailRepository, SiteType> {
  DetailRepositoryFamily._()
    : super(
        retry: null,
        name: r'detailRepositoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DetailRepositoryProvider call(SiteType siteType) =>
      DetailRepositoryProvider._(argument: siteType, from: this);

  @override
  String toString() => r'detailRepositoryProvider';
}
