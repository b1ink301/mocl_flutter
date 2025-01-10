// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$listItemHash() => r'71699228ec40a6b7d173ef6a4474f5ba31308fb6';

/// See also [listItem].
@ProviderFor(listItem)
final listItemProvider = AutoDisposeProvider<ListItem>.internal(
  listItem,
  name: r'listItemProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$listItemHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ListItemRef = AutoDisposeProviderRef<ListItem>;
String _$markAsReadHash() => r'6654c3c46ba7355d133354c40e4856af1d9574b2';

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
  _MarkAsReadProvider call(
    ListItem listItem,
  ) {
    return _MarkAsReadProvider(
      listItem,
    );
  }

  @override
  _MarkAsReadProvider getProviderOverride(
    covariant _MarkAsReadProvider provider,
  ) {
    return call(
      provider.listItem,
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
  String? get name => r'_markAsReadProvider';
}

/// See also [_markAsRead].
class _MarkAsReadProvider extends AutoDisposeFutureProvider<int> {
  /// See also [_markAsRead].
  _MarkAsReadProvider(
    ListItem listItem,
  ) : this._internal(
          (ref) => _markAsRead(
            ref as _MarkAsReadRef,
            listItem,
          ),
          from: _markAsReadProvider,
          name: r'_markAsReadProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$markAsReadHash,
          dependencies: _MarkAsReadFamily._dependencies,
          allTransitiveDependencies:
              _MarkAsReadFamily._allTransitiveDependencies,
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

String _$detailSmallTitleHash() => r'c59bfa6a97e8dc061c2cb74f872bec76a4530bb1';

/// See also [detailSmallTitle].
@ProviderFor(detailSmallTitle)
final detailSmallTitleProvider = AutoDisposeProvider<String>.internal(
  detailSmallTitle,
  name: r'detailSmallTitleProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$detailSmallTitleHash,
  dependencies: <ProviderOrFamily>[
    listItemProvider,
    currentSiteTypeNotifierProvider
  ],
  allTransitiveDependencies: <ProviderOrFamily>{
    listItemProvider,
    ...?listItemProvider.allTransitiveDependencies,
    currentSiteTypeNotifierProvider,
    ...?currentSiteTypeNotifierProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DetailSmallTitleRef = AutoDisposeProviderRef<String>;
String _$detailTitleHash() => r'01e0668c7ebb3c4e5e495aa3b333ac5b56b3d4bd';

/// See also [detailTitle].
@ProviderFor(detailTitle)
final detailTitleProvider = AutoDisposeProvider<String>.internal(
  detailTitle,
  name: r'detailTitleProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$detailTitleHash,
  dependencies: <ProviderOrFamily>[listItemProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    listItemProvider,
    ...?listItemProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DetailTitleRef = AutoDisposeProviderRef<String>;
String _$detailUrlHash() => r'd92b795d96f57df806f8880c5fb52024fd85975c';

/// See also [detailUrl].
@ProviderFor(detailUrl)
final detailUrlProvider = AutoDisposeProvider<String>.internal(
  detailUrl,
  name: r'detailUrlProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$detailUrlHash,
  dependencies: <ProviderOrFamily>[
    listItemProvider,
    currentSiteTypeNotifierProvider
  ],
  allTransitiveDependencies: <ProviderOrFamily>{
    listItemProvider,
    ...?listItemProvider.allTransitiveDependencies,
    currentSiteTypeNotifierProvider,
    ...?currentSiteTypeNotifierProvider.allTransitiveDependencies
  },
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DetailUrlRef = AutoDisposeProviderRef<String>;
String _$detailsNotifierHash() => r'fe8febd81891393ab0b00fa5ee08cc7b0a19b7c3';

/// See also [DetailsNotifier].
@ProviderFor(DetailsNotifier)
final detailsNotifierProvider =
    AutoDisposeAsyncNotifierProvider<DetailsNotifier, Details>.internal(
  DetailsNotifier.new,
  name: r'detailsNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$detailsNotifierHash,
  dependencies: <ProviderOrFamily>[listItemProvider],
  allTransitiveDependencies: <ProviderOrFamily>{
    listItemProvider,
    ...?listItemProvider.allTransitiveDependencies
  },
);

typedef _$DetailsNotifier = AutoDisposeAsyncNotifier<Details>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
