// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_list_dlg_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 게시판 추가 화면의 검색어. 화면이 닫히면 자동으로 초기화된다.

@ProviderFor(AddListSearchQuery)
final addListSearchQueryProvider = AddListSearchQueryProvider._();

/// 게시판 추가 화면의 검색어. 화면이 닫히면 자동으로 초기화된다.
final class AddListSearchQueryProvider
    extends $NotifierProvider<AddListSearchQuery, String> {
  /// 게시판 추가 화면의 검색어. 화면이 닫히면 자동으로 초기화된다.
  AddListSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addListSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addListSearchQueryHash();

  @$internal
  @override
  AddListSearchQuery create() => AddListSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$addListSearchQueryHash() =>
    r'ff2ff4201fd4a9ae0cdf443adf8900e7e76e0a9c';

/// 게시판 추가 화면의 검색어. 화면이 닫히면 자동으로 초기화된다.

abstract class _$AddListSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 현재 선택된 사이트가 제공하는 전체 게시판 목록.
/// 담겼는지 여부는 즐겨찾기(favoriteBoardKeys)가 알려주므로 여기선 다루지 않는다.

@ProviderFor(addBoardList)
final addBoardListProvider = AddBoardListProvider._();

/// 현재 선택된 사이트가 제공하는 전체 게시판 목록.
/// 담겼는지 여부는 즐겨찾기(favoriteBoardKeys)가 알려주므로 여기선 다루지 않는다.

final class AddBoardListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MainItem>>,
          List<MainItem>,
          FutureOr<List<MainItem>>
        >
    with $FutureModifier<List<MainItem>>, $FutureProvider<List<MainItem>> {
  /// 현재 선택된 사이트가 제공하는 전체 게시판 목록.
  /// 담겼는지 여부는 즐겨찾기(favoriteBoardKeys)가 알려주므로 여기선 다루지 않는다.
  AddBoardListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addBoardListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addBoardListHash();

  @$internal
  @override
  $FutureProviderElement<List<MainItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MainItem>> create(Ref ref) {
    return addBoardList(ref);
  }
}

String _$addBoardListHash() => r'd6f7b27c9f6f724d8b380680a4bf7846d4c470e0';

/// 지금 들어가 있는 컨테이너(카페 등). null 이면 최상위 목록을 보고 있다.
///
/// 사이트를 바꾸면 들어가 있던 카페는 의미가 없으므로 스스로 빠져나온다.

@ProviderFor(AddDrillDown)
final addDrillDownProvider = AddDrillDownProvider._();

/// 지금 들어가 있는 컨테이너(카페 등). null 이면 최상위 목록을 보고 있다.
///
/// 사이트를 바꾸면 들어가 있던 카페는 의미가 없으므로 스스로 빠져나온다.
final class AddDrillDownProvider
    extends $NotifierProvider<AddDrillDown, MainItem?> {
  /// 지금 들어가 있는 컨테이너(카페 등). null 이면 최상위 목록을 보고 있다.
  ///
  /// 사이트를 바꾸면 들어가 있던 카페는 의미가 없으므로 스스로 빠져나온다.
  AddDrillDownProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addDrillDownProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addDrillDownHash();

  @$internal
  @override
  AddDrillDown create() => AddDrillDown();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(MainItem? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<MainItem?>(value),
    );
  }
}

String _$addDrillDownHash() => r'914faa3910dab753eb547cb4e0962a824d60f62b';

/// 지금 들어가 있는 컨테이너(카페 등). null 이면 최상위 목록을 보고 있다.
///
/// 사이트를 바꾸면 들어가 있던 카페는 의미가 없으므로 스스로 빠져나온다.

