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
      title: TitleView(
        title: widget.item.title,
        isRead: _isReadValue,
        textStyles: widget.textStyles,
      ),
      subtitle: BottomView(
        item: widget.item,
        isRead: _isReadValue,
        textStyles: widget.textStyles,
      ),
    );
  }
}

class TitleView extends StatelessWidget {
  final String title;
  final bool isRead;
  final TextStyles textStyles;

  const TitleView({
    super.key,
    required this.title,
    required this.isRead,
    required this.textStyles,
  });

  @override
  Widget build(BuildContext context) {
    // debugPrint('TitleView build: title=$title');
    return Text(
      title,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: isRead ? textStyles.readTitleTextStyle : textStyles.titleTextStyle,
    );
  }
}

class BottomView extends StatelessWidget {
  final ListItem item;
  final bool isRead;
  final TextStyles textStyles;

  const BottomView({
    super.key,
    required this.item,
    required this.isRead,
    required this.textStyles,
  });

  @override
  Widget build(BuildContext context) {
    if (item.userInfo.id.isEmpty) {
      return const SizedBox.shrink();
    }

    final reply = item.reply;
    final nickImage = item.userInfo.nickImage;
    final hasReply = reply.isNotEmpty && reply != '0';

    return Column(
      children: [
        const SizedBox(height: 8),
        SizedBox(
          height: 20,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    if (nickImage.isNotEmpty && nickImage.startsWith('http'))
                      NickImageWidget(url: nickImage),
                    Flexible(
                      child: InfoText(
                        info: item.info,
                        isRead: isRead,
                        textStyles: textStyles,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasReply)
                RoundTextWidget(
                  text: reply,
                  textStyle: isRead
                      ? textStyles.readBadgeTextStyle
                      : textStyles.badgeTextStyle,
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class InfoText extends StatelessWidget {
  final String info;
  final bool isRead;
  final TextStyles textStyles;

  const InfoText({
    super.key,
    required this.info,
    required this.isRead,
    required this.textStyles,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      info,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: isRead ? textStyles.readSmallTextStyle : textStyles.smallTextStyle,
    );
  }
}

class ReplyBadge extends StatelessWidget {
  final String reply;
  final bool isRead;
  final TextStyles textStyles;

  const ReplyBadge({
    super.key,
    required this.reply,
    required this.isRead,
    required this.textStyles,
  });

  @override
  Widget build(BuildContext context) {
    return RoundTextWidget(
      text: reply,
      textStyle:
          isRead ? textStyles.readBadgeTextStyle : textStyles.badgeTextStyle,
    );
  }
}
