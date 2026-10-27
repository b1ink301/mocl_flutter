// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(listItem)
final listItemProvider = ListItemProvider._();

final class ListItemProvider
    extends $FunctionalProvider<ListItem, ListItem, ListItem>
    with $Provider<ListItem> {
  ListItemProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'listItemProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$listItemHash();

  @$internal
  @override
  $ProviderElement<ListItem> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  ListItem create(Ref ref) {
    return listItem(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ListItem value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ListItem>(value),
    );
  }
}

String _$listItemHash() => r'5979621f5fb9d6c055c046d194e6282673cf181e';

/// 이 상세 화면이 읽는 사이트.
///
/// 보통은 전역 [currentSiteTypeProvider] 와 같다. 본문 링크로 다른 사이트 글을
/// 열 때는 ProviderScope 에서 그 사이트로 교체한다 — 전역 값을 바꾸면 뒤에 쌓인
/// 목록 화면까지 다른 사이트로 바뀌어 버린다.

@ProviderFor(detailSiteType)
final detailSiteTypeProvider = DetailSiteTypeProvider._();

/// 이 상세 화면이 읽는 사이트.
///
/// 보통은 전역 [currentSiteTypeProvider] 와 같다. 본문 링크로 다른 사이트 글을
/// 열 때는 ProviderScope 에서 그 사이트로 교체한다 — 전역 값을 바꾸면 뒤에 쌓인
/// 목록 화면까지 다른 사이트로 바뀌어 버린다.

final class DetailSiteTypeProvider
    extends $FunctionalProvider<SiteType, SiteType, SiteType>
    with $Provider<SiteType> {
  /// 이 상세 화면이 읽는 사이트.
  ///
  /// 보통은 전역 [currentSiteTypeProvider] 와 같다. 본문 링크로 다른 사이트 글을
  /// 열 때는 ProviderScope 에서 그 사이트로 교체한다 — 전역 값을 바꾸면 뒤에 쌓인
  /// 목록 화면까지 다른 사이트로 바뀌어 버린다.
  DetailSiteTypeProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'detailSiteTypeProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[currentSiteTypeProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          DetailSiteTypeProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = currentSiteTypeProvider;

  @override
  String debugGetCreateSourceHash() => _$detailSiteTypeHash();

  @$internal
  @override
  $ProviderElement<SiteType> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SiteType create(Ref ref) {
    return detailSiteType(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SiteType value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SiteType>(value),
    );
  }
}

String _$detailSiteTypeHash() => r'6b1f8ff8b17b1f3b25aa4d3390217b69ba34b8f5';

@ProviderFor(DetailsNotifier)
final detailsProvider = DetailsNotifierProvider._();

final class DetailsNotifierProvider
    extends $AsyncNotifierProvider<DetailsNotifier, Details> {
  DetailsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'detailsProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[
          listItemProvider,
          detailSiteTypeProvider,
          detailTitleStateProvider,
          _markAsReadProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>{
          DetailsNotifierProvider.$allTransitiveDependencies0,
          DetailsNotifierProvider.$allTransitiveDependencies1,
          DetailsNotifierProvider.$allTransitiveDependencies2,
          DetailsNotifierProvider.$allTransitiveDependencies3,
          DetailsNotifierProvider.$allTransitiveDependencies4,
          DetailsNotifierProvider.$allTransitiveDependencies5,
        },
      );

  static final $allTransitiveDependencies0 = listItemProvider;
  static final $allTransitiveDependencies1 = detailSiteTypeProvider;
  static final $allTransitiveDependencies2 =
      DetailSiteTypeProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies3 = detailTitleStateProvider;
  static final $allTransitiveDependencies4 =
      DetailTitleStateNotifierProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies5 = _markAsReadProvider;

  @override
  String debugGetCreateSourceHash() => _$detailsNotifierHash();

  @$internal
  @override
  DetailsNotifier create() => DetailsNotifier();
}

String _$detailsNotifierHash() => r'7d0673b99a2248b81c08941f0ffaa28ce2682f53';

