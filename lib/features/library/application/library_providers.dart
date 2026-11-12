import 'package:mocl_flutter/features/bookmark/application/bookmark_providers.dart';
import 'package:mocl_flutter/features/bookmark/domain/bookmark_filter.dart';
import 'package:mocl_flutter/features/database/domain/entities/post_snapshot.dart';
import 'package:mocl_flutter/features/history/application/history_providers.dart';
import 'package:mocl_flutter/features/library/domain/library_segment.dart';
import 'package:mocl_flutter/features/settings_page/application/datasource_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'library_providers.g.dart';

/// 보관함 탭에서 고른 칸. 앱을 다시 켜도 마지막에 본 칸을 연다(기본 스크랩).
@Riverpod(keepAlive: true)
class LibrarySegmentNotifier() extends _$LibrarySegmentNotifier {
  static const String _key = 'library_segment';

  @override
  LibrarySegment build() {
    final String? saved = ref.watch(sharedPreferencesProvider).getString(_key);
    return LibrarySegment.values.asNameMap()[saved] ?? LibrarySegment.bookmarks;
  }

  Future<void> select(LibrarySegment segment) async {
    if (segment == state) return;
    state = segment;
    await ref.read(sharedPreferencesProvider).setString(_key, segment.name);
  }
}

/// 보관함 검색어. null 이면 검색을 닫은 것, '' 이면 열었지만 아직 비어 있음.
///
/// 스크랩 · 히스토리 두 칸이 같이 쓴다(검색 중에 칸을 바꾸면 그 칸에서 같은 말로 찾는다).
/// 보관함 탭을 떠나면 닫는다(`MainEvent.selectTab`).
@Riverpod(keepAlive: true)
class LibrarySearch() extends _$LibrarySearch {
  @override
  String? build() => null;

  void open() => state ??= '';

  void update(String query) => state = query;

  void close() => state = null;
}

/// 검색어에 맞는 스크랩 · 히스토리 수(세그먼트 숫자). 받는 중이면 null.
@riverpod
({int? bookmarks, int? history}) librarySegmentCounts(Ref ref) {
  final String query = ref.watch(librarySearchProvider) ?? '';
  int? count(List<PostSnapshot>? items) =>
      items == null ? null : BookmarkFilter.apply(items, query: query).length;
  return (
    bookmarks: count(ref.watch(bookmarksProvider).value),
    history: count(ref.watch(historyProvider).value),
  );
}
