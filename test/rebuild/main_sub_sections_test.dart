import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/core/domain/entities/board_path.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';

import '../helpers/screen_harness.dart';

/// 내 게시판 화면의 카페 소구획과 검색.
///
/// 같은 카페 게시판이 여러 개면 카페명을 행마다 부제로 반복하는 대신 소제목
/// 으로 한 번만 올린다(행이 모두 한 줄로 맞는다). 이름은 PlainText(RichText)로
/// 그려지므로 `findRichText: true` 로 찾는다.
void main() {
  Finder label(String text) => find.text(text, findRichText: true);
  // 앱바 아이콘은 PlainIcon(RichText 에 아이콘 글리프)으로 그려져
  // byIcon 으로는 잡히지 않는다.
  Finder icon(IconData data) =>
      find.text(String.fromCharCode(data.codePoint), findRichText: true);

  /// 카페 하나에 게시판 [count] 개 + 낱개 게시판 2개.
  List<MainItem> cafeItems({int count = 3, String cafe = '삼성스마트폰카페'}) => [
    ...fakeMainItems(count: 2),
    MainItem(
      siteType: SiteType.clien,
      board: cafe,
      text: '전체글',
      url: 'https://example.com/$cafe',
      orderBy: 10,
      parentBoard: cafe,
      parentText: cafe,
    ),
    for (int i = 0; i < count; i++)
      MainItem(
        siteType: SiteType.clien,
        board: joinBoard(cafe, '$i'),
        text: '갤24 메뉴$i',
        url: 'https://example.com/$cafe',
        orderBy: 11 + i,
        parentBoard: cafe,
        parentText: cafe,
      ),
  ];

  testWidgets('같은 카페 게시판은 소제목 아래로 묶이고 카페명은 한 번만 나온다', (tester) async {
    await pumpMainScreen(tester, items: cafeItems());

    // 카페명은 소제목에서 딱 한 번(행마다 반복하지 않는다).
    expect(label('삼성스마트폰카페'), findsOneWidget);
    // 소구획 안의 게시판은 제목만 남는다.
    expect(label('갤24 메뉴0'), findsOneWidget);
    expect(label('갤24 메뉴2'), findsOneWidget);
    // 소구획 개수 배지(전체글 + 메뉴 3개 = 4).
    expect(label('4'), findsOneWidget);
    // 부모가 없는 낱개 게시판은 예전처럼 평평하게 남는다.
    expect(label('게시판 0'), findsOneWidget);
  });

  testWidgets('소제목을 누르면 그 카페만 접히고 낱개 게시판은 남는다', (tester) async {
    await pumpMainScreen(tester, items: cafeItems());

    await tester.tap(label('삼성스마트폰카페'));
    await tester.pumpAndSettle();

    // 카페 하나가 한 줄로 줄어든다.
    expect(label('삼성스마트폰카페'), findsOneWidget);
    expect(label('갤24 메뉴0'), findsNothing);
    expect(label('4'), findsOneWidget);
    // 같은 그룹의 낱개 게시판은 영향을 받지 않는다.
    expect(label('게시판 0'), findsOneWidget);

    await tester.tap(label('삼성스마트폰카페'));
    await tester.pumpAndSettle();
    expect(label('갤24 메뉴0'), findsOneWidget);
  });

  testWidgets('카페 게시판이 혼자면 소제목을 만들지 않고 출처를 배지로 붙인다', (tester) async {
    await pumpMainScreen(tester, items: cafeItems(count: 0));

    // 전체글 1개뿐 → 소구획이 아니다. 제목이 '전체글' 이면 어느 카페인지
    // 알 수 없으므로 카페 이름을 제목으로 쓴다.
    expect(label('전체글'), findsNothing);
    expect(label('삼성스마트폰카페'), findsOneWidget);
  });

  testWidgets('소구획 밖의 하위 게시판은 출처가 오른쪽 배지로 붙는다', (tester) async {
    await pumpMainScreen(
      tester,
      items: [
        ...fakeMainItems(count: 2),
        MainItem(
          siteType: SiteType.clien,
          board: joinBoard('낫싱카페', '7'),
          text: '낫싱폰 잡담',
          url: 'https://example.com/nothing',
          orderBy: 10,
          parentBoard: '낫싱카페',
          parentText: '낫싱카페',
        ),
      ],
    );

    expect(label('낫싱폰 잡담'), findsOneWidget);
    // 배지는 일반 Text 로 그린다(부제가 아니라 행 오른쪽).
    expect(find.text('낫싱카페'), findsOneWidget);
  });

  testWidgets('검색하면 걸린 게시판만 남고 출처가 배지로 보인다', (tester) async {
    await pumpMainScreen(tester, items: cafeItems());

    await tester.tap(icon(Icons.search));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), '메뉴1');
    await tester.pumpAndSettle();

    expect(label('갤24 메뉴1'), findsOneWidget);
    expect(label('갤24 메뉴0'), findsNothing);
    expect(label('게시판 0'), findsNothing);
    // 검색 결과에서는 소구획을 묶지 않으므로 출처를 배지로 밝힌다.
    expect(find.text('삼성스마트폰카페'), findsOneWidget);
  });

  testWidgets('카페 이름으로도 찾을 수 있고, 닫으면 목록이 돌아온다', (tester) async {
    await pumpMainScreen(tester, items: cafeItems());

    await tester.tap(icon(Icons.search));
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), '삼성');
    await tester.pumpAndSettle();

    // 그 카페의 게시판 4개가 모두 걸린다.
    expect(label('갤24 메뉴0'), findsOneWidget);
    expect(label('갤24 메뉴2'), findsOneWidget);
    expect(label('게시판 0'), findsNothing);

    await tester.enterText(find.byType(TextField), '없는이름');
    await tester.pumpAndSettle();
    expect(find.textContaining('맞는 게시판이 없습니다'), findsOneWidget);

    await tester.tap(icon(Icons.close));
    await tester.pumpAndSettle();

    expect(label('클리앙'), findsOneWidget);
    expect(label('게시판 0'), findsOneWidget);
  });
}
