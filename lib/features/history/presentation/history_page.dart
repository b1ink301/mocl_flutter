import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/presentation/widgets/failure_view.dart';
import 'package:mocl_flutter/core/presentation/widgets/large_title_sliver_app_bar.dart';
import 'package:mocl_flutter/core/presentation/widgets/list_detail_layout.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_icon.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_icon_button.dart';
import 'package:mocl_flutter/core/presentation/widgets/window_size.dart';
import 'package:mocl_flutter/features/database/domain/entities/post_snapshot.dart';
import 'package:mocl_flutter/features/detail_page/presentation/mocl_detail_page.dart';
import 'package:mocl_flutter/features/history/presentation/state/history_event_mixin.dart';
import 'package:mocl_flutter/features/history/presentation/state/history_state_mixin.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';

/// 최근 본 글. 홈 "보관함" 탭의 한 칸이다(`LibraryPage`).
///
/// 상세를 받을 때마다 남기고(`HistoryNotifier.record`), 30일 · 300개까지 둔다.
class const HistoryPage({
  super.key,
  final String title = '히스토리',

  /// 큰 제목 아래에 둘 위젯(보관함의 칸 전환).
  final Widget? header,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      // 넓은 화면(태블릿 가로 · 펼친 폴드 · iPad)에서는 목록 옆에 상세를 둔다.
      ListDetailLayout<PostSnapshot>(
        list: _HistoryScaffold(title: title, header: header),
        detailBuilder: (_, p) =>
            DetailPage.init(p.toListItem(), siteType: p.siteType),
        pushDetail: (context, p) =>
            context.push<void>(Routes.detail, extra: p.toListItem()),
        keyOf: _keyOf,
        detailRoutePath: Routes.detail,
      );
}

String _keyOf(PostSnapshot p) => p.key;

/// 게시판 탭과 같은 큰 제목 앱바 + 최근 본 글 목록.
class const _HistoryScaffold({
  required final String title,
  required final Widget? header,
}) extends ConsumerWidget with HistoryState, HistoryEvent {
  Future<void> _clear(BuildContext context, WidgetRef ref) async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('최근 본 글을 모두 지울까요?'),
        content: const Text('읽음 표시는 그대로 남아요.'),
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
    if (ok == true) await clearHistory(ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = historyState(ref);
    final styles = ref.watch(appTextStylesFontSizeProvider);
    // 떠 있는 탭바에 가리지 않게(홈 Scaffold 가 바 높이를 더해 준다).
    final double bottom = MediaQuery.paddingOf(context).bottom;
    final bool hasItems = async.value?.isNotEmpty ?? false;

    return CustomScrollView(
      slivers: <Widget>[
        LargeTitleSliverAppBar(
          title: title,
          actions: [
            if (hasItems)
              PlainIconButton(
                semanticLabel: '최근 본 글 모두 지우기',
                semanticsId: 'history_clear',
                padding: const EdgeInsets.symmetric(horizontal: 12),
                onPressed: () => _clear(context, ref),
                icon: const PlainIcon(Icons.delete_sweep_outlined),
              ),
          ],
        ),
        if (header case final Widget header) SliverToBoxAdapter(child: header),
        async.when(
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
              return SliverMessageView(
                child: MessageView(
                  icon: Icons.history,
                  title: '최근 본 글이 없어요',
                  description: '글을 열면 여기에 30일 동안 남겨 둬요.',
                  titleStyle: styles.titleTextStyle,
                  descriptionStyle: styles.smallTextStyle,
                ),
              );
            }
            final List<_Row> rows = _rowsOf(items, DateTime.now());
            // 넓은 화면에서는 목록을 읽기 좋은 폭으로 가운데 모은다.
            return SliverReadableWidth(
              sliver: SliverPadding(
                padding: EdgeInsets.only(bottom: bottom + 16),
                sliver: SliverList.builder(
                  itemCount: rows.length,
                  itemBuilder: (context, i) => switch (rows[i]) {
                    _Header(:final String label) => _DayHeader(
                      label: label,
                      style: styles.smallTextStyle,
                    ),
                    _Item(:final PostSnapshot post) => _HistoryTile(
                      post: post,
                      titleStyle: styles.titleTextStyle,
                      subtitleStyle: styles.smallTextStyle,
                      onRemove: () =>
                          unawaited(removeHistory(ref, post.siteType, post.id)),
                      onTap: () {
                        // 상세는 현재 사이트 기준으로 동작하므로 먼저 사이트를 전환한다.
                        ref
                            .read(currentSiteTypeProvider.notifier)
                            .changeSiteType(post.siteType);
                        if (ListDetailScope.tryOpen(context, post)) return;
                        context.push(Routes.detail, extra: post.toListItem());
                      },
                    ),
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

/// 목록 한 줄: 날짜 머리 또는 글.
sealed class const _Row();

class const _Header(final String label) extends _Row;

class const _Item(final PostSnapshot post) extends _Row;

/// 최근 본 순 [items] 에 날짜가 바뀔 때마다 머리를 끼운다.
List<_Row> _rowsOf(List<PostSnapshot> items, DateTime now) {
  final List<_Row> rows = <_Row>[];
  String? last;
  for (final PostSnapshot item in items) {
    final String label = historyDayLabel(
      DateTime.fromMillisecondsSinceEpoch(item.savedAt),
      now,
    );
    if (label != last) {
      rows.add(_Header(label));
      last = label;
    }
    rows.add(_Item(item));
  }
  return rows;
}

/// 날짜 머리: 오늘 · 어제 · `11월 3일`(올해) · `2025년 12월 30일`.
@visibleForTesting
String historyDayLabel(DateTime viewedAt, DateTime now) {
  final DateTime day = DateTime(viewedAt.year, viewedAt.month, viewedAt.day);
  final DateTime today = DateTime(now.year, now.month, now.day);
  final int diff = today.difference(day).inDays;
  if (diff <= 0) return '오늘';
  if (diff == 1) return '어제';
  if (day.year == today.year) return '${day.month}월 ${day.day}일';
  return '${day.year}년 ${day.month}월 ${day.day}일';
}

class const _DayHeader({required final String label, final TextStyle? style})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
    child: Semantics(
      header: true,
      child: Text(label, style: style?.copyWith(fontWeight: FontWeight.w700)),
    ),
  );
}

class const _HistoryTile({
  required final PostSnapshot post,
  required final TextStyle? titleStyle,
  required final TextStyle? subtitleStyle,
  required final VoidCallback onRemove,
  required final VoidCallback onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DateTime viewedAt = DateTime.fromMillisecondsSinceEpoch(post.savedAt);
    final String hhmm =
        '${viewedAt.hour.toString().padLeft(2, '0')}:'
        '${viewedAt.minute.toString().padLeft(2, '0')}';
    final String board = post.boardTitle.isEmpty
        ? post.siteType.title
        : '${post.siteType.title} · ${post.boardTitle}';

    return Dismissible(
      key: ValueKey(post.key),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onRemove(),
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      child: ListTile(
        title: Text(
          post.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: titleStyle,
        ),
        subtitle: Text('$board · $hhmm', style: subtitleStyle),
        selected: ListDetailScope.isSelected(context, post.key),
        onTap: onTap,
      ),
    );
  }
}