abstract class _$AddDrillDown extends $Notifier<MainItem?> {
  MainItem? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<MainItem?, MainItem?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<MainItem?, MainItem?>,
              MainItem?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// [parent] 안의 하위 게시판 목록.
///
/// 카페 메뉴는 거의 바뀌지 않는데 조회는 네트워크 왕복이라, 화면을 오가는
/// 동안 다시 받지 않도록 살려둔다(앱을 다시 켜면 새로 받는다).

@ProviderFor(subMenuList)
final subMenuListProvider = SubMenuListFamily._();

/// [parent] 안의 하위 게시판 목록.
///
/// 카페 메뉴는 거의 바뀌지 않는데 조회는 네트워크 왕복이라, 화면을 오가는
/// 동안 다시 받지 않도록 살려둔다(앱을 다시 켜면 새로 받는다).

final class SubMenuListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MainItem>>,
          List<MainItem>,
          FutureOr<List<MainItem>>
        >
    with $FutureModifier<List<MainItem>>, $FutureProvider<List<MainItem>> {
  /// [parent] 안의 하위 게시판 목록.
  ///
  /// 카페 메뉴는 거의 바뀌지 않는데 조회는 네트워크 왕복이라, 화면을 오가는
  /// 동안 다시 받지 않도록 살려둔다(앱을 다시 켜면 새로 받는다).
  SubMenuListProvider._({
    required SubMenuListFamily super.from,
    required MainItem super.argument,
  }) : super(
         retry: null,
         name: r'subMenuListProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$subMenuListHash();

  @override
  String toString() {
    return r'subMenuListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<MainItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MainItem>> create(Ref ref) {
    final argument = this.argument as MainItem;
    return subMenuList(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SubMenuListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$subMenuListHash() => r'5323de857780c64adff7136185de729cc4ab63c5';

/// [parent] 안의 하위 게시판 목록.
///
/// 카페 메뉴는 거의 바뀌지 않는데 조회는 네트워크 왕복이라, 화면을 오가는
/// 동안 다시 받지 않도록 살려둔다(앱을 다시 켜면 새로 받는다).

final class SubMenuListFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<List<MainItem>>, MainItem> {
  SubMenuListFamily._()
    : super(
        retry: null,
        name: r'subMenuListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// [parent] 안의 하위 게시판 목록.
  ///
  /// 카페 메뉴는 거의 바뀌지 않는데 조회는 네트워크 왕복이라, 화면을 오가는
  /// 동안 다시 받지 않도록 살려둔다(앱을 다시 켜면 새로 받는다).

  SubMenuListProvider call(MainItem parent) =>
      SubMenuListProvider._(argument: parent, from: this);

  @override
  String toString() => r'subMenuListProvider';
}

/// 추가 화면이 실제로 그릴 목록. 드릴다운 여부를 여기서 흡수하므로
/// 위젯에는 '어느 단계인지' 분기가 생기지 않는다.

@ProviderFor(addVisibleBoards)
final addVisibleBoardsProvider = AddVisibleBoardsProvider._();

/// 추가 화면이 실제로 그릴 목록. 드릴다운 여부를 여기서 흡수하므로
/// 위젯에는 '어느 단계인지' 분기가 생기지 않는다.

final class AddVisibleBoardsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<MainItem>>,
          List<MainItem>,
          FutureOr<List<MainItem>>
        >
    with $FutureModifier<List<MainItem>>, $FutureProvider<List<MainItem>> {
  /// 추가 화면이 실제로 그릴 목록. 드릴다운 여부를 여기서 흡수하므로
  /// 위젯에는 '어느 단계인지' 분기가 생기지 않는다.
  AddVisibleBoardsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addVisibleBoardsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addVisibleBoardsHash();

  @$internal
  @override
  $FutureProviderElement<List<MainItem>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<MainItem>> create(Ref ref) {
    return addVisibleBoards(ref);
  }
}

String _$addVisibleBoardsHash() => r'ace37aea2c1c413e14d96559a6aacfb74e538c03';

/// 컨테이너 전환 드롭다운의 열림 상태. 사이트를 바꾸면 닫힌다.

@ProviderFor(AddContainerPickerOpen)
final addContainerPickerOpenProvider = AddContainerPickerOpenProvider._();

/// 컨테이너 전환 드롭다운의 열림 상태. 사이트를 바꾸면 닫힌다.
final class AddContainerPickerOpenProvider
    extends $NotifierProvider<AddContainerPickerOpen, bool> {
  /// 컨테이너 전환 드롭다운의 열림 상태. 사이트를 바꾸면 닫힌다.
  AddContainerPickerOpenProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addContainerPickerOpenProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addContainerPickerOpenHash();

  @$internal
  @override
  AddContainerPickerOpen create() => AddContainerPickerOpen();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$addContainerPickerOpenHash() =>
    r'7779d9eb95097a49b1b5dcfb73d90d95afc0063e';

/// 컨테이너 전환 드롭다운의 열림 상태. 사이트를 바꾸면 닫힌다.

abstract class _$AddContainerPickerOpen extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
