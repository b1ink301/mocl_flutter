import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/presentation/widgets/site_avatar.dart';
import 'package:mocl_flutter/core/presentation/widgets/window_size.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/radar/issue_feed.dart';

import 'widgets/issue_post_opener.dart';
import 'widgets/issue_time.dart';

/// 이슈 하나: 커뮤니티별로 묶은 글 목록. 글을 누르면 앱 상세로 연다.
class const IssueDetailPage({super.key, required final Issue issue})
    extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final systemOverlayStyle =
        theme.appBarTheme.systemOverlayStyle ?? SystemUiOverlayStyle.light;
    final titleStyle = ref.watch(appbarTextStyleProvider);
    final double bottom = MediaQuery.of(context).padding.bottom;

    // 커뮤니티 순서는 서버가 정한 순(글 많은 곳 먼저).
    final Map<SiteType, List<IssuePost>> bySite = {
      for (final SiteType s in issue.sites) s: [],
    };
    for (final IssuePost p in issue.posts) {
      (bySite[p.site] ??= []).add(p);
    }

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle,
      child: Container(
        color: systemOverlayStyle.statusBarColor,
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: theme.appBarTheme.backgroundColor,
              title: Text('이슈', style: titleStyle),
              scrolledUnderElevation: 0,
              titleSpacing: 0,
            ),
            body: BoxReadableWidth(
              child: ListView(
                padding: EdgeInsets.fromLTRB(16, 4, 16, bottom + 24),
                children: [
                  Text(
                    issue.title,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${issue.sites.length}개 커뮤니티 · ${issue.posts.length}글 · '
                    '${issueTimeAgo(issue.firstSeenAt)} 시작',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  for (final MapEntry<SiteType, List<IssuePost>> e
                      in bySite.entries)
                    if (e.value.isNotEmpty) ...[
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          SiteAvatar(siteType: e.key, radius: 11),
                          const SizedBox(width: 8),
                          Text(
                            e.key.title,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      for (final IssuePost p in e.value)
                        ListTile(
                          contentPadding: const EdgeInsets.only(left: 30),
                          title: Text(
                            p.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            [
                              if (p.reply >= 0) '댓글 ${p.reply}',
                              issueTimeAgo(p.firstSeenAt),
                            ].join(' · '),
                          ),
                          onTap: () => openIssuePost(context, p.url),
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
