import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';

import 'appbar_actions_icon_theme.dart';
import 'plain_icon.dart';
import 'plain_icon_button.dart';

/// 앱바 leading 용 뒤로가기 버튼.
///
/// AppBar 는 leading 을 폭 56 으로 tight 하게 묶고, IconButton 이 아닌 위젯은
/// Center 로 감싸주지 않는다(app_bar.dart). 그대로 두면 패딩 8 만큼 왼쪽에 붙어
/// 타이틀 · 액션과 광학 중심이 어긋나므로 직접 가운데로 둔다.
class const AppbarBackButton({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => AppbarFixedIconTheme(
    child: Center(
      child: PlainIconButton(
        onPressed: () => context.pop(),
        padding: EdgeInsets.zero,
        icon: const PlainIcon(Icons.arrow_back_rounded),
      ),
    ),
  );
}
