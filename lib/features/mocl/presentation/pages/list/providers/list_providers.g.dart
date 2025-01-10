// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$listSmallTitleHash() => r'd3cf32183aa651e4a18a261295aaa53e8bdbb03a';

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
String _$listTitleHash() => r'580a1c55011afe7848bc4db83dc68e8cf453cc6e';

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
String _$mainItemHash() => r'edcc40f3617b90c83b8af88d352751c497df0fed';

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
String _$listItemInfoHash() => r'f9ee83816f1b556ec54f44ef8853b10fb61bb92d';

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
    r'd9eef8180b164692e77086315a30b750e91bc9d7';

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
String _$lastIdNotifierHash() => r'596260d92355899deb04bdc3acd36bbf48cc17f8';

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
