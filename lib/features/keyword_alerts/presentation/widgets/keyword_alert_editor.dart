import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/features/keyword_alerts/data/keyword_alert_sync.dart';
import 'package:mocl_flutter/features/keyword_alerts/domain/keyword_alert_expiry.dart';
import 'package:mocl_shared/alerts/keyword_alerts.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';

import '../state/keyword_alert_event_mixin.dart';
import '../state/keyword_alert_state_mixin.dart';

/// 게시판 하나의 키워드 알림을 켜고 고치고 끄는 흐름. 관리 화면과 목록 앱바가 같이 쓴다.
///
/// 처음 거는 알림이면 알림 권한을 묻고, 서버 반영 결과를 스낵바로 알린다.
abstract final class KeywordAlertFlow() {
  static const _Flow _flow = _Flow();

  /// [board] 의 키워드를 편집한다. 이미 걸린 게시판이면 그 키워드로 시작한다.
  static Future<void> edit(
    BuildContext context,
    WidgetRef ref,
    AlertSubscription board,
  ) => _flow.edit(context, ref, board);

  static void showMessage(
    BuildContext context,
    String message, {
    SnackBarAction? action,
  }) {
    final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(
      context,
    );
    if (messenger == null) return;
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 96),
          action: action,
        ),
      );
  }

  static void reportSync(BuildContext context, AlertSyncResult result) {
    if (!context.mounted) return;
    switch (result) {
      case AlertSyncResult.synced || AlertSyncResult.noServer:
        break;
      case AlertSyncResult.noToken:
        showMessage(context, '알림 토큰을 받지 못했어요. 잠시 뒤 앱을 다시 열면 다시 시도합니다.');
      case AlertSyncResult.failed:
        showMessage(context, '서버에 반영하지 못했어요. 다음에 앱을 열 때 다시 시도합니다.');
    }
  }
}

class const _Flow() with KeywordAlertState, KeywordAlertEvent {
  Future<void> edit(
    BuildContext context,
    WidgetRef ref,
    AlertSubscription board,
  ) async {
    final List<AlertSubscription> current = readKeywordAlerts(ref);
    final AlertSubscription? existing = current
        .where((s) => s.boardKey == board.boardKey)
        .firstOrNull;
    // 허용 목록에서 빠진 게시판(알림이 오지 않음)은 한도에 세지 않는다.
    final int active = current.where((s) => readIsAlertBoard(ref, s)).length;
    if (existing == null && active >= KeywordAlerts.maxBoards) {
      KeywordAlertFlow.showMessage(
        context,
        '게시판은 ${KeywordAlerts.maxBoards}개까지 걸 수 있어요. 설정 → 키워드 알림에서 정리해 주세요.',
      );
      return;
    }

    final List<String>? keywords = await showModalBottomSheet<List<String>>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (_) => KeywordEditorSheet(
        subscription: existing ?? board,
        canTurnOff: existing != null,
        ttl: readKeywordAlertTtl(ref),
      ),
    );
    if (keywords == null || !context.mounted) return;

    if (keywords.isEmpty) {
      if (existing == null) return;
      final AlertSyncResult result = await removeKeywordAlert(ref, existing);
      if (!context.mounted) return;
      if (result == AlertSyncResult.failed) {
        return KeywordAlertFlow.reportSync(context, result);
      }
      return KeywordAlertFlow.showMessage(
        context,
        '\'${existing.title}\' 알림을 껐습니다.',
      );
    }

    if (current.isEmpty) {
      final bool granted = await requestAlertPermission(ref);
      if (!granted && context.mounted) {
        KeywordAlertFlow.showMessage(
          context,
          '알림 권한이 꺼져 있어요. 시스템 설정에서 켜야 알림이 옵니다.',
        );
      }
    }
    final AlertSyncResult result = await saveKeywordAlert(
      ref,
      AlertSubscription(
        site: board.site,
        board: board.board,
        url: board.url,
        title: board.title,
        keywords: keywords,
      ),
    );
    if (!context.mounted) return;
    if (result == AlertSyncResult.synced && existing == null) {
      final String? ttl = keywordAlertTtlLabel(readKeywordAlertTtl(ref));
      KeywordAlertFlow.showMessage(
        context,
        '\'${board.title}\' 에 키워드 알림을 걸었어요.'
        '${ttl == null ? '' : ' $ttl 동안 알려 드려요.'}',
      );
    } else {
      KeywordAlertFlow.reportSync(context, result);
    }
  }
}

class const KeywordChip({
  super.key,
  required final String label,
  final VoidCallback? onDeleted,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    // InputChip 은 콜백(onDeleted 등)이 없으면 비활성 색으로 그려진다.
    // 목록처럼 지우기 버튼 없이 보여 주기만 할 때도 같은 색이 나오게 Chip 을 쓴다.
    return Chip(
      label: Text(label),
      labelStyle: TextStyle(color: scheme.onSecondaryContainer),
      onDeleted: onDeleted,
      deleteIcon: const Icon(Icons.clear, size: 18),
      visualDensity: VisualDensity.compact,
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      backgroundColor: scheme.secondaryContainer.withValues(alpha: 0.6),
      side: BorderSide.none,
      shape: const StadiumBorder(),
    );
  }
}

/// 키워드 편집. 저장하면 키워드 목록을, "알림 끄기" 면 빈 목록을 돌려준다(취소하면 null).
class const KeywordEditorSheet({
  super.key,
  required final AlertSubscription subscription,
  final bool canTurnOff = false,

  /// 알림 기한(null = 기한 없음). 저장하면 지금부터 다시 센다는 안내에 쓴다.
  final Duration? ttl,
}) extends StatefulWidget {
  @override
  State<KeywordEditorSheet> createState() => KeywordEditorSheetState2();
}

class KeywordEditorSheetState2() extends State<KeywordEditorSheet> {
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
    // 한도가 10 이던 옛 버전에서 더 걸어 둔 키워드는 줄여야 저장된다.
    if (_keywords.length > KeywordAlerts.maxKeywordsPerBoard) {
      setState(
        () => _error =
            '게시판마다 키워드는 ${KeywordAlerts.maxKeywordsPerBoard}개까지예요. '
            '${_keywords.length - KeywordAlerts.maxKeywordsPerBoard}개를 지워 주세요.',
      );
      return;
    }
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
            '제목에 키워드가 들어간 새 글을 알려 드려요. 띄어쓰기와 대소문자는 구분하지 않아요.'
            '${widget.ttl == null ? '' : ' 저장하면 오늘부터 ${keywordAlertTtlLabel(widget.ttl)} 동안 알려 드려요.'}',
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
                KeywordChip(
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
          if (widget.canTurnOff)
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.of(context).pop(const <String>[]),
                child: const Text('이 게시판 알림 끄기'),
              ),
            ),
        ],
      ),
    );
  }
}
