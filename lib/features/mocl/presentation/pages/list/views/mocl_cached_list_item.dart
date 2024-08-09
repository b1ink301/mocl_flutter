import 'package:flutter/material.dart';

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
      builder: (context, isRead, child) {
        return ListTile(
          contentPadding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
          title: _buildTitle(),
          subtitle: _buildBottomView(
            widget.item.item.userInfo.id,
            child!,
            _buildNickName(),
            _buildTime(),
            _buildBadge(),
          ),
          onTap: widget.onTap,
        );
      },
      child: _buildNickImage(widget.item.item.userInfo.nickImage),
    );
  }

  Widget _buildTitle() => Text(
        widget.item.item.title,
        style: widget.item.isReadNotifier.value
            ? widget.textStyles.readTitleTextStyle
            : widget.textStyles.titleTextStyle,
      );

  Widget _buildNickName() => Text(
        widget.item.item.userInfo.nickName,
        style: widget.item.isReadNotifier.value
            ? widget.textStyles.readSmallTextStyle
            : widget.textStyles.smallTextStyle,
      );

  Widget _buildTime() => Text(
        widget.item.item.time,
        style: widget.item.isReadNotifier.value
            ? widget.textStyles.readSmallTextStyle
            : widget.textStyles.smallTextStyle,
      );

  Widget _buildBadge() => RoundTextWidget(
        text: widget.item.item.reply,
        textStyle: widget.item.isReadNotifier.value
            ? widget.textStyles.readBadgeTextStyle
            : widget.textStyles.badgeTextStyle,
      );

  /**

      @override
      Widget build(BuildContext context) {
      super.build(context);
      return _buildListView();
      }

      Widget _buildListView() => ListTile(
      contentPadding: const EdgeInsets.fromLTRB(16, 4, 4, 4),
      title: _buildTitle(),
      subtitle: _buildBottomView(
      widget.item.item.userInfo,
      _buildNickName(),
      _buildTime(),
      _buildBadge(),
      ),
      onTap: widget.onTap,
      );

      Widget _buildTitle() => ValueListenableBuilder<bool>(
      valueListenable: widget.item.isReadNotifier,
      builder: (context, isRead, child) {
      return Text(
      widget.item.item.title,
      style: isRead
      ? widget.textStyles.readTitleTextStyle
      : widget.textStyles.titleTextStyle,
      );
      },
      );

      Widget _buildNickName() => ValueListenableBuilder<bool>(
      valueListenable: widget.item.isReadNotifier,
      builder: (context, isRead, child) {
      return Text(
      widget.item.item.userInfo.nickName,
      style: isRead
      ? widget.textStyles.readSmallTextStyle
      : widget.textStyles.smallTextStyle,
      );
      },
      );

      Widget _buildTime() => ValueListenableBuilder<bool>(
      valueListenable: widget.item.isReadNotifier,
      builder: (context, isRead, child) {
      return Text(
      widget.item.item.time,
      style: isRead
      ? widget.textStyles.readSmallTextStyle
      : widget.textStyles.smallTextStyle,
      );
      },
      );

      Widget _buildBadge() => ValueListenableBuilder<bool>(
      valueListenable: widget.item.isReadNotifier,
      builder: (context, isRead, child) {
      return RoundTextWidget(
      text: widget.item.item.reply,
      textStyle: isRead
      ? widget.textStyles.readBadgeTextStyle
      : widget.textStyles.badgeTextStyle,
      );
      },
      );
   */

  Widget _buildNickImage(String url) => NickImageWidget(url: url);

  Widget? _buildBottomView(
    String id,
    Widget nickImage,
    Widget nickName,
    Widget time,
    Widget badge,
  ) {
    if (id.isEmpty) return null;
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          nickImage,
          nickName,
          const SizedBox(width: 8),
          time,
          const Spacer(),
          badge,
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
