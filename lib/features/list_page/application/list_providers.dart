import 'package:flutter/foundation.dart' show listEquals;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/last_id.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';
import 'package:mocl_flutter/features/database/domain/entities/mute_rule.dart';
import 'package:mocl_flutter/features/list_page/application/use_case_provider.dart';
import 'package:mocl_flutter/features/list_page/domain/usecases/get_list.dart';
import 'package:mocl_flutter/features/mute/application/mute_providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'list_providers.g.dart';

@riverpod
MainItem mainItem(Ref ref) => throw UnimplementedError('mainItem');

@riverpod
String listSmallTitle(Ref ref) =>
    ref.watch(currentSiteTypeProvider.select((siteType) => siteType.title));

@Riverpod(dependencies: [mainItem])
String listTitle(Ref ref) =>
    ref.watch(mainItemProvider.select((MainItem item) => item.text));

@Riverpod(dependencies: [mainItem])
Future<Either<Failure, List<ListItem>>> reqListData(
  Ref ref,
  MainItem mainItem,
  SortType sortType,
  int page,
  LastId lastId,
) {
  final GetListParams params = GetListParams(
    mainItem: mainItem,
    page: page,
    lastId: lastId,
    sortType: sortType,
  );
  return ref.read(getListUseCaseProvider)(params);
}

/// 페이지네이션이 없는 게시판(한 번 fetch 후 종료).
/// 뷰에서 '더 불러오기' 버튼 노출 여부 판단에도 사용한다.
@Riverpod(dependencies: [mainItem])
bool isSinglePageBoard(Ref ref) {
  final MainItem mainItem = ref.watch(mainItemProvider);
  return (mainItem.siteType == SiteType.clien &&
          mainItem.board == 'recommend') ||
      // 네이트판은 고정 랭킹 목록이라 페이지네이션이 없다.
      mainItem.siteType == SiteType.nate;
}

/// infinite_scroll_pagination 의 PagingController 를 Riverpod 으로 감싼다.
/// build() 는 mainItem/sortType 이 바뀔 때만 새 컨트롤러를 생성한다.
/// 이전 컨트롤러의 dispose 는 Riverpod 의 ref.onDispose 가 자동 처리.
@Riverpod(
  dependencies: [mainItem, reqListData, SortTypeNotifier, isSinglePageBoard],
)
class ListPagingController() extends _$ListPagingController {
  /// forceLoadMore 가 부여하는 추가 fetch 허용량.
  /// getNextPageKey 의 '연속 빈 페이지 종료' 가드를 이 횟수만큼 무시하고
  /// 더 깊은 페이지로 전진한다. (같은 페이지 재시도는 offset 이 밀린 상황에서
  /// 영원히 중복만 반환하므로, 복구는 반드시 새 키로 전진해야 한다)
  int _forcedFetchAllowance = 0;

