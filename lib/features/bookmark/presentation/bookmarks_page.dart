import 'dart:async';

import 'package:mocl_flutter/core/presentation/widgets/window_size.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/presentation/widgets/category_tag.dart';
import 'package:mocl_flutter/features/bookmark/domain/bookmark_filter.dart';
import 'package:mocl_flutter/features/database/domain/entities/bookmark_folder.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/presentation/widgets/list_detail_layout.dart';
import 'package:mocl_flutter/features/database/domain/entities/post_snapshot.dart';
import 'package:mocl_flutter/features/detail_page/presentation/mocl_detail_page.dart';
import 'package:mocl_flutter/features/bookmark/presentation/state/bookmark_event_mixin.dart';
import 'package:mocl_flutter/features/bookmark/presentation/state/bookmark_state_mixin.dart';

import '../../../core/presentation/widgets/failure_view.dart';
import '../../../core/presentation/widgets/large_title_sliver_app_bar.dart';
import 'widgets/bookmark_flow.dart';
import 'widgets/bookmark_folder_tag.dart';

/// 스크랩 목록. 홈 "보관함" 탭의 한 칸이다(`LibraryPage`).
///
/// 칸 전환 아래에 검색창과 폴더 칩을 두고, 고른 폴더 · 검색어로 거른다.
/// 행을 길게 누르면 폴더 · 메모 고치기 · 공유 · 지우기, 폴더 칩을 길게 누르면 폴더 고치기.
class const BookmarksPage({
  super.key,
  final String title = '스크랩',

  /// 큰 제목 아래에 둘 위젯(보관함의 칸 전환).
  final Widget? header,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      // 넓은 화면(태블릿 가로 · 펼친 폴드 · iPad)에서는 목록 옆에 상세를 둔다.
      ListDetailLayout<PostSnapshot>(
        list: _BookmarksScaffold(title: title, header: header),
        detailBuilder: (_, b) =>
            DetailPage.init(b.toListItem(), siteType: b.siteType),
        pushDetail: (context, b) =>
            context.push<void>(Routes.detail, extra: b.toListItem()),
        keyOf: _bookmarkKey,
        detailRoutePath: Routes.detail,
      );
}

String _bookmarkKey(PostSnapshot b) => '${b.siteType.name}_${b.id}';

/// 게시판 탭과 같은 큰 제목 앱바 + 스크랩 목록.
class const _BookmarksScaffold({
  required final String title,
  required final Widget? header,
}) extends ConsumerWidget with BookmarkState, BookmarkEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<PostSnapshot>> all = bookmarksState(ref);
    final AsyncValue<List<PostSnapshot>> filtered = filteredBookmarksState(ref);
    final List<BookmarkFolder> folders = bookmarkFoldersState(ref);
    final String? folderId = selectedBookmarkFolderState(ref);
    final String query = bookmarkQueryState(ref);
    final styles = ref.watch(appTextStylesFontSizeProvider);
    // 떠 있는 탭바에 가리지 않게(홈 Scaffold 가 바 높이를 더해 준다).
    final double bottom = MediaQuery.paddingOf(context).bottom;
    final List<PostSnapshot> allItems = all.value ?? const [];
    final Map<String, BookmarkFolder> folderById = {
      for (final BookmarkFolder f in folders) f.id: f,
    };

    return CustomScrollView(
      slivers: <Widget>[
        LargeTitleSliverAppBar(title: title),
        if (header case final Widget header) SliverToBoxAdapter(child: header),
        // 스크랩이 하나라도 있을 때만 검색 · 폴더 줄을 보인다.
        if (allItems.isNotEmpty)
          SliverToBoxAdapter(
            child: _SearchAndFolders(
              folders: folders,
              counts: BookmarkFilter.countByFolder(allItems),
              total: allItems.length,
              selected: folderId,
              query: query,
              labelStyle: styles.smallTextStyle,
            ),
          ),
        filtered.when(
          loading: () => const SliverMessageView(
            child: CircularProgressIndicator.adaptive(),
          ),
          error: (e, _) => SliverMessageView(
            child: FailureView(
              error: e,
              titleStyle: styles.titleTextStyle,
              descriptionStyle: styles.smallTextStyle,
            ),
          ),
          data: (items) {
            if (items.isEmpty) {
              final BookmarkFolder? folder = folderById[folderId];
              final (String head, String body) = switch (allItems.isEmpty) {
                true => ('스크랩한 글이 없어요', '글 화면 위쪽의 스크랩 버튼을 누르면 여기에 모아 둬요.'),
                false when query.trim().isNotEmpty => (
                  '\'${query.trim()}\' 에 맞는 스크랩이 없어요',
                  '제목 · 메모 · 사이트 · 게시판 이름에서 찾아요.',
                ),
                false => (
                  '\'${folder?.name ?? ''}\' 폴더가 비어 있어요',
                  '스크랩을 길게 눌러 이 폴더에 넣을 수 있어요.',
                ),
              };
              return SliverMessageView(
                child: MessageView(
                  icon: allItems.isEmpty
                      ? Icons.bookmark_border
                      : query.trim().isNotEmpty
                      ? Icons.search_off
                      : Icons.folder_open,
                  title: head,
                  description: body,
                  titleStyle: styles.titleTextStyle,
                  descriptionStyle: styles.smallTextStyle,
                ),
              );
            }
            // 넓은 화면에서는 목록을 읽기 좋은 폭으로 가운데 모은다.
            return SliverReadableWidth(
              sliver: SliverPadding(
                padding: EdgeInsets.only(bottom: bottom + 16),
                sliver: SliverList.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const Divider(height: 1),
                  itemBuilder: (context, i) {
                    final PostSnapshot b = items[i];
                    return _BookmarkTile(
                      post: b,
                      folders: [
                        for (final String id in b.folders)
                          if (folderById[id] case final BookmarkFolder f) f,
                      ],
                      query: query,
                      titleStyle: styles.titleTextStyle,
                      subtitleStyle: styles.smallTextStyle,
                      onRemove: () =>
                          unawaited(removeBookmark(ref, b.siteType, b.id)),
                      onLongPress: () =>
                          unawaited(BookmarkFlow.showActions(context, ref, b)),
                      onTap: () {
                        // 상세는 현재 사이트 기준으로 동작하므로 먼저 사이트를 전환한다.
                        ref
                            .read(currentSiteTypeProvider.notifier)
                            .changeSiteType(b.siteType);
                        if (ListDetailScope.tryOpen(context, b)) return;
                        context.push(Routes.detail, extra: b.toListItem());
                      },
                    );
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// 검색창 + 폴더 칩 줄.
class const _SearchAndFolders({
  required final List<BookmarkFolder> folders,
  required final Map<String, int> counts,
  required final int total,
  required final String? selected,
  required final String query,
  required final TextStyle labelStyle,
}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<_SearchAndFolders> createState() => _SearchAndFoldersState();
}

class _SearchAndFoldersState()
    extends ConsumerState<_SearchAndFolders>
    with BookmarkEvent {
  late final TextEditingController _controller = TextEditingController(
    text: widget.query,
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.clear();
    updateBookmarkQuery(ref, '');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    return Padding(
      // 큰 제목 · 칸 전환과 같은 좌우 여백.
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Semantics(
            identifier: 'bookmark_search',
            child: TextField(
              controller: _controller,
              textInputAction: TextInputAction.search,
              onChanged: (text) {
                updateBookmarkQuery(ref, text);
                setState(() {});
              },
              onTapOutside: (_) => FocusScope.of(context).unfocus(),
              style: widget.labelStyle.copyWith(color: scheme.onSurface),
              decoration: InputDecoration(
                isDense: true,
                hintText: '스크랩에서 찾기 (제목 · 메모)',
                hintStyle: widget.labelStyle.copyWith(color: scheme.outline),
                prefixIcon: Icon(Icons.search, size: 20, color: scheme.outline),
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: '지우기',
                        icon: const Icon(Icons.close, size: 18),
                        onPressed: _clear,
                      ),
                filled: true,
                fillColor: scheme.surfaceContainerLowest,
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: scheme.outlineVariant),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: scheme.outlineVariant),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _FolderChip(
                  label: '전체',
                  count: widget.total,
                  selected: widget.selected == null,
                  style: widget.labelStyle,
                  onTap: () => selectBookmarkFolder(ref, null),
                ),
                for (final BookmarkFolder f in widget.folders)
                  _FolderChip(
                    label: f.name,
                    count: widget.counts[f.id] ?? 0,
                    dot: f.colorOf(theme.brightness),
                    selected: widget.selected == f.id,
                    style: widget.labelStyle,
                    onTap: () => selectBookmarkFolder(
                      ref,
                      widget.selected == f.id ? null : f.id,
                    ),
                    onLongPress: () =>
                        unawaited(BookmarkFlow.editFolder(context, ref, f)),
                  ),
                if (widget.folders.length < BookmarkFolder.maxFolders)
                  _FolderChip(
                    label: widget.folders.isEmpty ? '폴더 만들기' : '',
                    icon: Icons.add,
                    semanticLabel: '새 폴더',
                    style: widget.labelStyle,
                    onTap: () =>
                        unawaited(BookmarkFlow.createFolder(context, ref)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class const _FolderChip({
  required final String label,
  required final TextStyle style,
  required final VoidCallback onTap,
  final int? count,
  final bool selected = false,
  final Color? dot,
  final IconData? icon,
  final String? semanticLabel,
  final VoidCallback? onLongPress,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final Color fg = selected ? scheme.primary : scheme.onSurface;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Semantics(
        button: true,
        selected: selected,
        label: semanticLabel,
        child: Material(
          color: selected ? scheme.primaryContainer : scheme.surfaceContainer,
          shape: StadiumBorder(
            side: BorderSide(
              color: selected ? Colors.transparent : scheme.outlineVariant,
            ),
          ),
          child: InkWell(
            customBorder: const StadiumBorder(),
            onTap: onTap,
            onLongPress: onLongPress,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (dot case final Color dot) ...[
                    DecoratedBox(
                      decoration: BoxDecoration(
                        color: dot,
                        shape: BoxShape.circle,
                      ),
                      child: const SizedBox(width: 8, height: 8),
                    ),
                    const SizedBox(width: 6),
                  ],
                  if (icon case final IconData icon)
                    Icon(icon, size: 16, color: scheme.primary),
                  if (label.isNotEmpty)
                    Text(
                      label,
                      style: style.copyWith(
                        color: icon != null ? scheme.primary : fg,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                  if (count != null) ...[
                    const SizedBox(width: 4),
                    Text(
                      '$count',
                      style: style.copyWith(
                        color: selected ? scheme.primary : scheme.outline,
                        fontSize: (style.fontSize ?? 13) * 0.85,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 스크랩 한 줄: 제목(검색어 강조) · 사이트 · 게시판 · 폴더 태그 · 메모.
class const _BookmarkTile({
  required final PostSnapshot post,
  required final List<BookmarkFolder> folders,
  required final String query,
  required final TextStyle titleStyle,
  required final TextStyle subtitleStyle,
  required final VoidCallback onRemove,
  required final VoidCallback onLongPress,
  required final VoidCallback onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextStyle highlight = TextStyle(
      color: scheme.primary,
      fontWeight: FontWeight.w700,
    );
    final String board = post.boardTitle.isEmpty
        ? post.siteType.title
        : '${post.siteType.title} · ${post.boardTitle}';
    final double tagSize = (subtitleStyle.fontSize ?? 13) * 0.85;

    return Dismissible(
      key: ValueKey(_bookmarkKey(post)),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        title: Text.rich(
          TextSpan(children: highlightSpans(post.title, query, highlight)),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: titleStyle,
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 6,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text(board, style: subtitleStyle),
                  for (final BookmarkFolder f in folders)
                    BookmarkFolderTag(folder: f, fontSize: tagSize),
                ],
              ),
              if (post.memo.isNotEmpty) ...[
                const SizedBox(height: 6),
                _MemoBox(
                  memo: post.memo,
                  query: query,
                  style: subtitleStyle.copyWith(color: scheme.onSurface),
                  highlight: highlight,
                ),
              ],
            ],
          ),
        ),
        selected: ListDetailScope.isSelected(context, _bookmarkKey(post)),
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}

/// 메모: 연한 강조색 칸에 두 줄까지.
class const _MemoBox({
  required final String memo,
  required final String query,
  required final TextStyle style,
  required final TextStyle highlight,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.primaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 1, right: 6),
              child: Icon(
                Icons.edit_note,
                size: (style.fontSize ?? 13) * 1.2,
                color: scheme.primary,
              ),
            ),
            Expanded(
              child: Text.rich(
                TextSpan(children: highlightSpans(memo, query, highlight)),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: style.copyWith(fontFamily: kAppFontFamily),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
