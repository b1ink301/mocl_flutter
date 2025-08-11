// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(listSmallTitle)
const listSmallTitleProvider = ListSmallTitleProvider._();

final class ListSmallTitleProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const ListSmallTitleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listSmallTitleProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$listSmallTitleHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return listSmallTitle(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$listSmallTitleHash() => r'afb276d55425a9e7f1bf477590ddc03e0236bea3';

@ProviderFor(listTitle)
const listTitleProvider = ListTitleProvider._();

final class ListTitleProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  const ListTitleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listTitleProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[mainItemProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          ListTitleProvider.$allTransitiveDependencies0,
        ],
      );

  static const $allTransitiveDependencies0 = mainItemProvider;

  @override
  String debugGetCreateSourceHash() => _$listTitleHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return listTitle(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$listTitleHash() => r'334015293ab03a204a6f3c31553fea624aaf7120';

@ProviderFor(mainItem)
const mainItemProvider = MainItemProvider._();

final class MainItemProvider
    extends $FunctionalProvider<MainItem, MainItem, MainItem>
    with $Provider<MainItem> {
  const MainItemProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'mainItemProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$mainItemHash();

  @$internal
  @override
  $ProviderElement<MainItem> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  MainItem create(Ref ref) {
    return mainItem(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MainItem value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MainItem>(value),
    );
  }
}

String _$mainItemHash() => r'bfd8c4675d74a8ec6b735008aa9f59eee3c014e6';

@ProviderFor(titleHeight)
const titleHeightProvider = TitleHeightFamily._();

final class TitleHeightProvider
    extends $FunctionalProvider<double, double, double>
    with $Provider<double> {
  const TitleHeightProvider._({
    required TitleHeightFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'titleHeightProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = appbarTextStyleProvider;
  static const $allTransitiveDependencies1 = screenWidthProvider;

  @override
  String debugGetCreateSourceHash() => _$titleHeightHash();

  @override
  String toString() {
    return r'titleHeightProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<double> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  double create(Ref ref) {
    final argument = this.argument as String;
    return titleHeight(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is TitleHeightProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$titleHeightHash() => r'db651b17f1a464563f1fbd0d9e130579f3648c25';

final class TitleHeightFamily extends $Family
    with $FunctionalFamilyOverride<double, String> {
  const TitleHeightFamily._()
    : super(
        retry: null,
        name: r'titleHeightProvider',
        dependencies: const <ProviderOrFamily>[
          appbarTextStyleProvider,
          screenWidthProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          TitleHeightProvider.$allTransitiveDependencies0,
          TitleHeightProvider.$allTransitiveDependencies1,
        ],
        isAutoDispose: true,
      );

  TitleHeightProvider call(String text) =>
      TitleHeightProvider._(argument: text, from: this);

  @override
  String toString() => r'titleHeightProvider';
}

@ProviderFor(reqListData)
const reqListDataProvider = ReqListDataFamily._();

final class ReqListDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<Either<Failure, List<ListItem>>>,
          Either<Failure, List<ListItem>>,
          FutureOr<Either<Failure, List<ListItem>>>
        >
    with
        $FutureModifier<Either<Failure, List<ListItem>>>,
        $FutureProvider<Either<Failure, List<ListItem>>> {
  const ReqListDataProvider._({
    required ReqListDataFamily super.from,
    required (MainItem, SortType, int, LastId) super.argument,
  }) : super(
         retry: null,
         name: r'reqListDataProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = mainItemProvider;

  @override
  String debugGetCreateSourceHash() => _$reqListDataHash();

  @override
  String toString() {
    return r'reqListDataProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  $FutureProviderElement<Either<Failure, List<ListItem>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Either<Failure, List<ListItem>>> create(Ref ref) {
    final argument = this.argument as (MainItem, SortType, int, LastId);
    return reqListData(ref, argument.$1, argument.$2, argument.$3, argument.$4);
  }

  @override
  bool operator ==(Object other) {
    return other is ReqListDataProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$reqListDataHash() => r'764566d49278bc1cfed67831f7d982da6a7e6764';

final class ReqListDataFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Either<Failure, List<ListItem>>>,
          (MainItem, SortType, int, LastId)
        > {
  const ReqListDataFamily._()
    : super(
        retry: null,
        name: r'reqListDataProvider',
        dependencies: const <ProviderOrFamily>[mainItemProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          ReqListDataProvider.$allTransitiveDependencies0,
        ],
        isAutoDispose: true,
      );

  ReqListDataProvider call(
    MainItem mainItem,
    SortType sortType,
    int page,
    LastId lastId,
  ) => ReqListDataProvider._(
    argument: (mainItem, sortType, page, lastId),
    from: this,
  );

  @override
  String toString() => r'reqListDataProvider';
}

@ProviderFor(ListStateNotifier)
const listStateNotifierProvider = ListStateNotifierProvider._();

final class ListStateNotifierProvider
    extends $AsyncNotifierProvider<ListStateNotifier, ListState> {
  const ListStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listStateNotifierProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[
          mainItemProvider,
          reqListDataProvider,
          sortTypeNotifierProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          ListStateNotifierProvider.$allTransitiveDependencies0,
          ListStateNotifierProvider.$allTransitiveDependencies1,
          ListStateNotifierProvider.$allTransitiveDependencies2,
        ],
      );

  static const $allTransitiveDependencies0 = mainItemProvider;
  static const $allTransitiveDependencies1 = reqListDataProvider;
  static const $allTransitiveDependencies2 = sortTypeNotifierProvider;

  @override
  String debugGetCreateSourceHash() => _$listStateNotifierHash();

  @$internal
  @override
  ListStateNotifier create() => ListStateNotifier();
}

String _$listStateNotifierHash() => r'4a96d8d3a2acec4d2bbf17d5bb4229a00b7ebc10';

abstract class _$ListStateNotifier extends $AsyncNotifier<ListState> {
  FutureOr<ListState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<ListState>, ListState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ListState>, ListState>,
              AsyncValue<ListState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(getListItem)
const getListItemProvider = GetListItemFamily._();

final class GetListItemProvider
    extends $FunctionalProvider<ListItem?, ListItem?, ListItem?>
    with $Provider<ListItem?> {
  const GetListItemProvider._({
    required GetListItemFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'getListItemProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static const $allTransitiveDependencies0 = listStateNotifierProvider;
  static const $allTransitiveDependencies1 =
      ListStateNotifierProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies2 =
      ListStateNotifierProvider.$allTransitiveDependencies1;
  static const $allTransitiveDependencies3 =
      ListStateNotifierProvider.$allTransitiveDependencies2;

  @override
  String debugGetCreateSourceHash() => _$getListItemHash();

  @override
  String toString() {
    return r'getListItemProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<ListItem?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ListItem? create(Ref ref) {
    final argument = this.argument as int;
    return getListItem(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ListItem? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ListItem?>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetListItemProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getListItemHash() => r'acb63b2c6cf355f6e35c579dcc668adb147997f8';

final class GetListItemFamily extends $Family
    with $FunctionalFamilyOverride<ListItem?, int> {
  const GetListItemFamily._()
    : super(
        retry: null,
        name: r'getListItemProvider',
        dependencies: const <ProviderOrFamily>[listStateNotifierProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>{
          GetListItemProvider.$allTransitiveDependencies0,
          GetListItemProvider.$allTransitiveDependencies1,
          GetListItemProvider.$allTransitiveDependencies2,
          GetListItemProvider.$allTransitiveDependencies3,
        },
        isAutoDispose: true,
      );

  GetListItemProvider call(int index) =>
      GetListItemProvider._(argument: index, from: this);

  @override
  String toString() => r'getListItemProvider';
}

@ProviderFor(SortTypeNotifier)
const sortTypeNotifierProvider = SortTypeNotifierProvider._();

final class SortTypeNotifierProvider
    extends $NotifierProvider<SortTypeNotifier, SortType> {
  const SortTypeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sortTypeNotifierProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sortTypeNotifierHash();

  @$internal
  @override
  SortTypeNotifier create() => SortTypeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SortType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SortType>(value),
    );
  }
}

String _$sortTypeNotifierHash() => r'19fe9c4b29d4d6b3d4c1c845099428124cb94554';

abstract class _$SortTypeNotifier extends $Notifier<SortType> {
  SortType build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<SortType, SortType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SortType, SortType>,
              SortType,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(listItem)
const listItemProvider = ListItemProvider._();

final class ListItemProvider
    extends $FunctionalProvider<ListItem?, ListItem?, ListItem?>
    with $Provider<ListItem?> {
  const ListItemProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listItemProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[
          listItemIndexProvider,
          getListItemProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>{
          ListItemProvider.$allTransitiveDependencies0,
          ListItemProvider.$allTransitiveDependencies1,
          ListItemProvider.$allTransitiveDependencies2,
          ListItemProvider.$allTransitiveDependencies3,
          ListItemProvider.$allTransitiveDependencies4,
          ListItemProvider.$allTransitiveDependencies5,
        },
      );

  static const $allTransitiveDependencies0 = listItemIndexProvider;
  static const $allTransitiveDependencies1 = getListItemProvider;
  static const $allTransitiveDependencies2 =
      GetListItemProvider.$allTransitiveDependencies0;
  static const $allTransitiveDependencies3 =
      GetListItemProvider.$allTransitiveDependencies1;
  static const $allTransitiveDependencies4 =
      GetListItemProvider.$allTransitiveDependencies2;
  static const $allTransitiveDependencies5 =
      GetListItemProvider.$allTransitiveDependencies3;

  @override
  String debugGetCreateSourceHash() => _$listItemHash();

  @$internal
  @override
  $ProviderElement<ListItem?> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ListItem? create(Ref ref) {
    return listItem(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ListItem? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ListItem?>(value),
    );
  }
}

String _$listItemHash() => r'cfa14f06c2d46a8696f395988a6e6969451ef49d';

@ProviderFor(listItemIndex)
const listItemIndexProvider = ListItemIndexProvider._();

final class ListItemIndexProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const ListItemIndexProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listItemIndexProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$listItemIndexHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return listItemIndex(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$listItemIndexHash() => r'70b52c3cc678f4bd8e917a5b7a17378665040e04';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
