import 'package:flutter/material.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/nick_image_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/round_text_widget.dart';

@immutable
class CachedListItem extends StatelessWidget {
  final ListItem item;
  final ValueNotifier<bool> isRead;
  final TextStyles textStyles;
  final VoidCallback onTap;

  const CachedListItem({
    super.key,
    required this.item,
    required this.isRead,
    required this.onTap,
    required this.textStyles,
  });

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 12, 0),
          child: ValueListenableBuilder<bool>(
            valueListenable: isRead,
            builder: (context, isReadValue, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 34,
                  child: Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: isReadValue
                        ? textStyles.readTitleTextStyle
                        : textStyles.titleTextStyle,
                  ),
                ),
                const SizedBox(height: 4),
                _buildBottomView(isReadValue),
                const SizedBox(height: 10),
                const DividerWidget(indent: 0, endIndent: 0),
              ],
            ),
          ),
        ),
      );

  Widget _buildBottomView(bool isReadValue) => SizedBox(
        height: 20,
        child: Row(
          children: [
            if (item.userInfo.nickImage.isNotEmpty)
              NickImageWidget(url: item.userInfo.nickImage),
            if (item.userInfo.nickName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  item.userInfo.nickName,
                  maxLines: 1,
                  style: isReadValue
                      ? textStyles.readSmallTextStyle
                      : textStyles.smallTextStyle,
                ),
              ),
            Text(
              item.time,
              maxLines: 1,
              style: isReadValue
                  ? textStyles.readSmallTextStyle
                  : textStyles.smallTextStyle,
            ),
            const Spacer(),
            RoundTextWidget(
              text: item.reply,
              textStyle: isReadValue
                  ? textStyles.readBadgeTextStyle
                  : textStyles.badgeTextStyle,
            ),
          ],
        ),
      );
}
