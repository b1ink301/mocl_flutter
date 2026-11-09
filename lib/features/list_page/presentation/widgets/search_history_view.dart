import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/presentation/widgets/message_view.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_icon.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_icon_button.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_text.dart';
import 'package:mocl_flutter/core/presentation/widgets/window_size.dart';

/// 검색 전 화면. 이 게시판의 최근 검색어(누르면 검색, ✕ 로 하나 지우기, 전체 삭제).
/// 기록이 없으면 무엇을 검색하는지 안내한다.
class const SearchHistoryView({
  super.key,
  required final String boardTitle,
  required final List<String> history,
  required final ValueChanged<String> onSelected,
  required final ValueChanged<String> onRemoved,
  required final VoidCallback onClearAll,
  required final TextStyle titleStyle,
  required final TextStyle smallStyle,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final double bottom = MediaQuery.paddingOf(context).bottom;
    final Color muted = (smallStyle.color ?? Colors.grey).withValues(
      alpha: 0.8,
    );

    if (history.isEmpty) {
      return Padding(
        padding: EdgeInsets.only(bottom: bottom + 80),
        child: Center(
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: MessageView(
              icon: Icons.manage_search_rounded,
              title: '$boardTitle에서 검색',
              description: '찾을 말을 입력하고 키보드의 검색을 누르세요.',
              titleStyle: titleStyle,
              descriptionStyle: smallStyle,
            ),
          ),
        ),
      );
    }

    return BoxReadableWidth(
      child: ListView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        padding: EdgeInsets.only(top: 8, bottom: bottom + 16),
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 4),
            child: Row(
              children: [
                Expanded(
                  child: PlainText(
                    '최근 검색어',
                    style: smallStyle.copyWith(
                      color: muted,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onClearAll,
                  child: PlainText('전체 삭제', style: smallStyle),
                ),
              ],
            ),
          ),
          for (final String word in history)
            InkWell(
              onTap: () => onSelected(word),
              child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 4),
                child: Row(
                  children: [
                    PlainIcon(Icons.history_rounded, size: 20, color: muted),
                    const SizedBox(width: 14),
                    Expanded(
                      child: PlainText(
                        word,
                        style: titleStyle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    PlainIconButton(
                      semanticLabel: '"$word" 기록 지우기',
                      padding: const EdgeInsets.all(14),
                      onPressed: () => onRemoved(word),
                      icon: PlainIcon(
                        Icons.close_rounded,
                        size: 18,
                        color: muted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
