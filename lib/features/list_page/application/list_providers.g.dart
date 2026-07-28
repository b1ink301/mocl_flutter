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

/// 페이지네이션이 없는 게시판(한 번 fetch 후 종료).
/// 뷰에서 '더 불러오기' 버튼 노출 여부 판단에도 사용한다.

@ProviderFor(isSinglePageBoard)
final isSinglePageBoardProvider = IsSinglePageBoardProvider._();

/// 페이지네이션이 없는 게시판(한 번 fetch 후 종료).
/// 뷰에서 '더 불러오기' 버튼 노출 여부 판단에도 사용한다.

final class IsSinglePageBoardProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// 페이지네이션이 없는 게시판(한 번 fetch 후 종료).
  /// 뷰에서 '더 불러오기' 버튼 노출 여부 판단에도 사용한다.
  IsSinglePageBoardProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isSinglePageBoardProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[mainItemProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          IsSinglePageBoardProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = mainItemProvider;

  @override
  String debugGetCreateSourceHash() => _$isSinglePageBoardHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return isSinglePageBoard(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$isSinglePageBoardHash() => r'9a121c853f79ab65103ec7c10a2b3b88686cdefd';

/// infinite_scroll_pagination 의 PagingController 를 Riverpod 으로 감싼다.
/// build() 는 mainItem/sortType 이 바뀔 때만 새 컨트롤러를 생성한다.
/// 이전 컨트롤러의 dispose 는 Riverpod 의 ref.onDispose 가 자동 처리.

@ProviderFor(ListPagingController)
final listPagingControllerProvider = ListPagingControllerProvider._();

/// infinite_scroll_pagination 의 PagingController 를 Riverpod 으로 감싼다.
/// build() 는 mainItem/sortType 이 바뀔 때만 새 컨트롤러를 생성한다.
/// 이전 컨트롤러의 dispose 는 Riverpod 의 ref.onDispose 가 자동 처리.
final class ListPagingControllerProvider
    extends
        $NotifierProvider<
          ListPagingController,
          PagingController<int, ListItem>
        > {
  /// infinite_scroll_pagination 의 PagingController 를 Riverpod 으로 감싼다.
  /// build() 는 mainItem/sortType 이 바뀔 때만 새 컨트롤러를 생성한다.
  /// 이전 컨트롤러의 dispose 는 Riverpod 의 ref.onDispose 가 자동 처리.
  ListPagingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listPagingControllerProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[
          mainItemProvider,
          reqListDataProvider,
          sortTypeProvider,
          isSinglePageBoardProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>{
          ListPagingControllerProvider.$allTransitiveDependencies0,
          ListPagingControllerProvider.$allTransitiveDependencies1,
          ListPagingControllerProvider.$allTransitiveDependencies2,
          ListPagingControllerProvider.$allTransitiveDependencies3,
        },
      );

  static final $allTransitiveDependencies0 = mainItemProvider;
  static final $allTransitiveDependencies1 = reqListDataProvider;
  static final $allTransitiveDependencies2 = sortTypeProvider;
  static final $allTransitiveDependencies3 = isSinglePageBoardProvider;

  @override
  String debugGetCreateSourceHash() => _$listPagingControllerHash();

  @$internal
  @override
  ListPagingController create() => ListPagingController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(PagingController<int, ListItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<PagingController<int, ListItem>>(
        value,
      ),
    );
  }
}

String _$listPagingControllerHash() =>
    r'd8e29810847965dee1a8be05f3f4347f03fb5990';

/// infinite_scroll_pagination 의 PagingController 를 Riverpod 으로 감싼다.
/// build() 는 mainItem/sortType 이 바뀔 때만 새 컨트롤러를 생성한다.
/// 이전 컨트롤러의 dispose 는 Riverpod 의 ref.onDispose 가 자동 처리.

abstract class _$ListPagingController
    extends $Notifier<PagingController<int, ListItem>> {
  PagingController<int, ListItem> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              PagingController<int, ListItem>,
              PagingController<int, ListItem>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                PagingController<int, ListItem>,
                PagingController<int, ListItem>
              >,
              PagingController<int, ListItem>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 컨트롤러가 보유한 flat items 를 Riverpod 상태로 노출.
/// detail/리스트 row 등 비-paging 영역에서 인덱스 기반 접근에 사용.

@ProviderFor(PagingItems)
final pagingItemsProvider = PagingItemsProvider._();

/// 컨트롤러가 보유한 flat items 를 Riverpod 상태로 노출.
/// detail/리스트 row 등 비-paging 영역에서 인덱스 기반 접근에 사용.
final class PagingItemsProvider
    extends $NotifierProvider<PagingItems, List<ListItem>> {
  /// 컨트롤러가 보유한 flat items 를 Riverpod 상태로 노출.
  /// detail/리스트 row 등 비-paging 영역에서 인덱스 기반 접근에 사용.
  PagingItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'pagingItemsProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[listPagingControllerProvider],
        $allTransitiveDependencies: <ProviderOrFamily>{
          PagingItemsProvider.$allTransitiveDependencies0,
          PagingItemsProvider.$allTransitiveDependencies1,
          PagingItemsProvider.$allTransitiveDependencies2,
          PagingItemsProvider.$allTransitiveDependencies3,
          PagingItemsProvider.$allTransitiveDependencies4,
        },
      );

  static final $allTransitiveDependencies0 = listPagingControllerProvider;
  static final $allTransitiveDependencies1 =
      ListPagingControllerProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 =
      ListPagingControllerProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies3 =
      ListPagingControllerProvider.$allTransitiveDependencies2;
  static final $allTransitiveDependencies4 =
      ListPagingControllerProvider.$allTransitiveDependencies3;

  @override
  String debugGetCreateSourceHash() => _$pagingItemsHash();

  @$internal
  @override
  PagingItems create() => PagingItems();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<ListItem> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<ListItem>>(value),
    );
  }
}

