import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/presentation/widgets/large_title_sliver_app_bar.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_icon.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_icon_button.dart';
import 'package:mocl_flutter/features/bookmark/presentation/bookmarks_page.dart';
import 'package:mocl_flutter/features/history/presentation/history_page.dart';
import 'package:mocl_flutter/features/library/domain/library_segment.dart';
import 'package:mocl_flutter/features/library/presentation/state/library_event_mixin.dart';
import 'package:mocl_flutter/features/library/presentation/state/library_state_mixin.dart';
import 'package:mocl_flutter/features/library/presentation/widgets/library_search_field.dart';
import 'package:mocl_flutter/features/library/presentation/widgets/library_segment_control.dart';

/// 홈 "보관함" 탭: 스크랩과 최근 본 글(히스토리)을 큰 제목 아래 칸 전환으로 오간다.
///
/// 둘 다 "다시 볼 글" 이라 한 탭에 둔다(탭을 늘리면 좁은 폰에서 탭바가 넘친다).
/// 두 목록을 [IndexedStack] 으로 함께 살려 두지 않는다 — 홈이 탭마다 준
/// [PrimaryScrollController] 하나에 스크롤뷰가 둘 붙는다. 칸을 바꾸면 스크롤은 맨 위부터.
///
/// 검색은 게시판 탭처럼 앱바에서 한다. 검색어는 두 칸이 같이 쓰고, 칸의 숫자는
/// 검색어에 맞는 글 수라 검색 중에 어느 칸에 결과가 있는지 보인다.
class const LibraryPage({super.key})
    extends ConsumerWidget
    with LibraryState, LibraryEvent {
  static const String title = '보관함';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LibrarySegment segment = librarySegmentState(ref);
    final String? search = librarySearchState(ref);
    final counts = librarySegmentCountsState(ref);
    final TextStyle labelStyle = ref.watch(
      appTextStylesFontSizeProvider.select((s) => s.smallTextStyle),
    );
    final Widget header = LibrarySegmentControl(
      selected: segment,
      labelStyle: labelStyle,
      counts: <LibrarySegment, int?>{
        LibrarySegment.bookmarks: counts.bookmarks,
        LibrarySegment.history: counts.history,
      },
      onChanged: (LibrarySegment next) => selectLibrarySegment(ref, next),
    );
    final AppBarSearch appBarSearch = AppBarSearch(
      open: search != null,
      field: LibrarySearchField(
        hint: switch (segment) {
          LibrarySegment.bookmarks => '스크랩 검색 (제목 · 메모)',
          LibrarySegment.history => '최근 본 글 검색',
        },
      ),
      toggle: search != null
          ? PlainIconButton(
              onPressed: () => closeLibrarySearch(ref),
              icon: const PlainIcon(Icons.close),
              semanticLabel: '검색 닫기',
              semanticsId: 'library_search_close',
            )
          : PlainIconButton(
              onPressed: () => openLibrarySearch(ref),
              icon: const PlainIcon(Icons.search),
              semanticLabel: '보관함 검색',
              semanticsId: 'library_search',
            ),
    );
    final String query = search ?? '';
    return switch (segment) {
      LibrarySegment.bookmarks => BookmarksPage(
        key: const ValueKey<LibrarySegment>(LibrarySegment.bookmarks),
        title: title,
        header: header,
        search: appBarSearch,
        query: query,
      ),
      LibrarySegment.history => HistoryPage(
        key: const ValueKey<LibrarySegment>(LibrarySegment.history),
        title: title,
        header: header,
        search: appBarSearch,
        query: query,
      ),
    };
  }
}
