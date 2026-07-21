import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_text.dart';

class AppbarDualTextWidget extends StatelessWidget {
  final String smallTitle;
  final String title;
  final TextStyle titleStyle;
  final TextStyle smallTitleStyle;
  final double toolbarHeight;
  final bool automaticallyImplyLeading;
  final List<Widget>? actions;

  /// 앱바 하단에 함께 붙어 floating 되는 확장 영역(예: 상세 작성자 헤더).
  /// floating 앱바이므로 이 영역도 앱바와 한 몸으로 밀려가고 되돌아온다.
  final PreferredSizeWidget? bottom;

  const AppbarDualTextWidget({
    super.key,
    required this.smallTitle,
    required this.title,
    required this.titleStyle,
    required this.smallTitleStyle,
    this.toolbarHeight = 62,
    this.automaticallyImplyLeading = false,
    this.actions,
    this.bottom,
  });

  @override
  Widget build(BuildContext context) => SliverAppBar(
    title: _DualTitle(
      title: title,
      titleStyle: titleStyle,
      smallTitle: smallTitle,
      smallTitleStyle: smallTitleStyle,
    ),
    scrolledUnderElevation: 1,
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
    bottom: bottom,
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
      PlainText(smallTitle, style: smallTitleStyle),
      PlainText(title, style: titleStyle, maxLines: 3, overflow: .ellipsis),
      const SizedBox(height: 2),
    ],
  );
}
