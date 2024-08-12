import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/mocl_list_item_wrapper.dart';
import '../../../widgets/nick_image_widget.dart';
import '../../../widgets/round_text_widget.dart';
import 'mocl_text_styles.dart';

class CachedListItem extends StatefulWidget {
  final ListItemWrapper item;
  final TextStyles textStyles;
  final VoidCallback onTap;

  const CachedListItem({
    super.key,
    required this.item,
    required this.onTap,
    required this.textStyles,
  });

  @override
  State createState() => _CachedListItemState();
}

class _CachedListItemState extends State<CachedListItem> {
  // with AutomaticKeepAliveClientMixin {
  // @override
  // bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    // super.build(context);

    return ValueListenableBuilder<bool>(
      valueListenable: widget.item.isReadNotifier,
      builder: (context, isRead, child) => InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 4, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitle(isRead),
              const SizedBox(height: 8),
              _buildBottomView(
                widget.item.item.userInfo.id,
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
  }

  Widget _buildTitle(bool isRead) {
    Get.log('_buildTitle = ${widget.item.item.title}');
    return SizedBox(
        height: 24,
        child: Text(
          widget.item.item.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: isRead
              ? widget.textStyles.readTitleTextStyle
              : widget.textStyles.titleTextStyle,
        ),
      );
  }

  Widget _buildNickName(bool isRead) => Text(
        widget.item.item.userInfo.nickName,
        maxLines: 1,
        style: isRead
            ? widget.textStyles.readSmallTextStyle
            : widget.textStyles.smallTextStyle,
      );

  Widget _buildTime(bool isRead) => Text(
        widget.item.item.time,
        maxLines: 1,
        style: isRead
            ? widget.textStyles.readSmallTextStyle
            : widget.textStyles.smallTextStyle,
      );

  Widget _buildBadge(bool isRead) => RoundTextWidget(
        text: widget.item.item.reply,
        textStyle: isRead
            ? widget.textStyles.readBadgeTextStyle
            : widget.textStyles.badgeTextStyle,
      );

  Widget _buildNickImage() =>
      NickImageWidget(url: widget.item.item.userInfo.nickImage);

  Widget _buildBottomView(
    String id,
    Widget nickImage,
    Widget nickName,
    Widget time,
    Widget badge,
  ) {
    if (id.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              nickImage,
              const SizedBox(width: 8), // 이미지와 닉네임 사이의 간격
              nickName,
              const SizedBox(width: 8), // 닉네임과 시간 사이의 간격
              time,
            ],
          ),
          Row(
            children: [
              badge,
              const SizedBox(width: 8), // 배지와 끝 사이의 간격
            ],
          ),
        ],
      ),
    );
  }
}
