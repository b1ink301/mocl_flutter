// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$listSmallTitleHash() => r'afb276d55425a9e7f1bf477590ddc03e0236bea3';

/// See also [listSmallTitle].
@ProviderFor(listSmallTitle)
final listSmallTitleProvider = AutoDisposeProvider<String>.internal(
  listSmallTitle,
  name: r'listSmallTitleProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$listSmallTitleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ListSmallTitleRef = AutoDisposeProviderRef<String>;
String _$listTitleHash() => r'334015293ab03a204a6f3c31553fea624aaf7120';

/// See also [listTitle].
@ProviderFor(listTitle)
final listTitleProvider = AutoDisposeProvider<String>.internal(
  listTitle,
  name: r'listTitleProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$listTitleHash,
  dependencies: <ProviderOrFamily>[mainItemProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    mainItemProvider,
    ...?mainItemProvider.allTransitiveDependencies,
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ListTitleRef = AutoDisposeProviderRef<String>;
String _$mainItemHash() => r'bfd8c4675d74a8ec6b735008aa9f59eee3c014e6';

/// See also [mainItem].
@ProviderFor(mainItem)
final mainItemProvider = AutoDisposeProvider<MainItem>.internal(
  mainItem,
  name: r'mainItemProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$mainItemHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef MainItemRef = AutoDisposeProviderRef<MainItem>;
String _$titleHeightHash() => r'db651b17f1a464563f1fbd0d9e130579f3648c25';

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

/// See also [titleHeight].
@ProviderFor(titleHeight)
const titleHeightProvider = TitleHeightFamily();

/// See also [titleHeight].
class TitleHeightFamily extends Family<double> {
  /// See also [titleHeight].
  const TitleHeightFamily();

  /// See also [titleHeight].
  TitleHeightProvider call(String text) {
    return TitleHeightProvider(text);
  }

  @override
  TitleHeightProvider getProviderOverride(
    covariant TitleHeightProvider provider,
  ) {
    return call(provider.text);
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    appbarTextStyleProvider,
    screenWidthProvider,
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
        appbarTextStyleProvider,
        ...?appbarTextStyleProvider.allTransitiveDependencies,
        screenWidthProvider,
        ...?screenWidthProvider.allTransitiveDependencies,
      };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'titleHeightProvider';
}

/// See also [titleHeight].
class TitleHeightProvider extends AutoDisposeProvider<double> {
  /// See also [titleHeight].
  TitleHeightProvider(String text)
    : this._internal(
        (ref) => titleHeight(ref as TitleHeightRef, text),
        from: titleHeightProvider,
        name: r'titleHeightProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$titleHeightHash,
        dependencies: TitleHeightFamily._dependencies,
        allTransitiveDependencies: TitleHeightFamily._allTransitiveDependencies,
        text: text,
      );

  TitleHeightProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.text,
  }) : super.internal();

  final String text;

  @override
  Override overrideWith(double Function(TitleHeightRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: TitleHeightProvider._internal(
        (ref) => create(ref as TitleHeightRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        text: text,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<double> createElement() {
    return _TitleHeightProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TitleHeightProvider && other.text == text;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, text.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TitleHeightRef on AutoDisposeProviderRef<double> {
  /// The parameter `text` of this provider.
  String get text;
}

class _TitleHeightProviderElement extends AutoDisposeProviderElement<double>
    with TitleHeightRef {
  _TitleHeightProviderElement(super.provider);

  @override
  String get text => (origin as TitleHeightProvider).text;
}

String _$extentPrecalculationPolicyHash() =>
    r'97fe21e21592c66ee79750d0632c56bc6f68bc39';

/// See also [extentPrecalculationPolicy].
@ProviderFor(extentPrecalculationPolicy)
final extentPrecalculationPolicyProvider =
    AutoDisposeProvider<ExtentPrecalculationPolicy>.internal(
      extentPrecalculationPolicy,
      name: r'extentPrecalculationPolicyProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$extentPrecalculationPolicyHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExtentPrecalculationPolicyRef =
    AutoDisposeProviderRef<ExtentPrecalculationPolicy>;
String _$reqListDataHash() => r'9648b8f2f547931bd0b0ed69a299bf5f5b8d37ec';

/// See also [reqListData].
@ProviderFor(reqListData)
const reqListDataProvider = ReqListDataFamily();

/// See also [reqListData].
class ReqListDataFamily
    extends Family<AsyncValue<Either<Failure, List<ListItem>>>> {
  /// See also [reqListData].
  const ReqListDataFamily();

  /// See also [reqListData].
  ReqListDataProvider call(int page, LastId lastId) {
    return ReqListDataProvider(page, lastId);
  }

  @override
  ReqListDataProvider getProviderOverride(
    covariant ReqListDataProvider provider,
  ) {
    return call(provider.page, provider.lastId);
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    mainItemProvider,
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
        mainItemProvider,
        ...?mainItemProvider.allTransitiveDependencies,
      };

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'reqListDataProvider';
}

/// See also [reqListData].
class ReqListDataProvider
    extends AutoDisposeFutureProvider<Either<Failure, List<ListItem>>> {
  /// See also [reqListData].
  ReqListDataProvider(int page, LastId lastId)
    : this._internal(
        (ref) => reqListData(ref as ReqListDataRef, page, lastId),
        from: reqListDataProvider,
        name: r'reqListDataProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$reqListDataHash,
        dependencies: ReqListDataFamily._dependencies,
        allTransitiveDependencies: ReqListDataFamily._allTransitiveDependencies,
        page: page,
        lastId: lastId,
      );

  ReqListDataProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.page,
    required this.lastId,
  }) : super.internal();

  final int page;
  final LastId lastId;

  @override
  Override overrideWith(
    FutureOr<Either<Failure, List<ListItem>>> Function(ReqListDataRef provider)
    create,
  ) {
    return ProviderOverride(
      origin: this,
      override: ReqListDataProvider._internal(
        (ref) => create(ref as ReqListDataRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        page: page,
        lastId: lastId,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<Either<Failure, List<ListItem>>>
  createElement() {
    return _ReqListDataProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ReqListDataProvider &&
        other.page == page &&
        other.lastId == lastId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, page.hashCode);
    hash = _SystemHash.combine(hash, lastId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ReqListDataRef
    on AutoDisposeFutureProviderRef<Either<Failure, List<ListItem>>> {
  /// The parameter `page` of this provider.
  int get page;

  /// The parameter `lastId` of this provider.
  LastId get lastId;
}

class _ReqListDataProviderElement
    extends AutoDisposeFutureProviderElement<Either<Failure, List<ListItem>>>
    with ReqListDataRef {
  _ReqListDataProviderElement(super.provider);

  @override
  int get page => (origin as ReqListDataProvider).page;
  @override
  LastId get lastId => (origin as ReqListDataProvider).lastId;
}

String _$initialPageHash() => r'2677bd42115edf23acbcc6771d6620253659e1bc';

/// See also [_initialPage].
@ProviderFor(_initialPage)
final _initialPageProvider = AutoDisposeProvider<int>.internal(
  _initialPage,
  name: r'_initialPageProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$initialPageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef _InitialPageRef = AutoDisposeProviderRef<int>;
String _$listStateNotifierHash() => r'1308fa076bfd1e2ec14c2321b84318de93644460';

/// See also [ListStateNotifier].
@ProviderFor(ListStateNotifier)
final listStateNotifierProvider =
    AutoDisposeNotifierProvider<ListStateNotifier, ListState>.internal(
      ListStateNotifier.new,
      name: r'listStateNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$listStateNotifierHash,
      dependencies: <ProviderOrFamily>{
        mainItemProvider,
        reqListDataProvider,
        sortTypeNotifierProvider,
        _initialPageProvider,
      },
      allTransitiveDependencies: <ProviderOrFamily>{
        mainItemProvider,
        ...?mainItemProvider.allTransitiveDependencies,
        reqListDataProvider,
        ...?reqListDataProvider.allTransitiveDependencies,
        sortTypeNotifierProvider,
        ...?sortTypeNotifierProvider.allTransitiveDependencies,
        _initialPageProvider,
        ...?_initialPageProvider.allTransitiveDependencies,
      },
    );

typedef _$ListStateNotifier = AutoDisposeNotifier<ListState>;
String _$sortTypeNotifierHash() => r'19fe9c4b29d4d6b3d4c1c845099428124cb94554';

/// See also [SortTypeNotifier].
@ProviderFor(SortTypeNotifier)
final sortTypeNotifierProvider =
    AutoDisposeNotifierProvider<SortTypeNotifier, SortType>.internal(
      SortTypeNotifier.new,
      name: r'sortTypeNotifierProvider',
      debugGetCreateSourceHash:
          const bool.fromEnvironment('dart.vm.product')
              ? null
              : _$sortTypeNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$SortTypeNotifier = AutoDisposeNotifier<SortType>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
