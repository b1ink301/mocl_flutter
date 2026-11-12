import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/library/application/library_providers.dart';
import 'package:mocl_flutter/features/library/domain/library_segment.dart';

mixin class LibraryEvent() {
  Future<void> selectLibrarySegment(WidgetRef ref, LibrarySegment segment) =>
      ref.read(librarySegmentProvider.notifier).select(segment);

  void openLibrarySearch(WidgetRef ref) =>
      ref.read(librarySearchProvider.notifier).open();

  void updateLibrarySearch(WidgetRef ref, String query) =>
      ref.read(librarySearchProvider.notifier).update(query);

  void closeLibrarySearch(WidgetRef ref) =>
      ref.read(librarySearchProvider.notifier).close();
}
