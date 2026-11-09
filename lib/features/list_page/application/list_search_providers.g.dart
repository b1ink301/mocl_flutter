// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_search_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 이 게시판에서 글 검색을 할 수 있는지(파서가 검색 주소 · 결과를 읽을 수 있는 사이트).

@ProviderFor(listSearchSupported)
final listSearchSupportedProvider = ListSearchSupportedProvider._();

/// 이 게시판에서 글 검색을 할 수 있는지(파서가 검색 주소 · 결과를 읽을 수 있는 사이트).

final class ListSearchSupportedProvider
    extends $FunctionalProvider<bool, bool, bool>
    with $Provider<bool> {
  /// 이 게시판에서 글 검색을 할 수 있는지(파서가 검색 주소 · 결과를 읽을 수 있는 사이트).
  ListSearchSupportedProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listSearchSupportedProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[mainItemProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          ListSearchSupportedProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = mainItemProvider;

  @override
  String debugGetCreateSourceHash() => _$listSearchSupportedHash();

  @$internal
  @override
  $ProviderElement<bool> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  bool create(Ref ref) {
    return listSearchSupported(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$listSearchSupportedHash() =>
    r'9f6adbea3173cce3c16c84c10085702b378133b0';

/// 제출한 검색어. 입력 중인 글자가 아니라 키보드 "검색" · 최근 검색어를 눌렀을 때만 바뀐다
/// (글자마다 사이트에 요청하지 않으려고). 비어 있으면 검색 전 화면.

@ProviderFor(SearchQuery)
final searchQueryProvider = SearchQueryProvider._();

/// 제출한 검색어. 입력 중인 글자가 아니라 키보드 "검색" · 최근 검색어를 눌렀을 때만 바뀐다
/// (글자마다 사이트에 요청하지 않으려고). 비어 있으면 검색 전 화면.
final class SearchQueryProvider extends $NotifierProvider<SearchQuery, String> {
  /// 제출한 검색어. 입력 중인 글자가 아니라 키보드 "검색" · 최근 검색어를 눌렀을 때만 바뀐다
  /// (글자마다 사이트에 요청하지 않으려고). 비어 있으면 검색 전 화면.
  SearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchQueryProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[mainItemProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          SearchQueryProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = mainItemProvider;

  @override
  String debugGetCreateSourceHash() => _$searchQueryHash();

  @$internal
  @override
  SearchQuery create() => SearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$searchQueryHash() => r'9692c86b301eeef23d308af7e8c4356f1c59ad37';

/// 제출한 검색어. 입력 중인 글자가 아니라 키보드 "검색" · 최근 검색어를 눌렀을 때만 바뀐다
/// (글자마다 사이트에 요청하지 않으려고). 비어 있으면 검색 전 화면.

abstract class _$SearchQuery extends $Notifier<String> {
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

/// 검색 결과 페이징. 첫 쪽 번호는 사이트마다 다르다(`firstSearchPage`).
///
/// 목록과 달리 lastId 의 `id >= lastId` 필터는 쓰지 않는다 — 검색 결과가 id 순서라는
/// 보장이 없다. 대신 이미 받은 글 id 로 중복을 거르고, 새 글이 하나도 없는 쪽이 오면
/// 끝으로 본다(끝을 넘기면 마지막 쪽을 다시 주는 사이트가 있다).

@ProviderFor(SearchPagingController)
final searchPagingControllerProvider = SearchPagingControllerProvider._();

/// 검색 결과 페이징. 첫 쪽 번호는 사이트마다 다르다(`firstSearchPage`).
///
/// 목록과 달리 lastId 의 `id >= lastId` 필터는 쓰지 않는다 — 검색 결과가 id 순서라는
/// 보장이 없다. 대신 이미 받은 글 id 로 중복을 거르고, 새 글이 하나도 없는 쪽이 오면
/// 끝으로 본다(끝을 넘기면 마지막 쪽을 다시 주는 사이트가 있다).
final class SearchPagingControllerProvider
    extends
        $NotifierProvider<
          SearchPagingController,
          PagingController<int, ListItem>
        > {
  /// 검색 결과 페이징. 첫 쪽 번호는 사이트마다 다르다(`firstSearchPage`).
  ///
  /// 목록과 달리 lastId 의 `id >= lastId` 필터는 쓰지 않는다 — 검색 결과가 id 순서라는
  /// 보장이 없다. 대신 이미 받은 글 id 로 중복을 거르고, 새 글이 하나도 없는 쪽이 오면
  /// 끝으로 본다(끝을 넘기면 마지막 쪽을 다시 주는 사이트가 있다).
  SearchPagingControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchPagingControllerProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[mainItemProvider, searchQueryProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          SearchPagingControllerProvider.$allTransitiveDependencies0,
          SearchPagingControllerProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = mainItemProvider;
  static final $allTransitiveDependencies1 = searchQueryProvider;

  @override
  String debugGetCreateSourceHash() => _$searchPagingControllerHash();

  @$internal
  @override
  SearchPagingController create() => SearchPagingController();

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

String _$searchPagingControllerHash() =>
    r'aef3e6f44c2939756e74bfa297103be2eda4aedf';

/// 검색 결과 페이징. 첫 쪽 번호는 사이트마다 다르다(`firstSearchPage`).
///
/// 목록과 달리 lastId 의 `id >= lastId` 필터는 쓰지 않는다 — 검색 결과가 id 순서라는
/// 보장이 없다. 대신 이미 받은 글 id 로 중복을 거르고, 새 글이 하나도 없는 쪽이 오면
/// 끝으로 본다(끝을 넘기면 마지막 쪽을 다시 주는 사이트가 있다).

abstract class _$SearchPagingController
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

@ProviderFor(searchHistoryStore)
final searchHistoryStoreProvider = SearchHistoryStoreProvider._();

final class SearchHistoryStoreProvider
    extends
        $FunctionalProvider<
          SearchHistoryStore,
          SearchHistoryStore,
          SearchHistoryStore
        >
    with $Provider<SearchHistoryStore> {
  SearchHistoryStoreProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchHistoryStoreProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$searchHistoryStoreHash();

  @$internal
  @override
  $ProviderElement<SearchHistoryStore> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SearchHistoryStore create(Ref ref) {
    return searchHistoryStore(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SearchHistoryStore value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SearchHistoryStore>(value),
    );
  }
}

String _$searchHistoryStoreHash() =>
    r'800000b3d96425ef8351c60a5ca0ae7a1ae72ef7';

/// 이 게시판의 최근 검색어(최신이 앞).

@ProviderFor(SearchHistory)
final searchHistoryProvider = SearchHistoryProvider._();

/// 이 게시판의 최근 검색어(최신이 앞).
final class SearchHistoryProvider
    extends $NotifierProvider<SearchHistory, List<String>> {
  /// 이 게시판의 최근 검색어(최신이 앞).
  SearchHistoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'searchHistoryProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[mainItemProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          SearchHistoryProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = mainItemProvider;

  @override
  String debugGetCreateSourceHash() => _$searchHistoryHash();

  @$internal
  @override
  SearchHistory create() => SearchHistory();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<String> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<String>>(value),
    );
  }
}

String _$searchHistoryHash() => r'd311f378a097b4cbde5a01f3d1204129f926ebab';

/// 이 게시판의 최근 검색어(최신이 앞).

abstract class _$SearchHistory extends $Notifier<List<String>> {
  List<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<List<String>, List<String>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<String>, List<String>>,
              List<String>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
