// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'add_list_dlg_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 게시판 선택 다이얼로그의 검색어. 다이얼로그가 닫히면 자동으로 초기화된다.

@ProviderFor(AddListSearchQuery)
final addListSearchQueryProvider = AddListSearchQueryProvider._();

/// 게시판 선택 다이얼로그의 검색어. 다이얼로그가 닫히면 자동으로 초기화된다.
final class AddListSearchQueryProvider
    extends $NotifierProvider<AddListSearchQuery, String> {
  /// 게시판 선택 다이얼로그의 검색어. 다이얼로그가 닫히면 자동으로 초기화된다.
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
    r'a580ca2b5f99632339b147828952a6ea3cef0cf2';

/// 게시판 선택 다이얼로그의 검색어. 다이얼로그가 닫히면 자동으로 초기화된다.

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

@ProviderFor(AddListDlgNotifier)
final addListDlgProvider = AddListDlgNotifierProvider._();

final class AddListDlgNotifierProvider
    extends
        $AsyncNotifierProvider<AddListDlgNotifier, List<CheckableMainItem>> {
  AddListDlgNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addListDlgProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addListDlgNotifierHash();

  @$internal
  @override
  AddListDlgNotifier create() => AddListDlgNotifier();
}

String _$addListDlgNotifierHash() =>
    r'2f6096d8016c84d8680833ae310462d7554d1aa1';

abstract class _$AddListDlgNotifier
    extends $AsyncNotifier<List<CheckableMainItem>> {
  FutureOr<List<CheckableMainItem>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref
            as $Ref<
              AsyncValue<List<CheckableMainItem>>,
              List<CheckableMainItem>
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<List<CheckableMainItem>>,
                List<CheckableMainItem>
              >,
              AsyncValue<List<CheckableMainItem>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
