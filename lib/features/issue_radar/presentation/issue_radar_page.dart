import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/presentation/widgets/large_title_sliver_app_bar.dart';
import 'package:mocl_flutter/core/presentation/widgets/message_view.dart';
import 'package:mocl_flutter/core/presentation/widgets/site_avatar.dart';
import 'package:mocl_flutter/core/presentation/widgets/window_size.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/radar/issue_feed.dart';

import 'state/issue_radar_event_mixin.dart';
import 'state/issue_radar_state_mixin.dart';
import 'widgets/issue_time.dart';

/// 이슈 레이더: 지금 여러 커뮤니티에서 함께 이야기되는 글 묶음.
///
/// 홈의 "지금 이슈" 탭 본문이다. 홈 셸은 탭을 `IndexedStack` 으로 살려 두므로
/// 앱을 켜면 곧바로 이슈를 받아 탭의 점(안 본 위쪽 이슈)을 맞춘다.
/// 앱이 오래 뒤에 있다가 돌아오면 이슈를 새로 받는다(그대로 두면 몇 시간 지난
/// 이슈가 남는다).
class const IssueRadarPage({super.key}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<IssueRadarPage> createState() => _IssueRadarPageState();
}

class _IssueRadarPageState()
    extends ConsumerState<IssueRadarPage>
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
    final AsyncValue<IssueFeed> feed = issueFeedState(ref);
    return RefreshIndicator.adaptive(
      color: Theme.of(context).colorScheme.primary,
      onRefresh: () => refreshIssues(ref),
      child: CustomScrollView(
        // 이슈가 적어도 당겨서 새로고침이 되도록.
        physics: const AlwaysScrollableScrollPhysics(),
        slivers: <Widget>[
          const LargeTitleSliverAppBar(title: '지금 이슈'),
          SliverReadableWidth(
            sliver: switch (feed) {
              AsyncData(:final value) => _IssueList(feed: value),
              AsyncError() => _IssueMessage(
                icon: Icons.cloud_off_outlined,
                title: '이슈를 불러오지 못했어요',
                description: '잠시 후 다시 시도해 주세요.',
                onRetry: () => unawaited(refreshIssues(ref)),
              ),
              _ => const SliverMessageView(
                child: CircularProgressIndicator.adaptive(),
              ),
            },
          ),
        ],
      ),
    );
  }
}

class const _IssueList({required final IssueFeed feed})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // 떠 있는 탭바에 가리지 않게 아래 여백을 둔다(Scaffold 가 바 높이를 더해 준다).
    final double bottom = MediaQuery.paddingOf(context).bottom;
    if (feed.issues.isEmpty) {
      return SliverMainAxisGroup(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            sliver: SliverToBoxAdapter(child: _Basis(feed: feed)),
          ),
          const _IssueMessage(
            icon: Icons.radar,
            title: '아직 이슈가 없어요',
            description: '여러 커뮤니티에서 함께 이야기되는 글이 생기면 여기에 모여요.',
          ),
        ],
      );
    }
    return SliverPadding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottom + 24),
      sliver: SliverList.separated(
        itemCount: feed.issues.length + 1,
        separatorBuilder: (_, i) => SizedBox(height: i == 0 ? 4 : 10),
        itemBuilder: (context, i) => i == 0
            ? _Basis(feed: feed)
            : _IssueCard(issue: feed.issues[i - 1], rank: i),
      ),
    );
  }
}

/// 어느 커뮤니티를 기준으로 본 이슈인지 밝힌다(빠진 곳을 숨기지 않는다).
class const _Basis({required final IssueFeed feed}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
      child: Text(
        '기준: ${feed.communities.map((s) => s.title).join(' · ')}\n'
        '${issueTimeAgo(feed.generatedAt)} 갱신 · 몇 분마다 새로 모읍니다',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class const _IssueCard({required final Issue issue, required final int rank})
    extends ConsumerWidget
    with IssueRadarState, IssueRadarEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final bool read = isIssueReadState(ref, issue.id);
    final Color muted = theme.colorScheme.onSurfaceVariant;

    return Material(
      color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.dividerColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () {
          unawaited(markIssueRead(ref, issue.id));
          unawaited(context.push(Routes.issueDetail, extra: issue));
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 28,
                    child: Text(
                      '$rank',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: rank <= 3 && !read
                            ? theme.colorScheme.primary
                            : muted,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      issue.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: read ? muted : null,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (issue.trending) ...[
                    const SizedBox(width: 6),
                    _TrendingBadge(),
                  ],
                ],
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 28),
                child: Row(
                  children: [
                    _SiteStack(sites: issue.sites),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${issue.sites.length}개 커뮤니티 · ${issue.posts.length}글 · '
                        '${issueTimeAgo(issue.firstSeenAt)} 시작',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: muted,
                        ),
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

class const _TrendingBadge() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: scheme.errorContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '급상승',
        style: TextStyle(
          color: scheme.onErrorContainer,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

/// 사이트 아이콘을 겹쳐 놓는다(최대 5개).
class const _SiteStack({required final List<SiteType> sites})
    extends StatelessWidget {
  static const double _r = 10;

  @override
  Widget build(BuildContext context) {
    final List<SiteType> shown = sites.take(5).toList();
    final Color ring = Theme.of(context).scaffoldBackgroundColor;
    return SizedBox(
      width: _r * 2 + (shown.length - 1) * _r * 1.3,
      height: _r * 2,
      child: Stack(
        children: [
          for (int i = 0; i < shown.length; i++)
            Positioned(
              left: i * _r * 1.3,
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: ring, width: 1.5),
                ),
                child: SiteAvatar(siteType: shown[i], radius: _r - 1.5),
              ),
            ),
        ],
      ),
    );
  }
}

/// 빈 화면 · 오류 화면. 다른 탭(게시판 · 스크랩)과 같은 [MessageView] 모양.
class const _IssueMessage({
  required final IconData icon,
  required final String title,
  required final String description,
  final VoidCallback? onRetry,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTextStyles styles = ref.watch(appTextStylesFontSizeProvider);
    return SliverMessageView(
      child: MessageView(
        icon: icon,
        title: title,
        description: description,
        primaryLabel: '다시 시도',
        onPrimary: onRetry,
        titleStyle: styles.titleTextStyle,
        descriptionStyle: styles.smallTextStyle,
      ),
    );
  }
}
