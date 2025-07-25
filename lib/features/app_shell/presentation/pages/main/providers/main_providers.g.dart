// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$mainTitleHash() => r'0f4a5b000762f1f7f5786eca779b0668c124eb7c';

/// See also [mainTitle].
@ProviderFor(mainTitle)
final mainTitleProvider = AutoDisposeProvider<String>.internal(
  mainTitle,
  name: r'mainTitleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mainTitleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MainTitleRef = AutoDisposeProviderRef<String>;
String _$showAddButtonHash() => r'c32d018e97a3e9f27ebf85919cae75d35efc35f0';

/// See also [showAddButton].
@ProviderFor(showAddButton)
final showAddButtonProvider = AutoDisposeProvider<bool>.internal(
  showAddButton,
  name: r'showAddButtonProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$showAddButtonHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ShowAddButtonRef = AutoDisposeProviderRef<bool>;
String _$isCurrentSiteTypeHash() => r'651fd497bf91f2bee0259aa8b5f729f183aa61e2';

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

/// See also [isCurrentSiteType].
@ProviderFor(isCurrentSiteType)
const isCurrentSiteTypeProvider = IsCurrentSiteTypeFamily();

/// See also [isCurrentSiteType].
class IsCurrentSiteTypeFamily extends Family<bool> {
  /// See also [isCurrentSiteType].
  const IsCurrentSiteTypeFamily();

  /// See also [isCurrentSiteType].
  IsCurrentSiteTypeProvider call(SiteType siteType) {
    return IsCurrentSiteTypeProvider(siteType);
  }

  @override
  IsCurrentSiteTypeProvider getProviderOverride(
    covariant IsCurrentSiteTypeProvider provider,
  ) {
    return call(provider.siteType);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'isCurrentSiteTypeProvider';
}

/// See also [isCurrentSiteType].
class IsCurrentSiteTypeProvider extends AutoDisposeProvider<bool> {
  /// See also [isCurrentSiteType].
  IsCurrentSiteTypeProvider(SiteType siteType)
    : this._internal(
        (ref) => isCurrentSiteType(ref as IsCurrentSiteTypeRef, siteType),
        from: isCurrentSiteTypeProvider,
        name: r'isCurrentSiteTypeProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$isCurrentSiteTypeHash,
        dependencies: IsCurrentSiteTypeFamily._dependencies,
        allTransitiveDependencies:
            IsCurrentSiteTypeFamily._allTransitiveDependencies,
        siteType: siteType,
      );

  IsCurrentSiteTypeProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.siteType,
  }) : super.internal();

  final SiteType siteType;

  @override
  Override overrideWith(bool Function(IsCurrentSiteTypeRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: IsCurrentSiteTypeProvider._internal(
        (ref) => create(ref as IsCurrentSiteTypeRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        siteType: siteType,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<bool> createElement() {
    return _IsCurrentSiteTypeProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is IsCurrentSiteTypeProvider && other.siteType == siteType;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, siteType.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin IsCurrentSiteTypeRef on AutoDisposeProviderRef<bool> {
  /// The parameter `siteType` of this provider.
  SiteType get siteType;
}

class _IsCurrentSiteTypeProviderElement extends AutoDisposeProviderElement<bool>
    with IsCurrentSiteTypeRef {
  _IsCurrentSiteTypeProviderElement(super.provider);

  @override
  SiteType get siteType => (origin as IsCurrentSiteTypeProvider).siteType;
}

String _$setMainItemsHash() => r'64d04ceb9a4f1b1b52e8cf09f6812a5c3ceedb53';

/// See also [setMainItems].
@ProviderFor(setMainItems)
const setMainItemsProvider = SetMainItemsFamily();

/// See also [setMainItems].
class SetMainItemsFamily
    extends Family<AsyncValue<Either<Failure, List<int>>>> {
  /// See also [setMainItems].
  const SetMainItemsFamily();

  /// See also [setMainItems].
  SetMainItemsProvider call(List<MainItem> list) {
    return SetMainItemsProvider(list);
  }

  @override
  SetMainItemsProvider getProviderOverride(
    covariant SetMainItemsProvider provider,
  ) {
    return call(provider.list);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'setMainItemsProvider';
}

/// See also [setMainItems].
class SetMainItemsProvider
    extends AutoDisposeFutureProvider<Either<Failure, List<int>>> {
  /// See also [setMainItems].
  SetMainItemsProvider(List<MainItem> list)
    : this._internal(
        (ref) => setMainItems(ref as SetMainItemsRef, list),
        from: setMainItemsProvider,
        name: r'setMainItemsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$setMainItemsHash,
        dependencies: SetMainItemsFamily._dependencies,
        allTransitiveDependencies:
            SetMainItemsFamily._allTransitiveDependencies,
        list: list,
      );

  SetMainItemsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.list,
  }) : super.internal();

  final List<MainItem> list;

  @override
  Override overrideWith(
    FutureOr<Either<Failure, List<int>>> Function(SetMainItemsRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: SetMainItemsProvider._internal(
        (ref) => create(ref as SetMainItemsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        list: list,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Either<Failure, List<int>>> createElement() {
    return _SetMainItemsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SetMainItemsProvider && other.list == list;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, list.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin SetMainItemsRef
    on AutoDisposeFutureProviderRef<Either<Failure, List<int>>> {
  /// The parameter `list` of this provider.
  List<MainItem> get list;
}

class _SetMainItemsProviderElement
    extends AutoDisposeFutureProviderElement<Either<Failure, List<int>>>
    with SetMainItemsRef {
  _SetMainItemsProviderElement(super.provider);

  @override
  List<MainItem> get list => (origin as SetMainItemsProvider).list;
}

String _$handleAddButtonHash() => r'79e4e6f3f57edbe81784910982d0ff2982ce3c49';

/// See also [handleAddButton].
@ProviderFor(handleAddButton)
const handleAddButtonProvider = HandleAddButtonFamily();

/// See also [handleAddButton].
class HandleAddButtonFamily extends Family<AsyncValue<void>> {
  /// See also [handleAddButton].
  const HandleAddButtonFamily();

  /// See also [handleAddButton].
  HandleAddButtonProvider call(BuildContext context) {
    return HandleAddButtonProvider(context);
  }

  @override
  HandleAddButtonProvider getProviderOverride(
    covariant HandleAddButtonProvider provider,
  ) {
    return call(provider.context);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'handleAddButtonProvider';
}

/// See also [handleAddButton].
class HandleAddButtonProvider extends AutoDisposeFutureProvider<void> {
  /// See also [handleAddButton].
  HandleAddButtonProvider(BuildContext context)
    : this._internal(
        (ref) => handleAddButton(ref as HandleAddButtonRef, context),
        from: handleAddButtonProvider,
        name: r'handleAddButtonProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$handleAddButtonHash,
        dependencies: HandleAddButtonFamily._dependencies,
        allTransitiveDependencies:
            HandleAddButtonFamily._allTransitiveDependencies,
        context: context,
      );

  HandleAddButtonProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.context,
  }) : super.internal();

  final BuildContext context;

  @override
  Override overrideWith(
    FutureOr<void> Function(HandleAddButtonRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HandleAddButtonProvider._internal(
        (ref) => create(ref as HandleAddButtonRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        context: context,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<void> createElement() {
    return _HandleAddButtonProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HandleAddButtonProvider && other.context == context;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, context.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HandleAddButtonRef on AutoDisposeFutureProviderRef<void> {
  /// The parameter `context` of this provider.
  BuildContext get context;
}

class _HandleAddButtonProviderElement
    extends AutoDisposeFutureProviderElement<void>
    with HandleAddButtonRef {
  _HandleAddButtonProviderElement(super.provider);

  @override
  BuildContext get context => (origin as HandleAddButtonProvider).context;
}

String _$mainScaffoldStateHash() => r'e08ed879718fe9af8a42c31c3df1fbd7c053b5eb';

/// See also [mainScaffoldState].
@ProviderFor(mainScaffoldState)
final mainScaffoldStateProvider = Provider<GlobalKey<ScaffoldState>>.internal(
  mainScaffoldState,
  name: r'mainScaffoldStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mainScaffoldStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MainScaffoldStateRef = ProviderRef<GlobalKey<ScaffoldState>>;
String _$mainItemsNotifierHash() => r'937ec4ac5bc0c84ea08fbc43484e4667bc930259';

/// See also [MainItemsNotifier].
@ProviderFor(MainItemsNotifier)
final mainItemsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<
      MainItemsNotifier,
      List<MainItem>
    >.internal(
      MainItemsNotifier.new,
      name: r'mainItemsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mainItemsNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MainItemsNotifier = AutoDisposeAsyncNotifier<List<MainItem>>;
String _$mainSidebarNotifierHash() =>
    r'7cf94c97c85560c6689389f28a0d7eb385adf4c5';

/// See also [MainSidebarNotifier].
@ProviderFor(MainSidebarNotifier)
final mainSidebarNotifierProvider =
    AutoDisposeNotifierProvider<MainSidebarNotifier, bool>.internal(
      MainSidebarNotifier.new,
      name: r'mainSidebarNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$mainSidebarNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$MainSidebarNotifier = AutoDisposeNotifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