abstract class _$DetailsNotifier extends $AsyncNotifier<Details> {
  FutureOr<Details> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Details>, Details>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Details>, Details>,
              AsyncValue<Details>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(_markAsRead)
final _markAsReadProvider = _MarkAsReadFamily._();

final class _MarkAsReadProvider
    extends $FunctionalProvider<AsyncValue<int>, int, FutureOr<int>>
    with $FutureModifier<int>, $FutureProvider<int> {
  _MarkAsReadProvider._({
    required _MarkAsReadFamily super.from,
    required ListItem super.argument,
  }) : super(
         retry: null,
         name: r'_markAsReadProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = detailSiteTypeProvider;
  static final $allTransitiveDependencies1 =
      DetailSiteTypeProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$_markAsReadHash();

  @override
  String toString() {
    return r'_markAsReadProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<int> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<int> create(Ref ref) {
    final argument = this.argument as ListItem;
    return _markAsRead(ref, argument);
  }

  @override
  bool operator ==(Object other) {
    return other is _MarkAsReadProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$_markAsReadHash() => r'485325e6a48a369cc16c2f436b9ca07548a91c31';

final class _MarkAsReadFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, ListItem> {
  _MarkAsReadFamily._()
    : super(
        retry: null,
        name: r'_markAsReadProvider',
        dependencies: <ProviderOrFamily>[detailSiteTypeProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          _MarkAsReadProvider.$allTransitiveDependencies0,
          _MarkAsReadProvider.$allTransitiveDependencies1,
        ],
        isAutoDispose: true,
      );

  _MarkAsReadProvider call(ListItem listItem) =>
      _MarkAsReadProvider._(argument: listItem, from: this);

  @override
  String toString() => r'_markAsReadProvider';
}

/// 툴바 크럼브: `클리앙 › 모두의공원`.
///
/// 큰 제목이 글 제목을 가져가면서 사이트 구분이 화면에서 사라졌다. 목록과
/// 같은 규칙(상위 경로는 툴바에)으로 여기에 되살린다. 게시판 이름을 모르는
/// 경우(스크랩 등 boardTitle 이 빈 항목)에는 사이트만 적는다.

@ProviderFor(detailSmallTitle)
final detailSmallTitleProvider = DetailSmallTitleProvider._();

/// 툴바 크럼브: `클리앙 › 모두의공원`.
///
/// 큰 제목이 글 제목을 가져가면서 사이트 구분이 화면에서 사라졌다. 목록과
/// 같은 규칙(상위 경로는 툴바에)으로 여기에 되살린다. 게시판 이름을 모르는
/// 경우(스크랩 등 boardTitle 이 빈 항목)에는 사이트만 적는다.

final class DetailSmallTitleProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  /// 툴바 크럼브: `클리앙 › 모두의공원`.
  ///
  /// 큰 제목이 글 제목을 가져가면서 사이트 구분이 화면에서 사라졌다. 목록과
  /// 같은 규칙(상위 경로는 툴바에)으로 여기에 되살린다. 게시판 이름을 모르는
  /// 경우(스크랩 등 boardTitle 이 빈 항목)에는 사이트만 적는다.
  DetailSmallTitleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'detailSmallTitleProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[
          listItemProvider,
          detailTitleProvider,
          detailSiteTypeProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>{
          DetailSmallTitleProvider.$allTransitiveDependencies0,
          DetailSmallTitleProvider.$allTransitiveDependencies1,
          DetailSmallTitleProvider.$allTransitiveDependencies2,
          DetailSmallTitleProvider.$allTransitiveDependencies3,
        },
      );

  static final $allTransitiveDependencies0 = listItemProvider;
  static final $allTransitiveDependencies1 = detailTitleProvider;
  static final $allTransitiveDependencies2 = detailSiteTypeProvider;
  static final $allTransitiveDependencies3 =
      DetailSiteTypeProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$detailSmallTitleHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return detailSmallTitle(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$detailSmallTitleHash() => r'07abe0c3048f069781e6ed8a8210a8ec398c47a8';

@ProviderFor(DetailTitleStateNotifier)
final detailTitleStateProvider = DetailTitleStateNotifierProvider._();

final class DetailTitleStateNotifierProvider
    extends $NotifierProvider<DetailTitleStateNotifier, String> {
  DetailTitleStateNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'detailTitleStateProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[listItemProvider, detailTitleProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          DetailTitleStateNotifierProvider.$allTransitiveDependencies0,
          DetailTitleStateNotifierProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = listItemProvider;
  static final $allTransitiveDependencies1 = detailTitleProvider;

  @override
  String debugGetCreateSourceHash() => _$detailTitleStateNotifierHash();

  @$internal
  @override
  DetailTitleStateNotifier create() => DetailTitleStateNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$detailTitleStateNotifierHash() =>
    r'528e0c2ff0c6a5cc8ffe7b3c0cca04889232ff5d';

abstract class _$DetailTitleStateNotifier extends $Notifier<String> {
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

@ProviderFor(detailTitle)
final detailTitleProvider = DetailTitleProvider._();

final class DetailTitleProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  DetailTitleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'detailTitleProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[listItemProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          DetailTitleProvider.$allTransitiveDependencies0,
        ],
      );

  static final $allTransitiveDependencies0 = listItemProvider;

  @override
  String debugGetCreateSourceHash() => _$detailTitleHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return detailTitle(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$detailTitleHash() => r'54a077ead00ea5b1644d41c85f12b2b94ce2ca75';

@ProviderFor(detailUrl)
final detailUrlProvider = DetailUrlProvider._();

final class DetailUrlProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  DetailUrlProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'detailUrlProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[
          listItemProvider,
          detailSiteTypeProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>[
          DetailUrlProvider.$allTransitiveDependencies0,
          DetailUrlProvider.$allTransitiveDependencies1,
          DetailUrlProvider.$allTransitiveDependencies2,
        ],
      );

  static final $allTransitiveDependencies0 = listItemProvider;
  static final $allTransitiveDependencies1 = detailSiteTypeProvider;
  static final $allTransitiveDependencies2 =
      DetailSiteTypeProvider.$allTransitiveDependencies0;

  @override
  String debugGetCreateSourceHash() => _$detailUrlHash();

  @$internal
  @override
  $ProviderElement<String> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  String create(Ref ref) {
    return detailUrl(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$detailUrlHash() => r'fee3df6fa1be8c8a6da47bc21ff1c0a921a44bef';

/// 상세 앱바의 expandedHeight.
///
/// 제목이 최대 3줄까지 늘어나므로 글마다 앱바 높이가 다르다. 실제로 그려지는
/// 것과 같은 스타일 · 같은 폭으로 재야 제목이 툴바 위로 삐져나오지 않는다.
/// 치수는 렌더 쪽(LargeTitleFlexibleSpace)과 같은 상수를 쓴다.

@ProviderFor(detailAppbarHeight)
final detailAppbarHeightProvider = DetailAppbarHeightFamily._();

/// 상세 앱바의 expandedHeight.
///
/// 제목이 최대 3줄까지 늘어나므로 글마다 앱바 높이가 다르다. 실제로 그려지는
/// 것과 같은 스타일 · 같은 폭으로 재야 제목이 툴바 위로 삐져나오지 않는다.
/// 치수는 렌더 쪽(LargeTitleFlexibleSpace)과 같은 상수를 쓴다.

final class DetailAppbarHeightProvider
    extends $FunctionalProvider<double, double, double>
    with $Provider<double> {
  /// 상세 앱바의 expandedHeight.
  ///
  /// 제목이 최대 3줄까지 늘어나므로 글마다 앱바 높이가 다르다. 실제로 그려지는
  /// 것과 같은 스타일 · 같은 폭으로 재야 제목이 툴바 위로 삐져나오지 않는다.
  /// 치수는 렌더 쪽(LargeTitleFlexibleSpace)과 같은 상수를 쓴다.
  DetailAppbarHeightProvider._({
    required DetailAppbarHeightFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'detailAppbarHeightProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  static final $allTransitiveDependencies0 = appbarTextStyleProvider;
  static final $allTransitiveDependencies1 =
      AppbarTextStyleProvider.$allTransitiveDependencies0;
  static final $allTransitiveDependencies2 =
      AppbarTextStyleProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies3 =
      AppbarTextStyleProvider.$allTransitiveDependencies2;
  static final $allTransitiveDependencies4 = screenWidthProvider;

  @override
  String debugGetCreateSourceHash() => _$detailAppbarHeightHash();

  @override
  String toString() {
    return r'detailAppbarHeightProvider'
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
    return detailAppbarHeight(ref, argument);
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
    return other is DetailAppbarHeightProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$detailAppbarHeightHash() =>
    r'a6c01eeed92e77918800bc3210a8fa85e9983e7b';

/// 상세 앱바의 expandedHeight.
///
/// 제목이 최대 3줄까지 늘어나므로 글마다 앱바 높이가 다르다. 실제로 그려지는
/// 것과 같은 스타일 · 같은 폭으로 재야 제목이 툴바 위로 삐져나오지 않는다.
/// 치수는 렌더 쪽(LargeTitleFlexibleSpace)과 같은 상수를 쓴다.

final class DetailAppbarHeightFamily extends $Family
    with $FunctionalFamilyOverride<double, String> {
  DetailAppbarHeightFamily._()
    : super(
        retry: null,
        name: r'detailAppbarHeightProvider',
        dependencies: <ProviderOrFamily>[
          appbarTextStyleProvider,
          screenWidthProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>{
          DetailAppbarHeightProvider.$allTransitiveDependencies0,
          DetailAppbarHeightProvider.$allTransitiveDependencies1,
          DetailAppbarHeightProvider.$allTransitiveDependencies2,
          DetailAppbarHeightProvider.$allTransitiveDependencies3,
          DetailAppbarHeightProvider.$allTransitiveDependencies4,
        },
        isAutoDispose: true,
      );

  /// 상세 앱바의 expandedHeight.
  ///
  /// 제목이 최대 3줄까지 늘어나므로 글마다 앱바 높이가 다르다. 실제로 그려지는
  /// 것과 같은 스타일 · 같은 폭으로 재야 제목이 툴바 위로 삐져나오지 않는다.
  /// 치수는 렌더 쪽(LargeTitleFlexibleSpace)과 같은 상수를 쓴다.

  DetailAppbarHeightProvider call(String text) =>
      DetailAppbarHeightProvider._(argument: text, from: this);

  @override
  String toString() => r'detailAppbarHeightProvider';
}
