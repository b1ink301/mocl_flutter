import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/features/main_page/presentation/mocl_main_view.dart';

import '../helpers/rebuild_recorder.dart';
import '../helpers/screen_harness.dart';

/// 메인 화면(게시판 목록) 리빌드 계측.
///
/// floating 앱바가 스크롤로 숨겨졌다 나타날 때 `toolbarOpacity` 가 매 프레임
/// 바뀌면서 SliverAppBar 내부는 계속 리빌드된다. 앱은 `AppbarActionsIconTheme`
/// 와 const 위젯으로 그 전파를 끊어놨는데, 이 테스트가 그 경계를 지킨다.
void main() {
  /// 스크롤만으로는 절대 리빌드되면 안 되는 위젯들.
  const List<String> appBarWidgets = <String>[
    '_MainAppBar',
    'AppbarActionsIconTheme',
    'PlainIconButton',
    'AdaptivePopupMenu',
  ];

  /// 본문(목록) 쪽. 화면에 새로 들어오는 행의 mount 는 정상이므로 rebuild 만 본다.
  const List<String> bodyWidgets = <String>[
    '_MainBody',
    '_BodyList',
    'ListTile',
    'PlainText',
    'PlainDividerWidget',
  ];

  testWidgets('앱바 숨김/보임 반복 시 앱바·목록 위젯이 리빌드되지 않는다', (tester) async {
    await pumpMainScreen(tester);

    final Finder scrollable = find.byType(Scrollable).first;
    // 최상단에서는 아래로 당길 때 RefreshIndicator 가 발동하므로, 오버스크롤
    // 없이 앱바 숨김/보임만 왕복할 수 있는 중간 지점으로 먼저 이동한다.
    await scrollBy(tester, -600, scrollable: scrollable);

    final RebuildRecorder rec = RebuildRecorder.attach();
    await scrollCycles(tester, times: 3, distance: 300, scrollable: scrollable);

    rec.expectNoRebuild(appBarWidgets, reason: '스크롤로 앱바 위젯이 리빌드됨');
    rec.expectNoRebuild(
      bodyWidgets,
      allowMounts: true,
      reason: '스크롤로 목록 위젯이 리빌드됨',
    );
  });

  testWidgets('폰트 크기 변경은 목록을 리빌드한다 (계측 sanity check)', (tester) async {
    await pumpMainScreen(tester);

    final ProviderContainer container = ProviderScope.containerOf(
      tester.element(find.byType(MainView)),
    );

    final RebuildRecorder rec = RebuildRecorder.attach();
    container.read(fontSizeDeltaProvider.notifier).update(1);
    await tester.pumpAndSettle();

    // 스타일이 바뀌면 목록은 반드시 다시 그려져야 한다.
    // (이게 0이면 계측 훅이 동작하지 않는다는 뜻이다)
    rec.expectRebuild('_BodyList');
  });
}
