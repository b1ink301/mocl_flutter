// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(historyRepository)
final historyRepositoryProvider = HistoryRepositoryProvider._();

final class HistoryRepositoryProvider
    extends
        $FunctionalProvider<
          HistoryRepository,
          HistoryRepository,
          HistoryRepository
        >
    with $Provider<HistoryRepository> {
  HistoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyRepositoryHash();

  @$internal
  @override
  $ProviderElement<HistoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  HistoryRepository create(Ref ref) {
    return historyRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HistoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HistoryRepository>(value),
    );
  }
}

String _$historyRepositoryHash() => r'b651d0756ac298b7cb6dffcc4b1ad4534638c35d';

/// 최근 본 글(최근 본 순). 홈 "히스토리" 탭이 본다.
///
/// 탭이 [IndexedStack] 으로 늘 살아 있어 keepAlive 로 둔다. 상세를 열 때마다
/// [record] 가 새로 읽게 한다.

@ProviderFor(HistoryNotifier)
final historyProvider = HistoryNotifierProvider._();

/// 최근 본 글(최근 본 순). 홈 "히스토리" 탭이 본다.
///
/// 탭이 [IndexedStack] 으로 늘 살아 있어 keepAlive 로 둔다. 상세를 열 때마다
/// [record] 가 새로 읽게 한다.
final class HistoryNotifierProvider
    extends $AsyncNotifierProvider<HistoryNotifier, List<PostSnapshot>> {
  /// 최근 본 글(최근 본 순). 홈 "히스토리" 탭이 본다.
  ///
  /// 탭이 [IndexedStack] 으로 늘 살아 있어 keepAlive 로 둔다. 상세를 열 때마다
  /// [record] 가 새로 읽게 한다.
  HistoryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'historyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$historyNotifierHash();

  @$internal
  @override
  HistoryNotifier create() => HistoryNotifier();
}

String _$historyNotifierHash() => r'9f887c64bf48be499a3604918597d32340187791';

/// 최근 본 글(최근 본 순). 홈 "히스토리" 탭이 본다.
///
/// 탭이 [IndexedStack] 으로 늘 살아 있어 keepAlive 로 둔다. 상세를 열 때마다
/// [record] 가 새로 읽게 한다.

abstract class _$HistoryNotifier extends $AsyncNotifier<List<PostSnapshot>> {
  FutureOr<List<PostSnapshot>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<PostSnapshot>>, List<PostSnapshot>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<PostSnapshot>>, List<PostSnapshot>>,
              AsyncValue<List<PostSnapshot>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
