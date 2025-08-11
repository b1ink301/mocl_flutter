// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_search_proivders.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(KeywordNotifier)
const keywordNotifierProvider = KeywordNotifierProvider._();

final class KeywordNotifierProvider
    extends $NotifierProvider<KeywordNotifier, String> {
  const KeywordNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'keywordNotifierProvider',
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
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(reqSearchListData)
const reqSearchListDataProvider = ReqSearchListDataProvider._();

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
  const ReqSearchListDataProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'reqSearchListDataProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[
          mainItemProvider,
          keywordNotifierProvider,
        ],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          ReqSearchListDataProvider.$allTransitiveDependencies0,
          ReqSearchListDataProvider.$allTransitiveDependencies1,
        ],
      );

  static const $allTransitiveDependencies0 = mainItemProvider;
  static const $allTransitiveDependencies1 = keywordNotifierProvider;

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

String _$reqSearchListDataHash() => r'e35e23b8910273d83af1fb5a8811f0b979102b0d';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
