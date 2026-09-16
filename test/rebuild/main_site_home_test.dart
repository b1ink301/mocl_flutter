import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';
import 'package:mocl_flutter/features/favorite/application/favorite_providers.dart';
import 'package:mocl_flutter/features/main_page/presentation/mocl_main_view.dart';

import '../helpers/screen_harness.dart';

/// 홈은 '지금 고른 사이트'의 담은 게시판만 보여준다.
///
/// 사이트를 가리지 않고 그룹으로 펼치던 화면에서 사이트 중심으로 되돌아온
/// 구조라, 사이트 필터와 사이트 안 정렬이 이 화면의 뼈대다.
/// 게시판 이름은 PlainText(RichText 기반)로 그려지므로 `findRichText: true`.
void main() {
  Finder label(String text) => find.text(text, findRichText: true);

  /// 클리앙 2개 + 다모앙 2개.
  List<MainItem> mixedItems() => <MainItem>[
    for (int i = 0; i < 2; i++)
      MainItem(
        siteType: SiteType.clien,
        board: 'clien$i',
        text: '클리앙 게시판 $i',
        url: 'https://clien.net/$i',
        orderBy: i,
      ),
    for (int i = 0; i < 2; i++)
      MainItem(
        siteType: SiteType.damoang,
        board: 'damoang$i',
        text: '다모앙 게시판 $i',
        url: 'https://damoang.net/$i',
        orderBy: i,
      ),
  ];

  testWidgets('다른 사이트 게시판은 홈에 섞이지 않는다', (tester) async {
    await pumpMainScreen(tester, items: mixedItems());

    expect(label('클리앙 게시판 0'), findsOneWidget);
    expect(label('클리앙 게시판 1'), findsOneWidget);
    expect(label('다모앙 게시판 0'), findsNothing);
    // 앱바 제목이 곧 지금 보고 있는 사이트다.
    expect(label('클리앙'), findsOneWidget);
  });

  testWidgets('사이트를 바꾸면 그 사이트의 목록으로 갈아탄다', (tester) async {
    await pumpMainScreen(tester, items: mixedItems());

    final ProviderContainer container = ProviderScope.containerOf(
      tester.element(find.byType(MainView)),
    );
    container
        .read(currentSiteTypeProvider.notifier)
        .changeSiteType(SiteType.damoang);
    await tester.pumpAndSettle();

    expect(label('다모앙 게시판 0'), findsOneWidget);
    expect(label('클리앙 게시판 0'), findsNothing);
    expect(label('다모앙'), findsOneWidget);
  });

  testWidgets('담은 게시판이 없는 사이트는 안내와 함께 비어 있다', (tester) async {
    await pumpMainScreen(tester, items: fakeMainItems(count: 2));

    final ProviderContainer container = ProviderScope.containerOf(
      tester.element(find.byType(MainView)),
    );
    container
        .read(currentSiteTypeProvider.notifier)
        .changeSiteType(SiteType.theqoo);
    await tester.pumpAndSettle();

    expect(find.textContaining('담은 게시판이 없습니다'), findsOneWidget);
    expect(label('게시판 0'), findsNothing);
  });

  test('사이트 안에서 순서를 바꾸면 orderBy 가 0..n 으로 다시 매겨진다', () async {
    final FakeFavoriteRepository repo = FakeFavoriteRepository(
      fakeMainItems(count: 3),
    );
    final ProviderContainer container = ProviderContainer(
      overrides: <Override>[
        ...await commonOverrides(),
        favoriteRepositoryProvider.overrideWithValue(repo),
      ],
    );
    addTearDown(container.dispose);

    final List<FavoriteData> items = await container.read(
      siteFavoritesProvider.future,
    );
    expect(items.map((item) => item.text), <String>['게시판 0', '게시판 1', '게시판 2']);

    // 마지막 게시판을 맨 위로.
    await container.read(favoritesProvider.notifier).reorderInSite(items, 2, 0);

    final List<FavoriteData> reordered = await container.read(
      siteFavoritesProvider.future,
    );
    expect(reordered.map((item) => item.text), <String>[
      '게시판 2',
      '게시판 0',
      '게시판 1',
    ]);
    // 저장된 순서가 곧 표시 순서다(0..n 으로 촘촘히).
    expect(reordered.map((item) => item.orderBy), <int>[0, 1, 2]);
  });
}
