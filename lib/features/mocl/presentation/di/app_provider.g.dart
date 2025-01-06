// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$appbarHeightHash() => r'fbc6ef67b6ce5ceea742324a7fd5dcd05b3a7d6b';

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

/// See also [appbarHeight].
@ProviderFor(appbarHeight)
const appbarHeightProvider = AppbarHeightFamily();

/// See also [appbarHeight].
class AppbarHeightFamily extends Family<double> {
  /// See also [appbarHeight].
  const AppbarHeightFamily();

  /// See also [appbarHeight].
  AppbarHeightProvider call(
    String text,
    TextStyle style,
    double screenWidth,
  ) {
    return AppbarHeightProvider(
      text,
      style,
      screenWidth,
    );
  }

  @override
  AppbarHeightProvider getProviderOverride(
    covariant AppbarHeightProvider provider,
  ) {
    return call(
      provider.text,
      provider.style,
      provider.screenWidth,
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
  String? get name => r'appbarHeightProvider';
}

/// See also [appbarHeight].
class AppbarHeightProvider extends AutoDisposeProvider<double> {
  /// See also [appbarHeight].
  AppbarHeightProvider(
    String text,
    TextStyle style,
    double screenWidth,
  ) : this._internal(
          (ref) => appbarHeight(
            ref as AppbarHeightRef,
            text,
            style,
            screenWidth,
          ),
          from: appbarHeightProvider,
          name: r'appbarHeightProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$appbarHeightHash,
          dependencies: AppbarHeightFamily._dependencies,
          allTransitiveDependencies:
              AppbarHeightFamily._allTransitiveDependencies,
          text: text,
          style: style,
          screenWidth: screenWidth,
        );

  AppbarHeightProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.text,
    required this.style,
    required this.screenWidth,
  }) : super.internal();

  final String text;
  final TextStyle style;
  final double screenWidth;

  @override
  Override overrideWith(
    double Function(AppbarHeightRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AppbarHeightProvider._internal(
        (ref) => create(ref as AppbarHeightRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        text: text,
        style: style,
        screenWidth: screenWidth,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<double> createElement() {
    return _AppbarHeightProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AppbarHeightProvider &&
        other.text == text &&
        other.style == style &&
        other.screenWidth == screenWidth;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, text.hashCode);
    hash = _SystemHash.combine(hash, style.hashCode);
    hash = _SystemHash.combine(hash, screenWidth.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AppbarHeightRef on AutoDisposeProviderRef<double> {
  /// The parameter `text` of this provider.
  String get text;

  /// The parameter `style` of this provider.
  TextStyle get style;

  /// The parameter `screenWidth` of this provider.
  double get screenWidth;
}

class _AppbarHeightProviderElement extends AutoDisposeProviderElement<double>
    with AppbarHeightRef {
  _AppbarHeightProviderElement(super.provider);

  @override
  String get text => (origin as AppbarHeightProvider).text;
  @override
  TextStyle get style => (origin as AppbarHeightProvider).style;
  @override
  double get screenWidth => (origin as AppbarHeightProvider).screenWidth;
}

String _$getAppVersionHash() => r'b0deb54eb91217529aa2202c0f630d4503ec3ebb';

/// See also [getAppVersion].
@ProviderFor(getAppVersion)
final getAppVersionProvider =
    AutoDisposeFutureProvider<Either<Failure, String>>.internal(
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
typedef GetAppVersionRef
    = AutoDisposeFutureProviderRef<Either<Failure, String>>;
String _$clearDataHash() => r'3d8bb129cd26c10c0549360ec50f8c6ab0e1db59';

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
String _$currentSiteTypeHash() => r'afebb6f18ae1a982c0e3aac960798dff831432ea';

/// See also [CurrentSiteType].
@ProviderFor(CurrentSiteType)
final currentSiteTypeProvider =
    AutoDisposeNotifierProvider<CurrentSiteType, SiteType>.internal(
  CurrentSiteType.new,
  name: r'currentSiteTypeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentSiteTypeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentSiteType = AutoDisposeNotifier<SiteType>;
String _$readableStateHash() => r'8264a316bb7d1b17a70a7510877be90ee5098952';

/// See also [ReadableState].
@ProviderFor(ReadableState)
final readableStateProvider =
    AutoDisposeNotifierProvider<ReadableState, int>.internal(
  ReadableState.new,
  name: r'readableStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$readableStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ReadableState = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
