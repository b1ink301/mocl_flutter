import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/bookmark/data/repositories/bookmark_repository_impl.dart';
import 'package:mocl_flutter/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:mocl_flutter/features/database/application/datasource_provider.dart';
import 'package:mocl_flutter/features/database/domain/entities/bookmark_folder.dart';
import 'package:mocl_flutter/features/database/domain/entities/post_snapshot.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'bookmark_providers.g.dart';

@Riverpod(keepAlive: true)
BookmarkRepository bookmarkRepository(Ref ref) =>
    BookmarkRepositoryImpl(ref.watch(localDatabaseProvider));

/// 스크랩 목록(최신순). 추가/삭제 시 invalidate 되어 화면이 갱신된다.
@riverpod
class BookmarksNotifier() extends _$BookmarksNotifier {
  @override
  Future<List<PostSnapshot>> build() =>
      ref.watch(bookmarkRepositoryProvider).getAll();

  Future<void> remove(SiteType siteType, int id) async {
    await ref.read(bookmarkRepositoryProvider).remove(siteType, id);
    ref.invalidateSelf();
    ref.invalidate(bookmarkButtonProvider(siteType, id));
  }

  /// 폴더 · 메모를 바꾼다.
  Future<void> updateMeta(
    SiteType siteType,
    int id, {
    required List<String> folders,
    required String memo,
  }) async {
    await ref
        .read(bookmarkRepositoryProvider)
        .updateMeta(siteType, id, folders: folders, memo: memo.trim());
    ref.invalidateSelf();
  }
}

/// 스크랩 폴더(만든 순).
@Riverpod(keepAlive: true)
class BookmarkFoldersNotifier() extends _$BookmarkFoldersNotifier {
  @override
  Future<List<BookmarkFolder>> build() =>
      ref.watch(bookmarkRepositoryProvider).getFolders();

  /// 새 폴더를 만들어 돌려준다. 이름이 비었거나 한도를 넘으면 null.
  Future<BookmarkFolder?> add(String name, int tone) async {
    final String trimmed = name.trim();
    final List<BookmarkFolder> current = await future;
    if (trimmed.isEmpty || current.length >= BookmarkFolder.maxFolders) {
      return null;
    }
    final int now = DateTime.now().millisecondsSinceEpoch;
    final BookmarkFolder folder = BookmarkFolder(
      id: now.toRadixString(36),
      name: trimmed,
      tone: tone,
      createdAt: now,
    );
    await ref.read(bookmarkRepositoryProvider).putFolder(folder);
    ref.invalidateSelf();
    return folder;
  }

  Future<void> edit(BookmarkFolder folder) async {
    if (folder.name.trim().isEmpty) return;
    await ref
        .read(bookmarkRepositoryProvider)
        .putFolder(folder.copyWith(name: folder.name.trim()));
    ref.invalidateSelf();
  }

  /// 폴더를 지운다. 담긴 글은 스크랩에 남고 그 폴더에서만 빠진다.
  Future<void> remove(String id) async {
    await ref.read(bookmarkRepositoryProvider).deleteFolder(id);
    if (ref.read(bookmarkFolderFilterProvider) == id) {
      ref.read(bookmarkFolderFilterProvider.notifier).select(null);
    }
    ref.invalidateSelf();
    ref.invalidate(bookmarksProvider);
  }
}

/// 스크랩 목록에서 고른 폴더(null = 전체). 앱이 떠 있는 동안만 기억한다.
@Riverpod(keepAlive: true)
class BookmarkFolderFilter() extends _$BookmarkFolderFilter {
  @override
  String? build() => null;

  void select(String? id) => state = id;
}

/// 특정 게시물의 북마크 여부 + 토글. 상세 화면 버튼이 사용한다.
@riverpod
class BookmarkButton() extends _$BookmarkButton {
  @override
  Future<bool> build(SiteType siteType, int id) =>
      ref.watch(bookmarkRepositoryProvider).isBookmarked(siteType, id);

  /// 켜고 끈다. 켜졌으면 true.
  Future<bool> toggle(PostSnapshot data) async {
    final repo = ref.read(bookmarkRepositoryProvider);
    final bool isOn = state.asData?.value ?? false;
    if (isOn) {
      await repo.remove(data.siteType, data.id);
    } else {
      await repo.add(data);
    }
    ref.invalidateSelf();
    ref.invalidate(bookmarksProvider);
    return !isOn;
  }
}
