import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/large_title_metrics.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';

import 'large_title_flexible_space.dart';
import 'scroll_to_top_title.dart';

/// 홈 하단 탭(지금 이슈 · 설정)의 큰 제목 앱바.
///
/// 게시판 탭(`MainAppBar`)과 같은 모양 · 높이라 탭을 오가도 제목 자리가 같다.
/// floating 이라 역스크롤하면 툴바만 내려오고, 툴바를 탭하면 맨 위로 올린다.
class const LargeTitleSliverAppBar({
  super.key,
  required final String title,
  final List<Widget>? actions,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final TextStyle style = largeTitleStyle(
      ref.watch(appTextStylesFontSizeProvider.select((s) => s.titleTextStyle)),
    );
    return SliverAppBar(
      automaticallyImplyLeading: false,
      expandedHeight: kLargeTitleExpandedHeightSingleLine,
      flexibleSpace: LargeTitleFlexibleSpace(title: title, style: style),
      title: const ScrollToTopTitle(child: SizedBox.shrink()),
      titleSpacing: 0,
      floating: true,
      centerTitle: false,
      toolbarHeight: kToolbarHeight,
      actions: actions,
    );
  }
}
