import 'dart:async';

import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_text.dart';
import 'package:mocl_flutter/features/issue_radar/application/issue_radar_providers.dart';
import 'package:mocl_flutter/features/main_page/presentation/widgets/main_site_title.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/radar/issue_feed.dart';

import '../helpers/screen_harness.dart';

/// 메인 "지금 이슈" 배치.
///
/// 카드를 켜면 이슈 → 큰 사이트 제목(함께 고정) → 게시판(스크롤), 끄면 기존 큰 제목 앱바.
/// 두 배치는 맨 위에서 제목 자리가 같아야 하고(카드를 닫을 때 제목이 안 움직임),
/// 처음 받는 동안 자리 표시가 칸을 잡아 이슈가 와도 제목이 밀리지 않아야 한다.
void main() {
  IssueFeed feedOf(int count) => IssueFeed(
    generatedAt: 0,
    communities: const [SiteType.clien],
    issues: [
      for (int i = 0; i < count; i++)
        Issue(
          id: 'i$i',
          title: '이슈 제목 $i',
          sites: const [SiteType.clien, SiteType.damoang],
          firstSeenAt: 0,
          lastSeenAt: 0,
          score: 1,
          posts: const [],
        ),
    ],
  );

  List<Override> issueFirst(Future<IssueFeed> feed) => <Override>[
    issueRadarAvailableProvider.overrideWithValue(true),
    visibleIssueFeedProvider.overrideWith((ref) => feed),
  ];

  /// 큰 사이트 제목(어느 배치든 화면에 하나뿐인 24pt 제목)의 글자 위치.
  Finder bodyTitle() => find.descendant(
    of: find.byType(MainSiteTitle),
    matching: find.byType(PlainText),
  );

  // PlainText 는 Text 가 아니라서 find.text 로는 안 잡힌다.
  Finder toolbarTitle(String text) => find.descendant(
    of: find.byType(AppBar),
    matching: find.byWidgetPredicate((w) => w is PlainText && w.text == text),
  );

  testWidgets('카드를 켜면 이슈가 사이트 제목 위에 오고, 툴바 제목은 비어 있다', (tester) async {
    await pumpMainScreen(
      tester,
      overrides: issueFirst(Future.value(feedOf(3))),
    );

    expect(find.byType(FlexibleSpaceBar), findsNothing);
    expect(find.text('이슈 제목 0'), findsOneWidget);
    expect(bodyTitle(), findsOneWidget);

    final String title = (tester.widget<PlainText>(bodyTitle())).text;
    expect(
      tester.getTopLeft(find.text('이슈 제목 2')).dy,
      lessThan(tester.getTopLeft(bodyTitle()).dy),
    );
    expect(toolbarTitle(title), findsNothing);
  });

  testWidgets('스크롤해도 툴바 · 이슈 · 사이트 제목은 고정되고 게시판만 움직인다', (tester) async {
    await pumpMainScreen(
      tester,
      overrides: issueFirst(Future.value(feedOf(3))),
    );
    final Finder firstBoard = find.byType(ListTile).first;
    final double issueY = tester.getTopLeft(find.text('이슈 제목 0')).dy;
    final double titleY = tester.getTopLeft(bodyTitle()).dy;
    final double boardY = tester.getTopLeft(firstBoard).dy;
    final double toolbarY = tester.getTopLeft(find.byType(AppBar)).dy;

    double headerElevation() => tester
        .widget<Material>(
          find.ancestor(of: bodyTitle(), matching: find.byType(Material)).first,
        )
        .elevation;
    expect(headerElevation(), 0);

    await tester.drag(find.byType(Scrollable).first, const Offset(0, -300));
    await tester.pumpAndSettle();

    expect(tester.getTopLeft(find.byType(AppBar)).dy, toolbarY);
    expect(tester.getTopLeft(find.text('이슈 제목 0')).dy, issueY);
    expect(tester.getTopLeft(bodyTitle()).dy, titleY);
    expect(tester.getTopLeft(find.byType(ListTile).first).dy, lessThan(boardY));
    // 목록이 머리 밑으로 지나가면 경계 그림자가 생긴다.
    expect(headerElevation(), greaterThan(0));
  });

  testWidgets('처음 받는 동안 자리 표시가 칸을 잡아, 이슈가 와도 제목이 밀리지 않는다', (tester) async {
    final Completer<IssueFeed> pending = Completer<IssueFeed>();
    await pumpMainScreen(
      tester,
      overrides: issueFirst(pending.future),
      settle: false,
    );

    // 앞 테스트에서 카드가 놓였으면 펼치며 나타나므로 애니메이션이 끝나길 기다린다.
    await tester.pump(const Duration(milliseconds: 500));
    expect(
      find.byWidgetPredicate(
        (w) => w is Semantics && w.properties.label == '지금 이슈 불러오는 중',
      ),
      findsOneWidget,
    );
    expect(find.text('지금 이슈'), findsOneWidget);
    final double before = tester.getTopLeft(bodyTitle()).dy;

    pending.complete(feedOf(3));
    await tester.pumpAndSettle();

    expect(find.text('이슈 제목 0'), findsOneWidget);
    expect(tester.getTopLeft(bodyTitle()).dy, closeTo(before, 1));
  });

  testWidgets('카드가 접힌 이슈 먼저 배치와 기존 배치의 제목 자리가 같다', (tester) async {
    // 기존 배치(서버 없는 빌드).
    await pumpMainScreen(tester);
    final Finder classic = find.descendant(
      of: find.byType(FlexibleSpaceBar),
      matching: find.byType(PlainText),
    );
    final Offset classicAt = tester.getTopLeft(classic);
    final String title = tester.widget<PlainText>(classic).text;

    // 이슈 먼저 배치, 이슈 없음 → 카드 접힘. 덮어쓰기가 달라 ProviderScope 를 새로 만든다.
    await tester.pumpWidget(const SizedBox());
    await pumpMainScreen(
      tester,
      overrides: issueFirst(Future.value(feedOf(0))),
    );
    expect(find.byType(FlexibleSpaceBar), findsNothing);
    expect(tester.widget<PlainText>(bodyTitle()).text, title);
    final Offset issueFirstAt = tester.getTopLeft(bodyTitle());
    expect(issueFirstAt.dx, closeTo(classicAt.dx, 0.5));
    expect(issueFirstAt.dy, closeTo(classicAt.dy, 0.5));
  });

  testWidgets('닫기는 카드가 다 접힌 뒤 기존 큰 제목 앱바로 바꾼다', (tester) async {
    await pumpMainScreen(
      tester,
      overrides: issueFirst(Future.value(feedOf(3))),
    );

    await tester.tap(find.byTooltip('지금 이슈 카드 닫기'));
    await tester.pump(const Duration(milliseconds: 100));
    // 접히는 중에는 아직 이슈 먼저 배치.
    expect(find.byType(MainSiteTitle), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.byType(MainSiteTitle), findsNothing);
    expect(find.byType(FlexibleSpaceBar), findsOneWidget);
    expect(find.text('되돌리기'), findsOneWidget);
  });
}
