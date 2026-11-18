// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_health_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(siteReportClient)
final siteReportClientProvider = SiteReportClientProvider._();

final class SiteReportClientProvider
    extends
        $FunctionalProvider<
          SiteReportClient,
          SiteReportClient,
          SiteReportClient
        >
    with $Provider<SiteReportClient> {
  SiteReportClientProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'siteReportClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$siteReportClientHash();

  @$internal
  @override
  $ProviderElement<SiteReportClient> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SiteReportClient create(Ref ref) {
    return siteReportClient(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SiteReportClient value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SiteReportClient>(value),
    );
  }
}

String _$siteReportClientHash() => r'1bb058818564f598cb9e23dbd510d624d4fa7912';

/// "문제 알리기" 를 보일지(서버 주소가 있는 빌드만).

@ProviderFor(siteReportsAvailable)
final siteReportsAvailableProvider = SiteReportsAvailableProvider._();

/// "문제 알리기" 를 보일지(서버 주소가 있는 빌드만).

final class SiteReportsAvailableProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// "문제 알리기" 를 보일지(서버 주소가 있는 빌드만).
  SiteReportsAvailableProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'siteReportsAvailableProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$siteReportsAvailableHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return siteReportsAvailable(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$siteReportsAvailableHash() =>
    r'158eab561c3f8145b8b066b735b9813e97bad286';

@ProviderFor(siteHealthReporter)
final siteHealthReporterProvider = SiteHealthReporterProvider._();

final class SiteHealthReporterProvider
    extends
        $FunctionalProvider<
          SiteHealthReporter,
          SiteHealthReporter,
          SiteHealthReporter
        >
    with $Provider<SiteHealthReporter> {
  SiteHealthReporterProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'siteHealthReporterProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$siteHealthReporterHash();

  @$internal
  @override
  $ProviderElement<SiteHealthReporter> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SiteHealthReporter create(Ref ref) {
    return siteHealthReporter(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SiteHealthReporter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SiteHealthReporter>(value),
    );
  }
}

String _$siteHealthReporterHash() =>
    r'219220256f921b6b07efedb436cfb6ace611ff52';
