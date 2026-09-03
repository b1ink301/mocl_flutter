import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_category.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_divider_widget.dart';

import '../../../core/presentation/widgets/plain_icon_button.dart';
import 'state/add_event_mixin.dart';
import 'state/add_state_mixin.dart';
import 'widgets/board_search_field.dart';

/// 게시판 추가 화면.
///
/// 왼쪽 레일에서 사이트를 고르고, 오른쪽에서 게시판 칩을 눌러 담는다.
/// 칩을 누르는 즉시 즐겨찾기에 저장/해제되므로 따로 '적용'이 없다
/// (레일로 사이트를 옮겨 다녀도 고른 게 사라지지 않는다).
/// 담긴 게시판은 그 사이트 이름의 그룹으로 자동 분류된다.
class const AddListBottomSheet({super.key})
    extends ConsumerWidget
    with AddState, AddEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // DraggableScrollableSheet 를 쓰지 않는다. 그 위젯은 레이아웃 도중
    // (LayoutBuilder) 자기 subtree 를 다시 빌드하는데, 레일로 사이트를 바꿔
    // 목록이 갈아끼워지는 순간과 겹치면 Scrollable 의 GlobalKey 를 다시
    // 붙이려다 assert 로 죽었다. 2단(레일+칩) 화면에선 드래그로 높이를 바꿀
    // 이유도 없으므로 높이를 90% 로 고정한다.
    return FractionallySizedBox(
      heightFactor: 0.9,
      alignment: Alignment.bottomCenter,
      // ListTile 이 ink/배경을 가장 가까운 Material 에 그리므로, 배경색은
      // Container 가 아니라 Material 에 줘서 assertion(배경/잉크 가림)을 막는다.
      child: Material(
        borderRadius: const BorderRadiusGeometry.vertical(
          top: Radius.circular(24),
        ),
        color: theme.scaffoldBackgroundColor,
        clipBehavior: Clip.antiAlias,
        child: SafeArea(
          top: false,
          child: Column(
            children: [
              const _TopBar(),
              const PlainDividerWidget(),
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _SiteRail(),
                    Expanded(
                      child: Column(
                        children: [
                          const BoardSearchField(),
                          const Expanded(child: _BoardChips()),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class const _TopBar() extends ConsumerWidget with AddState, AddEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final SiteType site = currentSite(ref);
    final int count = addedBoardKeys(
      ref,
    ).where((key) => key.startsWith('${site.name}_')).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: SizedBox(
        height: 58,
        child: Row(
          children: [
            PlainIconButton(
              padding: const EdgeInsets.all(10),
              icon: const Icon(Icons.close),
              onPressed: () => context.pop(),
            ),
            const Expanded(
              child: Center(
                child: Text(
                  '게시판 추가',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // 누르는 즉시 저장되므로 '적용' 대신 담긴 개수를 보여준다.
            if (count > 0)
              Text(
                '$count개',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: theme.focusColor,
                ),
              ),
            // 로그인은 사이트마다 필요하므로 여기(사이트를 고르는 화면)에 둔다.
            // 로그인 화면은 지금 고른 사이트로 들어간다.
            if (site.supportsLogin)
              PlainIconButton(
                padding: const EdgeInsets.all(10),
                icon: const Icon(Icons.login),
                onPressed: () => login(ref, context),
              )
            else
              const SizedBox(width: 12),
          ],
        ),
      ),
    );
  }
}

/// 왼쪽 사이트 레일. 18개 사이트를 세로로 훑으며 탭 한 번으로 전환한다.
class const _SiteRail() extends ConsumerWidget with AddState, AddEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final SiteType selected = currentSite(ref);

    return Container(
      width: 92,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.03)
            : Colors.black.withValues(alpha: 0.02),
        border: Border(right: BorderSide(color: theme.dividerColor)),
      ),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 6),
        itemCount: kAllSitesInOrder.length,
        itemBuilder: (context, index) {
          final SiteType site = kAllSitesInOrder[index];
          return _RailItem(
            site: site,
            isSelected: site == selected,
            onTap: () => selectSite(ref, site),
          );
        },
      ),
    );
  }
}

class const _RailItem({
  required final SiteType site,
  required final bool isSelected,
  required final VoidCallback onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color focusColor = theme.focusColor;

    return Material(
      color: isSelected ? theme.scaffoldBackgroundColor : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Stack(
          children: [
            // 선택된 사이트는 왼쪽에 강조색 막대를 붙인다.
            if (isSelected)
              Positioned(
                left: 0,
                top: 8,
                bottom: 8,
                child: Container(
                  width: 3,
                  decoration: BoxDecoration(
                    color: focusColor,
                    borderRadius: const BorderRadius.horizontal(
                      right: Radius.circular(3),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 13, 6, 13),
              child: Text(
                site.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.25,
                  color: isSelected
                      ? focusColor
                      : theme.textTheme.bodySmall?.color,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 오른쪽 게시판 칩 목록. 담긴 칩은 강조색으로 채워진다.
class const _BoardChips() extends ConsumerWidget with AddState, AddEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      // 로딩 · 에러 · 목록 중 무엇을 그리든 스크롤 뷰는 트리에 그대로 둔다.
      // 분기마다 Scrollable 이 사라졌다 다시 생기면 사이트를 바꾸는 순간
      // 스크롤 위치와 상태가 통째로 갈아끼워진다.
      SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 24),
        child: _buildContent(context, ref),
      );

  Widget _buildContent(BuildContext context, WidgetRef ref) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;

    return boardListState(ref).when(
      // 담기/빼기 때마다 목록이 '로딩 중'으로 깜빡이지 않게 직전 목록을 유지한다.
      skipLoadingOnReload: true,
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 48),
        child: LoadingWidget(),
      ),
      // 레딧 · 네이버카페처럼 로그인해야 목록을 주는 사이트는 원문 에러 대신
      // 무엇을 해야 하는지 알려주고 바로 로그인으로 보낸다.
      error: (error, _) => error is NotLoginFailure
          ? _LoginRequired(site: currentSite(ref))
          : _LoadFailed(message: error.toString()),
      data: (boards) {
        final String query = searchQuery(ref).trim().toLowerCase();
        final List<MainItem> items = query.isEmpty
            ? boards
            : boards
                  .where(
                    (board) =>
                        board.text.toLowerCase().contains(query) ||
                        board.category.toLowerCase().contains(query),
                  )
                  .toList();

        if (items.isEmpty) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 48),
            child: Text(
              query.isEmpty ? '게시판이 없습니다' : "'$query' 검색 결과가 없습니다",
              textAlign: TextAlign.center,
              style: textStyle,
            ),
          );
        }

        final Set<String> added = addedBoardKeys(ref);
        return Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final MainItem board in items)
              _BoardChip(
                board: board,
                isAdded: added.contains('${board.siteType.name}_${board.board}'),
                onTap: () => toggleBoard(ref, board),
              ),
          ],
        );
      },
    );
  }
}

