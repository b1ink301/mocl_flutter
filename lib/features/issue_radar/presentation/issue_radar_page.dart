import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/presentation/widgets/site_avatar.dart';
import 'package:mocl_flutter/core/presentation/widgets/window_size.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/radar/issue_feed.dart';

import 'state/issue_radar_event_mixin.dart';
import 'state/issue_radar_state_mixin.dart';
import 'widgets/issue_time.dart';

/// 이슈 레이더: 지금 여러 커뮤니티에서 함께 이야기되는 글 묶음.
class const IssueRadarPage({super.key})
    extends ConsumerWidget
    with IssueRadarState, IssueRadarEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final systemOverlayStyle =
        theme.appBarTheme.systemOverlayStyle ?? SystemUiOverlayStyle.light;
    final titleStyle = ref.watch(appbarTextStyleProvider);
    final AsyncValue<IssueFeed> feed = issueFeedState(ref);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle,
      child: Container(
        color: systemOverlayStyle.statusBarColor,
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: theme.appBarTheme.backgroundColor,
              title: Text('지금 이슈', style: titleStyle),
              scrolledUnderElevation: 0,
              titleSpacing: 0,
            ),
            body: BoxReadableWidth(
              child: RefreshIndicator(
                onRefresh: () => refreshIssues(ref),
                child: switch (feed) {
                  AsyncData(:final value) => _IssueList(feed: value),
                  AsyncError() => _Message(
                    icon: Icons.cloud_off_outlined,
                    text: '이슈를 불러오지 못했어요.',
                    action: TextButton(
                      onPressed: () => unawaited(refreshIssues(ref)),
                      child: const Text('다시 시도'),
                    ),
                  ),
                  _ => const Center(child: CircularProgressIndicator()),
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class const _IssueList({required final IssueFeed feed})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double bottom = MediaQuery.of(context).padding.bottom;
    if (feed.issues.isEmpty) {
      return ListView(
        // 당겨서 새로고침이 되도록 스크롤 가능하게 둔다.
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          _Basis(feed: feed),
          const SizedBox(height: 120),
          const _Message(icon: Icons.radar, text: '아직 여러 커뮤니티에 걸친 이슈가 없어요.'),
        ],
      );
    }
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16, 0, 16, bottom + 24),
      itemCount: feed.issues.length + 1,
      separatorBuilder: (_, i) => SizedBox(height: i == 0 ? 4 : 10),
      itemBuilder: (context, i) => i == 0
          ? _Basis(feed: feed)
          : _IssueCard(issue: feed.issues[i - 1], rank: i),
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

class const _Message({
  required final IconData icon,
  required final String text,
  final Widget? action,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color muted = theme.colorScheme.onSurfaceVariant;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 44, color: muted.withValues(alpha: 0.6)),
          const SizedBox(height: 12),
          Text(text, style: theme.textTheme.bodyLarge?.copyWith(color: muted)),
          ?action,
        ],
      ),
    );
  }
}
