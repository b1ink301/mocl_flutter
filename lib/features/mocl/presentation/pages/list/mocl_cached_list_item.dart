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

  void _updateIsRead() {
    setState(() {
      _isReadValue = widget.isRead.value;
    });
  }

  @override
  void dispose() {
    widget.isRead.removeListener(_updateIsRead);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // debugPrint('CachedListItem item=${widget.item.title}');
    return InkWell(
      onTap: widget.onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 10, 12, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitleView(),
            const SizedBox(height: 6),
            _buildBottomView(),
            const SizedBox(height: 11),
            // const DividerWidget(indent: 0, endIndent: 0),
          ],
        ),
      ),
    );
  }

  Widget _buildTitleView() {
    return Text(
      widget.item.title,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: _isReadValue
          ? widget.textStyles.readTitleTextStyle
          : widget.textStyles.titleTextStyle,
    );
  }

  Widget _buildBottomView() {
    final reply = widget.item.reply;
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          Expanded(
            child: _buildUserInfoAndTime(),
          ),
          Visibility(
            visible: reply.isNotEmpty && reply != '0',
            child: RoundTextWidget(
              text: reply,
              textStyle: _isReadValue
                  ? widget.textStyles.readBadgeTextStyle
                  : widget.textStyles.badgeTextStyle,
            ),
          ),
        ],
      ),
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
        Visibility(
          visible: nickImage.isNotEmpty,
          child: NickImageWidget(url: nickImage),
        ),
        Visibility(
          visible: nickName.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: Text(
              nickName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ),
          ),
        ),
        Visibility(
          visible: time.isNotEmpty,
          child: Flexible(
            child: Text(
              time,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textStyle,
            ),
          ),
        ),
      ],
    );
  }
}
