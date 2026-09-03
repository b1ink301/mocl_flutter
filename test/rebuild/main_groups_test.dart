import 'package:flutter_test/flutter_test.dart';

import '../helpers/screen_harness.dart';

/// 메인 화면 그룹 접기/펼치기.
/// 헤더를 누르면 그룹이 접히고, 접힘 상태는 저장소에 반영된다(앱 재시작 후에도 유지).
///
/// 그룹 이름·게시판 이름은 PlainText(RichText 기반)로 그려지므로
/// 찾을 때 `findRichText: true` 가 필요하다.
void main() {
  Finder label(String text) => find.text(text, findRichText: true);

  testWidgets('그룹 헤더를 누르면 접히고 다시 누르면 펼쳐진다', (tester) async {
    await pumpMainScreen(tester);

    // 처음엔 펼쳐진 상태 — 게시판이 보인다.
    expect(label('게시판 0'), findsOneWidget);

    await tester.tap(label('클리앙'));
    await tester.pumpAndSettle();

    // 접히면 헤더만 남고 게시판은 사라진다.
    expect(label('클리앙'), findsOneWidget);
    expect(label('게시판 0'), findsNothing);

    await tester.tap(label('클리앙'));
    await tester.pumpAndSettle();

    expect(label('게시판 0'), findsOneWidget);
  });

  testWidgets('접어도 그룹의 게시판 개수는 헤더에 남는다', (tester) async {
    await pumpMainScreen(tester, items: fakeMainItems(count: 7));

    expect(label('7'), findsOneWidget);

    await tester.tap(label('클리앙'));
    await tester.pumpAndSettle();

    // 안이 안 보이므로 개수는 접힌 뒤에도 계속 보여야 한다.
    expect(label('7'), findsOneWidget);
    expect(label('게시판 0'), findsNothing);
  });
}
