import 'package:material_ui/material_ui.dart';

/// 댓글 입력 바텀시트.
///
/// [replyTo] 가 있으면 그 닉네임에게 다는 대댓글로 표시한다. 보내기를 누르면
/// [onSubmit] 을 부르고, `null` 이 오면(성공) 시트를 `true` 로 닫고, 사유가 오면
/// 입력을 그대로 둔 채 사유를 보여준다. 전송 중에는 다시 보낼 수 없다.
class const CommentComposerSheet({
  super.key,
  final String? replyTo,
  required final Future<String?> Function(String content) onSubmit,
}) extends StatefulWidget {
  /// 시트를 띄운다. 댓글이 올라가면 `true`.
  static Future<bool?> show(
    BuildContext context, {
    String? replyTo,
    required Future<String?> Function(String content) onSubmit,
  }) => showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    builder: (_) => CommentComposerSheet(replyTo: replyTo, onSubmit: onSubmit),
  );

  @override
  State<CommentComposerSheet> createState() => _CommentComposerSheetState();
}

class _CommentComposerSheetState() extends State<CommentComposerSheet> {
  final TextEditingController _controller = TextEditingController();
  bool _sending = false;
  String? _error;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _send() async {
    if (_sending) return;
    final String content = _controller.text.trim();
    if (content.isEmpty) return;
    setState(() {
      _sending = true;
      _error = null;
    });
    final String? error = await widget.onSubmit(content);
    if (!mounted) return;
    if (error == null) {
      Navigator.of(context).pop(true);
      return;
    }
    setState(() {
      _sending = false;
      _error = error;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final String? replyTo = widget.replyTo;
    final String title = replyTo == null || replyTo.isEmpty
        ? '댓글 쓰기'
        : '$replyTo 님에게 답글';

    return Padding(
      // 키보드가 올라오면 그만큼 시트를 밀어 올린다.
      padding: EdgeInsets.only(
        left: 16,
        right: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom + 12,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: theme.textTheme.titleSmall),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  autofocus: true,
                  enabled: !_sending,
                  minLines: 1,
                  maxLines: 6,
                  maxLength: 2000,
                  keyboardType: TextInputType.multiline,
                  textInputAction: TextInputAction.newline,
                  decoration: InputDecoration(
                    hintText: '댓글을 입력하세요.',
                    errorText: _error,
                    errorMaxLines: 3,
                  ),
                ),
              ),
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: _controller,
                builder: (context, value, _) => IconButton(
                  tooltip: '보내기',
                  onPressed: _sending || value.text.trim().isEmpty
                      ? null
                      : _send,
                  icon: _sending
                      ? const SizedBox.square(
                          dimension: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.send),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
