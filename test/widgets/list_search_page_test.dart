import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/mocl_theme.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/html_parser/application/datasource_provider.dart';
import 'package:mocl_flutter/features/database/domain/entities/mute_rule.dart';
import 'package:mocl_flutter/features/list_page/application/use_case_provider.dart';
import 'package:mocl_flutter/features/list_page/domain/repositories/list_repository.dart';
import 'package:mocl_flutter/features/list_page/domain/usecases/get_search_list.dart';
import 'package:mocl_flutter/features/list_page/presentation/list_search_page.dart';
import 'package:mocl_flutter/features/list_page/presentation/widgets/mocl_list_item.dart';
import 'package:mocl_flutter/features/mute/application/mute_providers.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_api.dart';
import 'package:mocl_shared/entities/last_id.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_main_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/entities/sort_type.dart';
import 'package:mocl_shared/parser/clien/clien_parser.dart';

import '../helpers/screen_harness.dart';

/// 게시판 글 검색 화면: 검색 전 안내 → 제출 → 결과(목록과 같은 행) · 실패 모양.
void main() {
  final MainItem board = fakeMainItems(count: 1).first;

  Future<_FakeSearchRepository> pump(
    WidgetTester tester, {
    Either<Failure, List<ListItem>>? result,
  }) async {
    useFixedSurface(tester);
    final _FakeSearchRepository repo = _FakeSearchRepository(
      result ?? Right(fakeListItems(count: 5)),
    );
    final GoRouter router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => ListSearchPage.init(board)),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          ...await commonOverrides(siteType: SiteType.clien),
          getSearchListUseCaseProvider.overrideWithValue(
            GetSearchList(listRepository: repo),
          ),
          muteRulesProvider.overrideWith(_NoMutes.new),
          currentParserProvider.overrideWith(
            (Ref ref, SiteType siteType) =>
                (const ClienParser(false), _FakeApi()),
          ),
        ],
        child: MaterialApp.router(
          theme: MoclTheme.lightTheme,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();
    return repo;
  }

  Future<void> search(WidgetTester tester, String keyword) async {
    await tester.enterText(find.byType(TextField), keyword);
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await tester.pumpAndSettle();
  }

  testWidgets('검색 전에는 안내만 보이고 사이트에 요청하지 않는다', (tester) async {
    final repo = await pump(tester);
    expect(find.text('${board.text}에서 검색', findRichText: true), findsWidgets);
    await tester.enterText(find.byType(TextField), '리스트');
    await tester.pumpAndSettle();
    expect(repo.calls, isEmpty, reason: '글자를 칠 때마다 요청하지 않는다');
  });

  testWidgets('제출하면 결과를 목록과 같은 행으로 그리고 첫 쪽은 사이트 규칙을 따른다', (tester) async {
    final repo = await pump(tester);
    await search(tester, ' 항목 ');

    expect(find.byType(MoclListItem), findsWidgets);
    expect(repo.calls.first.keyword, '항목');
    expect(repo.calls.first.page, 0, reason: '클리앙 검색은 0쪽부터');

    // 제목의 검색어는 굵게 강조한다.
    final bool highlighted = tester
        .widgetList<RichText>(find.byType(RichText))
        .any((r) {
          bool hit = false;
          r.text.visitChildren((span) {
            if (span is TextSpan &&
                span.text == '항목' &&
                span.style?.fontWeight == FontWeight.w700) {
              hit = true;
            }
            return !hit;
          });
          return hit;
        });
    expect(highlighted, isTrue);

    // 검색어를 지우면 최근 검색어가 보인다.
    await tester.tap(find.bySemanticsLabel('검색어 지우기'));
    await tester.pumpAndSettle();
    expect(find.text('최근 검색어', findRichText: true), findsOneWidget);
    expect(find.text('항목', findRichText: true), findsOneWidget);
  });

  testWidgets('결과가 없으면 검색어와 함께 알린다', (tester) async {
    await pump(tester, result: const Right(<ListItem>[]));
    await search(tester, '없는말');
    expect(find.text("'없는말' 검색 결과가 없어요", findRichText: true), findsOneWidget);
  });

  testWidgets('로그인해야 검색되는 사이트는 로그인 버튼을 준다', (tester) async {
    await pump(
      tester,
      result: const Left(NotLoginFailure(message: '로그인해야 검색할 수 있어요.')),
    );
    await search(tester, '아이폰');
    expect(find.text('로그인이 필요해요', findRichText: true), findsOneWidget);
    expect(find.text('로그인', findRichText: true), findsOneWidget);
  });
}

class _FakeSearchRepository(final Either<Failure, List<ListItem>> _result)
    implements ListRepository {
  final List<({int page, String keyword})> calls = [];

  @override
  Future<Either<Failure, List<ListItem>>> getSearchList({
    required MainItem item,
    required int page,
    required LastId lastId,
    required SortType sortType,
    required String keyword,
  }) async {
    calls.add((page: page, keyword: keyword));
    // 두 번째 쪽부터는 같은 글을 다시 준다(끝을 넘긴 사이트처럼) → 중복이라 끝.
    return _result;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeApi() implements BaseApi {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _NoMutes() extends MuteRulesNotifier {
  @override
  Future<List<MuteRule>> build() async => const [];
}
