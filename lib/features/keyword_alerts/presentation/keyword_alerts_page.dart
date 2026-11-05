import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/presentation/widgets/window_size.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';
import 'package:mocl_flutter/features/keyword_alerts/data/keyword_alert_sync.dart';
import 'package:mocl_shared/alerts/keyword_alerts.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';

import 'state/keyword_alert_event_mixin.dart';
import 'state/keyword_alert_state_mixin.dart';

/// 키워드 알림 관리. 담은 게시판 중 하나를 골라 키워드를 걸면, 서버가 그 게시판의
/// 새 글을 보고 제목에 키워드가 있으면 푸시로 알려 준다.
class const KeywordAlertsPage({super.key}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<KeywordAlertsPage> createState() => _KeywordAlertsPageState();
}

class _KeywordAlertsPageState()
    extends ConsumerState<KeywordAlertsPage>
    with KeywordAlertState, KeywordAlertEvent {
  void _showMessage(String message, {SnackBarAction? action}) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 96),
        action: action,
      ),
    );
  }

  void _reportSync(AlertSyncResult result) {
    if (!mounted) return;
    switch (result) {
      case AlertSyncResult.synced || AlertSyncResult.noServer:
        break;
      case AlertSyncResult.noToken:
        _showMessage('알림 토큰을 받지 못했어요. 잠시 뒤 앱을 다시 열면 다시 시도합니다.');
      case AlertSyncResult.failed:
        _showMessage('서버에 반영하지 못했어요. 다음에 앱을 열 때 다시 시도합니다.');
    }
  }

  Future<void> _addBoard(List<AlertSubscription> current) async {
    if (current.length >= KeywordAlerts.maxBoards) {
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
      isNew: true,
    );
  }

  Future<void> _editKeywords(
    AlertSubscription sub, {
    bool isNew = false,
  }) async {
    final List<String>? keywords = await showModalBottomSheet<List<String>>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => _KeywordEditorSheet(subscription: sub),
    );
    if (keywords == null || !mounted) return;

    if (isNew && keywordAlertsState(ref).isEmpty) {
      final bool granted = await requestAlertPermission(ref);
      if (!granted && mounted) {
        _showMessage('알림 권한이 꺼져 있어요. 시스템 설정에서 켜야 알림이 옵니다.');
      }
    }
    final AlertSyncResult result = await saveKeywordAlert(
      ref,
      AlertSubscription(
        site: sub.site,
        board: sub.board,
        url: sub.url,
        title: sub.title,
        keywords: keywords,
      ),
    );
    _reportSync(result);
  }

  Future<void> _remove(AlertSubscription sub, int index) async {
    final AlertSyncResult result = await removeKeywordAlert(ref, sub);
    if (!mounted) return;
    if (result == AlertSyncResult.failed) return _reportSync(result);
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
                        if (i == 0) return const _Description();
                        final AlertSubscription sub = subs[i - 1];
                        return _SubscriptionCard(
                          subscription: sub,
                          onTap: () => _editKeywords(sub),
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

class const _Description() extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 8),
      child: Text(
        '게시판에 키워드가 들어간 새 글이 올라오면 알려 드려요. '
        '서버가 몇 분마다 확인하므로 조금 늦게 올 수 있어요.',
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class const _SubscriptionCard({
  required final AlertSubscription subscription,
  required final VoidCallback onTap,
  required final VoidCallback onRemove,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
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
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final String k in subscription.keywords)
                _KeywordChip(label: k),
            ],
          ),
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

class const _KeywordChip({
  required final String label,
  final VoidCallback? onDeleted,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return InputChip(
      label: Text(label),
      onDeleted: onDeleted,
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: scheme.secondaryContainer.withValues(alpha: 0.6),
      side: BorderSide.none,
      shape: const StadiumBorder(),
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

/// 알림을 걸 게시판 고르기(담은 게시판 중 지원 사이트).
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
                    '담은 게시판 중에서 고릅니다. 지원 사이트: '
                    '${KeywordAlerts.sites.map((s) => s.title).join(', ')}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
                if (available.isEmpty)
                  const Padding(
                    padding: EdgeInsets.fromLTRB(24, 16, 24, 32),
                    child: Text('고를 수 있는 게시판이 없어요. 지원 사이트의 게시판을 먼저 담아 주세요.'),
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

/// 키워드 편집. 저장하면 키워드 목록을 돌려준다(취소하면 null).
class const _KeywordEditorSheet({required final AlertSubscription subscription})
    extends StatefulWidget {
  @override
  State<_KeywordEditorSheet> createState() => _KeywordEditorSheetState();
}

class _KeywordEditorSheetState() extends State<_KeywordEditorSheet> {
  final TextEditingController _controller = TextEditingController();
  late final List<String> _keywords = [...widget.subscription.keywords];
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _add() {
    final String k = _controller.text.trim();
    if (k.isEmpty) return;
    String? error;
    if (k.length > KeywordAlerts.maxKeywordLength) {
      error = '키워드는 ${KeywordAlerts.maxKeywordLength}자까지예요.';
    } else if (_keywords.length >= KeywordAlerts.maxKeywordsPerBoard) {
      error = '게시판마다 키워드는 ${KeywordAlerts.maxKeywordsPerBoard}개까지예요.';
    } else if (_keywords.any(
      (e) => KeywordAlerts.normalize(e) == KeywordAlerts.normalize(k),
    )) {
      error = '이미 있는 키워드예요.';
    }
    setState(() {
      _error = error;
      if (error == null) {
        _keywords.add(k);
        _controller.clear();
      }
    });
  }

  /// 입력칸에 남은 글자는 키워드로 넣고 닫는다("추가" 를 안 눌러도 잃지 않게).
  void _save() {
    if (_controller.text.trim().isNotEmpty) _add();
    if (_error != null || _keywords.isEmpty) return;
    Navigator.of(context).pop(List<String>.of(_keywords));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final AlertSubscription sub = widget.subscription;
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${sub.title} · ${sub.site.title}',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 4),
          Text(
            '제목에 키워드가 들어간 새 글을 알려 드려요. 띄어쓰기와 대소문자는 구분하지 않아요.',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _controller,
            autofocus: _keywords.isEmpty,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _add(),
            onChanged: (_) => setState(() {}),
            decoration: InputDecoration(
              hintText: '키워드 (예: 에어팟)',
              errorText: _error,
              prefixIcon: const Icon(Icons.tag, size: 20),
              suffixIcon: IconButton(
                tooltip: '추가',
                icon: const Icon(Icons.add),
                onPressed: _add,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: [
              for (final String k in _keywords)
                _KeywordChip(
                  label: k,
                  onDeleted: () => setState(() => _keywords.remove(k)),
                ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _keywords.isEmpty && _controller.text.trim().isEmpty
                  ? null
                  : _save,
              child: const Text('저장'),
            ),
          ),
        ],
      ),
    );
  }
}
