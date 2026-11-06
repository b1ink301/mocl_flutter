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
/// 레이더 아이콘만 남는다(설정에서 다시 켠다).
///
/// 카드는 사이트 제목 위에 있어서, 늦게 나타나면 제목 · 게시판이 통째로 밀린다.
/// 그래서 처음 받는 동안은 같은 높이의 자리 표시로 칸을 잡아 두고, 못 받았거나
/// 이슈가 없을 때만 접는다 — 그때는 앱바 아이콘이 진입점이 된다. 다시 받는
/// 동안에는 직전 이슈를 그대로 둔다(깜빡이지 않게).
///
/// 앱을 켠 뒤 처음 놓일 때는 바로 그리고, 그다음부터(편집 · 검색을 마침,
/// 닫기 되돌리기, 설정에서 켬) 놓일 때는 펼치며 나타난다.
/// 닫기는 카드가 다 접힌 뒤 설정을 끈다 — 그래야 기존 큰 제목 앱바로 바뀌는
/// 순간 제목이 같은 자리에 있다.
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

  static const Duration _resize = Duration(milliseconds: 220);

  /// 이 실행에서 카드가 한 번이라도 놓였는지. 처음(앱 시작)은 펼침 없이 그린다.
  static bool _placedBefore = false;

  late final AppLifecycleListener _lifecycle;

  /// false 면 칸을 접어 둔다(나타나기 전 · 닫는 중).
  late bool _open;

  bool _closing = false;

  @override
  void initState() {
    super.initState();
    _lifecycle = AppLifecycleListener(onResume: _refreshIfStale);
    _open = !_placedBefore;
    _placedBefore = true;
    if (!_open) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && !_closing) setState(() => _open = true);
      });
    }
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

  /// 카드를 접고, 다 접힌 뒤 설정을 끈다(스낵바로 되돌리기).
  Future<void> _close() async {
    if (_closing) return;
    final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(
      context,
    );
    setState(() {
      _closing = true;
      _open = false;
    });
    await Future<void>.delayed(_resize);
    if (!mounted) return;
    final Future<void> Function() restore = closeIssueHomeCard(ref);
    messenger
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

  @override
  Widget build(BuildContext context) {
    final AsyncValue<IssueFeed> feed = issueFeedState(ref);
    final List<Issue> issues = homeCardIssuesState(ref);
    // 받은 적이 없고 받는 중일 때만 자리 표시. 실패 · 이슈 없음이면 접는다.
    final bool waiting = feed.value == null && feed.isLoading;

    final Widget child;
    if (!_open) {
      child = const SizedBox(width: double.infinity);
    } else if (issues.isNotEmpty) {
      child = _Card(
        onClose: _close,
        children: [
          for (int i = 0; i < issues.length; i++)
            _IssueRow(issue: issues[i], rank: i + 1),
        ],
      );
    } else if (waiting) {
      child = Semantics(
        label: '지금 이슈 불러오는 중',
        child: _Card(
          onClose: _close,
          children: const [
            _PlaceholderRow(widthFactor: 0.9),
            _PlaceholderRow(widthFactor: 0.65),
            _PlaceholderRow(widthFactor: 0.8),
          ],
        ),
      );
    } else {
      child = const SizedBox(width: double.infinity);
    }

    return AnimatedSize(
      duration: _resize,
      curve: Curves.easeOutCubic,
      alignment: Alignment.topCenter,
      child: child,
    );
  }
}

class const _Card({
  required final VoidCallback onClose,
  required final List<Widget> children,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
              _Header(onClose: onClose),
              ...children,
              const SizedBox(height: 6),
            ],
          ),
        ),
      ),
    );
  }
}

/// 받는 동안 이슈 줄 자리를 잡는 회색 막대. 높이는 [_IssueRow] 와 같다
/// (같은 여백 · 같은 글자 스타일의 빈 순위 칸이 줄 높이를 정한다).
class const _PlaceholderRow({required final double widthFactor})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme scheme = theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(14, 7, 14, 7),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: Text(
              ' ',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: AlignmentDirectional.centerStart,
              child: FractionallySizedBox(
                widthFactor: widthFactor,
                child: Container(
                  height: 10,
                  decoration: BoxDecoration(
                    color: scheme.onSurface.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),
          ),
        ],
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
