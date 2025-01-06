// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$listViewModelHash() => r'5cf6c78c1e2c9a110ac69052affec90cb2d8afd4';

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

abstract class _$ListViewModel
    extends BuildlessAutoDisposeNotifier<ListPageState> {
  late final MainItem mainItem;

  ListPageState build(
    MainItem mainItem,
  );
}

/// See also [ListViewModel].
@ProviderFor(ListViewModel)
const listViewModelProvider = ListViewModelFamily();

/// See also [ListViewModel].
class ListViewModelFamily extends Family<ListPageState> {
  /// See also [ListViewModel].
  const ListViewModelFamily();

  /// See also [ListViewModel].
  ListViewModelProvider call(
    MainItem mainItem,
  ) {
    return ListViewModelProvider(
      mainItem,
    );
  }

  @override
  ListViewModelProvider getProviderOverride(
    covariant ListViewModelProvider provider,
  ) {
    return call(
      provider.mainItem,
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
  String? get name => r'listViewModelProvider';
}

/// See also [ListViewModel].
class ListViewModelProvider
    extends AutoDisposeNotifierProviderImpl<ListViewModel, ListPageState> {
  /// See also [ListViewModel].
  ListViewModelProvider(
    MainItem mainItem,
  ) : this._internal(
          () => ListViewModel()..mainItem = mainItem,
          from: listViewModelProvider,
          name: r'listViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$listViewModelHash,
          dependencies: ListViewModelFamily._dependencies,
          allTransitiveDependencies:
              ListViewModelFamily._allTransitiveDependencies,
          mainItem: mainItem,
        );

  ListViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mainItem,
  }) : super.internal();

  final MainItem mainItem;

  @override
  ListPageState runNotifierBuild(
    covariant ListViewModel notifier,
  ) {
    return notifier.build(
      mainItem,
    );
  }

  @override
  Override overrideWith(ListViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: ListViewModelProvider._internal(
        () => create()..mainItem = mainItem,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mainItem: mainItem,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<ListViewModel, ListPageState>
      createElement() {
    return _ListViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ListViewModelProvider && other.mainItem == mainItem;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mainItem.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ListViewModelRef on AutoDisposeNotifierProviderRef<ListPageState> {
  /// The parameter `mainItem` of this provider.
  MainItem get mainItem;
}

class _ListViewModelProviderElement
    extends AutoDisposeNotifierProviderElement<ListViewModel, ListPageState>
    with ListViewModelRef {
  _ListViewModelProviderElement(super.provider);

  @override
  MainItem get mainItem => (origin as ListViewModelProvider).mainItem;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
