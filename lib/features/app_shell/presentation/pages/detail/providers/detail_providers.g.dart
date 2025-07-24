// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$listItemHash() => r'5979621f5fb9d6c055c046d194e6282673cf181e';

/// See also [listItem].
@ProviderFor(listItem)
final listItemProvider = AutoDisposeProvider<ListItem>.internal(
  listItem,
  name: r'listItemProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$listItemHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ListItemRef = AutoDisposeProviderRef<ListItem>;
String _$markAsReadHash() => r'536841a42c40168bada35f1f45788c0576b6f6a8';

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

/// See also [_markAsRead].
@ProviderFor(_markAsRead)
const _markAsReadProvider = _MarkAsReadFamily();

/// See also [_markAsRead].
class _MarkAsReadFamily extends Family<AsyncValue<int>> {
  /// See also [_markAsRead].
  const _MarkAsReadFamily();

  /// See also [_markAsRead].
  _MarkAsReadProvider call(ListItem listItem) {
    return _MarkAsReadProvider(listItem);
  }

  @override
  _MarkAsReadProvider getProviderOverride(
    covariant _MarkAsReadProvider provider,
  ) {
    return call(provider.listItem);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'_markAsReadProvider';
}

/// See also [_markAsRead].
class _MarkAsReadProvider extends AutoDisposeFutureProvider<int> {
  /// See also [_markAsRead].
  _MarkAsReadProvider(ListItem listItem)
    : this._internal(
        (ref) => _markAsRead(ref as _MarkAsReadRef, listItem),
        from: _markAsReadProvider,
        name: r'_markAsReadProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$markAsReadHash,
        dependencies: _MarkAsReadFamily._dependencies,
        allTransitiveDependencies: _MarkAsReadFamily._allTransitiveDependencies,
        listItem: listItem,
      );

  _MarkAsReadProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.listItem,
  }) : super.internal();

  final ListItem listItem;

  @override
  Override overrideWith(
    FutureOr<int> Function(_MarkAsReadRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: _MarkAsReadProvider._internal(
        (ref) => create(ref as _MarkAsReadRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        listItem: listItem,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<int> createElement() {
    return _MarkAsReadProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is _MarkAsReadProvider && other.listItem == listItem;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, listItem.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin _MarkAsReadRef on AutoDisposeFutureProviderRef<int> {
  /// The parameter `listItem` of this provider.
  ListItem get listItem;
}

class _MarkAsReadProviderElement extends AutoDisposeFutureProviderElement<int>
    with _MarkAsReadRef {
  _MarkAsReadProviderElement(super.provider);

  @override
  ListItem get listItem => (origin as _MarkAsReadProvider).listItem;
}

String _$detailSmallTitleHash() => r'9bc30084263914d4fcba17904ecc6e1f8f20d2b5';

/// See also [detailSmallTitle].
@ProviderFor(detailSmallTitle)
final detailSmallTitleProvider = AutoDisposeProvider<String>.internal(
  detailSmallTitle,
  name: r'detailSmallTitleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$detailSmallTitleHash,
  dependencies: <ProviderOrFamily>[listItemProvider, detailTitleProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    listItemProvider,
    ...?listItemProvider.allTransitiveDependencies,
    detailTitleProvider,
    ...?detailTitleProvider.allTransitiveDependencies,
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DetailSmallTitleRef = AutoDisposeProviderRef<String>;
String _$detailTitleHash() => r'ccdd0e6b61dab49331f7aacf0fd2a63a978f88b5';

/// See also [detailTitle].
@ProviderFor(detailTitle)
final detailTitleProvider = AutoDisposeProvider<String>.internal(
  detailTitle,
  name: r'detailTitleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$detailTitleHash,
  dependencies: <ProviderOrFamily>[listItemProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    listItemProvider,
    ...?listItemProvider.allTransitiveDependencies,
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DetailTitleRef = AutoDisposeProviderRef<String>;
String _$detailUrlHash() => r'a47ce191409d0c8786952a7f6dcfb3a8e016e3b1';

/// See also [detailUrl].
@ProviderFor(detailUrl)
final detailUrlProvider = AutoDisposeProvider<String>.internal(
  detailUrl,
  name: r'detailUrlProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$detailUrlHash,
  dependencies: <ProviderOrFamily>[
    listItemProvider,
    currentSiteTypeNotifierProvider,
  ],
  allTransitiveDependencies: <ProviderOrFamily>{
    listItemProvider,
    ...?listItemProvider.allTransitiveDependencies,
    currentSiteTypeNotifierProvider,
    ...?currentSiteTypeNotifierProvider.allTransitiveDependencies,
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DetailUrlRef = AutoDisposeProviderRef<String>;
String _$detailAppbarHeightHash() =>
    r'2d2ff4d5afa07dcf2b883a9010511a83ad210c63';

/// See also [detailAppbarHeight].
@ProviderFor(detailAppbarHeight)
const detailAppbarHeightProvider = DetailAppbarHeightFamily();

/// See also [detailAppbarHeight].
class DetailAppbarHeightFamily extends Family<double> {
  /// See also [detailAppbarHeight].
  const DetailAppbarHeightFamily();

  /// See also [detailAppbarHeight].
  DetailAppbarHeightProvider call(String text) {
    return DetailAppbarHeightProvider(text);
  }

  @override
  DetailAppbarHeightProvider getProviderOverride(
    covariant DetailAppbarHeightProvider provider,
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
  String? get name => r'detailAppbarHeightProvider';
}

/// See also [detailAppbarHeight].
class DetailAppbarHeightProvider extends AutoDisposeProvider<double> {
  /// See also [detailAppbarHeight].
  DetailAppbarHeightProvider(String text)
    : this._internal(
        (ref) => detailAppbarHeight(ref as DetailAppbarHeightRef, text),
        from: detailAppbarHeightProvider,
        name: r'detailAppbarHeightProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$detailAppbarHeightHash,
        dependencies: DetailAppbarHeightFamily._dependencies,
        allTransitiveDependencies:
            DetailAppbarHeightFamily._allTransitiveDependencies,
        text: text,
      );

  DetailAppbarHeightProvider._internal(
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
  Override overrideWith(
    double Function(DetailAppbarHeightRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DetailAppbarHeightProvider._internal(
        (ref) => create(ref as DetailAppbarHeightRef),
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
    return _DetailAppbarHeightProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DetailAppbarHeightProvider && other.text == text;
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
mixin DetailAppbarHeightRef on AutoDisposeProviderRef<double> {
  /// The parameter `text` of this provider.
  String get text;
}

class _DetailAppbarHeightProviderElement
    extends AutoDisposeProviderElement<double>
    with DetailAppbarHeightRef {
  _DetailAppbarHeightProviderElement(super.provider);

  @override
  String get text => (origin as DetailAppbarHeightProvider).text;
}

String _$detailsNotifierHash() => r'e1128f9b9dda76116dbead4fd943f0e997e42d2c';

/// See also [DetailsNotifier].
@ProviderFor(DetailsNotifier)
final detailsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<DetailsNotifier, Details>.internal(
      DetailsNotifier.new,
      name: r'detailsNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$detailsNotifierHash,
      dependencies: <ProviderOrFamily>[
        listItemProvider,
        detailTitleNotifierProvider,
        _markAsReadProvider,
      ],
      allTransitiveDependencies: <ProviderOrFamily>{
        listItemProvider,
        ...?listItemProvider.allTransitiveDependencies,
        detailTitleNotifierProvider,
        ...?detailTitleNotifierProvider.allTransitiveDependencies,
        _markAsReadProvider,
        ...?_markAsReadProvider.allTransitiveDependencies,
      },
    );

typedef _$DetailsNotifier = AutoDisposeAsyncNotifier<Details>;
String _$detailTitleNotifierHash() =>
    r'2c0eed6e6d6396efab1fdc1b172511429d686e9d';

/// See also [DetailTitleNotifier].
@ProviderFor(DetailTitleNotifier)
final detailTitleNotifierProvider =
    AutoDisposeNotifierProvider<DetailTitleNotifier, String>.internal(
      DetailTitleNotifier.new,
      name: r'detailTitleNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$detailTitleNotifierHash,
      dependencies: <ProviderOrFamily>[listItemProvider, detailTitleProvider],
      allTransitiveDependencies: <ProviderOrFamily>{
        listItemProvider,
        ...?listItemProvider.allTransitiveDependencies,
        detailTitleProvider,
        ...?detailTitleProvider.allTransitiveDependencies,
      },
    );

typedef _$DetailTitleNotifier = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
