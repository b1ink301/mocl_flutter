import 'package:flutter/material.dart';
import 'package:mocl_flutter/core/presentation/widgets/nick_image_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/round_text_widget.dart';
import 'package:mocl_flutter/features/list_page/presentation/state/list_event_mixin.dart';

import '../../../../core/presentation/widgets/author_info_text.dart';
import '../../../../core/presentation/widgets/plain_text.dart';
import 'list_scope.dart';

class MoclListItem extends StatelessWidget with ListEvent {
  const MoclListItem({super.key});

  @override
  Widget build(BuildContext context) {
    // InheritedWidget 으로부터 item 직접 획득 (Riverpod 경유 없음)
    final item = ListItemScope.of(context);
    // 스타일은 폰트 크기 등 글로벌 설정이라 Riverpod 으로 watch
    final styles = ListStyleScope.of(context);
    final isRead = item.isRead;

    final titleStyle = styles
        .title(isRead)
        .copyWith(fontWeight: isRead ? FontWeight.w500 : FontWeight.w600);
    final infoStyle = styles.smallTitle(isRead);
    final badgeStyle = styles.badge(isRead).copyWith(fontWeight: FontWeight.w700);
    // 답글 배지는 코랄 톤의 필드 칩으로 표현(강조색 12% 배경, 테두리 없음).
    final Color badgeBg = (badgeStyle.color ?? const Color(0xFFE8552D))
        .withValues(alpha: 0.12);

    final hasNickImage = item.userInfo.nickImage.isNotEmpty;
    final hasReply = item.reply.isNotEmpty && item.reply != '0';

    return InkWell(
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
            // Title
            PlainText(
              item.title,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: titleStyle,
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
                    if (hasReply)
                      RoundTextWidget(
                        text: item.reply,
                        textStyle: badgeStyle,
                        backgroundColor: badgeBg,
                        borderColor: Colors.transparent,
                        borderRadius: 999,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 7,
                          vertical: 1.5,
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
