import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_providers.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/nick_image_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/round_text_widget.dart';

class MoclListItem extends ConsumerWidget {
  final ListItem item;

  const MoclListItem({
    super.key,
    required this.item,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textStyles = MoclTextStyles.of(context);
    final titleStyle = textStyles.title(item.isRead);
    final smallTitleStyle = textStyles.smallTitle(item.isRead);
    final badgeStyle = textStyles.badge(item.isRead);

    return Column(
      children: [
        ListTile(
          minVerticalPadding: 10,
          minTileHeight: 24,
          contentPadding: const EdgeInsets.only(left: 16, right: 12),
          onTap: () {
            ref.read(handleListItemTapProvider(context, item));
          },
          title: TitleView(
            title: item.title,
            titleStyle: titleStyle,
          ),
          subtitle: BottomView(
            item: item,
            smallTitleStyle: smallTitleStyle,
            badgeStyle: badgeStyle,
          ),
        ),
        const DividerWidget(),
      ],
    );
  }
}

class TitleView extends StatelessWidget {
  final String title;
  final TextStyle titleStyle;

  const TitleView({
    super.key,
    required this.title,
    required this.titleStyle,
  });

  @override
  Widget build(BuildContext context) => Text(
        title,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: titleStyle,
      );
}

class BottomView extends StatelessWidget {
  final ListItem item;
  final TextStyle smallTitleStyle;
  final TextStyle badgeStyle;

  const BottomView({
    super.key,
    required this.item,
    required this.smallTitleStyle,
    required this.badgeStyle,
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
                        textStyle: smallTitleStyle,
                      ),
                    ),
                  ],
                ),
              ),
              if (hasReply) RoundTextWidget(text: reply, textStyle: badgeStyle),
            ],
          ),
        ),
      ],
    );
  }
}

class InfoText extends StatelessWidget {
  final String info;
  final TextStyle textStyle;

  const InfoText({
    super.key,
    required this.info,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) => Text(
        info,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: textStyle,
      );
}