/// 로그인해야 게시판 목록을 받아오는 사이트의 안내. 바로 로그인으로 이어진다.
class const _LoginRequired({required final SiteType site})
    extends ConsumerWidget
    with AddEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final Color subColor = theme.textTheme.bodySmall?.color ?? theme.hintColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 8),
      child: Column(
        children: [
          Icon(Icons.lock_outline_rounded, size: 34, color: subColor),
          const SizedBox(height: 14),
          Text(
            '${site.title} 로그인이 필요해요',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '로그인하면 게시판 목록을 불러옵니다.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 12.5, color: subColor),
          ),
          const SizedBox(height: 18),
          FilledButton.icon(
            onPressed: () => login(ref, context),
            icon: const Icon(Icons.login, size: 18),
            label: const Text('로그인하기'),
            style: FilledButton.styleFrom(
              backgroundColor: theme.focusColor,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

/// 로그인 외의 이유로 목록을 못 불러왔을 때. 다시 시도할 수 있게 한다.
class const _LoadFailed({required final String message})
    extends ConsumerWidget
    with AddEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final Color subColor = theme.textTheme.bodySmall?.color ?? theme.hintColor;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 8),
      child: Column(
        children: [
          Icon(Icons.cloud_off_rounded, size: 34, color: subColor),
          const SizedBox(height: 14),
          Text(
            '게시판 목록을 불러오지 못했어요',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            maxLines: 4,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(fontSize: 12, color: subColor),
          ),
          const SizedBox(height: 18),
          OutlinedButton.icon(
            onPressed: () => retry(ref),
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('다시 시도'),
          ),
        ],
      ),
    );
  }
}

class const _BoardChip({
  required final MainItem board,
  required final bool isAdded,
  required final VoidCallback onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color focusColor = theme.focusColor;

    return Material(
      color: isAdded
          ? focusColor.withValues(alpha: 0.10)
          : theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(19),
        side: BorderSide(color: isAdded ? focusColor : theme.dividerColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isAdded) ...[
                Icon(Icons.check, size: 14, color: focusColor),
                const SizedBox(width: 5),
              ],
              Text(
                board.text,
                style: TextStyle(
                  fontSize: 13.5,
                  color: isAdded
                      ? focusColor
                      : theme.textTheme.bodyMedium?.color,
                  fontWeight: isAdded ? FontWeight.w700 : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
