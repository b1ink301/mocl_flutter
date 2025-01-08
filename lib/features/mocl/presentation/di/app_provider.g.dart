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

String _$getAppVersionHash() => r'd1deb1e74150f4b0b16f1afca8747fc4a641c4a2';

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

String _$appRouterHash() => r'2678e2635ae636e3c33d42456684dc183738e3ff';

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
String _$currentSiteTypeNotifierHash() =>
    r'07f07f4072252d6278460b69b2bc7c6fac864046';

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