  @override
  PagingController<int, ListItem> build() {
    _forcedFetchAllowance = 0;
    final MainItem mainItem = ref.watch(mainItemProvider);
    final SortType sortType = ref.watch(sortTypeProvider);

    // 뮤트 규칙은 전역. 비동기 로딩(로딩→데이터)을 watch 하면 콜드 스타트의
    // 첫 fetch 도중 컨트롤러가 재생성되어 첫 페이지가 영영 '로딩 중'에 박힌다.
    // 따라서 컨트롤러 수명주기는 뮤트 로딩과 분리하고, 규칙은 fetchPage 에서
    // future 로 정착된 값을 읽어 적용한다(아래 appliedMutes 에 기록).
    // 규칙이 실제로 바뀐 경우(이미 적용한 규칙과 달라진 경우)에만 기존
    // 컨트롤러를 refresh 한다 — 재생성하지 않으므로 첫 fetch 유실이 없다.
    List<MuteRule>? appliedMutes;
    ref.listen<AsyncValue<List<MuteRule>>>(muteRulesProvider, (prev, next) {
      final List<MuteRule>? nextRules = next.asData?.value;
      if (appliedMutes != null &&
          nextRules != null &&
          !listEquals(appliedMutes, nextRules)) {
        state.refresh();
      }
    });

    final int initialPage = _initialPage();
    final bool singlePageBoard = ref.watch(isSinglePageBoardProvider);
    late final PagingController<int, ListItem> controller;

    controller = PagingController<int, ListItem>(
      getNextPageKey: (state) {
        // 단일 페이지 게시판: 한 번 fetch 후 종료
        if (singlePageBoard && (state.keys?.isNotEmpty ?? false)) {
          return null;
        }
        // 연속 2페이지가 비어있으면 종료. 한 페이지만 빈 경우는 뮤트 규칙이나
        // lastId 중복 필터가 페이지 전체를 걸러낸 것일 수 있으므로 한 번 더
        // 다음 키로 시도한다. 보배드림처럼 끝 페이지를 넘겨도 마지막 페이지를
        // 다시 주는 사이트는 중복 필터로 매번 빈 페이지가 되어 2연속에서 멈춘다.
        // forceLoadMore('더 불러오기')가 허용량을 부여한 동안은 종료하지 않고
        // 계속 다음 키로 전진한다(오래 방치 후 offset 이 여러 페이지 밀린 경우).
        final List<List<ListItem>>? pages = state.pages;
        if (pages != null &&
            pages.isNotEmpty &&
            pages.last.isEmpty &&
            (pages.length < 2 || pages[pages.length - 2].isEmpty)) {
          if (_forcedFetchAllowance <= 0) return null;
          _forcedFetchAllowance--;
        }

        final int? lastKey = state.keys?.lastOrNull;
        return lastKey == null ? initialPage : lastKey + 1;
      },
      fetchPage: (pageKey) async {
        // LastId 의 두 용도: (1) id 내림차순 목록에서 파서의 `id >= lastId`
        // 중복 필터, (2) reddit 의 after 커서.
        // 추천순은 목록이 id 순서가 아니므로 (1) 이 정상 글을 오필터한다
        // (lastId 보다 큰 id 의 저추천 최신 글이 다음 페이지에 올 수 있음).
        // 따라서 추천순에서는 lastId 를 비워 필터를 끄고, 커서형이라 정렬과
        // 무관하게 lastId 가 필요한 reddit 만 예외로 유지한다.
        final bool useLastId =
            sortType == SortType.recent || mainItem.siteType == SiteType.reddit;
        final ListItem? lastItem = useLastId
            ? controller.value.items?.lastOrNull
            : null;
        final LastId lastId = lastItem != null
            ? LastId(intId: lastItem.id, stringId: lastItem.url)
            : const LastId();

        // 정착된 뮤트 규칙을 사용(첫 fetch 도 로딩 완료 후 필터 적용).
        final List<MuteRule> mutes = await ref.read(muteRulesProvider.future);
        appliedMutes = mutes;

        final result = await ref.read(
          reqListDataProvider(mainItem, sortType, pageKey, lastId).future,
        );
        return result.fold((failure) => throw _PagingFailure(failure.message), (
          items,
        ) {
          final List<ListItem> filtered = _applyMute(items, mutes);
          // 새 항목을 만나면 강제 전진 모드 종료 → 정상 페이징 복귀.
          // (남은 허용량이 이후의 자연스러운 끝 감지를 늦추지 않도록)
          if (filtered.isNotEmpty) _forcedFetchAllowance = 0;
          return filtered;
        });
      },
    );

    ref.onDispose(controller.dispose);
    return controller;
  }

  int _initialPage() {
    final siteType = ref.read(currentSiteTypeProvider);
    return siteType == SiteType.clien ? 0 : 1;
  }

  void refresh() => state.refresh();

  void retry() {
    final ctrl = state;
    // hasNextPage 가 false 인 상태(completed)에서는 fetchNextPage 가
    // 내부 가드(`if (!state.hasNextPage) return`)에 막혀 no-op 이 된다.
    // 에러가 살아있고 다음 페이지가 있을 때만 같은 키로 재시도하고,
    // 그 외(completed / firstPageError 등)는 전체 리프레시로 복구한다.
    if (ctrl.value.error != null && ctrl.value.hasNextPage) {
      // 에러 클리어 후 같은 키로 재시도
      ctrl.value = ctrl.value.copyWith(error: null);
      ctrl.fetchNextPage();
    } else {
      ctrl.refresh();
    }
  }

  void loadMore() => state.fetchNextPage();

