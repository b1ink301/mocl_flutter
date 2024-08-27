import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/views/mocl_text_styles.dart';
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
  Widget build(BuildContext context) {
    log('CachedListItem title=${item.title}');
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.fromLTRB(16, 4, 12, 4),
      title: _buildTitle(),
      subtitle: _buildBottomView(item.userInfo.id),
    );
  }

  Widget _buildTitle() => SizedBox(
        // height: 24,
        child: ValueListenableBuilder<bool>(
          valueListenable: isRead,
          builder: (context, isReadValue, child) => Text(
            item.title,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: isReadValue
                ? textStyles.readTitleTextStyle
                : textStyles.titleTextStyle,
          ),
        ),
      );

  Widget? _buildNickName() {
    if (item.userInfo.nickName.isEmpty) {
      return null;
    }
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: ValueListenableBuilder(
        builder: (context, isReadValue, _) => Text(
          item.userInfo.nickName,
          maxLines: 1,
          style: isReadValue
              ? textStyles.readSmallTextStyle
              : textStyles.smallTextStyle,
        ),
        valueListenable: isRead,
      ),
    );
  }

  Widget _buildTime() => ValueListenableBuilder(
        builder: (context, isReadValue, _) => Text(
          item.time,
          maxLines: 1,
          style: isReadValue
              ? textStyles.readSmallTextStyle
              : textStyles.smallTextStyle,
        ),
        valueListenable: isRead,
      );

  Widget _buildBadge() => ValueListenableBuilder(
        builder: (context, isReadValue, _) => RoundTextWidget(
          text: item.reply,
          textStyle: isReadValue
              ? textStyles.readBadgeTextStyle
              : textStyles.badgeTextStyle,
        ),
        valueListenable: isRead,
      );

  Widget? _buildNickImage() => NickImageWidget(url: item.userInfo.nickImage);

  Widget? _buildBottomView(
    String id,
  ) {
    if (id.isEmpty) null;

    return Column(children: [
      const SizedBox(height: 10),
      SizedBox(
        height: 20,
        child: Row(
          children: [
            _buildNickImage(),
            _buildNickName(),
            _buildTime(),
            const Spacer(),
            _buildBadge()
          ].whereType<Widget>().toList(),
        ),
      )
    ]);
  }
}
