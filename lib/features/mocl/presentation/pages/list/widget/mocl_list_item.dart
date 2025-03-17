import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/mocl_list_item_info.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_providers.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_routes.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/nick_image_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/round_text_widget.dart';

class MoclListItem extends ConsumerWidget {
  final ListItem item;
  final int index;

  const MoclListItem({super.key, required this.item, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final MoclListItemInfo itemInfo = item.toListItemInfo(context, index, 0);
    return PlatformListTile(
      material: (_, __) => MaterialListTileData(
        minVerticalPadding: 10,
        contentPadding: const EdgeInsets.only(left: 16, right: 12),
      ),
      cupertino: (_, __) => CupertinoListTileData(
        padding:
            const EdgeInsets.only(left: 16, right: 12, top: 10, bottom: 10),
      ),
      onTap: () => _handleItemTap(context, ref, itemInfo.index),
      title: _TitleView(title: itemInfo.title, titleStyle: itemInfo.titleStyle),
      subtitle: _BottomView(
        smallTitleStyle: itemInfo.smallTitleStyle,
        badgeStyle: itemInfo.badgeStyle,
        id: itemInfo.id,
        reply: itemInfo.reply,
        nickImage: itemInfo.nickImage,
        info: itemInfo.info,
      ),
    );
  }

  void _handleItemTap(
    BuildContext context,
    WidgetRef ref,
    int index,
  ) {
    try {
      GoRouter.of(context).push(Routes.detail, extra: item).then((_) {
        if (context.mounted) {
          final readId = ref.read(readableStateNotifierProvider);
          if (readId == item.id && !item.isRead) {
            ref.read(listStateNotifierProvider.notifier).markAsRead(index);
          }
        }
      });
    } catch (e) {
      debugPrint('_handleItemTap = $e');
    }
  }
}

class _TitleView extends StatelessWidget {
  final String title;
  final TextStyle titleStyle;

  const _TitleView({
    required this.title,
    required this.titleStyle,
  });

  @override
  Widget build(BuildContext context) => PlatformText(
        title,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        style: titleStyle,
      );
}

class _BottomView extends StatelessWidget {
  final String id;
  final String reply;
  final String nickImage;
  final String info;
  final TextStyle smallTitleStyle;
  final TextStyle badgeStyle;

  const _BottomView({
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
                          child: _InfoText(
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

class _InfoText extends StatelessWidget {
  final String info;
  final TextStyle textStyle;

  const _InfoText({
    required this.info,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) => PlatformText(
        info,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: textStyle,
      );
}
