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
