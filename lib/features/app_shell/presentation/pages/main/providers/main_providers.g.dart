// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'main_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(MainItemsNotifier)
const mainItemsNotifierProvider = MainItemsNotifierProvider._();

final class MainItemsNotifierProvider
    extends $AsyncNotifierProvider<MainItemsNotifier, List<MainItem>> {
  const MainItemsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mainItemsNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mainItemsNotifierHash();

  @$internal
  @override
  MainItemsNotifier create() => MainItemsNotifier();
}

String _$mainItemsNotifierHash() => r'937ec4ac5bc0c84ea08fbc43484e4667bc930259';

abstract class _$MainItemsNotifier extends $AsyncNotifier<List<MainItem>> {
  FutureOr<List<MainItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<MainItem>>, List<MainItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<MainItem>>, List<MainItem>>,
              AsyncValue<List<MainItem>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(mainTitle)
const mainTitleProvider = MainTitleProvider._();

final class MainTitleProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const MainTitleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mainTitleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mainTitleHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return mainTitle(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$mainTitleHash() => r'0f4a5b000762f1f7f5786eca779b0668c124eb7c';

@ProviderFor(showAddButton)
const showAddButtonProvider = ShowAddButtonProvider._();

final class ShowAddButtonProvider extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const ShowAddButtonProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'showAddButtonProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$showAddButtonHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return showAddButton(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$showAddButtonHash() => r'c32d018e97a3e9f27ebf85919cae75d35efc35f0';

@ProviderFor(isCurrentSiteType)
const isCurrentSiteTypeProvider = IsCurrentSiteTypeFamily._();

final class IsCurrentSiteTypeProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  const IsCurrentSiteTypeProvider._({
    required IsCurrentSiteTypeFamily super.from,
    required SiteType super.argument,
  }) : super(
         retry: null,
         name: r'isCurrentSiteTypeProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$isCurrentSiteTypeHash();

  @override
  String toString() {
    return r'isCurrentSiteTypeProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    final argument = this.argument as SiteType;
    return isCurrentSiteType(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is IsCurrentSiteTypeProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$isCurrentSiteTypeHash() => r'651fd497bf91f2bee0259aa8b5f729f183aa61e2';

final class IsCurrentSiteTypeFamily extends $Family
    with $FunctionalFamilyOverride<bool, SiteType> {
  const IsCurrentSiteTypeFamily._()
    : super(
        retry: null,
        name: r'isCurrentSiteTypeProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  IsCurrentSiteTypeProvider call(SiteType siteType) =>
      IsCurrentSiteTypeProvider._(argument: siteType, from: this);

  @override
  String toString() => r'isCurrentSiteTypeProvider';
}

@ProviderFor(setMainItems)
const setMainItemsProvider = SetMainItemsFamily._();

final class SetMainItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<Either<Failure, List<int>>>,
          Either<Failure, List<int>>,
          FutureOr<Either<Failure, List<int>>>
        >
    with
        $FutureModifier<Either<Failure, List<int>>>,
        $FutureProvider<Either<Failure, List<int>>> {
  const SetMainItemsProvider._({
    required SetMainItemsFamily super.from,
    required List<MainItem> super.argument,
  }) : super(
         retry: null,
         name: r'setMainItemsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$setMainItemsHash();

  @override
  String toString() {
    return r'setMainItemsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Either<Failure, List<int>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Either<Failure, List<int>>> create(Ref ref) {
    final argument = this.argument as List<MainItem>;
    return setMainItems(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SetMainItemsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$setMainItemsHash() => r'd4de75f3aa63149603539c87fe36edd427912b42';

final class SetMainItemsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Either<Failure, List<int>>>,
          List<MainItem>
        > {
  const SetMainItemsFamily._()
    : super(
        retry: null,
        name: r'setMainItemsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  SetMainItemsProvider call(List<MainItem> list) =>
      SetMainItemsProvider._(argument: list, from: this);

  @override
  String toString() => r'setMainItemsProvider';
}

@ProviderFor(mainScaffoldState)
const mainScaffoldStateProvider = MainScaffoldStateProvider._();

final class MainScaffoldStateProvider
    extends
        $FunctionalProvider<
          GlobalKey<ScaffoldState>,
          GlobalKey<ScaffoldState>,
          GlobalKey<ScaffoldState>
        >
    with $Provider<GlobalKey<ScaffoldState>> {
  const MainScaffoldStateProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mainScaffoldStateProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mainScaffoldStateHash();

  @$internal
  @override
  $ProviderElement<GlobalKey<ScaffoldState>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  GlobalKey<ScaffoldState> create(Ref ref) {
    return mainScaffoldState(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(GlobalKey<ScaffoldState> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<GlobalKey<ScaffoldState>>(value),
    );
  }
}

String _$mainScaffoldStateHash() => r'e08ed879718fe9af8a42c31c3df1fbd7c053b5eb';

@ProviderFor(MainSidebarNotifier)
const mainSidebarNotifierProvider = MainSidebarNotifierProvider._();

final class MainSidebarNotifierProvider
    extends $NotifierProvider<MainSidebarNotifier, bool> {
  const MainSidebarNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mainSidebarNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mainSidebarNotifierHash();

  @$internal
  @override
  MainSidebarNotifier create() => MainSidebarNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$mainSidebarNotifierHash() =>
    r'7cf94c97c85560c6689389f28a0d7eb385adf4c5';

abstract class _$MainSidebarNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
