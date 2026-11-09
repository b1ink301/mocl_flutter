import 'package:mocl_flutter/core/presentation/widgets/large_title_sliver_app_bar.dart';
import 'package:mocl_flutter/core/presentation/widgets/window_size.dart';
import 'package:material_ui/material_ui.dart';

import 'settings_view.dart';

/// 설정. 홈의 "설정" 탭 본문이다(게시판 탭과 같은 큰 제목 앱바).
///
/// 세부 화면(차단 · 키워드 알림 · 오픈소스 등)은 여기서 위로 밀어 올린다.
/// 아래 여백은 [SettingsView] 가 `MediaQuery.padding.bottom` 으로 잡는다
/// (홈 Scaffold 가 떠 있는 탭바 높이를 더해 준다).
class const SettingsPage({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => const CustomScrollView(
    slivers: <Widget>[
      LargeTitleSliverAppBar(title: '설정'),
      SliverReadableWidth(sliver: SettingsView()),
    ],
  );
}
