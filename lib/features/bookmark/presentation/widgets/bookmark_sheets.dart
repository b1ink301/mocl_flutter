import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/features/database/domain/entities/bookmark_folder.dart';

import '../state/bookmark_event_mixin.dart';
import '../state/bookmark_state_mixin.dart';
import 'bookmark_folder_tag.dart';

/// 폴더 만들기 · 고치기 시트의 결과.
sealed class const FolderSheetResult();

/// 저장(이름 · 색).
class const FolderSaved(final String name, final int tone)
    extends FolderSheetResult;

/// 폴더 지우기.
class const FolderDeleted() extends FolderSheetResult;

/// 폴더 이름 · 색. [folder] 가 있으면 고치기(지우기 버튼이 보인다), 없으면 새로 만들기.
class const BookmarkFolderSheet({
  super.key,
  final BookmarkFolder? folder,

  /// 새 폴더의 처음 색(폴더마다 다른 색이 먼저 고르게 돌린다).
  final int initialTone = 1,
}) extends StatefulWidget {
  @override
  State<BookmarkFolderSheet> createState() => _BookmarkFolderSheetState();
}

class _BookmarkFolderSheetState() extends State<BookmarkFolderSheet> {
  late final TextEditingController _name = TextEditingController(
    text: widget.folder?.name ?? '',
  );
  late int _tone = widget.folder?.tone ?? widget.initialTone;

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  void _save() {
    final String name = _name.text.trim();
    if (name.isEmpty) return;
    Navigator.of(context).pop(FolderSaved(name, _tone));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool editing = widget.folder != null;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(editing ? '폴더 고치기' : '새 폴더', style: theme.textTheme.titleMedium),
          const SizedBox(height: 12),
          TextField(
            controller: _name,
            autofocus: !editing,
            maxLength: BookmarkFolder.maxNameLength,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _save(),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: '폴더 이름 (예: 읽을거리)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 4),
          BookmarkToneSelector(
            selected: _tone,
            onChanged: (tone) => setState(() => _tone = tone),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _name.text.trim().isEmpty ? null : _save,
              child: Text(editing ? '저장' : '만들기'),
            ),
          ),
          if (editing)
            SizedBox(
              width: double.infinity,
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: theme.colorScheme.error,
                ),
                onPressed: () =>
                    Navigator.of(context).pop(const FolderDeleted()),
                child: const Text('폴더 지우기'),
              ),
            ),
        ],
      ),
    );
  }
}

/// 스크랩 한 개의 폴더 · 메모. 완료하면 `(folders, memo)` 를, 닫으면 null 을 돌려준다.
///
/// 폴더는 여러 개 고를 수 있고, 시트 안에서 새 폴더를 만들면 바로 체크된다.
class const BookmarkMetaSheet({
  super.key,
  required final String title,
  required final String postTitle,
  required final List<String> folders,
  required final String memo,

  /// "새 폴더" 를 눌렀을 때. 만든 폴더를 돌려준다(취소면 null).
  required final Future<BookmarkFolder?> Function() onCreateFolder,
}) extends ConsumerStatefulWidget {
  /// 메모 최대 길이.
  static const int maxMemoLength = 200;

  @override
  ConsumerState<BookmarkMetaSheet> createState() => _BookmarkMetaSheetState();
}

class _BookmarkMetaSheetState()
    extends ConsumerState<BookmarkMetaSheet>
    with BookmarkState, BookmarkEvent {
  late final Set<String> _selected = {...widget.folders};
  late final TextEditingController _memo = TextEditingController(
    text: widget.memo,
  );

  @override
  void dispose() {
    _memo.dispose();
    super.dispose();
  }

  Future<void> _create() async {
    final BookmarkFolder? folder = await widget.onCreateFolder();
    if (folder != null && mounted) setState(() => _selected.add(folder.id));
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final List<BookmarkFolder> folders = bookmarkFoldersState(ref);
    final bool canAdd = folders.length < BookmarkFolder.maxFolders;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.title, style: theme.textTheme.titleMedium),
          const SizedBox(height: 2),
          Text(
            widget.postTitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          // 폴더가 많으면 목록만 스크롤한다(메모 · 완료 버튼은 늘 보이게).
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.sizeOf(context).height * 0.35,
            ),
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              children: [
                for (final BookmarkFolder folder in folders)
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    value: _selected.contains(folder.id),
                    onChanged: (on) => setState(
                      () => on == true
                          ? _selected.add(folder.id)
                          : _selected.remove(folder.id),
                    ),
                    secondary: Icon(
                      Icons.folder,
                      color: folder.colorOf(theme.brightness),
                    ),
                    title: Text(folder.name),
                  ),
                if (canAdd)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    dense: true,
                    leading: Icon(
                      Icons.create_new_folder_outlined,
                      color: theme.colorScheme.primary,
                    ),
                    title: Text(
                      '새 폴더',
                      style: TextStyle(color: theme.colorScheme.primary),
                    ),
                    onTap: _create,
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _memo,
            minLines: 1,
            maxLines: 3,
            maxLength: BookmarkMetaSheet.maxMemoLength,
            textInputAction: TextInputAction.newline,
            decoration: InputDecoration(
              labelText: '메모 (선택)',
              hintText: '나중에 볼 때 떠올릴 한마디',
              prefixIcon: const Icon(Icons.edit_note, size: 22),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => Navigator.of(context).pop((
                folders: [
                  // 폴더 순서(만든 순)대로 둔다.
                  for (final BookmarkFolder f in folders)
                    if (_selected.contains(f.id)) f.id,
                ],
                memo: _memo.text.trim(),
              )),
              child: const Text('완료'),
            ),
          ),
        ],
      ),
    );
  }
}
