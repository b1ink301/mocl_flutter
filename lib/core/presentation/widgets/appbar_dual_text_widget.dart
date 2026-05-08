import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';

import 'message_widget.dart';

class AppbarDualTextWidget extends StatelessWidget {
  final String smallTitle;
  final String title;
  final double toolbarHeight;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;

  const AppbarDualTextWidget({
    super.key,
    required this.smallTitle,
    required this.title,
    this.toolbarHeight = 64,
    this.automaticallyImplyLeading = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) => SliverAppBar(
    title: _DualTitle(smallTitle: smallTitle, title: title),
    scrolledUnderElevation: 0,
    titleSpacing: automaticallyImplyLeading
        ? 0
        : NavigationToolbar.kMiddleSpacing,
    automaticallyImplyLeading: automaticallyImplyLeading,
    centerTitle: false,
    floating: true,
    pinned: false,
    toolbarHeight: toolbarHeight,
    actions: actions,
  );
}

class _DualTitle extends ConsumerWidget {
  final String smallTitle;
  final String title;

  const _DualTitle({required this.smallTitle, required this.title});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titleStyle = ref
        .watch(appTextStylesFontSizeProvider.select((s) => s.titleTextStyle))
        .copyWith(color: Colors.white);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        MessageWidget(
          message: smallTitle,
          textStyle: Theme.of(context).textTheme.labelSmall,
        ),
        const SizedBox(height: 4),
        MessageWidget(textStyle: titleStyle, message: title),
      ],
    );
  }
}
