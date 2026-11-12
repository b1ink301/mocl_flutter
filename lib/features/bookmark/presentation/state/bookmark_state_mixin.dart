import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/bookmark/application/bookmark_providers.dart';
import 'package:mocl_flutter/features/database/domain/entities/bookmark_folder.dart';
import 'package:mocl_flutter/features/database/domain/entities/post_snapshot.dart';

mixin class BookmarkState() {
  /// 거르지 않은 전체 스크랩.
  AsyncValue<List<PostSnapshot>> bookmarksState(WidgetRef ref) =>
      ref.watch(bookmarksProvider);

  List<BookmarkFolder> bookmarkFoldersState(WidgetRef ref) =>
      ref.watch(bookmarkFoldersProvider).value ?? const [];

  String? selectedBookmarkFolderState(WidgetRef ref) =>
      ref.watch(bookmarkFolderFilterProvider);

  /// 지금 있는 폴더(다 받을 때까지 기다린다). 스크랩 버튼이 시트를 띄울지 정할 때 쓴다.
  Future<List<BookmarkFolder>> readBookmarkFolders(WidgetRef ref) =>
      ref.read(bookmarkFoldersProvider.future);
}
