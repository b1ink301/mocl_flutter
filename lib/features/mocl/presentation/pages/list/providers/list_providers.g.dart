// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$listSmallTitleHash() => r'8600e9b6f0e6e14b003e39b178c62cf5cdfac987';

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
String _$listTitleHash() => r'ab4b6238fecc90fb253993e35d662496912dbc0c';

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
String _$mainItemHash() => r'cfdaba790e8aec68dee67a9c1b304af84fef86ea';

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
String _$listItemInfoHash() => r'983444d5e5e409ca032faeb8346b8fe22c0d0954';

/// See also [listItemInfo].
@ProviderFor(listItemInfo)
final listItemInfoProvider = AutoDisposeProvider<MoclListItemInfo>.internal(
  listItemInfo,
  name: r'listItemInfoProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$listItemInfoHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ListItemInfoRef = AutoDisposeProviderRef<MoclListItemInfo>;
String _$paginationStateNotifierHash() =>
    r'a4be4bc4cbd939fa4a8c7b9fe752ad04c93ae40f';

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
String _$itemListNotifierHash() => r'60b0dcd9a7ccc656ab543d863fb911fd1384cb4c';

/// See also [ItemListNotifier].
@ProviderFor(ItemListNotifier)
final itemListNotifierProvider =
    AutoDisposeNotifierProvider<ItemListNotifier, List<ListItem>>.internal(
  ItemListNotifier.new,
  name: r'itemListNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$itemListNotifierHash,
  dependencies: const <ProviderOrFamily>[],
  allTransitiveDependencies: const <ProviderOrFamily>{},
);

typedef _$ItemListNotifier = AutoDisposeNotifier<List<ListItem>>;
String _$pageNumberNotifierHash() =>
    r'78b27cc8affd4d7a1d994e61c34ca3815f10fbf1';

/// See also [PageNumberNotifier].
@ProviderFor(PageNumberNotifier)
final pageNumberNotifierProvider =
    AutoDisposeNotifierProvider<PageNumberNotifier, int>.internal(
  PageNumberNotifier.new,
  name: r'pageNumberNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$pageNumberNotifierHash,
  dependencies: const <ProviderOrFamily>[],
  allTransitiveDependencies: const <ProviderOrFamily>{},
);

typedef _$PageNumberNotifier = AutoDisposeNotifier<int>;
String _$lastIdNotifierHash() => r'4cc27cb92b24dad7c08899752f670a91a8388d63';

/// See also [_LastIdNotifier].
@ProviderFor(_LastIdNotifier)
final _lastIdNotifierProvider =
    AutoDisposeNotifierProvider<_LastIdNotifier, int>.internal(
  _LastIdNotifier.new,
  name: r'_lastIdNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lastIdNotifierHash,
  dependencies: const <ProviderOrFamily>[],
  allTransitiveDependencies: const <ProviderOrFamily>{},
);

typedef _$LastIdNotifier = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
