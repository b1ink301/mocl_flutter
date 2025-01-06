// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getAppVersionHash() => r'62d8fc0a04be7a3d9a27d135a5b397a5ddbf9677';

/// See also [getAppVersion].
@ProviderFor(getAppVersion)
final getAppVersionProvider = AutoDisposeFutureProvider<String>.internal(
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
typedef GetAppVersionRef = AutoDisposeFutureProviderRef<String>;
String _$currentSiteTypeHash() => r'afebb6f18ae1a982c0e3aac960798dff831432ea';

/// See also [CurrentSiteType].
@ProviderFor(CurrentSiteType)
final currentSiteTypeProvider =
    AutoDisposeNotifierProvider<CurrentSiteType, SiteType>.internal(
  CurrentSiteType.new,
  name: r'currentSiteTypeProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentSiteTypeHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentSiteType = AutoDisposeNotifier<SiteType>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
