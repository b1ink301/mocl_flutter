import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/views/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/nick_image_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/round_text_widget.dart';

class CachedListItem extends StatelessWidget {
  final ReadableListItem item;
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
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 12, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(),
              _buildBottomView(
                item.item.userInfo.id,
                _buildNickImage(),
                _buildNickName(),
                _buildTime(),
                _buildBadge(),
              ),
            ],
          ),
        ),
      );

  Widget _buildTitle() => ValueListenableBuilder<bool>(
      valueListenable: item.readNotifier,
      builder: (context, isRead, child) {
        log('[CachedListItem] title=${item.item.title}, child=$child');
        return Text(
          item.item.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: isRead
              ? textStyles.readTitleTextStyle
              : textStyles.titleTextStyle,
        );
      });

  Widget _buildNickName() {
    if (item.item.userInfo.nickName.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ValueListenableBuilder<bool>(
          valueListenable: item.readNotifier,
          builder: (context, isRead, child) {
            return Text(
              item.item.userInfo.nickName,
              maxLines: 1,
              style: isRead
                  ? textStyles.readSmallTextStyle
                  : textStyles.smallTextStyle,
            );
          }),
    );
  }

  Widget _buildTime() => ValueListenableBuilder<bool>(
      valueListenable: item.readNotifier,
      builder: (context, isRead, child) {
        return Text(
          item.item.time,
          maxLines: 1,
          style: isRead
              ? textStyles.readSmallTextStyle
              : textStyles.smallTextStyle,
        );
      });

  Widget _buildBadge() => ValueListenableBuilder<bool>(
      valueListenable: item.readNotifier,
      builder: (context, isRead, child) {
        return RoundTextWidget(
          text: item.item.reply,
          textStyle: isRead
              ? textStyles.readBadgeTextStyle
              : textStyles.badgeTextStyle,
        );
      });

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

    return Container(
      padding: const EdgeInsets.only(top: 10),
      height: 30,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          nickImage,
          nickName,
          time,
          const Spacer(),
          badge,
        ],
      ),
    );
  }
}
