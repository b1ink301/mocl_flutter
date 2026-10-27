import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/features/detail_page/presentation/mocl_detail_page.dart';
import 'package:mocl_flutter/features/detail_page/presentation/widgets/detail_header_bar.dart';

import '../helpers/rebuild_recorder.dart';
import '../helpers/screen_harness.dart';

/// 상세 화면 리빌드 계측.
///
/// 배경: `AppBar` 는 `bottom` 슬롯을 `bottomOpacity == 1.0` 여부에 따라
/// bare ↔ `Opacity(child: bottom)` 로 감싼다(app_bar.dart). floating 앱바가
/// 숨겨졌다 나타나면 같은 슬롯의 위젯 타입이 바뀌면서 서브트리가
/// unmount → re-inflate 되고, 그 안의 위젯이 앱바 숨김/보임마다 재생성된다.
///
/// 지금 상세 앱바는 확장 영역에 **제목만** 둔다. 작성자 헤더는 앱바를 떠나
/// 본문 맨 위 sliver 로 내려갔으므로 `bottom` 슬롯은 아예 비어 있다.
/// 이 테스트는 헤더가 다시 앱바로 올라가는 회귀를 막는다.
void main() {
  const List<String> appBarWidgets = <String>[
    'DetailAppBar',
    'LargeTitleFlexibleSpace',
    'AppbarBackButton',
    '_DetailPopupMenuButton',
    'AppbarActionsIconTheme',
    // 색을 IconTheme 에서 받는 아이콘들. floating 앱바가 toolbarOpacity 를
    // IconThemeData 에 실어 보내므로, 고정 IconTheme 이 빠지면 스크롤하는
    // 내내 여기서 잡힌다(AppbarFixedIconTheme 주석 참고).
    'PlainIcon',
  ];

  const List<String> headerWidgets = <String>[
    'DetailHeaderBar',
    'BookmarkIconButton',
    'AuthorInfoText',
  ];

  testWidgets('앱바 숨김/보임 반복에도 앱바·작성자 헤더가 리빌드/재생성되지 않는다', (tester) async {
    await pumpDetailScreen(tester);
    expect(find.byType(DetailHeaderBar), findsOneWidget);

    final Finder scrollable = find.byType(Scrollable).first;
    await scrollBy(tester, -400, scrollable: scrollable);

    final RebuildRecorder rec = RebuildRecorder.attach();
    await scrollCycles(tester, times: 3, distance: 200, scrollable: scrollable);

    rec.expectNoRebuild(appBarWidgets, reason: '스크롤로 앱바 위젯이 리빌드됨');
    rec.expectNoRebuild(
      headerWidgets,
      reason: '작성자 헤더가 앱바 숨김/보임마다 리빌드/재생성됨 — 앱바로 되돌아갔는지 확인',
    );
  });

  testWidgets('작성자 헤더는 앱바가 아니라 본문에 있다', (tester) async {
    await pumpDetailScreen(tester);

    final AppBar appBar = tester.widget<AppBar>(
      find.byType(AppBar, skipOffstage: false),
    );

    // 확장 영역은 제목 전용이다. 헤더가 bottom 으로 돌아가면 앱바 숨김/보임마다
    // 서브트리가 재생성된다.
    expect(
      appBar.bottom,
      isNull,
      reason: 'DetailHeaderBar 가 AppBar.bottom 에 들어가면 앱바 숨김/보임마다 재생성된다',
    );
    expect(
      find.descendant(
        of: find.byType(FlexibleSpaceBarSettings, skipOffstage: false),
        matching: find.byType(DetailHeaderBar, skipOffstage: false),
        skipOffstage: false,
      ),
      findsNothing,
      reason: '작성자 헤더는 앱바 확장 영역이 아니라 본문 맨 위에 있어야 한다',
    );
    expect(find.byType(DetailHeaderBar, skipOffstage: false), findsOneWidget);
  });

  testWidgets('본문/댓글은 앱바 숨김/보임에 영향받지 않는다', (tester) async {
    await pumpDetailScreen(tester);

    final Finder scrollable = find.byType(Scrollable).first;
    await scrollBy(tester, -400, scrollable: scrollable);

    final RebuildRecorder rec = RebuildRecorder.attach();
    await scrollCycles(tester, times: 3, distance: 200, scrollable: scrollable);

    rec.expectNoRebuild(
      const <String>['_DetailView', '_Body', '_CommentList', '_CommentItem'],
      allowMounts: true,
      reason: '스크롤로 본문/댓글이 리빌드됨',
    );
  });

  testWidgets('폰트 크기 변경은 헤더와 본문을 리빌드한다 (계측 sanity check)', (tester) async {
    await pumpDetailScreen(tester);

    final ProviderContainer container = ProviderScope.containerOf(
      tester.element(find.byType(DetailPage)),
    );

    final RebuildRecorder rec = RebuildRecorder.attach();
    container.read(fontSizeDeltaProvider.notifier).update(1);
    await tester.pumpAndSettle();

    // 폰트가 커지면 DetailHeaderBar.preferredSize 도 커져야 하므로 반드시 재빌드된다.
    rec.expectRebuild('DetailHeaderBar');
    rec.expectRebuild('_DetailView');
  });
}
