// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'library_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 보관함 탭에서 고른 칸. 앱을 다시 켜도 마지막에 본 칸을 연다(기본 스크랩).

@ProviderFor(LibrarySegmentNotifier)
final librarySegmentProvider = LibrarySegmentNotifierProvider._();

/// 보관함 탭에서 고른 칸. 앱을 다시 켜도 마지막에 본 칸을 연다(기본 스크랩).
final class LibrarySegmentNotifierProvider
    extends $NotifierProvider<LibrarySegmentNotifier, LibrarySegment> {
  /// 보관함 탭에서 고른 칸. 앱을 다시 켜도 마지막에 본 칸을 연다(기본 스크랩).
  LibrarySegmentNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'librarySegmentProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$librarySegmentNotifierHash();

  @$internal
  @override
  LibrarySegmentNotifier create() => LibrarySegmentNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LibrarySegment value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LibrarySegment>(value),
    );
  }
}

String _$librarySegmentNotifierHash() =>
    r'9d63a8c52c51f90e2f108428fa6fdb203d4a65fa';

/// 보관함 탭에서 고른 칸. 앱을 다시 켜도 마지막에 본 칸을 연다(기본 스크랩).

abstract class _$LibrarySegmentNotifier extends $Notifier<LibrarySegment> {
  LibrarySegment build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<LibrarySegment, LibrarySegment>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LibrarySegment, LibrarySegment>,
              LibrarySegment,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 보관함 검색어. null 이면 검색을 닫은 것, '' 이면 열었지만 아직 비어 있음.
///
/// 스크랩 · 히스토리 두 칸이 같이 쓴다(검색 중에 칸을 바꾸면 그 칸에서 같은 말로 찾는다).
/// 보관함 탭을 떠나면 닫는다(`MainEvent.selectTab`).

@ProviderFor(LibrarySearch)
final librarySearchProvider = LibrarySearchProvider._();

/// 보관함 검색어. null 이면 검색을 닫은 것, '' 이면 열었지만 아직 비어 있음.
///
/// 스크랩 · 히스토리 두 칸이 같이 쓴다(검색 중에 칸을 바꾸면 그 칸에서 같은 말로 찾는다).
/// 보관함 탭을 떠나면 닫는다(`MainEvent.selectTab`).
final class LibrarySearchProvider
    extends $NotifierProvider<LibrarySearch, String?> {
  /// 보관함 검색어. null 이면 검색을 닫은 것, '' 이면 열었지만 아직 비어 있음.
  ///
  /// 스크랩 · 히스토리 두 칸이 같이 쓴다(검색 중에 칸을 바꾸면 그 칸에서 같은 말로 찾는다).
  /// 보관함 탭을 떠나면 닫는다(`MainEvent.selectTab`).
  LibrarySearchProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'librarySearchProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$librarySearchHash();

  @$internal
  @override
  LibrarySearch create() => LibrarySearch();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String?>(value),
    );
  }
}

String _$librarySearchHash() => r'db3442292526a6c856ee5627d105a4923bdfd83d';

/// 보관함 검색어. null 이면 검색을 닫은 것, '' 이면 열었지만 아직 비어 있음.
///
/// 스크랩 · 히스토리 두 칸이 같이 쓴다(검색 중에 칸을 바꾸면 그 칸에서 같은 말로 찾는다).
/// 보관함 탭을 떠나면 닫는다(`MainEvent.selectTab`).

abstract class _$LibrarySearch extends $Notifier<String?> {
  String? build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<String?, String?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String?, String?>,
              String?,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 검색어에 맞는 스크랩 · 히스토리 수(세그먼트 숫자). 받는 중이면 null.

@ProviderFor(librarySegmentCounts)
final librarySegmentCountsProvider = LibrarySegmentCountsProvider._();

/// 검색어에 맞는 스크랩 · 히스토리 수(세그먼트 숫자). 받는 중이면 null.

final class LibrarySegmentCountsProvider
    extends
        $FunctionalProvider<
          ({int? bookmarks, int? history}),
          ({int? bookmarks, int? history}),
          ({int? bookmarks, int? history})
        >
    with $Provider<({int? bookmarks, int? history})> {
  /// 검색어에 맞는 스크랩 · 히스토리 수(세그먼트 숫자). 받는 중이면 null.
  LibrarySegmentCountsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'librarySegmentCountsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$librarySegmentCountsHash();

  @$internal
  @override
  $ProviderElement<({int? bookmarks, int? history})> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ({int? bookmarks, int? history}) create(Ref ref) {
    return librarySegmentCounts(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(({int? bookmarks, int? history}) value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<({int? bookmarks, int? history})>(
        value,
      ),
    );
  }
}

String _$librarySegmentCountsHash() =>
    r'8731b753af3cf735b4af4558624e69f67d359d7b';
