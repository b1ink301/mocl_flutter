// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$listStateHash() => r'23da0acec9b32adbe7dd5de547900e12f39ff65b';

/// See also [ListState].
@ProviderFor(ListState)
final listStateProvider = AutoDisposeAsyncNotifierProvider<ListState,
    List<ReadableListItem>>.internal(
  ListState.new,
  name: r'listStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$listStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ListState = AutoDisposeAsyncNotifier<List<ReadableListItem>>;
String _$isReadStateHash() => r'ce9a9620d1ab7b5a31cbd143fc1972f2ec69b4d5';

/// See also [IsReadState].
@ProviderFor(IsReadState)
final isReadStateProvider = NotifierProvider<IsReadState, bool>.internal(
  IsReadState.new,
  name: r'isReadStateProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isReadStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IsReadState = Notifier<bool>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
