import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/features/site_health/domain/site_report_target.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/reports/site_report.dart';

import '../state/site_report_event_mixin.dart';

/// "문제 알리기" 흐름(시트 → 보내기 → 스낵바). 들어가는 곳: 상세 더보기 메뉴 · 목록 오류 화면 · 설정.
abstract final class SiteReportFlow() {
  /// 사용자가 고를 수 있는 이유(자동 신고용 이유는 빼고).
  static final List<SiteReportReason> userReasons = [
    for (final SiteReportReason r in SiteReportReason.values)
      if (r.kind == SiteReportKind.user) r,
  ];

  static Future<void> open(
    BuildContext context,
    SiteReportTarget target, {
    SiteReportReason initialReason = SiteReportReason.other,
  }) async {
    final bool? sent = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) =>
          SiteReportSheet(target: target, initialReason: initialReason),
    );
    if (sent == null || !context.mounted) return;
    ScaffoldMessenger.maybeOf(context)
      ?..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            sent ? '보냈어요. 알려 주셔서 고마워요!' : '보내지 못했어요. 잠시 뒤 다시 시도해 주세요.',
          ),
        ),
      );
  }
}

/// 이유 고르기 + 메모 + 보내기. 보냈으면 true, 실패하면 false 로 닫힌다(취소는 null).
class const SiteReportSheet({
  super.key,
  required final SiteReportTarget target,
  final SiteReportReason initialReason = SiteReportReason.other,
}) extends ConsumerStatefulWidget {
  @override
  ConsumerState<SiteReportSheet> createState() => _SiteReportSheetState();
}

class _SiteReportSheetState()
    extends ConsumerState<SiteReportSheet>
    with SiteReportEvent {
  late SiteReportReason _reason = widget.initialReason;
  final TextEditingController _memo = TextEditingController();
  bool _sending = false;

  @override
  void dispose() {
    _memo.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    setState(() => _sending = true);
    final bool ok = await sendSiteReport(
      ref,
      widget.target,
      _reason,
      _memo.text,
    );
    if (mounted) Navigator.of(context).pop(ok);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final SiteReportTarget target = widget.target;
    final TextStyle? sub = theme.textTheme.bodySmall?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
    );
    // 사이트 글이면 이유를, 일반 의견이면 메모를 먼저 받는다.
    final bool general = target.site == null;
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
            general ? '문제 · 의견 보내기' : '문제 알리기',
            style: theme.textTheme.titleMedium,
          ),
          const SizedBox(height: 2),
          Text(
            general
                ? '불편한 점이나 바라는 점을 적어 주세요. 답장은 드리지 못해요.'
                : '사이트가 바뀌면 글을 못 읽을 수 있어요. 알려 주시면 고칠게요.',
            style: sub,
          ),
          if (!general) ...[
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final SiteReportReason r in SiteReportFlow.userReasons)
                  ChoiceChip(
                    label: Text(r.label),
                    selected: _reason == r,
                    onSelected: _sending
                        ? null
                        : (_) => setState(() => _reason = r),
                  ),
              ],
            ),
          ],
          const SizedBox(height: 12),
          TextField(
            controller: _memo,
            enabled: !_sending,
            minLines: general ? 3 : 1,
            maxLines: 4,
            maxLength: SiteReport.maxMemoLength,
            textInputAction: TextInputAction.newline,
            onChanged: general ? (_) => setState(() {}) : null,
            decoration: InputDecoration(
              labelText: general ? '내용' : '자세히 (선택)',
              hintText: general ? null : '예: 본문 이미지가 안 나와요',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
          ),
          _SentInfo(target: target, style: sub),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              // 일반 의견은 내용이 있어야 보낸다.
              onPressed: _sending || (general && _memo.text.trim().isEmpty)
                  ? null
                  : _send,
              child: _sending
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('보내기'),
            ),
          ),
        ],
      ),
    );
  }
}

/// 함께 보내는 정보를 그대로 보여 준다(무엇이 나가는지 알 수 있게).
class const _SentInfo({
  required final SiteReportTarget target,
  final TextStyle? style,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final List<String> parts = [
      if (target.site case final SiteType site) site.title,
      if (target.boardTitle ?? target.board case final String board) board,
      if (target.url != null) '글 주소',
      '앱 버전',
      '기기 종류(Android · iOS)',
    ];
    return Text('함께 보내는 정보: ${parts.join(' · ')}', style: style);
  }
}
