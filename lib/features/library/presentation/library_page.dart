import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/features/bookmark/presentation/bookmarks_page.dart';
import 'package:mocl_flutter/features/history/presentation/history_page.dart';
import 'package:mocl_flutter/features/library/domain/library_segment.dart';
import 'package:mocl_flutter/features/library/presentation/state/library_event_mixin.dart';
import 'package:mocl_flutter/features/library/presentation/state/library_state_mixin.dart';
import 'package:mocl_flutter/features/library/presentation/widgets/library_segment_control.dart';

/// 홈 "보관함" 탭: 스크랩과 최근 본 글(히스토리)을 큰 제목 아래 칸 전환으로 오간다.
///
/// 둘 다 "다시 볼 글" 이라 한 탭에 둔다(탭을 늘리면 좁은 폰에서 탭바가 넘친다).
/// 두 목록을 [IndexedStack] 으로 함께 살려 두지 않는다 — 홈이 탭마다 준
/// [PrimaryScrollController] 하나에 스크롤뷰가 둘 붙는다. 칸을 바꾸면 스크롤은 맨 위부터.
class const LibraryPage({super.key})
    extends ConsumerWidget
    with LibraryState, LibraryEvent {
  static const String title = '보관함';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final LibrarySegment segment = librarySegmentState(ref);
    final TextStyle labelStyle = ref.watch(
      appTextStylesFontSizeProvider.select((s) => s.smallTextStyle),
    );
    final Widget header = LibrarySegmentControl(
      selected: segment,
      labelStyle: labelStyle,
      onChanged: (LibrarySegment next) => selectLibrarySegment(ref, next),
    );
    return switch (segment) {
      LibrarySegment.bookmarks => BookmarksPage(
        key: const ValueKey<LibrarySegment>(LibrarySegment.bookmarks),
        title: title,
        header: header,
      ),
      LibrarySegment.history => HistoryPage(
        key: const ValueKey<LibrarySegment>(LibrarySegment.history),
        title: title,
        header: header,
      ),
    };
  }
}
