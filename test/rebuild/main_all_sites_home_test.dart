import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart' show SliverReorderableList;
import 'package:mocl_flutter/features/database/domain/entities/favorite_group.dart';
import 'package:mocl_flutter/features/favorite/application/favorite_providers.dart';
import 'package:mocl_flutter/features/main_page/application/main_providers.dart';
import 'package:mocl_flutter/features/main_page/presentation/mocl_main_view.dart';
import 'package:mocl_flutter/features/settings_page/application/settings_providers.dart';
import 'package:mocl_shared/entities/mocl_main_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';

import '../helpers/screen_harness.dart';

/// 설정 "모든 사이트 게시판 모아 보기" 를 켜면 홈이 모든 사이트의 담은 게시판을
/// 사이트 머리글로 묶어 보인다(데이터는 사이트별 보기와 같은 전역 즐겨찾기).
void main() {
  Finder label(String text) => find.text(text, findRichText: true);

  /// 다모앙 2개 + 클리앙 2개(담은 순서와 사이트 순서를 일부러 엇갈리게).
  List<MainItem> mixedItems() => <MainItem>[
    for (int i = 0; i < 2; i++)
      MainItem(
        siteType: SiteType.damoang,
        board: 'damoang$i',
        text: '다모앙 게시판 $i',
        url: 'https://damoang.net/$i',
        orderBy: i,
      ),
    for (int i = 0; i < 2; i++)
      MainItem(
        siteType: SiteType.clien,
        board: 'clien$i',
        text: '클리앙 게시판 $i',
        url: 'https://clien.net/$i',
        orderBy: i,
      ),
  ];

  Future<ProviderContainer> pumpAllSites(WidgetTester tester) async {
    await pumpMainScreen(tester, items: mixedItems());
    final ProviderContainer container = ProviderScope.containerOf(
      tester.element(find.byType(MainView)),
    );
    container.read(homeAllSitesProvider.notifier).toggle();
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('켜면 모든 사이트 게시판이 사이트 머리글 아래 함께 보인다', (tester) async {
    await pumpAllSites(tester);

    expect(label('클리앙 게시판 0'), findsOneWidget);
    expect(label('다모앙 게시판 1'), findsOneWidget);
    // 앱바 제목은 사이트가 아니라 '내 게시판', 사이트 이름은 머리글로.
    expect(label(kAllSitesHomeTitle), findsOneWidget);
    expect(label('클리앙'), findsOneWidget);
    expect(label('다모앙'), findsOneWidget);
  });

  testWidgets('사이트 머리글을 누르면 그 사이트만 접힌다', (tester) async {
    await pumpAllSites(tester);

    await tester.tap(label('클리앙'));
    await tester.pumpAndSettle();

    expect(label('클리앙 게시판 0'), findsNothing);
    expect(label('다모앙 게시판 0'), findsOneWidget);
  });

  testWidgets('편집 중에는 접힌 사이트도 펼쳐 사이트마다 정렬한다', (tester) async {
    final ProviderContainer container = await pumpAllSites(tester);

    await tester.tap(label('클리앙'));
    await tester.pumpAndSettle();
    container.read(mainEditModeProvider.notifier).toggle();
    await tester.pumpAndSettle();

    expect(label('클리앙 게시판 0'), findsOneWidget);
    expect(find.byType(SliverReorderableList), findsNWidgets(2));
  });

  testWidgets('검색은 사이트 이름으로도 찾는다', (tester) async {
    final ProviderContainer container = await pumpAllSites(tester);

    container.read(mainSearchQueryProvider.notifier).update('다모앙');
    await tester.pumpAndSettle();

    expect(label('다모앙 게시판 0'), findsOneWidget);
    expect(label('클리앙 게시판 0'), findsNothing);
  });

  test('사이트는 드로어 순서, 사이트 안은 사용자가 정한 순서', () async {
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        ...await commonOverrides(),
        favoriteRepositoryProvider.overrideWithValue(
          FakeFavoriteRepository(mixedItems()),
        ),
      ],
    );
    addTearDown(container.dispose);

    final List<SiteFavorites> sites = await container.read(
      favoritesBySiteProvider.future,
    );
    // 담은 순서(다모앙 먼저)가 아니라 kAllSitesInOrder(클리앙이 앞)를 따른다.
    expect(sites.map((site) => site.siteType), <SiteType>[
      SiteType.clien,
      SiteType.damoang,
    ]);
    expect(sites.first.items.map((item) => item.text), <String>[
      '클리앙 게시판 0',
      '클리앙 게시판 1',
    ]);
  });
}
