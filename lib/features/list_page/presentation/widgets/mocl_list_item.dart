import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/presentation/widgets/category_tag.dart';
import 'package:mocl_flutter/core/presentation/widgets/list_detail_layout.dart';
import 'package:mocl_flutter/core/presentation/widgets/nick_image_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/round_text_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/list_page/presentation/state/list_event_mixin.dart';
import 'package:mocl_flutter/features/list_page/presentation/state/list_state_mixin.dart';

import '../../../../core/presentation/widgets/author_info_text.dart';
import 'list_scope.dart';

class const MoclListItem({super.key}) extends StatelessWidget with ListEvent {
  @override
  Widget build(BuildContext context) {
    // InheritedWidget 으로부터 item 직접 획득 (Riverpod 경유 없음)
    final item = ListItemScope.of(context);
    // 스타일은 폰트 크기 등 글로벌 설정이라 Riverpod 으로 watch
    final styles = ListStyleScope.of(context);
    final isRead = item.isRead;
    final showCategory = ListStyleScope.showCategoryOf(context);

    final titleStyle = styles.title(isRead);
    final infoStyle = styles.smallTitle(isRead);

    final hasNickImage = item.userInfo.nickImage.isNotEmpty;
    final hasReply = item.reply.isNotEmpty && item.reply != '0';

    // 답글 배지는 코랄 톤의 필드 칩(강조색 12% 배경, 테두리 없음).
    // 배지 스타일/배경색은 답글이 있는 행에서만 계산한다(불필요한 Color 할당 방지).
    Widget? replyBadge;
    if (hasReply) {
      final badgeStyle = styles.badge(isRead);
      final badgeBg = (badgeStyle.color ?? const Color(0xFFE8552D)).withValues(
        alpha: 0.12,
      );
      replyBadge = RoundTextWidget(
        text: item.reply,
        textStyle: badgeStyle,
        backgroundColor: badgeBg,
        borderColor: Colors.transparent,
        borderRadius: 999,
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1.5),
      );
    }

    // 넓은 화면에서 옆 칸에 열려 있는 글은 강조한다.
    final bool selected = ListDetailScope.isSelected(context, item.id);

    final Widget row = InkWell(
      onTap: () => handleItemTap(context, item),
      child: Padding(
        padding: const EdgeInsets.only(
          left: 16,
          right: 10,
          top: 14,
          bottom: 14,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title (말머리가 있으면 첫 줄 앞에 태그)
            _ListTitle(
              title: item.title,
              category: showCategory ? item.category : '',
              style: titleStyle,
              brightness: styles.brightness,
              dimmed: isRead,
              highlight: SearchHighlightScope.of(context),
            ),

            // Bottom Info (Merged for performance)
            if (item.info.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    if (hasNickImage)
                      Padding(
                        padding: const EdgeInsets.only(right: 6.0),
                        child: NickImageWidget(url: item.userInfo.nickImage),
                      ),
                    Expanded(
                      child: AuthorInfoText(
                        info: item.info,
                        nickName: item.userInfo.nickName,
                        style: infoStyle,
                      ),
                    ),
                    ?replyBadge,
                  ],
                ),
              ),
          ],
        ),
      ),
    );

    // 잉크가 강조색 위에 보이도록 Material 로 칠한다(강조할 때만 만든다).
    return selected
        ? Material(
            color: Theme.of(context).colorScheme.primary
                .withValues(alpha: 0.08),
            child: row,
          )
        : row;
  }
}

/// 행 제목. 번역을 켰으면 번역문을 보인다(행 데이터는 원문 그대로라 스크랩 ·
/// 뮤트 · 상세는 원문 기준). 번역이 끝난 행만 다시 그린다.
class const _ListTitle({
  required final String title,
  required final String category,
  required final TextStyle style,
  required final Brightness brightness,
  required final bool dimmed,
  final String highlight = '',
}) extends ConsumerWidget with ListState {
  @override
  Widget build(BuildContext context, WidgetRef ref) => CategoryTitleText(
    title: displayTitleState(ref, title),
    category: category,
    style: style,
    brightness: brightness,
    dimmed: dimmed,
    maxLines: 3,
    highlight: highlight,
    highlightColor: highlight.isEmpty
        ? null
        : Theme.of(context).colorScheme.primary,
  );
}
