// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$listSmallTitleHash() => r'df68719e3dc6782a0f6313627f1ae6118734791c';

/// See also [listSmallTitle].
@ProviderFor(listSmallTitle)
final listSmallTitleProvider = AutoDisposeProvider<String>.internal(
  listSmallTitle,
  name: r'listSmallTitleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$listSmallTitleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ListSmallTitleRef = AutoDisposeProviderRef<String>;
String _$listTitleHash() => r'f66173a39402b6859adc850630de48fbb04ba43e';

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
    ...?mainItemProvider.allTransitiveDependencies
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
  TitleHeightProvider call(
    String text,
  ) {
    return TitleHeightProvider(
      text,
    );
  }

  @override
  TitleHeightProvider getProviderOverride(
    covariant TitleHeightProvider provider,
  ) {
    return call(
      provider.text,
    );
  }

  static final Iterable<ProviderOrFamily> _dependencies = <ProviderOrFamily>[
    appbarTextStyleProvider,
    screenWidthProvider
  ];

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static final Iterable<ProviderOrFamily> _allTransitiveDependencies =
      <ProviderOrFamily>{
    appbarTextStyleProvider,
    ...?appbarTextStyleProvider.allTransitiveDependencies,
    screenWidthProvider,
    ...?screenWidthProvider.allTransitiveDependencies
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
  TitleHeightProvider(
    String text,
  ) : this._internal(
          (ref) => titleHeight(
            ref as TitleHeightRef,
            text,
          ),
          from: titleHeightProvider,
          name: r'titleHeightProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$titleHeightHash,
          dependencies: TitleHeightFamily._dependencies,
          allTransitiveDependencies:
              TitleHeightFamily._allTransitiveDependencies,
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
  Override overrideWith(
    double Function(TitleHeightRef provider) create,
  ) {
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
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$extentPrecalculationPolicyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExtentPrecalculationPolicyRef
    = AutoDisposeProviderRef<ExtentPrecalculationPolicy>;
String _$paginationStateNotifierHash() =>
    r'2884404010049898451a43f6b454fdc1a8ed4a56';

/// See also [PaginationStateNotifier].
@ProviderFor(PaginationStateNotifier)
final paginationStateNotifierProvider = AutoDisposeAsyncNotifierProvider<
    PaginationStateNotifier, PaginationState>.internal(
  PaginationStateNotifier.new,
  name: r'paginationStateNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paginationStateNotifierHash,
  dependencies: <ProviderOrFamily>{
    mainItemProvider,
    pageNumberNotifierProvider,
    itemListNotifierProvider,
    _lastIdNotifierProvider
  },
  allTransitiveDependencies: <ProviderOrFamily>{
    mainItemProvider,
    ...?mainItemProvider.allTransitiveDependencies,
    pageNumberNotifierProvider,
    ...?pageNumberNotifierProvider.allTransitiveDependencies,
    itemListNotifierProvider,
    ...?itemListNotifierProvider.allTransitiveDependencies,
    _lastIdNotifierProvider,
    ...?_lastIdNotifierProvider.allTransitiveDependencies
  },
);

typedef _$PaginationStateNotifier = AutoDisposeAsyncNotifier<PaginationState>;
String _$itemListNotifierHash() => r'36d5e456170e4e4b99b68b1eaf59e7702eab5a9c';

/// See also [ItemListNotifier].
@ProviderFor(ItemListNotifier)
final itemListNotifierProvider =
    AutoDisposeNotifierProvider<ItemListNotifier, List<ListItem>>.internal(
  ItemListNotifier.new,
  name: r'itemListNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$itemListNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ItemListNotifier = AutoDisposeNotifier<List<ListItem>>;
String _$pageNumberNotifierHash() =>
    r'8e9dc62088bde73d120c269dc2b697cb3a5a80b2';

/// See also [PageNumberNotifier].
@ProviderFor(PageNumberNotifier)
final pageNumberNotifierProvider =
    AutoDisposeNotifierProvider<PageNumberNotifier, int>.internal(
  PageNumberNotifier.new,
  name: r'pageNumberNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pageNumberNotifierHash,
  dependencies: <ProviderOrFamily>[
    mainItemProvider,
    currentSiteTypeNotifierProvider
  ],
  allTransitiveDependencies: <ProviderOrFamily>{
    mainItemProvider,
    ...?mainItemProvider.allTransitiveDependencies,
    currentSiteTypeNotifierProvider,
    ...?currentSiteTypeNotifierProvider.allTransitiveDependencies
  },
);

typedef _$PageNumberNotifier = AutoDisposeNotifier<int>;
String _$lastIdNotifierHash() => r'b9513f7960d1375c814b52d14f9d5c119425e57c';

/// See also [_LastIdNotifier].
@ProviderFor(_LastIdNotifier)
final _lastIdNotifierProvider =
    AutoDisposeNotifierProvider<_LastIdNotifier, int>.internal(
  _LastIdNotifier.new,
  name: r'_lastIdNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lastIdNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LastIdNotifier = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
