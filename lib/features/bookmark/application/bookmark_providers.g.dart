// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bookmark_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(bookmarkRepository)
final bookmarkRepositoryProvider = BookmarkRepositoryProvider._();

final class BookmarkRepositoryProvider
    extends
        $FunctionalProvider<
          BookmarkRepository,
          BookmarkRepository,
          BookmarkRepository
        >
    with $Provider<BookmarkRepository> {
  BookmarkRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookmarkRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookmarkRepositoryHash();

  @$internal
  @override
  $ProviderElement<BookmarkRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  BookmarkRepository create(Ref ref) {
    return bookmarkRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(BookmarkRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<BookmarkRepository>(value),
    );
  }
}

String _$bookmarkRepositoryHash() =>
    r'64403ece99acc095b64286f1c48870a0380fe67c';

/// 스크랩 목록(최신순). 추가/삭제 시 invalidate 되어 화면이 갱신된다.

@ProviderFor(BookmarksNotifier)
final bookmarksProvider = BookmarksNotifierProvider._();

/// 스크랩 목록(최신순). 추가/삭제 시 invalidate 되어 화면이 갱신된다.
final class BookmarksNotifierProvider
    extends $AsyncNotifierProvider<BookmarksNotifier, List<BookmarkData>> {
  /// 스크랩 목록(최신순). 추가/삭제 시 invalidate 되어 화면이 갱신된다.
  BookmarksNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'bookmarksProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$bookmarksNotifierHash();

  @$internal
  @override
  BookmarksNotifier create() => BookmarksNotifier();
}

String _$bookmarksNotifierHash() => r'c43fd10b78f6d390df1f174fe2f45859b76be846';

/// 스크랩 목록(최신순). 추가/삭제 시 invalidate 되어 화면이 갱신된다.

abstract class _$BookmarksNotifier extends $AsyncNotifier<List<BookmarkData>> {
  FutureOr<List<BookmarkData>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<BookmarkData>>, List<BookmarkData>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<BookmarkData>>, List<BookmarkData>>,
              AsyncValue<List<BookmarkData>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// 특정 게시물의 북마크 여부 + 토글. 상세 화면 버튼이 사용한다.

@ProviderFor(BookmarkButton)
final bookmarkButtonProvider = BookmarkButtonFamily._();

/// 특정 게시물의 북마크 여부 + 토글. 상세 화면 버튼이 사용한다.
final class BookmarkButtonProvider
    extends $AsyncNotifierProvider<BookmarkButton, bool> {
  /// 특정 게시물의 북마크 여부 + 토글. 상세 화면 버튼이 사용한다.
  BookmarkButtonProvider._({
    required BookmarkButtonFamily super.from,
    required (SiteType, int) super.argument,
  }) : super(
         retry: null,
         name: r'bookmarkButtonProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$bookmarkButtonHash();

  @override
  String toString() {
    return r'bookmarkButtonProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  BookmarkButton create() => BookmarkButton();

  @override
  bool operator ==(Object other) {
    return other is BookmarkButtonProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$bookmarkButtonHash() => r'37071775b85ad07d37183b40b39930565a52bb52';

/// 특정 게시물의 북마크 여부 + 토글. 상세 화면 버튼이 사용한다.

final class BookmarkButtonFamily extends $Family
    with
        $ClassFamilyOverride<
          BookmarkButton,
          AsyncValue<bool>,
          bool,
          FutureOr<bool>,
          (SiteType, int)
        > {
  BookmarkButtonFamily._()
    : super(
        retry: null,
        name: r'bookmarkButtonProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// 특정 게시물의 북마크 여부 + 토글. 상세 화면 버튼이 사용한다.

  BookmarkButtonProvider call(SiteType siteType, int id) =>
      BookmarkButtonProvider._(argument: (siteType, id), from: this);

  @override
  String toString() => r'bookmarkButtonProvider';
}

/// 특정 게시물의 북마크 여부 + 토글. 상세 화면 버튼이 사용한다.

abstract class _$BookmarkButton extends $AsyncNotifier<bool> {
  late final _$args = ref.$arg as (SiteType, int);
  SiteType get siteType => _$args.$1;
  int get id => _$args.$2;

  FutureOr<bool> build(SiteType siteType, int id);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args.$1, _$args.$2));
  }
}
