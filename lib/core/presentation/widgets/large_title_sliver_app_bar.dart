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
///
/// [search] 를 주면 게시판 탭처럼 앱바에서 검색한다: 평소엔 검색 버튼이 [actions] 앞에
/// 붙고, 연 동안은 툴바 제목 자리가 입력창이 되고 오른쪽엔 닫기만 남는다.
class const LargeTitleSliverAppBar({
  super.key,
  required final String title,
  final List<Widget>? actions,
  final AppBarSearch? search,
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
      title: switch (search) {
        AppBarSearch(open: true, :final Widget field) => Padding(
          padding: const EdgeInsetsDirectional.only(
            start: kLargeTitleStartInset,
          ),
          child: field,
        ),
        _ => const ScrollToTopTitle(child: SizedBox.shrink()),
      },
      titleSpacing: 0,
      floating: true,
      centerTitle: false,
      toolbarHeight: kToolbarHeight,
      actions: switch (search) {
        null => actions,
        AppBarSearch(open: true, :final Widget toggle) => [toggle],
        AppBarSearch(:final Widget toggle) => [toggle, ...?actions],
      },
    );
  }
}

/// [LargeTitleSliverAppBar] 의 앱바 검색. [field] 는 연 동안 툴바 제목 자리에,
/// [toggle] 은 연 동안 닫기 · 닫힌 동안 검색 버튼으로 오른쪽에 둔다.
class const AppBarSearch({
  required final bool open,
  required final Widget field,
  required final Widget toggle,
});
