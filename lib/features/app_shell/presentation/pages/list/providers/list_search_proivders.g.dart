// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_search_proivders.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$reqSearchListDataHash() => r'e35e23b8910273d83af1fb5a8811f0b979102b0d';

/// See also [reqSearchListData].
@ProviderFor(reqSearchListData)
final reqSearchListDataProvider =
    AutoDisposeFutureProvider<Either<Failure, List<ListItem>>>.internal(
      reqSearchListData,
      name: r'reqSearchListDataProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$reqSearchListDataHash,
      dependencies: <ProviderOrFamily>[
        mainItemProvider,
        keywordNotifierProvider,
      ],
      allTransitiveDependencies: <ProviderOrFamily>{
        mainItemProvider,
        ...?mainItemProvider.allTransitiveDependencies,
        keywordNotifierProvider,
        ...?keywordNotifierProvider.allTransitiveDependencies,
      },
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ReqSearchListDataRef =
    AutoDisposeFutureProviderRef<Either<Failure, List<ListItem>>>;
String _$keywordNotifierHash() => r'71b08ed24030b6db2641eadccaee061fba69673f';

/// See also [KeywordNotifier].
@ProviderFor(KeywordNotifier)
final keywordNotifierProvider =
    AutoDisposeNotifierProvider<KeywordNotifier, String>.internal(
      KeywordNotifier.new,
      name: r'keywordNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$keywordNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$KeywordNotifier = AutoDisposeNotifier<String>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
