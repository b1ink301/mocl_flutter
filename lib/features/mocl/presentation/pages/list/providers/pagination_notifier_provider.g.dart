// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_notifier_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$currentMainItemHash() => r'cca615d8467902c6df2f45e1068ac98ca0897385';

/// See also [CurrentMainItem].
@ProviderFor(CurrentMainItem)
final currentMainItemProvider =
    AutoDisposeNotifierProvider<CurrentMainItem, MainItem?>.internal(
  CurrentMainItem.new,
  name: r'currentMainItemProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentMainItemHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentMainItem = AutoDisposeNotifier<MainItem?>;
String _$paginationNotifierHash() =>
    r'7da616236fa1a7bac566f0910e15d1e77edaf158';

/// See also [PaginationNotifier].
@ProviderFor(PaginationNotifier)
final paginationNotifierProvider =
    AutoDisposeNotifierProvider<PaginationNotifier, PaginationState>.internal(
  PaginationNotifier.new,
  name: r'paginationNotifierProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$paginationNotifierHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$PaginationNotifier = AutoDisposeNotifier<PaginationState>;
String _$currentPageHash() => r'4575a16a731ae7acda418c56b9d35b29bc77753f';

/// See also [_CurrentPage].
@ProviderFor(_CurrentPage)
final _currentPageProvider =
    AutoDisposeNotifierProvider<_CurrentPage, int>.internal(
  _CurrentPage.new,
  name: r'_currentPageProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$currentPageHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentPage = AutoDisposeNotifier<int>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
