// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$urlRequestHash() => r'309fca7c9d71708450c0a653780faab23ac1216c';

/// See also [urlRequest].
@ProviderFor(urlRequest)
final urlRequestProvider = AutoDisposeProvider<URLRequest>.internal(
  urlRequest,
  name: r'urlRequestProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$urlRequestHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef UrlRequestRef = AutoDisposeProviderRef<URLRequest>;
String _$hasLoginHash() => r'723405ea143bc5fff3c7f977672e39de4f4b0e3b';

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
  HasLoginProvider call(CookieManager cookieManager, String url) {
    return HasLoginProvider(cookieManager, url);
  }

  @override
  HasLoginProvider getProviderOverride(covariant HasLoginProvider provider) {
    return call(provider.cookieManager, provider.url);
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
  HasLoginProvider(CookieManager cookieManager, String url)
    : this._internal(
        (ref) => hasLogin(ref as HasLoginRef, cookieManager, url),
        from: hasLoginProvider,
        name: r'hasLoginProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$hasLoginHash,
        dependencies: HasLoginFamily._dependencies,
        allTransitiveDependencies: HasLoginFamily._allTransitiveDependencies,
        cookieManager: cookieManager,
        url: url,
      );

  HasLoginProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.cookieManager,
    required this.url,
  }) : super.internal();

  final CookieManager cookieManager;
  final String url;

  @override
  Override overrideWith(FutureOr<bool> Function(HasLoginRef provider) create) {
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
        url: url,
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
        other.url == url;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, cookieManager.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HasLoginRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `cookieManager` of this provider.
  CookieManager get cookieManager;

  /// The parameter `url` of this provider.
  String get url;
}

class _HasLoginProviderElement extends AutoDisposeFutureProviderElement<bool>
    with HasLoginRef {
  _HasLoginProviderElement(super.provider);

  @override
  CookieManager get cookieManager => (origin as HasLoginProvider).cookieManager;
  @override
  String get url => (origin as HasLoginProvider).url;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
