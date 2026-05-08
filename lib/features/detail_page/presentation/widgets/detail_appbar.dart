import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/presentation/widgets/adaptive_popup_menu.dart';
import 'package:mocl_flutter/core/presentation/widgets/appbar_dual_text_widget.dart';

import '../state/detail_event_mixin.dart';
import '../state/detail_state_mixin.dart';

class DetailAppBar extends ConsumerWidget with DetailState, DetailEvent {
  const DetailAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String title = titleState(ref);
    final double height = appbarHeight(ref, title);

    return AppbarDualTextWidget(
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
          onIncreaseFontSize: () => adjustFontSize(ref, 1),
          onDecreaseFontSize: () => adjustFontSize(ref, -1),
          onResetFontSize: () => resetFontSize(ref),
        ),
      ],
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
  final void Function() onResetFontSize;

  const _DetailPopupMenuButton({
    required this.focusColor,
    required this.onRefresh,
    required this.onOpenBrowser,
    required this.onShareUrl,
    required this.onIncreaseFontSize,
    required this.onDecreaseFontSize,
    required this.onResetFontSize,
  });

  @override
  Widget build(BuildContext context) => AdaptivePopupMenu(
    icon: Icon(size: 24, Icons.more_vert_rounded),
    options: [
      AdaptiveMenuOption(label: '새로고침', onTap: onRefresh),
      AdaptiveMenuOption(label: '브라우저로 열기', onTap: onOpenBrowser),
      AdaptiveMenuOption(label: '공유하기', onTap: onShareUrl),
      AdaptiveMenuOption(
        label: '글자 크기 변경',
        onTap: () => showAdaptiveDialog(
          context: context,
          builder: (dialogContext) => _FontSizeDialog(
            focusColor: focusColor,
            onIncrease: onIncreaseFontSize,
            onDecrease: onDecreaseFontSize,
            onReset: () {
              onResetFontSize();
              Navigator.of(dialogContext).pop();
            },
          ),
        ),
      ),
    ],
  );
}

class _FontSizeDialog extends ConsumerWidget {
  final Color focusColor;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onReset;

  const _FontSizeDialog({
    required this.focusColor,
    required this.onIncrease,
    required this.onDecrease,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double delta = ref.watch(fontSizeDeltaProvider);
    return AlertDialog.adaptive(
      title: const Text('글자 크기 변경'),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.exposure_minus_1, color: focusColor),
            onPressed: onDecrease,
          ),
          Text(
            _label(delta),
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          IconButton(
            icon: Icon(Icons.exposure_plus_1, color: focusColor),
            onPressed: onIncrease,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onReset,
          child: Text(
            '초기화',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: focusColor,
            ),
          ),
        ),
      ],
    );
  }

  String _label(double delta) {
    if (delta == 0) return '기본';
    final int step = delta.toInt();
    return step > 0 ? '+$step' : '$step';
  }
}
