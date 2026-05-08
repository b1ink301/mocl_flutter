import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/presentation/widgets/nick_image_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/round_text_widget.dart';
import 'package:mocl_flutter/features/list_page/presentation/state/list_event_mixin.dart';
import 'package:mocl_flutter/features/list_page/presentation/state/list_state_mixin.dart';

import '../mocl_list_view.dart';

class MoclListItem extends ConsumerWidget with ListState, ListEvent {
  const MoclListItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1. InheritedWidget을 통해 index를 가져옴 (const 유지 가능)
    final index = ItemIndex.of(context);

    // 2. 해당 인덱스의 아이템을 직접 구독
    final item = itemState(ref, index);

    if (item == null) {
      return const SizedBox.shrink();
    }

    // 3. 스타일 정보를 한 번에 가져옴 (여러 ConsumerWidget의 오버헤드 제거)
    final styles = ref.watch(appTextStylesFontSizeProvider);
    final isRead = item.isRead;

    final titleStyle = isRead
        ? styles.readTitleTextStyle
        : styles.titleTextStyle;
    final infoStyle = isRead
        ? styles.readSmallTextStyle
        : styles.smallTextStyle;
    final badgeStyle = isRead
        ? styles.readBadgeTextStyle
        : styles.badgeTextStyle;

    final hasNickImage = item.userInfo.nickImage.isNotEmpty;
    final hasReply = item.reply.isNotEmpty && item.reply != '0';

    return InkWell(
      onTap: () => handleItemTap(ref, context, item),
      child: Padding(
        padding: const EdgeInsets.only(left: 16, right: 12, top: 8, bottom: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            Text(
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
                      child: Text(
                        item.info,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: infoStyle,
                      ),
                    ),
                    if (hasReply)
                      RoundTextWidget(text: item.reply, textStyle: badgeStyle),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
