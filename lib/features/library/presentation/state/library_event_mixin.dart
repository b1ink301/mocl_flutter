import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/library/application/library_providers.dart';
import 'package:mocl_flutter/features/library/domain/library_segment.dart';

mixin class LibraryEvent() {
  Future<void> selectLibrarySegment(WidgetRef ref, LibrarySegment segment) =>
      ref.read(librarySegmentProvider.notifier).select(segment);
}
