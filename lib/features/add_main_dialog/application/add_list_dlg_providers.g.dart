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
    r'ff2ff4201fd4a9ae0cdf443adf8900e7e76e0a9c';

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

/// 선택한 게시판을 담을 즐겨찾기 그룹. 기본값은 그 사이트가 속한 카테고리라,
/// 사용자가 아무것도 고르지 않아도 정리된 상태로 쌓인다.
/// (그룹 이름이 바뀌어도 ID 로 찾으므로 유지되고, 그룹이 지워졌으면 첫 그룹)

@ProviderFor(AddTargetGroup)
final addTargetGroupProvider = AddTargetGroupProvider._();

/// 선택한 게시판을 담을 즐겨찾기 그룹. 기본값은 그 사이트가 속한 카테고리라,
/// 사용자가 아무것도 고르지 않아도 정리된 상태로 쌓인다.
/// (그룹 이름이 바뀌어도 ID 로 찾으므로 유지되고, 그룹이 지워졌으면 첫 그룹)
final class AddTargetGroupProvider
    extends $AsyncNotifierProvider<AddTargetGroup, String> {
  /// 선택한 게시판을 담을 즐겨찾기 그룹. 기본값은 그 사이트가 속한 카테고리라,
  /// 사용자가 아무것도 고르지 않아도 정리된 상태로 쌓인다.
  /// (그룹 이름이 바뀌어도 ID 로 찾으므로 유지되고, 그룹이 지워졌으면 첫 그룹)
  AddTargetGroupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'addTargetGroupProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$addTargetGroupHash();

  @$internal
  @override
  AddTargetGroup create() => AddTargetGroup();
}

String _$addTargetGroupHash() => r'ed54cd44fd64b40ce9c6ffa80fd3f9dbeea6226c';

/// 선택한 게시판을 담을 즐겨찾기 그룹. 기본값은 그 사이트가 속한 카테고리라,
/// 사용자가 아무것도 고르지 않아도 정리된 상태로 쌓인다.
/// (그룹 이름이 바뀌어도 ID 로 찾으므로 유지되고, 그룹이 지워졌으면 첫 그룹)

abstract class _$AddTargetGroup extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
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
    r'8bc3d69b9e5104ce1cd4e04ee02afa4e0ea300c7';

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
