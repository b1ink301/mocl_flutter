import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/bookmark/application/bookmark_providers.dart';
import 'package:mocl_flutter/features/database/domain/entities/bookmark_folder.dart';

mixin class BookmarkEvent() {
  Future<void> removeBookmark(WidgetRef ref, SiteType siteType, int id) =>
      ref.read(bookmarksProvider.notifier).remove(siteType, id);

  Future<void> updateBookmarkMeta(
    WidgetRef ref,
    SiteType siteType,
    int id, {
    required List<String> folders,
    required String memo,
  }) => ref
      .read(bookmarksProvider.notifier)
      .updateMeta(siteType, id, folders: folders, memo: memo);

  void selectBookmarkFolder(WidgetRef ref, String? id) =>
      ref.read(bookmarkFolderFilterProvider.notifier).select(id);

  Future<BookmarkFolder?> addBookmarkFolder(
    WidgetRef ref,
    String name,
    int tone,
  ) => ref.read(bookmarkFoldersProvider.notifier).add(name, tone);

  Future<void> editBookmarkFolder(WidgetRef ref, BookmarkFolder folder) =>
      ref.read(bookmarkFoldersProvider.notifier).edit(folder);

  Future<void> removeBookmarkFolder(WidgetRef ref, String id) =>
      ref.read(bookmarkFoldersProvider.notifier).remove(id);
}
