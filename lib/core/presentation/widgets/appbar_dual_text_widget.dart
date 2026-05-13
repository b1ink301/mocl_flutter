import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppbarDualTextWidget extends StatelessWidget {
  final String smallTitle;
  final String title;
  final TextStyle titleStyle;
  final TextStyle smallTitleStyle;
  final double toolbarHeight;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;

  const AppbarDualTextWidget({
    super.key,
    required this.smallTitle,
    required this.title,
    required this.titleStyle,
    required this.smallTitleStyle,
    this.toolbarHeight = 64,
    this.automaticallyImplyLeading = false,
    this.actions,
  });

  @override
  Widget build(BuildContext context) => SliverAppBar(
    title: _DualTitle(
      title: title,
      titleStyle: titleStyle,
      smallTitle: smallTitle,
      smallTitleStyle: smallTitleStyle,
    ),
    scrolledUnderElevation: 0,
    titleSpacing: automaticallyImplyLeading
        ? 0
        : NavigationToolbar.kMiddleSpacing,
    automaticallyImplyLeading: automaticallyImplyLeading,
    centerTitle: false,
    floating: true,
    // snap: true,
    pinned: false,
    toolbarHeight: toolbarHeight,
    actions: actions,
  );
}

class _DualTitle extends ConsumerWidget {
  final String smallTitle;
  final String title;
  final TextStyle titleStyle;
  final TextStyle smallTitleStyle;

  const _DualTitle({
    required this.smallTitle,
    required this.title,
    required this.titleStyle,
    required this.smallTitleStyle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(smallTitle, style: smallTitleStyle),
      const SizedBox(height: 4),
      Text(title, style: titleStyle, maxLines: 3, overflow: .ellipsis),
    ],
  );
}
