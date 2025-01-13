// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAppVersionHash() => r'c4281fce8377945fd7409c9eca1fb5f423da0eff';

/// See also [getAppVersion].
@ProviderFor(getAppVersion)
final getAppVersionProvider = FutureProvider<String>.internal(
  getAppVersion,
  name: r'getAppVersionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getAppVersionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef GetAppVersionRef = FutureProviderRef<String>;
String _$clearDataHash() => r'b0a541fc4f6aa6a9fbb014c67f22badd76ecc31c';

/// See also [clearData].
@ProviderFor(clearData)
final clearDataProvider = AutoDisposeFutureProvider<void>.internal(
  clearData,
  name: r'clearDataProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$clearDataHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ClearDataRef = AutoDisposeFutureProviderRef<void>;
String _$showToastHash() => r'38e03d8486b2e54b92b29cbe5d6e3211f7b4e71a';

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

/// See also [showToast].
@ProviderFor(showToast)
const showToastProvider = ShowToastFamily();

/// See also [showToast].
class ShowToastFamily extends Family<void> {
  /// See also [showToast].
  const ShowToastFamily();

  /// See also [showToast].
  ShowToastProvider call(
    String message,
    BuildContext context,
  ) {
    return ShowToastProvider(
      message,
      context,
    );
  }

  @override
  ShowToastProvider getProviderOverride(
    covariant ShowToastProvider provider,
  ) {
    return call(
      provider.message,
      provider.context,
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
  String? get name => r'showToastProvider';
}

/// See also [showToast].
class ShowToastProvider extends AutoDisposeProvider<void> {
  /// See also [showToast].
  ShowToastProvider(
    String message,
    BuildContext context,
  ) : this._internal(
          (ref) => showToast(
            ref as ShowToastRef,
            message,
            context,
          ),
          from: showToastProvider,
          name: r'showToastProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$showToastHash,
          dependencies: ShowToastFamily._dependencies,
          allTransitiveDependencies: ShowToastFamily._allTransitiveDependencies,
          message: message,
          context: context,
        );

  ShowToastProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.message,
    required this.context,
  }) : super.internal();

  final String message;
  final BuildContext context;

  @override
  Override overrideWith(
    void Function(ShowToastRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ShowToastProvider._internal(
        (ref) => create(ref as ShowToastRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        message: message,
        context: context,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<void> createElement() {
    return _ShowToastProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShowToastProvider &&
        other.message == message &&
        other.context == context;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, message.hashCode);
    hash = _SystemHash.combine(hash, context.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ShowToastRef on AutoDisposeProviderRef<void> {
  /// The parameter `message` of this provider.
  String get message;

  /// The parameter `context` of this provider.
  BuildContext get context;
}

class _ShowToastProviderElement extends AutoDisposeProviderElement<void>
    with ShowToastRef {
  _ShowToastProviderElement(super.provider);

  @override
  String get message => (origin as ShowToastProvider).message;
  @override
  BuildContext get context => (origin as ShowToastProvider).context;
}

String _$appRouterHash() => r'f1ca33dce438e6b9805137069c2e46064a0f4d69';

/// See also [appRouter].
@ProviderFor(appRouter)
final appRouterProvider = AutoDisposeProvider<GoRouter>.internal(
  appRouter,
  name: r'appRouterProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$appRouterHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppRouterRef = AutoDisposeProviderRef<GoRouter>;
String _$openBrowserByUrlHash() => r'db746ea383f5f88500a430c3e3529eab3d97d5d9';

/// See also [openBrowserByUrl].
@ProviderFor(openBrowserByUrl)
const openBrowserByUrlProvider = OpenBrowserByUrlFamily();

/// See also [openBrowserByUrl].
class OpenBrowserByUrlFamily extends Family<AsyncValue<bool>> {
  /// See also [openBrowserByUrl].
  const OpenBrowserByUrlFamily();

  /// See also [openBrowserByUrl].
  OpenBrowserByUrlProvider call(
    String url,
  ) {
    return OpenBrowserByUrlProvider(
      url,
    );
  }

  @override
  OpenBrowserByUrlProvider getProviderOverride(
    covariant OpenBrowserByUrlProvider provider,
  ) {
    return call(
      provider.url,
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
  String? get name => r'openBrowserByUrlProvider';
}

/// See also [openBrowserByUrl].
class OpenBrowserByUrlProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [openBrowserByUrl].
  OpenBrowserByUrlProvider(
    String url,
  ) : this._internal(
          (ref) => openBrowserByUrl(
            ref as OpenBrowserByUrlRef,
            url,
          ),
          from: openBrowserByUrlProvider,
          name: r'openBrowserByUrlProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$openBrowserByUrlHash,
          dependencies: OpenBrowserByUrlFamily._dependencies,
          allTransitiveDependencies:
              OpenBrowserByUrlFamily._allTransitiveDependencies,
          url: url,
        );

  OpenBrowserByUrlProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.url,
  }) : super.internal();

  final String url;

  @override
  Override overrideWith(
    FutureOr<bool> Function(OpenBrowserByUrlRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OpenBrowserByUrlProvider._internal(
        (ref) => create(ref as OpenBrowserByUrlRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        url: url,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _OpenBrowserByUrlProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OpenBrowserByUrlProvider && other.url == url;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OpenBrowserByUrlRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `url` of this provider.
  String get url;
}

class _OpenBrowserByUrlProviderElement
    extends AutoDisposeFutureProviderElement<bool> with OpenBrowserByUrlRef {
  _OpenBrowserByUrlProviderElement(super.provider);

  @override
  String get url => (origin as OpenBrowserByUrlProvider).url;
}

String _$shareUrlHash() => r'53ee6be8cda84c6ac68994490517e17ac423ab93';

/// See also [shareUrl].
@ProviderFor(shareUrl)
const shareUrlProvider = ShareUrlFamily();

/// See also [shareUrl].
class ShareUrlFamily extends Family<AsyncValue<bool>> {
  /// See also [shareUrl].
  const ShareUrlFamily();

  /// See also [shareUrl].
  ShareUrlProvider call(
    String url,
  ) {
    return ShareUrlProvider(
      url,
    );
  }

  @override
  ShareUrlProvider getProviderOverride(
    covariant ShareUrlProvider provider,
  ) {
    return call(
      provider.url,
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
  String? get name => r'shareUrlProvider';
}

/// See also [shareUrl].
class ShareUrlProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [shareUrl].
  ShareUrlProvider(
    String url,
  ) : this._internal(
          (ref) => shareUrl(
            ref as ShareUrlRef,
            url,
          ),
          from: shareUrlProvider,
          name: r'shareUrlProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$shareUrlHash,
          dependencies: ShareUrlFamily._dependencies,
          allTransitiveDependencies: ShareUrlFamily._allTransitiveDependencies,
          url: url,
        );

  ShareUrlProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.url,
  }) : super.internal();

  final String url;

  @override
  Override overrideWith(
    FutureOr<bool> Function(ShareUrlRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ShareUrlProvider._internal(
        (ref) => create(ref as ShareUrlRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        url: url,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _ShareUrlProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ShareUrlProvider && other.url == url;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ShareUrlRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `url` of this provider.
  String get url;
}

class _ShareUrlProviderElement extends AutoDisposeFutureProviderElement<bool>
    with ShareUrlRef {
  _ShareUrlProviderElement(super.provider);

  @override
  String get url => (origin as ShareUrlProvider).url;
}

String _$openUrlHash() => r'41295218d6ea91bda7c36e29bb298c287a6fb1ec';

/// See also [openUrl].
@ProviderFor(openUrl)
const openUrlProvider = OpenUrlFamily();

/// See also [openUrl].
class OpenUrlFamily extends Family<AsyncValue<bool>> {
  /// See also [openUrl].
  const OpenUrlFamily();

  /// See also [openUrl].
  OpenUrlProvider call(
    BuildContext context,
    String url,
  ) {
    return OpenUrlProvider(
      context,
      url,
    );
  }

  @override
  OpenUrlProvider getProviderOverride(
    covariant OpenUrlProvider provider,
  ) {
    return call(
      provider.context,
      provider.url,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    _isImageUrlProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    _isImageUrlProvider,
    ...?_isImageUrlProvider.allTransitiveDependencies
  };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'openUrlProvider';
}

/// See also [openUrl].
class OpenUrlProvider extends AutoDisposeFutureProvider<bool> {
  /// See also [openUrl].
  OpenUrlProvider(
    BuildContext context,
    String url,
  ) : this._internal(
          (ref) => openUrl(
            ref as OpenUrlRef,
            context,
            url,
          ),
          from: openUrlProvider,
          name: r'openUrlProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$openUrlHash,
          dependencies: OpenUrlFamily._dependencies,
          allTransitiveDependencies: OpenUrlFamily._allTransitiveDependencies,
          context: context,
          url: url,
        );

  OpenUrlProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.context,
    required this.url,
  }) : super.internal();

  final BuildContext context;
  final String url;

  @override
  Override overrideWith(
    FutureOr<bool> Function(OpenUrlRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: OpenUrlProvider._internal(
        (ref) => create(ref as OpenUrlRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        context: context,
        url: url,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<bool> createElement() {
    return _OpenUrlProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is OpenUrlProvider &&
        other.context == context &&
        other.url == url;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, context.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin OpenUrlRef on AutoDisposeFutureProviderRef<bool> {
  /// The parameter `context` of this provider.
  BuildContext get context;

  /// The parameter `url` of this provider.
  String get url;
}

class _OpenUrlProviderElement extends AutoDisposeFutureProviderElement<bool>
    with OpenUrlRef {
  _OpenUrlProviderElement(super.provider);

  @override
  BuildContext get context => (origin as OpenUrlProvider).context;
  @override
  String get url => (origin as OpenUrlProvider).url;
}

String _$isImageUrlHash() => r'c1900604e1db0e98de79c598b4ec322d221645af';

/// See also [_isImageUrl].
@ProviderFor(_isImageUrl)
const _isImageUrlProvider = _IsImageUrlFamily();

/// See also [_isImageUrl].
class _IsImageUrlFamily extends Family<bool> {
  /// See also [_isImageUrl].
  const _IsImageUrlFamily();

  /// See also [_isImageUrl].
  _IsImageUrlProvider call(
    String url,
  ) {
    return _IsImageUrlProvider(
      url,
    );
  }

  @override
  _IsImageUrlProvider getProviderOverride(
    covariant _IsImageUrlProvider provider,
  ) {
    return call(
      provider.url,
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
  String? get name => r'_isImageUrlProvider';
}

/// See also [_isImageUrl].
class _IsImageUrlProvider extends AutoDisposeProvider<bool> {
  /// See also [_isImageUrl].
  _IsImageUrlProvider(
    String url,
  ) : this._internal(
          (ref) => _isImageUrl(
            ref as _IsImageUrlRef,
            url,
          ),
          from: _isImageUrlProvider,
          name: r'_isImageUrlProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$isImageUrlHash,
          dependencies: _IsImageUrlFamily._dependencies,
          allTransitiveDependencies:
              _IsImageUrlFamily._allTransitiveDependencies,
          url: url,
        );

  _IsImageUrlProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.url,
  }) : super.internal();

  final String url;

  @override
  Override overrideWith(
    bool Function(_IsImageUrlRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _IsImageUrlProvider._internal(
        (ref) => create(ref as _IsImageUrlRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        url: url,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _IsImageUrlProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _IsImageUrlProvider && other.url == url;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, url.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _IsImageUrlRef on AutoDisposeProviderRef<bool> {
  /// The parameter `url` of this provider.
  String get url;
}

class _IsImageUrlProviderElement extends AutoDisposeProviderElement<bool>
    with _IsImageUrlRef {
  _IsImageUrlProviderElement(super.provider);

  @override
  String get url => (origin as _IsImageUrlProvider).url;
}

String _$appbarTextStyleHash() => r'831bec677d811438105caedd0b3152db2db72e02';

/// See also [appbarTextStyle].
@ProviderFor(appbarTextStyle)
final appbarTextStyleProvider = AutoDisposeProvider<TextStyle>.internal(
  appbarTextStyle,
  name: r'appbarTextStyleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appbarTextStyleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AppbarTextStyleRef = AutoDisposeProviderRef<TextStyle>;
String _$screenWidthHash() => r'f9429b6bf80fa9cf2ffb37cba2678dbfcafd523e';

/// See also [screenWidth].
@ProviderFor(screenWidth)
final screenWidthProvider = Provider<double>.internal(
  screenWidth,
  name: r'screenWidthProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$screenWidthHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ScreenWidthRef = ProviderRef<double>;
String _$currentSiteTypeNotifierHash() =>
    r'c73bf72962d97791de69a72d75d769545797e8e7';

/// See also [CurrentSiteTypeNotifier].
@ProviderFor(CurrentSiteTypeNotifier)
final currentSiteTypeNotifierProvider =
    NotifierProvider<CurrentSiteTypeNotifier, SiteType>.internal(
  CurrentSiteTypeNotifier.new,
  name: r'currentSiteTypeNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentSiteTypeNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentSiteTypeNotifier = Notifier<SiteType>;
String _$readableStateNotifierHash() =>
    r'b6d400867e7860fcfc2758c47d287b0bd013485e';

/// See also [ReadableStateNotifier].
@ProviderFor(ReadableStateNotifier)
final readableStateNotifierProvider =
    NotifierProvider<ReadableStateNotifier, int>.internal(
  ReadableStateNotifier.new,
  name: r'readableStateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$readableStateNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReadableStateNotifier = Notifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
