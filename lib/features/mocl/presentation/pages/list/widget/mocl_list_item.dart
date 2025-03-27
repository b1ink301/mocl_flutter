import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_providers.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_routes.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/nick_image_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/round_text_widget.dart';

class MoclListItem extends ConsumerWidget {
  final ListItem item;
  final int index;

  const MoclListItem({super.key, required this.item, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) => PlatformListTile(
    material:
        (_, _) => MaterialListTileData(
          minVerticalPadding: 10,
          contentPadding: const EdgeInsets.only(left: 16, right: 12),
        ),
    cupertino:
        (_, _) => CupertinoListTileData(
          padding: const EdgeInsets.only(
            left: 16,
            right: 12,
            top: 10,
            bottom: 10,
          ),
        ),
    onTap: () => _handleItemTap(context, ref),
    title: _TitleView(title: item.title, isRead: item.isRead),
    subtitle:
        item.userInfo.id.isEmpty
            ? null
            : _BottomView(
              id: item.userInfo.id,
              reply: item.reply,
              nickImage: item.userInfo.nickImage,
              info: item.info,
              isRead: item.isRead,
            ),
  );

  void _handleItemTap(BuildContext context, WidgetRef ref) {
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
  final bool isRead;

  const _TitleView({required this.title, required this.isRead});

  @override
  Widget build(BuildContext context) => PlatformText(
    title,
    maxLines: 3,
    overflow: TextOverflow.ellipsis,
    style: MoclTextStyles.of(context).title(isRead),
  );
}

class _BottomView extends StatelessWidget {
  final String id;
  final String reply;
  final String nickImage;
  final String info;
  final bool isRead;

  const _BottomView({
    required this.id,
    required this.reply,
    required this.nickImage,
    required this.info,
    required this.isRead,
  });

  @override
  Widget build(BuildContext context) => Column(
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
                  if (nickImage.isNotEmpty) NickImageWidget(url: nickImage),
                  Flexible(child: _InfoText(info: info, isRead: isRead)),
                ],
              ),
            ),
            if (reply.isNotEmpty && reply != '0')
              RoundTextWidget(
                text: reply,
                textStyle: MoclTextStyles.of(context).badge(isRead),
              ),
          ],
        ),
      ),
    ],
  );
}

class _InfoText extends StatelessWidget {
  final String info;
  final bool isRead;

  const _InfoText({required this.info, required this.isRead});

  @override
  Widget build(BuildContext context) => PlatformText(
    info,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: MoclTextStyles.of(context).smallTitle(isRead),
  );
}
