import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/util/utilities.dart';
import 'package:mocl_flutter/features/database/domain/entities/bookmark_folder.dart';
import 'package:mocl_flutter/features/database/domain/entities/post_snapshot.dart';

import '../state/bookmark_event_mixin.dart';
import '../state/bookmark_state_mixin.dart';
import 'bookmark_sheets.dart';

/// 스크랩 폴더 · 메모 흐름. 상세의 스크랩 버튼과 스크랩 목록이 같이 쓴다.
abstract final class BookmarkFlow() {
  static const _Flow _flow = _Flow();

  /// 스크랩을 막 켰을 때. 폴더가 있으면 폴더 · 메모 시트를 띄우고, 없으면
  /// "스크랩했어요" 스낵바에 "폴더 · 메모" 버튼만 둔다(폴더를 안 쓰는 사람은 한 번에 끝).
  static Future<void> afterBookmarked(
    BuildContext context,
    WidgetRef ref,
    PostSnapshot post,
  ) => _flow.afterBookmarked(context, ref, post);

  /// [post] 의 폴더 · 메모를 고친다.
  static Future<void> editMeta(
    BuildContext context,
    WidgetRef ref,
    PostSnapshot post, {
    String title = '폴더 · 메모',
  }) => _flow.editMeta(context, ref, post, title: title);

  /// 새 폴더를 만든다(만든 폴더, 취소면 null).
  static Future<BookmarkFolder?> createFolder(
    BuildContext context,
    WidgetRef ref,
  ) => _flow.createFolder(context, ref);

  /// 폴더 이름 · 색을 고치거나 지운다.
  static Future<void> editFolder(
    BuildContext context,
    WidgetRef ref,
    BookmarkFolder folder,
  ) => _flow.editFolder(context, ref, folder);

  /// 스크랩 행을 길게 눌렀을 때의 메뉴.
  static Future<void> showActions(
    BuildContext context,
    WidgetRef ref,
    PostSnapshot post,
  ) => _flow.showActions(context, ref, post);

  static void showMessage(
    BuildContext context,
    String message, {
    SnackBarAction? action,
  }) {
    final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(
      context,
    );
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          action: action,
        ),
      );
  }
}

class const _Flow() with BookmarkState, BookmarkEvent {
  Future<void> afterBookmarked(
    BuildContext context,
    WidgetRef ref,
    PostSnapshot post,
  ) async {
    final List<BookmarkFolder> folders = await readBookmarkFolders(ref);
    if (!context.mounted) return;
    if (folders.isNotEmpty) {
      return editMeta(context, ref, post, title: '스크랩했어요');
    }
    BookmarkFlow.showMessage(
      context,
      '스크랩했어요',
      action: SnackBarAction(
        label: '폴더 · 메모',
        onPressed: () {
          if (context.mounted) {
            unawaited(editMeta(context, ref, post, title: '폴더 · 메모'));
          }
        },
      ),
    );
  }

  Future<void> editMeta(
    BuildContext context,
    WidgetRef ref,
    PostSnapshot post, {
    required String title,
  }) async {
    final ({List<String> folders, String memo})? result =
        await showModalBottomSheet<({List<String> folders, String memo})>(
          context: context,
          showDragHandle: true,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (sheetContext) => BookmarkMetaSheet(
            title: title,
            postTitle: post.title,
            folders: post.folders,
            memo: post.memo,
            onCreateFolder: () => createFolder(sheetContext, ref),
          ),
        );
    if (result == null) return;
    if (_sameFolders(result.folders, post.folders) &&
        result.memo == post.memo) {
      return;
    }
    await updateBookmarkMeta(
      ref,
      post.siteType,
      post.id,
      folders: result.folders,
      memo: result.memo,
    );
  }

  static bool _sameFolders(List<String> a, List<String> b) =>
      a.length == b.length && a.toSet().containsAll(b);

  Future<BookmarkFolder?> createFolder(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final List<BookmarkFolder> folders = await readBookmarkFolders(ref);
    if (!context.mounted) return null;
    if (folders.length >= BookmarkFolder.maxFolders) {
      BookmarkFlow.showMessage(
        context,
        '폴더는 ${BookmarkFolder.maxFolders}개까지 만들 수 있어요.',
      );
      return null;
    }
    final FolderSheetResult? result =
        await showModalBottomSheet<FolderSheetResult>(
          context: context,
          showDragHandle: true,
          isScrollControlled: true,
          useSafeArea: true,
          // 폴더마다 색이 갈리게 만든 수만큼 돌린다(코랄은 강조색과 겹쳐 뒤로).
          builder: (_) =>
              BookmarkFolderSheet(initialTone: 1 + folders.length % 5),
        );
    if (result is! FolderSaved) return null;
    return addBookmarkFolder(ref, result.name, result.tone);
  }

  Future<void> editFolder(
    BuildContext context,
    WidgetRef ref,
    BookmarkFolder folder,
  ) async {
    final FolderSheetResult? result =
        await showModalBottomSheet<FolderSheetResult>(
          context: context,
          showDragHandle: true,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (_) => BookmarkFolderSheet(folder: folder),
        );
    if (!context.mounted) return;
    switch (result) {
      case FolderSaved(:final String name, :final int tone):
        await editBookmarkFolder(ref, folder.copyWith(name: name, tone: tone));
      case FolderDeleted():
        final bool? ok = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog.adaptive(
            title: Text('\'${folder.name}\' 폴더를 지울까요?'),
            content: const Text('담긴 글은 스크랩에 그대로 남아요.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('취소'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('지우기'),
              ),
            ],
          ),
        );
        if (ok == true) await removeBookmarkFolder(ref, folder.id);
      case null:
        break;
    }
  }

  Future<void> showActions(
    BuildContext context,
    WidgetRef ref,
    PostSnapshot post,
  ) async {
    final _Action? action = await showModalBottomSheet<_Action>(
      context: context,
      showDragHandle: true,
      useSafeArea: true,
      builder: (sheetContext) {
        final ThemeData theme = Theme.of(sheetContext);
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                child: Text(
                  post.title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleSmall,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.edit_note),
                title: const Text('폴더 · 메모 고치기'),
                onTap: () => Navigator.of(sheetContext).pop(_Action.meta),
              ),
              ListTile(
                leading: const Icon(Icons.share_outlined),
                title: const Text('공유'),
                onTap: () => Navigator.of(sheetContext).pop(_Action.share),
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: theme.colorScheme.error,
                ),
                title: Text(
                  '스크랩 지우기',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
                onTap: () => Navigator.of(sheetContext).pop(_Action.remove),
              ),
            ],
          ),
        );
      },
    );
    if (action == null || !context.mounted) return;
    switch (action) {
      case _Action.meta:
        await editMeta(context, ref, post, title: '폴더 · 메모');
      case _Action.share:
        await post.url.shareUrl();
      case _Action.remove:
        await removeBookmark(ref, post.siteType, post.id);
    }
  }
}

enum _Action() {
  meta,
  share,
  remove,
}
