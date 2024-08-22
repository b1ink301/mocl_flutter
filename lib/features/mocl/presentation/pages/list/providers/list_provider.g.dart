// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$listStateHash() => r'd86ca0f7eb673f14eb30ee1b2f90770fb9ac1370';

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

abstract class _$ListState
    extends BuildlessAutoDisposeAsyncNotifier<List<ReadableListItem>?> {
  late final MainItem item;

  FutureOr<List<ReadableListItem>?> build({
    required MainItem item,
  });
}

/// See also [ListState].
@ProviderFor(ListState)
const listStateProvider = ListStateFamily();

/// See also [ListState].
class ListStateFamily extends Family<AsyncValue<List<ReadableListItem>?>> {
  /// See also [ListState].
  const ListStateFamily();

  /// See also [ListState].
  ListStateProvider call({
    required MainItem item,
  }) {
    return ListStateProvider(
      item: item,
    );
  }

  @override
  ListStateProvider getProviderOverride(
    covariant ListStateProvider provider,
  ) {
    return call(
      item: provider.item,
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
  String? get name => r'listStateProvider';
}

/// See also [ListState].
class ListStateProvider extends AutoDisposeAsyncNotifierProviderImpl<ListState,
    List<ReadableListItem>?> {
  /// See also [ListState].
  ListStateProvider({
    required MainItem item,
  }) : this._internal(
          () => ListState()..item = item,
          from: listStateProvider,
          name: r'listStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$listStateHash,
          dependencies: ListStateFamily._dependencies,
          allTransitiveDependencies: ListStateFamily._allTransitiveDependencies,
          item: item,
        );

  ListStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.item,
  }) : super.internal();

  final MainItem item;

  @override
  FutureOr<List<ReadableListItem>?> runNotifierBuild(
    covariant ListState notifier,
  ) {
    return notifier.build(
      item: item,
    );
  }

  @override
  Override overrideWith(ListState Function() create) {
    return ProviderOverride(
      origin: this,
      override: ListStateProvider._internal(
        () => create()..item = item,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        item: item,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ListState, List<ReadableListItem>?>
      createElement() {
    return _ListStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ListStateProvider && other.item == item;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, item.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ListStateRef
    on AutoDisposeAsyncNotifierProviderRef<List<ReadableListItem>?> {
  /// The parameter `item` of this provider.
  MainItem get item;
}

class _ListStateProviderElement extends AutoDisposeAsyncNotifierProviderElement<
    ListState, List<ReadableListItem>?> with ListStateRef {
  _ListStateProviderElement(super.provider);

  @override
  MainItem get item => (origin as ListStateProvider).item;
}

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
