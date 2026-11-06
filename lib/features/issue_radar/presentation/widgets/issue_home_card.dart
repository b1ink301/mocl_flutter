import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_shared/radar/issue_feed.dart';

import '../state/issue_radar_event_mixin.dart';
import '../state/issue_radar_state_mixin.dart';

/// 메인 화면 맨 위의 "지금 이슈" 카드. 위쪽 이슈 몇 개를 미리 보여 준다.
///
/// 머리줄을 누르면 이슈 목록, 줄을 누르면 그 이슈 상세로 간다. 닫으면 앱바의
/// 레이더 아이콘만 남는다(설정에서 다시 켠다). 이슈를 받는 중이거나 못 받았거나
/// 없으면 칸을 차지하지 않는다 — 그때는 앱바 아이콘이 진입점이 된다.
///
/// 앱이 오래 뒤에 있다가 돌아오면 이슈를 새로 받는다(메인은 계속 살아 있어서
/// 그대로 두면 몇 시간 지난 이슈가 남는다).
class const IssueHomeCard({super.key}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<IssueHomeCard> createState() => _IssueHomeCardState();
}

class _IssueHomeCardState()
    extends ConsumerState<IssueHomeCard>
    with IssueRadarState, IssueRadarEvent {
  /// 앱에 돌아왔을 때 이보다 오래된 이슈면 새로 받는다.
  static const Duration _staleAfter = Duration(minutes: 10);

  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _refreshIfStale);
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  void _refreshIfStale() {
    final IssueFeed? feed = readIssueFeed(ref);
    if (feed == null) return;
    final DateTime at = DateTime.fromMillisecondsSinceEpoch(feed.generatedAt);
    if (DateTime.now().difference(at) < _staleAfter) return;
    unawaited(refreshIssues(ref));
  }

  @override
  Widget build(BuildContext context) {
    final List<Issue> issues = homeCardIssuesState(ref);
    return AnimatedSize(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: issues.isEmpty
          ? const SizedBox(width: double.infinity)
          : _Card(issues: issues),
    );
  }
}

class const _Card({required final List<Issue> issues})
    extends ConsumerWidget
    with IssueRadarEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;

    return Semantics(
      identifier: 'main_issue_card',
      container: true,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 4, 12, 8),
        child: Material(
          color: scheme.primaryContainer.withValues(alpha: 0.55),
          borderRadius: BorderRadius.circular(14),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(onClose: () => _close(context, ref)),
              for (int i = 0; i < issues.length; i++)
                _IssueRow(issue: issues[i], rank: i + 1),
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }

  void _close(BuildContext context, WidgetRef ref) {
    final Future<void> Function() restore = closeIssueHomeCard(ref);
    ScaffoldMessenger.maybeOf(context)
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('지금 이슈는 위쪽 레이더 아이콘으로 볼 수 있어요. 설정에서 다시 켤 수 있어요.'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: '되돌리기',
            onPressed: () => unawaited(restore()),
          ),
        ),
      );
  }
}

class const _Header({required final VoidCallback onClose})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final Color onCard = scheme.onPrimaryContainer;

    return InkWell(
      onTap: () => unawaited(context.push(Routes.issues)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 4, 2, 0),
        child: Row(
          children: [
            Icon(Icons.radar, size: 20, color: scheme.primary),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                '지금 이슈',
                style: theme.textTheme.titleSmall?.copyWith(
                  color: onCard,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              '전체',
              style: theme.textTheme.bodySmall?.copyWith(
                color: onCard.withValues(alpha: 0.75),
              ),
            ),
            Icon(
              Icons.chevron_right,
              size: 18,
              color: onCard.withValues(alpha: 0.75),
            ),
            IconButton(
              onPressed: onClose,
              tooltip: '지금 이슈 카드 닫기',
              visualDensity: VisualDensity.compact,
              icon: Icon(
                Icons.close,
                size: 18,
                color: onCard.withValues(alpha: 0.6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class const _IssueRow({required final Issue issue, required final int rank})
    extends ConsumerWidget
    with IssueRadarState, IssueRadarEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    final bool read = isIssueReadState(ref, issue.id);
    // 제목은 본문색으로 둔다(테마에 따라 onPrimaryContainer 가 강조색이라 읽기 어렵다).
    final Color onCard = scheme.onSurface;
    final Color dim = scheme.onSurfaceVariant.withValues(alpha: 0.75);

    return InkWell(
      onTap: () {
        unawaited(markIssueRead(ref, issue.id));
        unawaited(context.push(Routes.issueDetail, extra: issue));
      },
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
        child: Row(
          children: [
            SizedBox(
              width: 20,
              child: Text(
                '$rank',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: read ? dim : scheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
            Expanded(
              child: Text(
                issue.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: read ? dim : onCard,
                ),
              ),
            ),
            const SizedBox(width: 8),
            _SitesPill(
              text: issue.trending
                  ? '급상승 · ${issue.sites.length}곳'
                  : '${issue.sites.length}곳',
              hot: issue.trending && !read,
            ),
          ],
        ),
      ),
    );
  }
}

class const _SitesPill({required final String text, required final bool hot})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
      decoration: BoxDecoration(
        color: hot ? scheme.errorContainer : scheme.surface,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: theme.textTheme.labelSmall?.copyWith(
          color: hot ? scheme.onErrorContainer : scheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
