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
/// 그래서 `AppbarDualTextWidget` 은 실제 확장 콘텐츠(작성자 헤더)를 구조가
/// 안정적인 `flexibleSpace` 에 두고, `bottom` 에는 높이 확보용 빈 `PreferredSize`
/// 만 남긴다. 즉 **앱바 숨김/보임에서 churn 이 허용되는 것은 그 빈 sizer 뿐**이다.
void main() {
  const List<String> appBarWidgets = <String>[
    'DetailAppBar',
    'AppbarDualTextWidget',
    '_DualTitle',
    '_DetailPopupMenuButton',
    'AppbarActionsIconTheme',
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
      reason:
          '확장 헤더가 앱바 숨김/보임마다 리빌드/재생성됨 — '
          'bottom 슬롯으로 되돌아갔는지 확인 (AppbarDualTextWidget 주석 참고)',
    );
  });

  testWidgets('확장 헤더는 bottom 이 아니라 flexibleSpace 에 있다', (tester) async {
    await pumpDetailScreen(tester);

    final AppBar appBar = tester.widget<AppBar>(
      find.byType(AppBar, skipOffstage: false),
    );

    // bottom 슬롯에 남은 것은 높이 확보용 빈 PreferredSize 뿐이어야 한다.
    // 헤더가 다시 bottom 으로 들어가면 여기서 잡힌다.
    expect(
      appBar.bottom,
      isA<PreferredSize>(),
      reason: 'DetailHeaderBar 가 AppBar.bottom 에 직접 들어가면 앱바 숨김/보임마다 재생성된다',
    );
    // 실제 헤더는 구조가 안정적인 flexibleSpace(=FlexibleSpaceBarSettings 하위)에 있다.
    expect(
      find.descendant(
        of: find.byType(FlexibleSpaceBarSettings, skipOffstage: false),
        matching: find.byType(DetailHeaderBar, skipOffstage: false),
        skipOffstage: false,
      ),
      findsOneWidget,
      reason: '확장 헤더는 flexibleSpace 에 있어야 한다',
    );
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
