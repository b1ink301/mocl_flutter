// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

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

String _$urlRequestHash() => r'309fca7c9d71708450c0a653780faab23ac1216c';

@ProviderFor(hasLogin)
const hasLoginProvider = HasLoginFamily._();

final class HasLoginProvider
    extends $FunctionalProvider<AsyncValue<bool>, bool, FutureOr<bool>>
    with $FutureModifier<bool>, $FutureProvider<bool> {
  const HasLoginProvider._({
    required HasLoginFamily super.from,
    required (CookieManager, String) super.argument,
  }) : super(
         retry: null,
         name: r'hasLoginProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$hasLoginHash();

  @override
  String toString() {
    return r'hasLoginProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<bool> create(Ref ref) {
    final argument = this.argument as (CookieManager, String);
    return hasLogin(ref, argument.$1, argument.$2);
  }

  @override
  bool operator ==(Object other) {
    return other is HasLoginProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$hasLoginHash() => r'723405ea143bc5fff3c7f977672e39de4f4b0e3b';

final class HasLoginFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<bool>, (CookieManager, String)> {
  const HasLoginFamily._()
    : super(
        retry: null,
        name: r'hasLoginProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  HasLoginProvider call(CookieManager cookieManager, String url) =>
      HasLoginProvider._(argument: (cookieManager, url), from: this);

  @override
  String toString() => r'hasLoginProvider';
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
