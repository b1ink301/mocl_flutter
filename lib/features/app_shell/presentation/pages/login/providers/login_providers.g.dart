// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(urlRequest)
const urlRequestProvider = UrlRequestProvider._();

final class UrlRequestProvider
    extends $FunctionalProvider<URLRequest, URLRequest, URLRequest>
    with $Provider<URLRequest> {
  const UrlRequestProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'urlRequestProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$urlRequestHash();

  @$internal
  @override
  $ProviderElement<URLRequest> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  URLRequest create(Ref ref) {
    return urlRequest(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(URLRequest value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<URLRequest>(value),
    );
  }
}

String _$urlRequestHash() => r'9a15893a224e6f823bdbcf129d1c9a8e8ea2db5d';
