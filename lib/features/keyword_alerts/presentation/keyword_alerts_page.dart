import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/presentation/widgets/window_size.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';
import 'package:mocl_flutter/features/keyword_alerts/data/keyword_alert_sync.dart';
import 'package:mocl_flutter/features/keyword_alerts/domain/keyword_alert_expiry.dart';
import 'package:mocl_shared/alerts/keyword_alerts.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';

import 'state/keyword_alert_event_mixin.dart';
import 'state/keyword_alert_state_mixin.dart';
import 'widgets/keyword_alert_editor.dart';
import 'widgets/keyword_alert_inbox_button.dart';

/// 키워드 알림 관리. 담은 게시판 중 하나를 골라 키워드를 걸면, 서버가 그 게시판의
/// 새 글을 보고 제목에 키워드가 있으면 푸시로 알려 준다.
class const KeywordAlertsPage({super.key}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<KeywordAlertsPage> createState() => _KeywordAlertsPageState();
}

class _KeywordAlertsPageState()
    extends ConsumerState<KeywordAlertsPage>
    with KeywordAlertState, KeywordAlertEvent {
  void _showMessage(String message, {SnackBarAction? action}) =>
      KeywordAlertFlow.showMessage(context, message, action: action);

  Future<void> _addBoard(List<AlertSubscription> current) async {
    // 허용 목록에서 빠진 게시판(알림이 오지 않음)은 한도에 세지 않는다.
    final int active = current.where((s) => readIsAlertBoard(ref, s)).length;
    if (active >= KeywordAlerts.maxBoards) {
      _showMessage('게시판은 ${KeywordAlerts.maxBoards}개까지 걸 수 있어요.');
      return;
    }
    final FavoriteData? board = await showModalBottomSheet<FavoriteData>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) =>
          _BoardPickerSheet(taken: current.map((s) => s.boardKey).toSet()),
    );
    if (board == null || !mounted) return;
    await _editKeywords(
      AlertSubscription(
        site: board.siteType,
        board: board.board,
        url: board.url,
        title: board.text,
        keywords: const [],
      ),
    );
  }

  Future<void> _editKeywords(AlertSubscription sub) =>
      KeywordAlertFlow.edit(context, ref, sub);

  Future<void> _renew(AlertSubscription sub) async {
    final AlertSyncResult result = await renewKeywordAlert(ref, sub);
    if (!mounted) return;
    if (result != AlertSyncResult.synced) {
      return KeywordAlertFlow.reportSync(context, result);
    }
    final String? ttl = keywordAlertTtlLabel(readKeywordAlertTtl(ref));
    _showMessage(
      '\'${sub.title}\' 알림을 다시 켰어요.${ttl == null ? '' : ' $ttl 동안 알려 드려요.'}',
    );
  }

  Future<void> _remove(AlertSubscription sub, int index) async {
    final AlertSyncResult result = await removeKeywordAlert(ref, sub);
    if (!mounted) return;
    if (result == AlertSyncResult.failed) {
      return KeywordAlertFlow.reportSync(context, result);
    }
    _showMessage(
      '\'${sub.title}\' 알림을 껐습니다.',
      action: SnackBarAction(
        label: '실행취소',
        onPressed: () => restoreKeywordAlert(ref, sub, index),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<AlertSubscription> subs = keywordAlertsState(ref);
    final Duration? ttl = keywordAlertTtlState(ref);
    final DateTime now = DateTime.now();
    final theme = Theme.of(context);
    final systemOverlayStyle =
        theme.appBarTheme.systemOverlayStyle ?? SystemUiOverlayStyle.light;
    final titleStyle = ref.watch(appbarTextStyleProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle,
      child: Container(
        color: systemOverlayStyle.statusBarColor,
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: theme.appBarTheme.backgroundColor,
              title: Text('키워드 알림', style: titleStyle),
              scrolledUnderElevation: 0,
              titleSpacing: 0,
              actions: const [KeywordAlertInboxButton(), SizedBox(width: 8)],
            ),
            floatingActionButton: FloatingActionButton.extended(
              onPressed: () => _addBoard(subs),
              icon: const Icon(Icons.add_alert_outlined),
              label: const Text('게시판 추가'),
            ),
            body: BoxReadableWidth(
              child: subs.isEmpty
                  ? const _EmptyView()
                  : ListView.separated(
                      padding: EdgeInsets.fromLTRB(
                        16,
                        8,
                        16,
                        MediaQuery.of(context).padding.bottom + 96,
                      ),
                      itemCount: subs.length + 1,
                      separatorBuilder: (_, _) => const SizedBox(height: 8),
                      itemBuilder: (context, i) {
                        if (i == 0) {
                          return _Description(
                            ttl: ttl,
                            count: keywordAlertActiveCountState(ref),
                          );
                        }
                        final AlertSubscription sub = subs[i - 1];
                        final bool supported = keywordAlertBoardAllowedState(
                          ref,
                          sub.site,
                          sub.board,
                        );
                        return _SubscriptionCard(
                          subscription: sub,
                          supported: supported,
                          expiry: KeywordAlertExpiry.of(sub, ttl, now),
                          onTap: supported ? () => _editKeywords(sub) : null,
                          onRenew: () => _renew(sub),
                          onRemove: () => _remove(sub, i - 1),
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

class const _Description({
  required final Duration? ttl,

  /// 걸어 둔 게시판 수. 한도가 10 이던 옛 버전에서 더 걸어 둔 경우 안내한다.
  required final int count,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String? days = keywordAlertTtlLabel(ttl);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '게시판에 키워드가 들어간 새 글이 올라오면 알려 드려요. '
            '서버가 몇 분마다 확인하므로 조금 늦게 올 수 있어요. '
            '게시판은 ${KeywordAlerts.maxBoards}개, 게시판마다 키워드는 '
            '${KeywordAlerts.maxKeywordsPerBoard}개까지 걸 수 있어요.'
            '${days == null ? '' : ' 알림은 걸거나 고친 뒤 $days 동안 오고, 끝나면 다시 켜야 해요.'}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          if (count > KeywordAlerts.maxBoards)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                '지금은 위의 게시판 ${KeywordAlerts.maxBoards}개만 알려 드려요'
                '(게시판마다 앞의 키워드 ${KeywordAlerts.maxKeywordsPerBoard}개). '
                '나머지는 꺼 주세요.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class const _SubscriptionCard({
  required final AlertSubscription subscription,

  /// 지금 알림을 받는 게시판인지. 허용 목록(원격 설정)에서 빠지면 false — 끄기만 할 수 있다.
  required final bool supported,
  required final KeywordAlertExpiry expiry,
  required final VoidCallback? onTap,
  required final VoidCallback onRenew,
  required final VoidCallback onRemove,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool expired = !supported || expiry.isExpired;
    final String? label = supported ? expiry.label : null;
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.35,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.fromLTRB(16, 6, 6, 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(
          '${subscription.title} · ${subscription.site.title}',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: expired
              ? TextStyle(color: theme.colorScheme.onSurfaceVariant)
              : null,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Opacity(
                opacity: expired ? 0.5 : 1,
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final String k in subscription.keywords)
                      KeywordChip(label: k),
                  ],
                ),
              ),
            ),
            if (!supported)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    Icon(
                      Icons.notifications_off_outlined,
                      size: 14,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '이제 알림을 받지 않는 게시판이에요. 꺼 주세요.',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            if (label != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    Icon(
                      expired
                          ? Icons.notifications_off_outlined
                          : Icons.schedule,
                      size: 14,
                      color: expired
                          ? theme.colorScheme.error
                          : theme.colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      expired ? '알림 기간이 끝났어요' : label,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: expired
                            ? theme.colorScheme.error
                            : theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: onRenew,
                      style: TextButton.styleFrom(
                        visualDensity: VisualDensity.compact,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(expired ? '다시 켜기' : '연장'),
                    ),
                  ],
                ),
              ),
          ],
        ),
        trailing: IconButton(
          tooltip: '알림 끄기',
          icon: const Icon(Icons.close),
          onPressed: onRemove,
        ),
      ),
    );
  }
}

class const _EmptyView() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color muted = theme.colorScheme.onSurfaceVariant;
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(32, 0, 32, 72),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_none,
              size: 44,
              color: muted.withValues(alpha: 0.6),
            ),
            const SizedBox(height: 12),
            Text(
              '키워드 알림이 없습니다.',
              style: theme.textTheme.bodyLarge?.copyWith(color: muted),
            ),
            const SizedBox(height: 6),
            Text(
              '담은 게시판에 "에어팟" 같은 키워드를 걸어 두면\n새 글이 올라올 때 알려 드려요.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: muted.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 알림을 걸 게시판 고르기(담은 게시판 중 허용 게시판, 원격 설정 `alerts.boards`).
class const _BoardPickerSheet({required final Set<String> taken})
    extends ConsumerWidget
    with KeywordAlertState {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        child: keywordAlertCandidatesState(ref).when(
          loading: () => const Padding(
            padding: EdgeInsets.all(32),
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => Padding(
            padding: const EdgeInsets.all(24),
            child: Text('게시판을 불러오지 못했어요: $e'),
          ),
          data: (boards) {
            final String allowed = keywordAlertBoardsState(ref).entries
                .map((e) => '${e.key.title} ${e.value.values.join(' · ')}')
                .join(', ');
            final List<FavoriteData> available = boards
                .where((b) => !taken.contains('${b.siteType.name}|${b.board}'))
                .toList();
            return Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 4),
                  child: Text('게시판 고르기', style: theme.textTheme.titleMedium),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
                  child: Text(
                    allowed.isEmpty
                        ? '지금은 알림을 걸 수 있는 게시판이 없어요.'
                        : '담은 게시판 중에서 고릅니다. 알림을 걸 수 있는 게시판: $allowed',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (available.isEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
                    child: Text(
                      allowed.isEmpty
                          ? '고를 수 있는 게시판이 없어요.'
                          : '고를 수 있는 게시판이 없어요. 위 게시판을 메인에 먼저 담아 주세요.',
                    ),
                  )
                else
                  Flexible(
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: available.length,
                      itemBuilder: (context, i) {
                        final FavoriteData b = available[i];
                        return ListTile(
                          title: Text(b.text),
                          subtitle: Text(b.siteType.title),
                          onTap: () => Navigator.of(context).pop(b),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
