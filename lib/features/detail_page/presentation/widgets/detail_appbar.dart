import 'dart:io';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/presentation/widgets/adaptive_popup_menu.dart';
import 'package:mocl_flutter/core/presentation/widgets/appbar_dual_text_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_icon_button.dart';

import '../../../../core/presentation/widgets/plain_icon.dart';
import '../../../../core/presentation/widgets/plain_text.dart';
import '../state/detail_event_mixin.dart';
import '../state/detail_state_mixin.dart';
import 'detail_header_bar.dart';
import 'detail_scope.dart';

class const DetailAppBar({super.key})
    extends ConsumerWidget
    with DetailState, DetailEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String title = titleState(ref);
    final double height = appbarHeight(ref, title);

    final styles = DetailStyleScope.of(context).$1;
    final titleStyle = styles.titleTextStyle.copyWith(
      fontWeight: FontWeight.w800,
    );
    final theme = Theme.of(context);
    final smallTitleStyle = theme.textTheme.labelSmall!;
    final focusColor = theme.focusColor;

    // 상세 데이터가 로드되면 작성자 헤더를 앱바 확장 영역(bottom)으로 붙여
    // floating 앱바와 한 몸으로 스크롤/재등장하게 한다.
    final detail = detailState(ref).asData?.value;

    return AppbarDualTextWidget(
      title: title,
      smallTitle: smallTitleState(ref),
      titleStyle: titleStyle,
      smallTitleStyle: smallTitleStyle,
      automaticallyImplyLeading: Platform.isMacOS,
      toolbarHeight: height,
      bottom: detail != null
          ? DetailHeaderBar(detail: detail, style: styles.smallTextStyle)
          : null,
      actions: [
        _DetailPopupMenuButton(
          focusColor: focusColor,
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

class const _DetailPopupMenuButton({
  required final Color focusColor,
  required final void Function() onRefresh,
  required final void Function() onOpenBrowser,
  required final void Function() onShareUrl,
  required final void Function() onIncreaseFontSize,
  required final void Function() onDecreaseFontSize,
  required final void Function() onResetFontSize,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => AdaptivePopupMenu(
    icon: PlainIcon(Icons.more_vert_rounded),
    options: [
      AdaptiveMenuOption(label: '새로고침', onTap: onRefresh),
      AdaptiveMenuOption(label: '브라우저로 열기', onTap: onOpenBrowser),
      AdaptiveMenuOption(label: '공유하기', onTap: onShareUrl),
      AdaptiveMenuOption(
        label: '글자 크기 변경',
        onTap: () => showAdaptiveDialog<void>(
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

class const _FontSizeDialog({
  required final Color focusColor,
  required final VoidCallback onIncrease,
  required final VoidCallback onDecrease,
  required final VoidCallback onReset,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double delta = ref.watch(fontSizeDeltaProvider);
    final textStyle = Theme.of(context).textTheme.headlineMedium!;

    return AlertDialog.adaptive(
      title: PlainText('글자 크기 변경', style: textStyle),
      content: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PlainIconButton(
            icon: PlainIcon(Icons.exposure_minus_1, color: focusColor),
            onPressed: onDecrease,
          ),
          PlainText(_label(delta), style: textStyle),
          PlainIconButton(
            icon: PlainIcon(Icons.exposure_plus_1, color: focusColor),
            onPressed: onIncrease,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: onReset,
          child: PlainText('초기화', style: textStyle.copyWith(color: focusColor)),
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
