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
