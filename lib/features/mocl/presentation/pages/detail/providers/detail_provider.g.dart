// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$detailStateHash() => r'451f35a29d6ff472ef1dc759e708092375033efb';

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

abstract class _$DetailState extends BuildlessAutoDisposeAsyncNotifier<Result> {
  late final ListItem item;

  FutureOr<Result> build(
    ListItem item,
  );
}

/// See also [DetailState].
@ProviderFor(DetailState)
const detailStateProvider = DetailStateFamily();

/// See also [DetailState].
class DetailStateFamily extends Family<AsyncValue<Result>> {
  /// See also [DetailState].
  const DetailStateFamily();

  /// See also [DetailState].
  DetailStateProvider call(
    ListItem item,
  ) {
    return DetailStateProvider(
      item,
    );
  }

  @override
  DetailStateProvider getProviderOverride(
    covariant DetailStateProvider provider,
  ) {
    return call(
      provider.item,
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
  String? get name => r'detailStateProvider';
}

/// See also [DetailState].
class DetailStateProvider
    extends AutoDisposeAsyncNotifierProviderImpl<DetailState, Result> {
  /// See also [DetailState].
  DetailStateProvider(
    ListItem item,
  ) : this._internal(
          () => DetailState()..item = item,
          from: detailStateProvider,
          name: r'detailStateProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$detailStateHash,
          dependencies: DetailStateFamily._dependencies,
          allTransitiveDependencies:
              DetailStateFamily._allTransitiveDependencies,
          item: item,
        );

  DetailStateProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.item,
  }) : super.internal();

  final ListItem item;

  @override
  FutureOr<Result> runNotifierBuild(
    covariant DetailState notifier,
  ) {
    return notifier.build(
      item,
    );
  }

  @override
  Override overrideWith(DetailState Function() create) {
    return ProviderOverride(
      origin: this,
      override: DetailStateProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<DetailState, Result> createElement() {
    return _DetailStateProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DetailStateProvider && other.item == item;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, item.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin DetailStateRef on AutoDisposeAsyncNotifierProviderRef<Result> {
  /// The parameter `item` of this provider.
  ListItem get item;
}

class _DetailStateProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<DetailState, Result>
    with DetailStateRef {
  _DetailStateProviderElement(super.provider);

  @override
  ListItem get item => (origin as DetailStateProvider).item;
}

String _$appBarHeightStateHash() => r'8628637257b92c053e59ab6b372302f87047ec88';

/// See also [AppBarHeightState].
@ProviderFor(AppBarHeightState)
final appBarHeightStateProvider =
    AutoDisposeNotifierProvider<AppBarHeightState, double>.internal(
  AppBarHeightState.new,
  name: r'appBarHeightStateProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$appBarHeightStateHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$AppBarHeightState = AutoDisposeNotifier<double>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
