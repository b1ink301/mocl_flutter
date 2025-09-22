import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/presentation/widgets/appbar_dual_text_widget.dart';

import 'detail_event_mixin.dart';
import 'detail_state_mixin.dart';

class DetailAppBar extends ConsumerWidget with DetailState, DetailEvent {
  const DetailAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String title = titleState(ref);
    final double height = appbarHeight(ref, title);

    return PlatformWidget(
      material: (_, _) => AppbarDualTextWidget(
        title: title,
        smallTitle: smallTitleState(ref),
        automaticallyImplyLeading: Platform.isMacOS,
        toolbarHeight: height,
        actions: [
          _DetailPopupMenuButton(
            focusColor: Theme.of(context).focusColor,
            onRefresh: () => handleRefresh(ref),
            onOpenBrowser: () => handleOpenBrowser(ref),
            onShareUrl: () => handleShareUrl(ref),
            onIncreaseFontSize: () => increaseFontSize(ref),
            onDecreaseFontSize: () => decreaseFontSize(ref),
            onInitFontSize: () => initFontSize(ref),
          ),
        ],
      ),
      cupertino: (_, _) => SliverPersistentHeader(
        delegate: _DetailCupertinoAppBar(title: title, height: height),
      ),
    );
  }
}

class _DetailPopupMenuButton extends StatelessWidget {
  final Color focusColor;
  final void Function() onRefresh;
  final void Function() onOpenBrowser;
  final void Function() onShareUrl;
  final void Function() onIncreaseFontSize;
  final void Function() onDecreaseFontSize;
  final void Function() onInitFontSize;

  const _DetailPopupMenuButton({
    required this.focusColor,
    required this.onRefresh,
    required this.onOpenBrowser,
    required this.onShareUrl,
    required this.onIncreaseFontSize,
    required this.onDecreaseFontSize,
    required this.onInitFontSize,
  });

  @override
  Widget build(BuildContext context) => PlatformPopupMenu(
    icon: Icon(
      size: 24,
      context.platformIcon(
        material: Icons.more_vert_rounded,
        cupertino: CupertinoIcons.ellipsis,
      ),
    ),
    options: [
      PopupMenuOption(label: '새로고침', onTap: (_) => onRefresh()),
      PopupMenuOption(label: '브라우저로 열기', onTap: (_) => onOpenBrowser()),
      PopupMenuOption(label: '공유하기', onTap: (_) => onShareUrl()),
      PopupMenuOption(
        label: '글자 크기 변경',
        onTap: (_) => showAdaptiveDialog(
          context: context,
          builder: (dialogContext) => AlertDialog.adaptive(
            title: const Text('글자 크기 변경'),
            content: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.exposure_minus_1, color: focusColor),
                  onPressed: onDecreaseFontSize,
                ),
                IconButton(
                  icon: Icon(Icons.exposure_plus_1, color: focusColor),
                  onPressed: onIncreaseFontSize,
                ),
              ],
            ),
            actions: [
              PlatformDialogAction(
                onPressed: onInitFontSize,
                child: PlatformText(
                  '초기화',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Theme.of(context).focusColor,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );
}

class _DetailCupertinoAppBar extends SliverPersistentHeaderDelegate {
  final String title;
  final double height;

  const _DetailCupertinoAppBar({required this.title, required this.height});

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    color: CupertinoTheme.of(context).scaffoldBackgroundColor,
    child: Text(
      title,
      style: CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle,
      maxLines: 3,
      overflow: TextOverflow.ellipsis,
    ),
  );

  @override
  double get maxExtent => height; // 3줄 높이에 맞게 조정

  @override
  double get minExtent => height;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
