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

import 'package:mocl_flutter/core/presentation/widgets/large_title_sliver_app_bar.dart';

import '../../../core/presentation/widgets/plain_divider_widget.dart';
import 'widgets/bookmark_flow.dart';
import 'widgets/bookmark_folder_tag.dart';

/// 스크랩 목록. 홈 "보관함" 탭의 한 칸이다(`LibraryPage`).
///
/// 칸 전환 아래에 폴더 칩을 두고, 고른 폴더 · 검색어로 거른다. 검색은 보관함 앱바에서
/// 하고([search], 검색어는 [query]) 여기서는 받은 말로 거르기만 한다.
/// 행을 길게 누르면 폴더 · 메모 고치기 · 공유 · 지우기, 폴더 칩을 길게 누르면 폴더 고치기.
class const BookmarksPage({
  super.key,
  final String title = '스크랩',

  /// 큰 제목 아래에 둘 위젯(보관함의 칸 전환).
  final Widget? header,

  /// 앱바 검색(보관함이 준다).
  final AppBarSearch? search,

  /// 검색어(비면 거르지 않음).
  final String query = '',
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      // 넓은 화면(태블릿 가로 · 펼친 폴드 · iPad)에서는 목록 옆에 상세를 둔다.
      ListDetailLayout<PostSnapshot>(
        list: _BookmarksScaffold(
          title: title,
          header: header,
          search: search,
          query: query,
        ),
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
  required final AppBarSearch? search,
  required final String query,
}) extends ConsumerWidget with BookmarkState, BookmarkEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AsyncValue<List<PostSnapshot>> all = bookmarksState(ref);
    final List<BookmarkFolder> folders = bookmarkFoldersState(ref);
    final String? folderId = selectedBookmarkFolderState(ref);
    final AsyncValue<List<PostSnapshot>> filtered = all.whenData(
      (items) => BookmarkFilter.apply(items, folderId: folderId, query: query),
    );
    final styles = ref.watch(appTextStylesFontSizeProvider);
    // 떠 있는 탭바에 가리지 않게(홈 Scaffold 가 바 높이를 더해 준다).
    final double bottom = MediaQuery.paddingOf(context).bottom;
    final List<PostSnapshot> allItems = all.value ?? const [];
    final List<PostSnapshot> searched = BookmarkFilter.apply(
      allItems,
      query: query,
    );
    final Map<String, BookmarkFolder> folderById = {
      for (final BookmarkFolder f in folders) f.id: f,
    };

    return CustomScrollView(
      slivers: <Widget>[
        LargeTitleSliverAppBar(title: title, search: search),
        if (header case final Widget header) SliverToBoxAdapter(child: header),
        // 스크랩이 하나라도 있을 때만 폴더 줄을 보인다. 숫자는 검색어에 맞는 글 수.
        if (allItems.isNotEmpty)
          SliverToBoxAdapter(
            child: _FolderChips(
              folders: folders,
              counts: BookmarkFilter.countByFolder(searched),
              total: searched.length,
              selected: folderId,
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
                  separatorBuilder: (_, _) => const PlainDividerWidget(),
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

/// 폴더 칩 줄: 전체 · 폴더… · 새 폴더.
class const _FolderChips({
  required final List<BookmarkFolder> folders,
  required final Map<String, int> counts,
  required final int total,
  required final String? selected,
  required final TextStyle labelStyle,
}) extends ConsumerWidget with BookmarkEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final Brightness brightness = Theme.of(context).brightness;
    return SizedBox(
      // 큰 글자 설정에서 칩 글자가 잘리지 않게 줄 높이도 같이 키운다.
      height: MediaQuery.textScalerOf(context).scale(32).clamp(32, 68),
      child: ListView(
        // 큰 제목 · 칸 전환과 같은 좌우 여백.
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        children: [
          _FolderChip(
            label: '전체',
            count: total,
            selected: selected == null,
            style: labelStyle,
            onTap: () => selectBookmarkFolder(ref, null),
          ),
          for (final BookmarkFolder f in folders)
            _FolderChip(
              label: f.name,
              count: counts[f.id] ?? 0,
              dot: f.colorOf(brightness),
              selected: selected == f.id,
              style: labelStyle,
              onTap: () =>
                  selectBookmarkFolder(ref, selected == f.id ? null : f.id),
              onLongPress: () =>
                  unawaited(BookmarkFlow.editFolder(context, ref, f)),
            ),
          if (folders.length < BookmarkFolder.maxFolders)
            _FolderChip(
              label: folders.isEmpty ? '폴더 만들기' : '',
              icon: Icons.add,
              semanticLabel: '새 폴더',
              style: labelStyle,
              onTap: () => unawaited(BookmarkFlow.createFolder(context, ref)),
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
    // 선택은 잉크색으로 채운다(위의 칸 전환 · 탭바와 강조색이 겹치지 않게).
    final Color fg = selected ? scheme.surface : scheme.onSurface;
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: Semantics(
        button: true,
        selected: selected,
        label: semanticLabel,
        child: Material(
          color: selected ? scheme.onSurface : scheme.surfaceContainerLowest,
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
                        color: selected
                            ? scheme.surface.withValues(alpha: 0.7)
                            : scheme.outline,
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
