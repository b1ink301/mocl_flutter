import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/mocl_list_item_info.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_providers.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_routes.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/nick_image_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/round_text_widget.dart';

class MoclListItem extends ConsumerWidget {
  const MoclListItem({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MoclListItemInfo itemInfo = ref.watch(listItemInfoProvider);
    return Column(
      children: [
        ListTile(
          minVerticalPadding: 10,
          minTileHeight: 24,
          contentPadding: const EdgeInsets.only(left: 16, right: 12),
          onTap: () => _handleItemTap(context, ref, itemInfo.index),
          title:
              TitleView(title: itemInfo.title, titleStyle: itemInfo.titleStyle),
          subtitle: BottomView(
            smallTitleStyle: itemInfo.smallTitleStyle,
            badgeStyle: itemInfo.badgeStyle,
            id: itemInfo.id,
            reply: itemInfo.reply,
            nickImage: itemInfo.nickImage,
            info: itemInfo.info,
          ),
        ),
        const DividerWidget(),
      ],
    );
  }

  void _handleItemTap(
    BuildContext context,
    WidgetRef ref,
    int index,
  ) {
    final ListItem item = ref.watch(itemListNotifierProvider)[index];
    GoRouter.of(context).push(Routes.detail, extra: item).then((_) {
      if (context.mounted) {
        final readId = ref.watch(readableStateNotifierProvider);
        if (readId == item.id && !item.isRead) {
          ref
              .read(itemListNotifierProvider.notifier)
              .markAsReadItem(index, item);
          ref.read(paginationStateNotifierProvider.notifier).invalidate();
        }
      }
    });
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
  final String id;
  final String reply;
  final String nickImage;
  final String info;
  final TextStyle smallTitleStyle;
  final TextStyle badgeStyle;

  const BottomView({
    super.key,
    required this.id,
    required this.reply,
    required this.nickImage,
    required this.info,
    required this.smallTitleStyle,
    required this.badgeStyle,
  });

  @override
  Widget build(BuildContext context) => id.isEmpty
      ? const SizedBox.shrink()
      : Column(
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
                        if (nickImage.isNotEmpty &&
                            nickImage.startsWith('http'))
                          NickImageWidget(url: nickImage),
                        Flexible(
                          child: InfoText(
                            info: info,
                            textStyle: smallTitleStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (reply.isNotEmpty && reply != '0')
                    RoundTextWidget(text: reply, textStyle: badgeStyle),
                ],
              ),
            ),
          ],
        );
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
