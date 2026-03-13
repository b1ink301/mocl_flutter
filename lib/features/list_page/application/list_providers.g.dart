// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(mainItem)
final mainItemProvider = MainItemProvider._();

final class MainItemProvider
    extends $FunctionalProvider<MainItem, MainItem, MainItem>
    with $Provider<MainItem> {
  MainItemProvider._()
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

@ProviderFor(listSmallTitle)
final listSmallTitleProvider = ListSmallTitleProvider._();

final class ListSmallTitleProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  ListSmallTitleProvider._()
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

String _$listSmallTitleHash() => r'4d44c4e8d04a365a84741c0d5ce123f586f67b4b';

@ProviderFor(listTitle)
final listTitleProvider = ListTitleProvider._();

final class ListTitleProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  ListTitleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listTitleProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[mainItemProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          ListTitleProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = mainItemProvider;

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

@ProviderFor(titleHeight)
final titleHeightProvider = TitleHeightFamily._();

final class TitleHeightProvider
    extends $FunctionalProvider<double, double, double>
    with $Provider<double> {
  TitleHeightProvider._({
    required TitleHeightFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'titleHeightProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = appbarTextStyleProvider;
  static final $allTransitiveDependencies1 = screenWidthProvider;

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

String _$titleHeightHash() => r'b3ac5f226f086bdf6c69eb2b3e0571faac67a2f3';

final class TitleHeightFamily extends $Family
    with $FunctionalFamilyOverride<double, String> {
  TitleHeightFamily._()
    : super(
        retry: null,
        name: r'titleHeightProvider',
        dependencies: <ProviderOrFamily>[
          appbarTextStyleProvider,
          screenWidthProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>[
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
final reqListDataProvider = ReqListDataFamily._();

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
  ReqListDataProvider._({
    required ReqListDataFamily super.from,
    required (MainItem, SortType, int, LastId) super.argument,
  }) : super(
         retry: null,
         name: r'reqListDataProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = mainItemProvider;

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

String _$reqListDataHash() => r'60e4dc48f0638f8923f851109ea5a803e6a6ca24';

final class ReqListDataFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Either<Failure, List<ListItem>>>,
          (MainItem, SortType, int, LastId)
        > {
  ReqListDataFamily._()
    : super(
        retry: null,
        name: r'reqListDataProvider',
        dependencies: <ProviderOrFamily>[mainItemProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
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

@ProviderFor(PageStateNotifier)
final pageStateProvider = PageStateNotifierProvider._();

final class PageStateNotifierProvider
    extends $AsyncNotifierProvider<PageStateNotifier, PageState> {
  PageStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pageStateProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[
          mainItemProvider,
          reqListDataProvider,
          sortTypeProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>[
          PageStateNotifierProvider.$allTransitiveDependencies0,
          PageStateNotifierProvider.$allTransitiveDependencies1,
          PageStateNotifierProvider.$allTransitiveDependencies2,
        ],
      );

  static final $allTransitiveDependencies0 = mainItemProvider;
  static final $allTransitiveDependencies1 = reqListDataProvider;
  static final $allTransitiveDependencies2 = sortTypeProvider;

  @override
  String debugGetCreateSourceHash() => _$pageStateNotifierHash();

  @$internal
  @override
  PageStateNotifier create() => PageStateNotifier();
}

String _$pageStateNotifierHash() => r'2f2c0c191b8fceb4eb70bbb76e1c9ce7d2ed7cf3';

abstract class _$PageStateNotifier extends $AsyncNotifier<PageState> {
  FutureOr<PageState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<PageState>, PageState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PageState>, PageState>,
              AsyncValue<PageState>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(getListItem)
final getListItemProvider = GetListItemFamily._();

final class GetListItemProvider
    extends $FunctionalProvider<ListItem?, ListItem?, ListItem?>
    with $Provider<ListItem?> {
  GetListItemProvider._({
    required GetListItemFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'getListItemProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = pageStateProvider;
  static final $allTransitiveDependencies1 =
      PageStateNotifierProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 =
      PageStateNotifierProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies3 =
      PageStateNotifierProvider.$allTransitiveDependencies2;

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

String _$getListItemHash() => r'7989487e8b24ef20cc5289b6d5867a16b4f5d79e';

final class GetListItemFamily extends $Family
    with $FunctionalFamilyOverride<ListItem?, int> {
  GetListItemFamily._()
    : super(
        retry: null,
        name: r'getListItemProvider',
        dependencies: <ProviderOrFamily>[pageStateProvider],
        $allTransitiveDependencies: <ProviderOrFamily>{
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
final sortTypeProvider = SortTypeNotifierProvider._();

final class SortTypeNotifierProvider
    extends $NotifierProvider<SortTypeNotifier, SortType> {
  SortTypeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sortTypeProvider',
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
    final ref = this.ref as $Ref<SortType, SortType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SortType, SortType>,
              SortType,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

@ProviderFor(listItem)
final listItemProvider = ListItemProvider._();

final class ListItemProvider
    extends $FunctionalProvider<ListItem?, ListItem?, ListItem?>
    with $Provider<ListItem?> {
  ListItemProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listItemProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[
          listItemIndexProvider,
          getListItemProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>{
          ListItemProvider.$allTransitiveDependencies0,
          ListItemProvider.$allTransitiveDependencies1,
          ListItemProvider.$allTransitiveDependencies2,
          ListItemProvider.$allTransitiveDependencies3,
          ListItemProvider.$allTransitiveDependencies4,
          ListItemProvider.$allTransitiveDependencies5,
        },
      );

  static final $allTransitiveDependencies0 = listItemIndexProvider;
  static final $allTransitiveDependencies1 = getListItemProvider;
  static final $allTransitiveDependencies2 =
      GetListItemProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies3 =
      GetListItemProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies4 =
      GetListItemProvider.$allTransitiveDependencies2;
  static final $allTransitiveDependencies5 =
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
final listItemIndexProvider = ListItemIndexProvider._();

final class ListItemIndexProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  ListItemIndexProvider._()
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
