import 'package:flutter/material.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/nick_image_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/round_text_widget.dart';

@immutable
class CachedListItem extends StatefulWidget {
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

  factory CachedListItem.empty() => CachedListItem(
        item: ListItem.empty(),
        isRead: ValueNotifier(false),
        onTap: () {},
        textStyles: TextStyles.empty(),
      );

  @override
  State<CachedListItem> createState() => _CachedListItemState();
}

class _CachedListItemState extends State<CachedListItem> {
  late bool _isReadValue;

  @override
  void initState() {
    super.initState();
    _isReadValue = widget.isRead.value;
    widget.isRead.addListener(_updateIsRead);
  }

  @override
  void didUpdateWidget(CachedListItem oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isRead != widget.isRead) {
      oldWidget.isRead.removeListener(_updateIsRead);
      _isReadValue = widget.isRead.value;
      widget.isRead.addListener(_updateIsRead);
    }
  }

  void _updateIsRead() => setState(() {
        _isReadValue = widget.isRead.value;
      });

  @override
  void dispose() {
    widget.isRead.removeListener(_updateIsRead);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      minVerticalPadding: 10,
      minTileHeight: 24,
      contentPadding: const EdgeInsets.only(left: 16, right: 12),
      onTap: widget.onTap,
      title: _buildTitleView(),
      subtitle: _buildBottomView(),
    );
  }

  Widget _buildTitleView() {
    // debugPrint('_buildTitleView item=${widget.item.title}');
    return Text(
      widget.item.title,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: _isReadValue
          ? widget.textStyles.readTitleTextStyle
          : widget.textStyles.titleTextStyle,
    );
  }

  Widget? _buildBottomView() {
    if (widget.item.userInfo.id.isEmpty) {
      return null;
    }

    final reply = widget.item.reply;
    return Column(
      children: [
        const SizedBox(height: 8),
        SizedBox(
          height: 20,
          child: Row(
            children: [
              Expanded(
                child: _buildUserInfoAndTime(),
              ),
              if (reply.isNotEmpty && reply != '0')
                RoundTextWidget(
                  text: reply,
                  textStyle: _isReadValue
                      ? widget.textStyles.readBadgeTextStyle
                      : widget.textStyles.badgeTextStyle,
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfoAndTime() {
    final nickImage = widget.item.userInfo.nickImage;
    final nickName = widget.item.userInfo.nickName;
    final time = widget.item.time;
    final textStyle = _isReadValue
        ? widget.textStyles.readSmallTextStyle
        : widget.textStyles.smallTextStyle;

    return Row(
      children: [
        if (nickImage.isNotEmpty && nickImage.startsWith('http'))
          NickImageWidget(url: nickImage),
        if (nickName.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              nickName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ),
          ),
        if (time.isNotEmpty)
          Flexible(
            child: Text(
              time,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ),
          ),
      ],
    );
  }
}
