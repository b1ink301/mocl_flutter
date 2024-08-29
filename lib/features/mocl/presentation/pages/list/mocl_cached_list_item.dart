import 'dart:developer';

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
  Widget build(BuildContext context) => InkWell(
        onTap: widget.onTap,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 12, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleView(),
              const SizedBox(height: 4),
              _buildBottomView(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );

  Widget _buildTitleView() {
    log('_buildTitleView = ${widget.item.title}');
    return Text(
      widget.item.title,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: _isReadValue
          ? widget.textStyles.readTitleTextStyle
          : widget.textStyles.titleTextStyle,
    );
  }

  Widget _buildBottomView() => SizedBox(
        height: 20,
        child: Row(
          children: [
            if (widget.item.userInfo.nickImage.isNotEmpty)
              NickImageWidget(url: widget.item.userInfo.nickImage),
            if (widget.item.userInfo.nickName.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Text(
                  widget.item.userInfo.nickName,
                  maxLines: 1,
                  style: _isReadValue
                      ? widget.textStyles.readSmallTextStyle
                      : widget.textStyles.smallTextStyle,
                ),
              ),
            Text(
              widget.item.time,
              maxLines: 1,
              style: _isReadValue
                  ? widget.textStyles.readSmallTextStyle
                  : widget.textStyles.smallTextStyle,
            ),
            const Spacer(),
            RoundTextWidget(
              text: widget.item.reply,
              textStyle: _isReadValue
                  ? widget.textStyles.readBadgeTextStyle
                  : widget.textStyles.badgeTextStyle,
            ),
          ],
        ),
      );
}
