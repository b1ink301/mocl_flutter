// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$headersHash() => r'10f3fd28b422d583481c4492533660310e715031';

/// See also [headers].
@ProviderFor(headers)
final headersProvider = AutoDisposeProvider<Map<String, String>>.internal(
  headers,
  name: r'headersProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$headersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef HeadersRef = AutoDisposeProviderRef<Map<String, String>>;
String _$reqUrlHash() => r'917024090a1779f9950ee3f454a254d657585855';

/// See also [reqUrl].
@ProviderFor(reqUrl)
final reqUrlProvider = AutoDisposeProvider<WebUri>.internal(
  reqUrl,
  name: r'reqUrlProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$reqUrlHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReqUrlRef = AutoDisposeProviderRef<WebUri>;
String _$hasLoginHash() => r'83e0143a9c314edd10a191ac55ef9ebdf03f7265';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [hasLogin].
@ProviderFor(hasLogin)
const hasLoginProvider = HasLoginFamily();

/// See also [hasLogin].
class HasLoginFamily extends Family<AsyncValue<bool>> {
  /// See also [hasLogin].
  const HasLoginFamily();

  /// See also [hasLogin].
  HasLoginProvider call(
    CookieManager cookieManager,
    WebUri uri,
  ) {
    return HasLoginProvider(
      cookieManager,
      uri,
    );
  }

  @override
  HasLoginProvider getProviderOverride(
    covariant HasLoginProvider provider,
  ) {
    return call(
      provider.cookieManager,
      provider.uri,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'hasLoginProvider';
}

/// See also [hasLogin].
class HasLoginProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [hasLogin].
  HasLoginProvider(
    CookieManager cookieManager,
    WebUri uri,
  ) : this._internal(
          (ref) => hasLogin(
            ref as HasLoginRef,
            cookieManager,
            uri,
          ),
          from: hasLoginProvider,
          name: r'hasLoginProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$hasLoginHash,
          dependencies: HasLoginFamily._dependencies,
          allTransitiveDependencies: HasLoginFamily._allTransitiveDependencies,
          cookieManager: cookieManager,
          uri: uri,
        );

  HasLoginProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cookieManager,
    required this.uri,
  }) : super.internal();

  final CookieManager cookieManager;
  final WebUri uri;

  @override
  Override overrideWith(
    FutureOr<bool> Function(HasLoginRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HasLoginProvider._internal(
        (ref) => create(ref as HasLoginRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        cookieManager: cookieManager,
        uri: uri,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _HasLoginProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HasLoginProvider &&
        other.cookieManager == cookieManager &&
        other.uri == uri;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cookieManager.hashCode);
    hash = _SystemHash.combine(hash, uri.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HasLoginRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `cookieManager` of this provider.
  CookieManager get cookieManager;

  /// The parameter `uri` of this provider.
  WebUri get uri;
}

class _HasLoginProviderElement extends AutoDisposeFutureProviderElement<bool>
    with HasLoginRef {
  _HasLoginProviderElement(super.provider);

  @override
  CookieManager get cookieManager => (origin as HasLoginProvider).cookieManager;
  @override
  WebUri get uri => (origin as HasLoginProvider).uri;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
