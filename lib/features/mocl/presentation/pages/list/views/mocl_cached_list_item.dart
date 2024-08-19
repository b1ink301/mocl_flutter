import 'package:flutter/material.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

import '../../../models/mocl_list_item_wrapper.dart';
import '../../../widgets/nick_image_widget.dart';
import '../../../widgets/round_text_widget.dart';
import 'mocl_text_styles.dart';

class CachedListItem extends StatelessWidget {
  final ListItemWrapper item;
  final SiteType siteType;
  final TextStyles textStyles;
  final VoidCallback onTap;

  const CachedListItem({
    super.key,
    required this.siteType,
    required this.item,
    required this.onTap,
    required this.textStyles,
  });

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<bool>(
        valueListenable: item.isReadNotifier,
        builder: (context, isRead, child) => InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(isRead),
                const SizedBox(height: 8),
                _buildBottomView(
                  item.item.userInfo.id,
                  _buildNickImage(),
                  _buildNickName(isRead),
                  _buildTime(isRead),
                  _buildBadge(isRead),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildTitle(bool isRead) => Text(
        item.item.title,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style:
            isRead ? textStyles.readTitleTextStyle : textStyles.titleTextStyle,
      );

  Widget _buildNickName(bool isRead) {
    if (item.item.userInfo.nickName.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Text(
        item.item.userInfo.nickName,
        maxLines: 1,
        style:
            isRead ? textStyles.readSmallTextStyle : textStyles.smallTextStyle,
      ),
    );
  }

  Widget _buildTime(bool isRead) => Text(
        item.item.time,
        maxLines: 1,
        style:
            isRead ? textStyles.readSmallTextStyle : textStyles.smallTextStyle,
      );

  Widget _buildBadge(bool isRead) => RoundTextWidget(
        text: item.item.reply,
        textStyle:
            isRead ? textStyles.readBadgeTextStyle : textStyles.badgeTextStyle,
      );

  Widget _buildNickImage() =>
      NickImageWidget(url: item.item.userInfo.nickImage, siteType: siteType);

  Widget _buildBottomView(
    String id,
    Widget nickImage,
    Widget nickName,
    Widget time,
    Widget badge,
  ) {
    if (id.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 20,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          nickImage,
          nickName,
          time,
          const Spacer(),
          badge,
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
