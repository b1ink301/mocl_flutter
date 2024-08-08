import 'package:flutter/material.dart';

import '../../../../domain/entities/mocl_user_info.dart';
import '../../../models/mocl_list_item_wrapper.dart';
import '../../../widgets/nick_image_widget.dart';
import '../../../widgets/round_text_widget.dart';

class CachedListItem extends StatefulWidget {
  final ListItemWrapper item;
  final VoidCallback onTap;

  const CachedListItem({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  State createState() => _CachedListItemState();
}

class _CachedListItemState extends State<CachedListItem>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final theme = Theme.of(context);
    final textStyle = theme.textTheme.bodyMedium;
    final smallTextStyle = theme.textTheme.bodySmall;
    final badgeTextStyle = theme.textTheme.labelSmall;
    final color = theme.highlightColor;

    return ValueListenableBuilder<bool>(
      valueListenable: widget.item.isReadNotifier,
      builder: (context, isRead, _) => ListTile(
        dense: true,
        contentPadding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
        title: AnimatedDefaultTextStyle(
          style: isRead ? textStyle!.copyWith(color: color) : textStyle!,
          duration: const Duration(milliseconds: 200),
          child: Text(widget.item.item.title),
        ),
        subtitle: _buildBottomView(
          context,
          widget.item.item.userInfo,
          widget.item.item.reply,
          widget.item.item.time,
          isRead ? smallTextStyle?.copyWith(color: color) : smallTextStyle,
          isRead ? badgeTextStyle?.copyWith(color: color) : badgeTextStyle,
        ),
        onTap: widget.onTap,
      ),
    );
  }

  Widget _buildBottomView(
    BuildContext context,
    UserInfo userInfo,
    String reply,
    String time,
    TextStyle? textStyle,
    TextStyle? badgeTextStyle,
  ) =>
      Padding(
        padding: const EdgeInsets.only(top: 8.0),
        child: Row(
          children: [
            NickImageWidget(url: userInfo.nickImage),
            Text(userInfo.nickName, style: textStyle),
            const SizedBox(width: 8),
            Text(time, style: textStyle),
            const Spacer(),
            RoundTextWidget(text: reply, textStyle: badgeTextStyle),
            const SizedBox(width: 8),
          ],
        ),
      );
}
