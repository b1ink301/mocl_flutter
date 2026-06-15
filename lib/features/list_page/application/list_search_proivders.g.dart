// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_search_proivders.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(KeywordNotifier)
final keywordProvider = KeywordNotifierProvider._();

final class KeywordNotifierProvider
    extends $NotifierProvider<KeywordNotifier, String> {
  KeywordNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keywordProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$keywordNotifierHash();

  @$internal
  @override
  KeywordNotifier create() => KeywordNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$keywordNotifierHash() => r'71b08ed24030b6db2641eadccaee061fba69673f';

abstract class _$KeywordNotifier extends $Notifier<String> {
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

@ProviderFor(reqSearchListData)
final reqSearchListDataProvider = ReqSearchListDataProvider._();

final class ReqSearchListDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<Either<Failure, List<ListItem>>>,
          Either<Failure, List<ListItem>>,
          FutureOr<Either<Failure, List<ListItem>>>
        >
    with
        $FutureModifier<Either<Failure, List<ListItem>>>,
        $FutureProvider<Either<Failure, List<ListItem>>> {
  ReqSearchListDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reqSearchListDataProvider',
        isAutoDispose: true,
        dependencies: <ProviderOrFamily>[mainItemProvider, keywordProvider],
        $allTransitiveDependencies: <ProviderOrFamily>[
          ReqSearchListDataProvider.$allTransitiveDependencies0,
          ReqSearchListDataProvider.$allTransitiveDependencies1,
        ],
      );

  static final $allTransitiveDependencies0 = mainItemProvider;
  static final $allTransitiveDependencies1 = keywordProvider;

  @override
  String debugGetCreateSourceHash() => _$reqSearchListDataHash();

  @$internal
  @override
  $FutureProviderElement<Either<Failure, List<ListItem>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Either<Failure, List<ListItem>>> create(Ref ref) {
    return reqSearchListData(ref);
  }
}

String _$reqSearchListDataHash() => r'd8e5d17a4dc647729fe8abf1cc75e048a28c8bdd';
