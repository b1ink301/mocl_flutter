import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/presentation/widgets/appbar_actions_icon_theme.dart';
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
    actions: actions == null
        ? null
        : <Widget>[AppbarActionsIconTheme(children: actions!)],
    // bottom 슬롯은 bottomOpacity 가 1.0 ↔ <1.0 을 오갈 때 bare ↔ Opacity 로
    // 트리 구조가 바뀌어(app_bar.dart) 서브트리가 deactivate/activate 되고,
    // Directionality 등 상속 의존성이 있는 하위 위젯(Padding/Row 포함)이
    // 앱바 숨김/보임마다 리빌드된다. 실제 콘텐츠는 구조가 안정적인
    // flexibleSpace 하단에 붙이고, bottom 에는 높이 확보용 sizer 만 둔다.
    // (flexibleSpace 는 매 프레임 동일 인스턴스가 그대로 전달되어 리빌드 없음.
    //  트레이드오프: 확장 영역은 앱바 등장 중 페이드되지 않는데, 액션/제목도
    //  페이드하지 않으므로 오히려 일관적이다.)
    flexibleSpace: bottom == null
        ? null
        : Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SizedBox(height: bottom!.preferredSize.height, child: bottom),
            ],
          ),
    bottom: bottom == null
        ? null
        : PreferredSize(
            preferredSize: bottom!.preferredSize,
            child: const SizedBox.shrink(),
          ),
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
      const SizedBox(height: 2),
      PlainText(smallTitle, style: smallTitleStyle),
      const SizedBox(height: 4),
      PlainText(title, style: titleStyle, maxLines: 3, overflow: .ellipsis),
    ],
  );
}
