import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';
import 'package:mocl_flutter/features/list_page/application/list_providers.dart';
import 'package:mocl_flutter/features/list_page/presentation/mocl_list_view.dart';
import 'package:mocl_flutter/features/list_page/presentation/widgets/mocl_list_item.dart';

import '../helpers/rebuild_recorder.dart';
import '../helpers/screen_harness.dart';

/// 리스트 화면 리빌드 계측.
///
/// 이 화면의 성능 설계는 두 축이다.
/// 1. 앱바: `AppbarDualTextWidget` + const actions 로 floating opacity 전파를 차단
/// 2. 행: `ListItemScope`(InheritedWidget)로 item 을 전달해 `MoclListItem` 을
///    const 로 유지 → 변경된 행만 리빌드
void main() {
  const List<String> appBarWidgets = <String>[
    'ListAppBar',
    'AppbarDualTextWidget',
    '_DualTitle',
    '_SearchButton',
    '_SortButton',
    '_MoreButton',
    'AppbarActionsIconTheme',
  ];

  const List<String> rowWidgets = <String>[
    'MoclListItem',
    'AuthorInfoText',
    'PlainText',
    'RoundTextWidget',
  ];

  testWidgets('앱바 숨김/보임 반복 시 앱바·행 위젯이 리빌드되지 않는다', (tester) async {
    await pumpListScreen(tester);
    expect(find.byType(MoclListItem), findsWidgets, reason: '행이 렌더되어야 한다');

    final Finder scrollable = find.byType(Scrollable).first;
    await scrollBy(tester, -600, scrollable: scrollable);

    final RebuildRecorder rec = RebuildRecorder.attach();
    await scrollCycles(tester, times: 3, distance: 300, scrollable: scrollable);

    rec.expectNoRebuild(appBarWidgets, reason: '스크롤로 앱바 위젯이 리빌드됨');
    rec.expectNoRebuild(
      rowWidgets,
      allowMounts: true,
      reason: '스크롤로 리스트 행이 리빌드됨 (ListItemScope 경계가 깨졌을 수 있다)',
    );
  });

  testWidgets('한 행을 읽음 처리하면 그 행만 리빌드된다', (tester) async {
    final items = fakeListItems(count: 30);
    await pumpListScreen(tester, items: items);

    final ProviderContainer container = ProviderScope.containerOf(
      tester.element(find.byType(MoclListView)),
    );

    final int visibleRows = tester.widgetList(find.byType(MoclListItem)).length;
    expect(visibleRows, greaterThan(1));

    final RebuildRecorder rec = RebuildRecorder.attach();
    // 첫 행을 읽음 처리 → ListItemScope.updateShouldNotify 로 해당 행만 통지된다.
    container
        .read(listPagingControllerProvider.notifier)
        .markAsReadById(items.first.id);
    await tester.pumpAndSettle();

    expect(
      rec.builds('MoclListItem'),
      1,
      reason:
          '읽음 처리된 행 1개만 리빌드되어야 한다 (실제: ${rec.builds('MoclListItem')})\n'
          '${rec.report()}',
    );
  });

  testWidgets('정렬 변경은 앱바를 리빌드하지 않는다', (tester) async {
    await pumpListScreen(tester);

    final ProviderContainer container = ProviderScope.containerOf(
      tester.element(find.byType(MoclListView)),
    );

    final RebuildRecorder rec = RebuildRecorder.attach();
    container
        .read(sortTypeProvider.notifier)
        .changeSortType(SortType.recommend);
    await tester.pumpAndSettle();

    // `_SortButton` 도 리빌드되지 않는다. sortType 을 watch 하는 지점이
    // `PlainPopupMenuButton.itemBuilder` 안(CheckedPopupMenuItem.checked)이라,
    // 팝업이 닫혀 있는 동안에는 구독이 등록되지 않기 때문이다. 체크 표시는
    // 메뉴를 열 때 itemBuilder 가 다시 돌면서 최신 값으로 그려진다.
    rec.expectNoRebuild(const <String>[
      'ListAppBar',
      '_DualTitle',
      '_SearchButton',
      '_SortButton',
      '_MoreButton',
    ], reason: '정렬 변경이 앱바를 리빌드시킴');
  });

  testWidgets('폰트 크기 변경은 행을 리빌드한다 (계측 sanity check)', (tester) async {
    await pumpListScreen(tester);

    final ProviderContainer container = ProviderScope.containerOf(
      tester.element(find.byType(MoclListView)),
    );

    final RebuildRecorder rec = RebuildRecorder.attach();
    container.read(fontSizeDeltaProvider.notifier).update(1);
    await tester.pumpAndSettle();

    rec.expectRebuild('MoclListItem');
  });
}