String _$pagingItemsHash() => r'c8ef6859bc86dca4c6c749b6e3fd4cef0e8a37ed';

/// 컨트롤러가 보유한 flat items 를 Riverpod 상태로 노출.
/// detail/리스트 row 등 비-paging 영역에서 인덱스 기반 접근에 사용.

abstract class _$PagingItems extends $Notifier<List<ListItem>> {
  List<ListItem> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<ListItem>, List<ListItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<ListItem>, List<ListItem>>,
              List<ListItem>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(itemAtIndex)
final itemAtIndexProvider = ItemAtIndexFamily._();

final class ItemAtIndexProvider
    extends $FunctionalProvider<ListItem?, ListItem?, ListItem?>
    with $Provider<ListItem?> {
  ItemAtIndexProvider._({
    required ItemAtIndexFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'itemAtIndexProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = pagingItemsProvider;
  static final $allTransitiveDependencies1 =
      PagingItemsProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 =
      PagingItemsProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies3 =
      PagingItemsProvider.$allTransitiveDependencies2;
  static final $allTransitiveDependencies4 =
      PagingItemsProvider.$allTransitiveDependencies3;
  static final $allTransitiveDependencies5 =
      PagingItemsProvider.$allTransitiveDependencies4;

  @override
  String debugGetCreateSourceHash() => _$itemAtIndexHash();

  @override
  String toString() {
    return r'itemAtIndexProvider'
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
    return itemAtIndex(ref, argument);
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
    return other is ItemAtIndexProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$itemAtIndexHash() => r'd36eceb99789717d9f2f8684e917ef1374b992cd';

final class ItemAtIndexFamily extends $Family
    with $FunctionalFamilyOverride<ListItem?, int> {
  ItemAtIndexFamily._()
    : super(
        retry: null,
        name: r'itemAtIndexProvider',
        dependencies: <ProviderOrFamily>[pagingItemsProvider],
        $allTransitiveDependencies: <ProviderOrFamily>{
          ItemAtIndexProvider.$allTransitiveDependencies0,
          ItemAtIndexProvider.$allTransitiveDependencies1,
          ItemAtIndexProvider.$allTransitiveDependencies2,
          ItemAtIndexProvider.$allTransitiveDependencies3,
          ItemAtIndexProvider.$allTransitiveDependencies4,
          ItemAtIndexProvider.$allTransitiveDependencies5,
        },
        isAutoDispose: true,
      );

  ItemAtIndexProvider call(int index) =>
      ItemAtIndexProvider._(argument: index, from: this);

  @override
  String toString() => r'itemAtIndexProvider';
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
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SortType, SortType>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SortType, SortType>,
              SortType,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
