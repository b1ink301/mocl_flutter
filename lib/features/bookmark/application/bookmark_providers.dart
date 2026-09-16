import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/bookmark/data/repositories/bookmark_repository_impl.dart';
import 'package:mocl_flutter/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:mocl_flutter/features/database/application/datasource_provider.dart';
import 'package:mocl_flutter/features/database/domain/entities/bookmark_data.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookmark_providers.g.dart';

@Riverpod(keepAlive: true)
BookmarkRepository bookmarkRepository(Ref ref) =>
    BookmarkRepositoryImpl(ref.watch(localDatabaseProvider));

/// 스크랩 목록(최신순). 추가/삭제 시 invalidate 되어 화면이 갱신된다.
@riverpod
class BookmarksNotifier() extends _$BookmarksNotifier {
  @override
  Future<List<BookmarkData>> build() =>
      ref.watch(bookmarkRepositoryProvider).getAll();

  Future<void> remove(SiteType siteType, int id) async {
    await ref.read(bookmarkRepositoryProvider).remove(siteType, id);
    ref.invalidateSelf();
  }
}

/// 특정 게시물의 북마크 여부 + 토글. 상세 화면 버튼이 사용한다.
@riverpod
class BookmarkButton() extends _$BookmarkButton {
  @override
  Future<bool> build(SiteType siteType, int id) =>
      ref.watch(bookmarkRepositoryProvider).isBookmarked(siteType, id);

  Future<void> toggle(BookmarkData data) async {
    final repo = ref.read(bookmarkRepositoryProvider);
    final bool isOn = state.asData?.value ?? false;
    if (isOn) {
      await repo.remove(data.siteType, data.id);
    } else {
      await repo.add(data);
    }
    ref.invalidateSelf();
    ref.invalidate(bookmarksProvider);
  }
}
