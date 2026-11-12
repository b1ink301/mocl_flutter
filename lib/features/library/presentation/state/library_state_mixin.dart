import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/library/application/library_providers.dart';

import 'package:mocl_flutter/features/library/domain/library_segment.dart';

mixin class LibraryState() {
  LibrarySegment librarySegmentState(WidgetRef ref) =>
      ref.watch(librarySegmentProvider);

  /// 보관함 검색어(null = 검색 닫힘).
  String? librarySearchState(WidgetRef ref) => ref.watch(librarySearchProvider);

  String? readLibrarySearch(WidgetRef ref) => ref.read(librarySearchProvider);

  /// 칸마다 (검색어에 맞는) 글 수.
  ({int? bookmarks, int? history}) librarySegmentCountsState(WidgetRef ref) =>
      ref.watch(librarySegmentCountsProvider);
}
