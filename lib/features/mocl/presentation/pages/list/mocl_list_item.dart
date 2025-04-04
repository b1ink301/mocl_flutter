import 'package:flutter/material.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/nick_image_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/round_text_widget.dart';

class MoclListItem extends StatelessWidget {
  final ListItem item;
  final VoidCallback onTap;

  const MoclListItem({
    required this.item,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) => ListTile(
        minVerticalPadding: 10,
        minTileHeight: 24,
        contentPadding: const EdgeInsets.only(left: 16, right: 12),
        onTap: onTap,
        title: TitleView(
          title: item.title,
          isRead: item.isRead,
        ),
        subtitle: item.info.isEmpty
            ? null
            : BottomView(
                item: item,
                isRead: item.isRead,
              ),
      );
}

class TitleView extends StatelessWidget {
  final String title;
  final bool isRead;

  const TitleView({
    super.key,
    required this.title,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = MoclTextStyles.of(context);
    return Text(
      title,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
      style: textStyles.title(isRead),
    );
  }
}

class BottomView extends StatelessWidget {
  final ListItem item;
  final bool isRead;

  const BottomView({
    super.key,
    required this.item,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    final reply = item.reply;
    // final nickImage = item.userInfo.nickImage;
    final hasReply = reply.isNotEmpty && reply != '0';
    final textStyles = MoclTextStyles.of(context);

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
                    // if (nickImage.isNotEmpty && nickImage.startsWith('http'))
                    //   NickImageWidget(url: nickImage),
                    Flexible(
                      child: InfoText(
                        info: item.info,
                        isRead: isRead,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasReply)
                RoundTextWidget(
                    text: reply, textStyle: textStyles.badge(isRead)),
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

  const InfoText({
    super.key,
    required this.info,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = MoclTextStyles.of(context);
    return Text(
      info,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: textStyles.smallTitle(isRead),
    );
  }
}

class ReplyBadge extends StatelessWidget {
  final String reply;
  final bool isRead;

  const ReplyBadge({
    super.key,
    required this.reply,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) {
    final textStyles = MoclTextStyles.of(context);
    return RoundTextWidget(text: reply, textStyle: textStyles.badge(isRead));
  }
}
