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
          detailTitleStateProvider,
          _markAsReadProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>{
          DetailsNotifierProvider.$allTransitiveDependencies0,
          DetailsNotifierProvider.$allTransitiveDependencies1,
          DetailsNotifierProvider.$allTransitiveDependencies2,
          DetailsNotifierProvider.$allTransitiveDependencies3,
        },
      );

  static final $allTransitiveDependencies0 = listItemProvider;
  static final $allTransitiveDependencies1 = detailTitleStateProvider;
  static final $allTransitiveDependencies2 =
      DetailTitleStateNotifierProvider.$allTransitiveDependencies1;
  static final $allTransitiveDependencies3 = _markAsReadProvider;

  @override
  String debugGetCreateSourceHash() => _$detailsNotifierHash();

  @$internal
  @override
  DetailsNotifier create() => DetailsNotifier();
}

String _$detailsNotifierHash() => r'2bb881f9efad651923d7630a9b076ed803fb4dfe';

abstract class _$DetailsNotifier extends $AsyncNotifier<Details> {
  FutureOr<Details> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<Details>, Details>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Details>, Details>,
              AsyncValue<Details>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
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

String _$_markAsReadHash() => r'8ba56bf4538ae91b0ae6ad423f8d9a1e3a0c81bf';

final class _MarkAsReadFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<int>, ListItem> {
  _MarkAsReadFamily._()
    : super(
        retry: null,
        name: r'_markAsReadProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  _MarkAsReadProvider call(ListItem listItem) =>
      _MarkAsReadProvider._(argument: listItem, from: this);

  @override
  String toString() => r'_markAsReadProvider';
}

@ProviderFor(detailSmallTitle)
final detailSmallTitleProvider = DetailSmallTitleProvider._();

final class DetailSmallTitleProvider
    extends $FunctionalProvider<String, String, String>
    with $Provider<String> {
  DetailSmallTitleProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'detailSmallTitleProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[listItemProvider, detailTitleProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          DetailSmallTitleProvider.$allTransitiveDependencies0,
          DetailSmallTitleProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = listItemProvider;
  static final $allTransitiveDependencies1 = detailTitleProvider;

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

String _$detailSmallTitleHash() => r'710823e81464ca519003e6367eda2f308610d560';

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
    r'63decb395ef74d725259430126449c2460871287';

abstract class _$DetailTitleStateNotifier extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
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
          currentSiteTypeProvider,
        ],
        $allTransitiveDependencies: <ProviderOrFamily>[
          DetailUrlProvider.$allTransitiveDependencies0,
          DetailUrlProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = listItemProvider;
  static final $allTransitiveDependencies1 = currentSiteTypeProvider;

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

String _$detailUrlHash() => r'e8d8b65b390da45d78b52b2fa4cafe7415b04d7a';

@ProviderFor(detailAppbarHeight)
final detailAppbarHeightProvider = DetailAppbarHeightFamily._();

final class DetailAppbarHeightProvider
    extends $FunctionalProvider<double, double, double>
    with $Provider<double> {
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
    r'2f73d594e6c0849c43ef3bd712ba748a47c6fa52';

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

  DetailAppbarHeightProvider call(String text) =>
      DetailAppbarHeightProvider._(argument: text, from: this);

  @override
  String toString() => r'detailAppbarHeightProvider';
}
