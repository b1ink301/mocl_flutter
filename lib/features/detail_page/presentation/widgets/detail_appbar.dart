import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/large_title_metrics.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/presentation/widgets/adaptive_popup_menu.dart';
import 'package:mocl_flutter/core/presentation/widgets/appbar_actions_icon_theme.dart';
import 'package:mocl_flutter/core/presentation/widgets/category_tag.dart';
import 'package:mocl_flutter/core/presentation/widgets/large_title_flexible_space.dart';
import 'package:mocl_flutter/core/presentation/widgets/list_detail_layout.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_icon_button.dart';
import 'package:mocl_flutter/core/presentation/widgets/scroll_to_top_title.dart';

import '../../../../core/presentation/widgets/plain_icon.dart';
import '../../../../core/presentation/widgets/plain_text.dart';
import '../state/detail_event_mixin.dart';
import '../state/detail_state_mixin.dart';
import 'bookmark_icon_button.dart';
import 'translate_icon_button.dart';
import 'detail_scope.dart';

/// 상세 화면 앱바.
///
/// 메인/리스트와 같은 규칙: 툴바에는 작은 크럼브만 두고, 확장 영역에는
/// 오로지 큰 제목만 둔다. 위로 스크롤하면 큰 제목이 서서히 사라진다.
/// 작성자 헤더는 앱바가 아니라 본문 맨 위에 있다(DetailView). 본문 중간에도
/// 필요한 북마크는 액션에 두고, 헤더는 툴바를 탭해 맨 위로 올려 본다.
class const DetailAppBar({super.key})
    extends ConsumerWidget
    with DetailState, DetailEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 제목 줄 수는 화면 폭이 아니라 상세 화면이 받은 폭으로 잰다(목록 옆 상세 칸,
    // 폴드 접기/펼치기).
    final double width = DetailWidthScope.of(context);
    final bool inPane = ListDetailPane.isPane(context);
    // 말머리는 작성자 헤더의 태그로 보여주므로 제목 앞 "[말머리]" 는 뗀다.
    final String title = stripCategoryPrefix(
      titleState(ref),
      categoryState(ref),
    );
    // 제목 줄 수에 따라 확장 높이가 달라진다(최대 3줄).
    final double height = appbarHeight(ref, title, width);

    final styleScope = DetailStyleScope.of(context).$1;
    final titleStyle = largeTitleStyle(styleScope.titleTextStyle);
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final crumbStyle = appbarCrumbStyle(styleScope.smallTextStyle);

    return SliverAppBar(
      // 목록 옆 칸의 상세는 라우트가 아니라 닫을 것이 없다.
      // scrolledUnderElevation: 1,
      expandedHeight: height,
      automaticallyImplyLeading: !inPane,
      // 툴바에는 상위 경로만(= 사이트 › 게시판). 큰 제목은 글 제목을 쓴다.
      title: ScrollToTopTitle(
        child: PlainText(
          smallTitleState(ref),
          style: crumbStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      // 뒤로가기 버튼이 없으면 크럼브를 큰 제목과 같은 선에서 시작한다.
      titleSpacing: inPane
          ? kLargeTitlePadding.start
          : kAppbarCrumbTitleSpacing,
      flexibleSpace: LargeTitleFlexibleSpace(
        title: title,
        style: titleStyle,
        maxLines: kDetailTitleMaxLines,
      ),
      floating: true,
      pinned: false,
      centerTitle: false,
      actions: [
        AppbarActionsIconTheme(
          children: [
            const TranslateIconButton(),
            const BookmarkIconButton(),
            _DetailPopupMenuButton(
              focusColor: primaryColor,
              onRefresh: () => handleRefresh(ref),
              onOpenBrowser: () => handleOpenBrowser(ref),
              onShareUrl: () => handleShareUrl(ref),
              onIncreaseFontSize: () => adjustFontSize(ref, 1),
              onDecreaseFontSize: () => adjustFontSize(ref, -1),
              onResetFontSize: () => resetFontSize(ref),
            ),
          ],
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
            semanticLabel: '글자 작게',
            icon: PlainIcon(Icons.exposure_minus_1, color: focusColor),
            onPressed: onDecrease,
          ),
          PlainText(_label(delta), style: textStyle),
          PlainIconButton(
            semanticLabel: '글자 크게',
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
