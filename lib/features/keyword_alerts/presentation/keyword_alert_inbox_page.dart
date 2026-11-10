import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/presentation/widgets/list_detail_layout.dart';
import 'package:mocl_flutter/core/presentation/widgets/message_view.dart';
import 'package:mocl_flutter/core/presentation/widgets/window_size.dart';
import 'package:mocl_flutter/features/detail_page/domain/site_link_resolver.dart';
import 'package:mocl_flutter/features/detail_page/presentation/mocl_detail_page.dart';
import 'package:mocl_flutter/features/issue_radar/presentation/widgets/issue_time.dart';
import 'package:mocl_flutter/features/keyword_alerts/data/keyword_alert_inbox.dart';
import 'package:mocl_flutter/features/keyword_alerts/domain/inbox_alert.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';

import 'state/keyword_alert_event_mixin.dart';
import 'state/keyword_alert_state_mixin.dart';
import 'widgets/keyword_alert_editor.dart';
import 'widgets/keyword_alert_open.dart';

/// 받은 키워드 알림(알림함). 기기에만 쌓아 두고, 다시 눌러 글을 연다.
/// 넓은 화면은 목록 옆 칸에 상세를 연다.
class const KeywordAlertInboxPage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ListDetailLayout<SiteLink>(
    list: const _InboxScaffold(),
    detailBuilder: (_, link) =>
        DetailPage.init(link.item, siteType: link.siteType),
    pushDetail: (context, link) =>
        context.push<void>(Routes.detail, extra: link),
    keyOf: (link) => '${link.siteType.name}_${link.item.id}',
    detailRoutePath: Routes.detail,
    placeholder: '알림을 선택하세요',
  );
}

class const _InboxScaffold()
    extends ConsumerWidget
    with KeywordAlertState, KeywordAlertEvent {
  void _open(BuildContext context, WidgetRef ref, InboxAlert alert) {
    if (!alert.read) unawaited(markKeywordAlertRead(ref, alert));
    openKeywordAlertUrl(
      alert.url,
      pushDetail: (link) async {
        if (ListDetailScope.tryOpen(context, link)) return;
        await context.push<void>(Routes.detail, extra: link);
      },
    );
  }

  void _remove(BuildContext context, WidgetRef ref, InboxAlert alert) {
    unawaited(removeInboxAlert(ref, alert));
    ScaffoldMessenger.maybeOf(context)
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: const Text('알림을 지웠습니다.'),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: '실행취소',
            onPressed: () => restoreInboxAlert(ref, alert),
          ),
        ),
      );
  }

  Future<void> _clear(BuildContext context, WidgetRef ref) async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog.adaptive(
        title: const Text('받은 알림을 모두 지울까요?'),
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
    if (ok == true) await clearKeywordAlertInbox(ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<InboxAlert> alerts =
        keywordAlertInboxState(ref).value ?? const [];
    final bool hasUnread = keywordAlertUnreadCountState(ref) > 0;
    final theme = Theme.of(context);
    final systemOverlayStyle =
        theme.appBarTheme.systemOverlayStyle ?? SystemUiOverlayStyle.light;
    final TextStyle titleStyle = ref.watch(appbarTextStyleProvider);
    final AppTextStyles styles = ref.watch(appTextStylesFontSizeProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle,
      child: Container(
        color: systemOverlayStyle.statusBarColor,
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: theme.appBarTheme.backgroundColor,
              title: Text('받은 알림', style: titleStyle),
              scrolledUnderElevation: 0,
              titleSpacing: 0,
              actions: [
                if (alerts.isNotEmpty)
                  PopupMenuButton<_Menu>(
                    tooltip: '더 보기',
                    onSelected: (m) => switch (m) {
                      _Menu.readAll => markAllKeywordAlertsRead(ref),
                      _Menu.clear => _clear(context, ref),
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: _Menu.readAll,
                        enabled: hasUnread,
                        child: const Text('모두 읽음'),
                      ),
                      const PopupMenuItem(
                        value: _Menu.clear,
                        child: Text('모두 지우기'),
                      ),
                    ],
                  ),
              ],
            ),
            body: alerts.isEmpty
                // MessageView 는 가로로 늘지 않으므로 Center 로 가운데에 둔다.
                // 아래 여백(제스처 바)만큼 올려 보이는 영역 가운데에 맞춘다.
                ? Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.paddingOf(context).bottom,
                    ),
                    child: Center(
                      child: MessageView(
                        icon: Icons.notifications_none,
                        title: '받은 알림이 없습니다',
                        description:
                            '키워드 알림이 오면 여기에 '
                            '${KeywordAlertInbox.retention.inDays}일 동안 남겨 둬요.',
                        titleStyle: styles.titleTextStyle,
                        descriptionStyle: styles.smallTextStyle,
                        semanticsId: 'keyword_alert_inbox_empty',
                      ),
                    ),
                  )
                : BoxReadableWidth(
                    child: ListView.separated(
                      padding: EdgeInsets.only(
                        top: 4,
                        bottom: MediaQuery.of(context).padding.bottom + 24,
                      ),
                      itemCount: alerts.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, i) {
                        final InboxAlert alert = alerts[i];
                        return Dismissible(
                          key: ValueKey(alert.id),
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: Alignment.centerRight,
                            padding: const EdgeInsets.only(right: 24),
                            color: theme.colorScheme.errorContainer,
                            child: Icon(
                              Icons.delete_outline,
                              color: theme.colorScheme.onErrorContainer,
                            ),
                          ),
                          onDismissed: (_) => _remove(context, ref, alert),
                          child: _InboxTile(
                            alert: alert,
                            styles: styles,
                            onTap: () => _open(context, ref, alert),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

enum _Menu() {
  readAll,
  clear,
}

class const _InboxTile({
  required final InboxAlert alert,
  required final AppTextStyles styles,
  required final VoidCallback onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool read = alert.read;
    final TextStyle meta = read
        ? styles.readSmallTextStyle
        : styles.smallTextStyle;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 안 읽은 알림 표시.
            Padding(
              padding: const EdgeInsets.only(top: 6, right: 10),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: read ? Colors.transparent : theme.colorScheme.primary,
                ),
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${alert.boardTitle} · ${alert.site.title} · '
                    '${issueTimeAgo(alert.receivedAt)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: meta,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alert.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: read
                        ? styles.readTitleTextStyle
                        : styles.titleTextStyle,
                  ),
                  if (alert.keywords.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 6),
                      child: Opacity(
                        opacity: read ? 0.6 : 1,
                        child: Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: [
                            for (final String k in alert.keywords)
                              KeywordChip(label: k),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
