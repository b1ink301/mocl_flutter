// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getMainDialogHash() => r'82af37b3623f41387ff5edac36c7d75eb9f6a8c7';

/// See also [getMainDialog].
@ProviderFor(getMainDialog)
final getMainDialogProvider = AutoDisposeFutureProvider<Result>.internal(
  getMainDialog,
  name: r'getMainDialogProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getMainDialogHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetMainDialogRef = AutoDisposeFutureProviderRef<Result>;
String _$mainTitleHash() => r'05964e23cd0f5317a5d697a341632e6d5ede3f9e';

/// See also [mainTitle].
@ProviderFor(mainTitle)
final mainTitleProvider = AutoDisposeProvider<String>.internal(
  mainTitle,
  name: r'mainTitleProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$mainTitleHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef MainTitleRef = AutoDisposeProviderRef<String>;
String _$currentSiteTypeHash() => r'e5609ac321ff47b1179915ea5c01000e3f15ead4';

/// See also [currentSiteType].
@ProviderFor(currentSiteType)
final currentSiteTypeProvider = AutoDisposeFutureProvider<SiteType>.internal(
  currentSiteType,
  name: r'currentSiteTypeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentSiteTypeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CurrentSiteTypeRef = AutoDisposeFutureProviderRef<SiteType>;
String _$mainListStateHash() => r'd73b8373603f9b16ba4999c186c42f98d869df3c';

/// See also [MainListState].
@ProviderFor(MainListState)
final mainListStateProvider =
    AsyncNotifierProvider<MainListState, Result>.internal(
  MainListState.new,
  name: r'mainListStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$mainListStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$MainListState = AsyncNotifier<Result>;
String _$currentSiteTypeStateHash() =>
    r'381d1c5a28315321c4eb1d502b341f08457a01cd';

/// See also [CurrentSiteTypeState].
@ProviderFor(CurrentSiteTypeState)
final currentSiteTypeStateProvider =
    NotifierProvider<CurrentSiteTypeState, SiteType>.internal(
  CurrentSiteTypeState.new,
  name: r'currentSiteTypeStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentSiteTypeStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentSiteTypeState = Notifier<SiteType>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