  /// noMoreItems 로 종료된 상태에서 사용자가 명시적으로 다음 페이지를 요청.
  ///
  /// hasNextPage 가 false 면 fetchNextPage 는 내부 가드에 막혀 no-op 이므로,
  /// hasNextPage 를 되돌린 뒤 fetch 한다. 이미 비어있는 것으로 확인된 페이지를
  /// 다시 요청해도 offset 이 밀린 상황에서는 계속 중복만 오므로, 허용량을
  /// 부여해 getNextPageKey 가 더 깊은 새 키로 전진하게 한다. 사용자가 리스트
  /// 끝에 머무는 동안 허용량만큼(최대 [_forcedFetchBudget] 페이지) 연속으로
  /// 시도되고, 그 안에 새 항목을 만나면 정상 페이징으로 복귀한다.
  void forceLoadMore() {
    final ctrl = state;
    if (ctrl.value.hasNextPage) {
      ctrl.fetchNextPage();
      return;
    }
    _forcedFetchAllowance = _forcedFetchBudget;
    ctrl.value = ctrl.value.copyWith(hasNextPage: true, error: null);
    ctrl.fetchNextPage();
  }

  /// '더 불러오기' 한 번당 추가로 전진해 볼 최대 페이지 수.
  static const int _forcedFetchBudget = 5;

  /// 백그라운드 → 포그라운드 복귀 후 fetch 가 멈춰 있을 때 강제로 재시작.
  ///
  /// PagingController 는 isLoading==true 면 fetchNextPage 호출을 무시한다.
  /// 백그라운드 중 in-flight 였던 요청은 소켓이 죽어 영영 resolve 되지 않고,
  /// 그 결과 isLoading 이 영구 true 로 박혀 스크롤해도 다음 페이지가
  /// 로드되지 않는 증상이 발생한다.
  ///
  /// 이를 감지해서 상태를 리셋 후 다시 fetch 를 시도.
  void kickIfStale() {
    final ctrl = state;
    if (!ctrl.value.isLoading) return;
    MoclLogger.log('[ListPagingController] kickIfStale: 멈춘 fetch 강제 재시작');
    // PagingController 의 mutex 가드는 isLoading 이 아니라 내부 `operation`
    // 필드다. isLoading 만 내려서는 다음 fetchNextPage 가 `operation != null`
    // 에 막혀 no-op 이 되므로, operation 까지 비워주는 cancel() 을 호출한다.
    ctrl.cancel();
    ctrl.fetchNextPage();
  }

  void markAsReadById(int id) {
    final ctrl = state;
    final pages = ctrl.value.pages;
    if (pages == null) return;

    for (int p = 0; p < pages.length; p++) {
      final page = pages[p];
      final idx = page.indexWhere((e) => e.id == id);
      if (idx < 0) continue;
      if (page[idx].isRead) return;

      final newPage = List<ListItem>.from(page);
      newPage[idx] = page[idx].copyWith(isRead: true);
      final newPages = List<List<ListItem>>.from(pages);
      newPages[p] = newPage;

      ctrl.value = ctrl.value.copyWith(pages: newPages);
      return;
    }
  }
}

/// 컨트롤러가 보유한 flat items 를 Riverpod 상태로 노출.
/// detail/리스트 row 등 비-paging 영역에서 인덱스 기반 접근에 사용.
@Riverpod(dependencies: [ListPagingController])
class PagingItems() extends _$PagingItems {
  @override
  List<ListItem> build() {
    final controller = ref.watch(listPagingControllerProvider);

    void listener() {
      state = _flatten(controller.value.pages);
    }

    controller.addListener(listener);
    ref.onDispose(() => controller.removeListener(listener));

    return _flatten(controller.value.pages);
  }

  static List<ListItem> _flatten(List<List<ListItem>>? pages) {
    if (pages == null) return const <ListItem>[];
    return List<ListItem>.unmodifiable([for (final p in pages) ...p]);
  }
}

@Riverpod(dependencies: [PagingItems])
ListItem? itemAtIndex(Ref ref, int index) {
  return ref.watch(
    pagingItemsProvider.select((items) {
      if (index >= 0 && index < items.length) return items[index];
      return null;
    }),
  );
}

@riverpod
class SortTypeNotifier() extends _$SortTypeNotifier {
  @override
  SortType build() => SortType.recent;

  void changeSortType(SortType sortType) => state = sortType;
}

/// 뮤트 규칙에 걸리는 항목을 제거한다(제목 키워드 / 작성자 닉네임).
List<ListItem> _applyMute(List<ListItem> items, List<MuteRule> mutes) {
  if (mutes.isEmpty) return items;
  return items.where((item) {
    for (final MuteRule m in mutes) {
      final bool hit = switch (m.type) {
        MuteType.keyword => item.title.contains(m.pattern),
        MuteType.user =>
          item.userInfo.nickName == m.pattern || item.info.contains(m.pattern),
      };
      if (hit) return false;
    }
    return true;
  }).toList();
}

class _PagingFailure(final String message) implements Exception {
  @override
  String toString() => message;
}
