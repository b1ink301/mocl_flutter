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
String _$handleListItemTapHash() => r'51e762ca9468e20dbb00097012708961eb558744';

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

/// See also [handleListItemTap].
@ProviderFor(handleListItemTap)
const handleListItemTapProvider = HandleListItemTapFamily();

/// See also [handleListItemTap].
class HandleListItemTapFamily extends Family<void> {
  /// See also [handleListItemTap].
  const HandleListItemTapFamily();

  /// See also [handleListItemTap].
  HandleListItemTapProvider call(
    BuildContext context,
    ListItem item,
  ) {
    return HandleListItemTapProvider(
      context,
      item,
    );
  }

  @override
  HandleListItemTapProvider getProviderOverride(
    covariant HandleListItemTapProvider provider,
  ) {
    return call(
      provider.context,
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
  String? get name => r'handleListItemTapProvider';
}

/// See also [handleListItemTap].
class HandleListItemTapProvider extends AutoDisposeProvider<void> {
  /// See also [handleListItemTap].
  HandleListItemTapProvider(
    BuildContext context,
    ListItem item,
  ) : this._internal(
          (ref) => handleListItemTap(
            ref as HandleListItemTapRef,
            context,
            item,
          ),
          from: handleListItemTapProvider,
          name: r'handleListItemTapProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$handleListItemTapHash,
          dependencies: HandleListItemTapFamily._dependencies,
          allTransitiveDependencies:
              HandleListItemTapFamily._allTransitiveDependencies,
          context: context,
          item: item,
        );

  HandleListItemTapProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.context,
    required this.item,
  }) : super.internal();

  final BuildContext context;
  final ListItem item;

  @override
  Override overrideWith(
    void Function(HandleListItemTapRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: HandleListItemTapProvider._internal(
        (ref) => create(ref as HandleListItemTapRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        context: context,
        item: item,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<void> createElement() {
    return _HandleListItemTapProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is HandleListItemTapProvider &&
        other.context == context &&
        other.item == item;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, context.hashCode);
    hash = _SystemHash.combine(hash, item.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin HandleListItemTapRef on AutoDisposeProviderRef<void> {
  /// The parameter `context` of this provider.
  BuildContext get context;

  /// The parameter `item` of this provider.
  ListItem get item;
}

class _HandleListItemTapProviderElement extends AutoDisposeProviderElement<void>
    with HandleListItemTapRef {
  _HandleListItemTapProviderElement(super.provider);

  @override
  BuildContext get context => (origin as HandleListItemTapProvider).context;
  @override
  ListItem get item => (origin as HandleListItemTapProvider).item;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
