import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// `Override` 타입은 misc.dart 에서 노출된다(앱의 *_event_mixin 과 동일한 경로).
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/config/mocl_theme.dart';
import 'package:mocl_flutter/core/domain/entities/board_path.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/add_main_dialog/presentation/add_list_modal_sheet_page.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_group.dart';
import 'package:mocl_flutter/features/favorite/application/favorite_providers.dart';
import 'package:mocl_flutter/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:mocl_flutter/features/main_page/application/repository_provider.dart';
import 'package:mocl_flutter/features/main_page/domain/repositories/main_repository.dart';

import '../helpers/screen_harness.dart';

/// 게시판 추가 시트는 DraggableScrollableSheet(LayoutBuilder) 안에서 그려진다.
/// 레일로 사이트를 바꾸면 게시판 목록 provider 가 다시 로드되는데, 이때
/// 스크롤 뷰가 트리에서 사라졌다 다시 생기면 시트의 scrollController 재부착과
/// 레이아웃 중 리빌드가 겹치면서 GlobalKey 재활성화 assert 로 죽었다.
/// 이 테스트가 그 경계를 지킨다.
void main() {
  testWidgets('레일로 사이트를 연속 전환해도 예외가 발생하지 않는다', (tester) async {
    useFixedSurface(tester);
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          ...await commonOverrides(siteType: SiteType.clien),
          mainRepositoryProvider.overrideWith(
            (Ref ref, SiteType siteType) => _FakeMainRepository(),
          ),
          favoriteRepositoryProvider.overrideWithValue(
            _InMemoryFavoriteRepository(),
          ),
        ],
        child: MaterialApp(
          theme: MoclTheme.lightTheme,
          home: const _SheetHost(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // 앱과 동일하게 실제 모달 시트 라우트 위에서 띄운다
    // (크래시가 시트의 레이아웃 델리게이트 안에서 났다).
    await tester.tap(find.text('시트 열기'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // 레일에서 다른 사이트로 옮겨 다닌다(목록 provider 가 매번 다시 로드된다).
    for (final String siteTitle in ['다모앙', '뽐뿌', '클리앙']) {
      await tester.tap(find.text(siteTitle).first);
      await tester.pumpAndSettle();
      expect(
        tester.takeException(),
        isNull,
        reason: '$siteTitle 로 전환할 때 예외 발생',
      );
    }
  });

  testWidgets('사이트를 바꾸면 불러오는 동안 로딩이 보인다', (tester) async {
    useFixedSurface(tester);
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          ...await commonOverrides(siteType: SiteType.clien),
          mainRepositoryProvider.overrideWith(
            // 목록을 받아오는 데 시간이 걸리는 상황을 만든다.
            (Ref ref, SiteType siteType) =>
                _FakeMainRepository(delay: const Duration(seconds: 2)),
          ),
          favoriteRepositoryProvider.overrideWithValue(
            _InMemoryFavoriteRepository(),
          ),
        ],
        child: MaterialApp(
          theme: MoclTheme.lightTheme,
          home: const _SheetHost(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('시트 열기'));
    await tester.pump();

    // 시트를 열자마자도 로딩이 보여야 한다.
    expect(find.textContaining('불러오는 중'), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.textContaining('불러오는 중'), findsNothing);

    await tester.tap(find.text('다모앙').first);
    await tester.pump();

    // 직전 사이트 목록을 남겨두지 않고 로딩을 노출한다.
    expect(find.text('다모앙 게시판을 불러오는 중...'), findsOneWidget);

    await tester.pumpAndSettle();
    expect(find.textContaining('불러오는 중'), findsNothing);
  });

  testWidgets('게시판 칩을 누르면 담기고 다시 누르면 빠진다', (tester) async {
    useFixedSurface(tester);
    final _InMemoryFavoriteRepository repo = _InMemoryFavoriteRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          ...await commonOverrides(siteType: SiteType.clien),
          mainRepositoryProvider.overrideWith(
            (Ref ref, SiteType siteType) => _FakeMainRepository(),
          ),
          favoriteRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(
          theme: MoclTheme.lightTheme,
          home: const _SheetHost(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    // 앱과 동일하게 실제 모달 시트 라우트 위에서 띄운다
    // (크래시가 시트의 레이아웃 델리게이트 안에서 났다).
    await tester.tap(find.text('시트 열기'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('게시판0').first);
    await tester.pumpAndSettle();
    expect(repo.favorites.length, 1);
    // 사이트 이름으로 그룹이 자동 생성된다.
    expect(repo.groups.single.id, SiteType.clien.name);
    expect(repo.favorites.single.group, SiteType.clien.name);

    await tester.tap(find.text('게시판0').first);
    await tester.pumpAndSettle();
    expect(repo.favorites, isEmpty);
  });

  testWidgets('컨테이너 칩은 담기지 않고 안으로 들어간다', (tester) async {
    final _InMemoryFavoriteRepository repo = _InMemoryFavoriteRepository();
    await _pumpSheet(tester, repo);

    await tester.tap(find.text('카페A').first);
    await tester.pumpAndSettle();

    // 담기지 않았고, 대신 그 안의 메뉴가 보인다.
    expect(repo.favorites, isEmpty);
    expect(find.text('카페A메뉴0'), findsOneWidget);
    expect(find.text('전체글'), findsOneWidget);
    // 폴더는 계층이 아니라 섹션 제목으로 눕는다.
    expect(find.text('폴더'), findsOneWidget);
    // 레일은 그대로 남아 있어야 한다(사이트 전환이 언제나 1탭).
    expect(find.text('다모앙'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('컨테이너 안에서 담으면 부모와의 합성 키로 저장된다', (tester) async {
    final _InMemoryFavoriteRepository repo = _InMemoryFavoriteRepository();
    await _pumpSheet(tester, repo);

    await tester.tap(find.text('카페A').first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('카페A메뉴1'));
    await tester.pumpAndSettle();

    final FavoriteData saved = repo.favorites.single;
    expect(saved.board, joinBoard('카페A', '1'));
    // 홈에서 출처를 밝힐 수 있어야 한다.
    expect(saved.parentText, '카페A');
    expect(saved.parentBoard, '카페A');
  });

  testWidgets('뒤로가기는 시트를 닫지 않고 한 단계만 나간다', (tester) async {
    await _pumpSheet(tester, _InMemoryFavoriteRepository());

    await tester.tap(find.text('카페A').first);
    await tester.pumpAndSettle();
    expect(find.text('카페A메뉴0'), findsOneWidget);

    // 시스템 뒤로가기.
    await simulateSystemBack();
    await tester.pumpAndSettle();

    // 시트는 살아 있고 최상위 목록으로 돌아온다.
    expect(find.text('게시판 추가'), findsOneWidget);
    expect(find.text('카페A메뉴0'), findsNothing);
    expect(find.text('게시판0'), findsOneWidget);

    // 한 번 더 누르면 시트가 닫힌다.
    await simulateSystemBack();
    await tester.pumpAndSettle();
    expect(find.text('게시판 추가'), findsNothing);
  });

  testWidgets('브레드크럼으로 다른 컨테이너로 바로 건너뛴다', (tester) async {
    await _pumpSheet(tester, _InMemoryFavoriteRepository());

    await tester.tap(find.text('카페A').first);
    await tester.pumpAndSettle();

    // 경로 표시줄의 이름을 누르면 전환 목록이 열린다.
    await tester.tap(find.text('카페A').first);
    await tester.pumpAndSettle();
    expect(find.text('이동할 목록 검색'), findsOneWidget);

    await tester.tap(find.text('카페B').last);
    await tester.pumpAndSettle();

    // 최상위로 나가지 않고 옆 컨테이너로 바로 들어간다.
    expect(find.text('카페B메뉴0'), findsOneWidget);
    expect(find.text('카페A메뉴0'), findsNothing);
  });
}

Future<void> _pumpSheet(
  WidgetTester tester,
  FavoriteRepository favoriteRepository,
) async {
  useFixedSurface(tester);
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        ...await commonOverrides(siteType: SiteType.clien),
        mainRepositoryProvider.overrideWith(
          (Ref ref, SiteType siteType) => _FakeMainRepository(),
        ),
        favoriteRepositoryProvider.overrideWithValue(favoriteRepository),
      ],
      child: MaterialApp(
        theme: MoclTheme.lightTheme,
        home: const _SheetHost(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  await tester.tap(find.text('시트 열기'));
  await tester.pumpAndSettle();
}

/// 안드로이드 시스템 뒤로가기.
Future<void> simulateSystemBack() =>
    TestWidgetsFlutterBinding.instance.handlePopRoute();

/// 앱의 ModalBottomSheetPage 와 같은 조건(ModalBottomSheetRoute,
/// isScrollControlled, 투명 배경)으로 시트를 띄운다.
class const _SheetHost() extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Builder(
        builder: (context) => TextButton(
          onPressed: () => Navigator.of(context).push(
            ModalBottomSheetRoute<void>(
              builder: (_) => const AddListBottomSheet(),
              isScrollControlled: true,
              backgroundColor: Colors.transparent,
            ),
          ),
          child: const Text('시트 열기'),
        ),
      ),
    ),
  );
}

class _FakeMainRepository({final Duration? delay}) implements MainRepository {
  @override
  Future<Either<Failure, List<MainItem>>> getMainListFromJson({
    required SiteType siteType,
  }) async {
    if (delay != null) await Future<void>.delayed(delay!);
    return Right(<MainItem>[
      for (int i = 0; i < 12; i++)
        MainItem(
          siteType: siteType,
          board: 'board$i',
          text: '게시판$i',
          url: 'https://example.com/${siteType.name}/$i',
          orderBy: i,
        ),
      // 하위 메뉴를 가진 컨테이너(네이버카페의 카페 같은 항목).
      for (final String name in const ['카페A', '카페B'])
        MainItem(
          siteType: siteType,
          board: name,
          text: name,
          url: 'https://example.com/${siteType.name}/$name',
          orderBy: 100,
          hasItem: true,
        ),
    ]);
  }

  @override
  Future<Either<Failure, List<MainItem>>> getSubMenuList({
    required MainItem parent,
  }) async {
    if (delay != null) await Future<void>.delayed(delay!);
    return Right(<MainItem>[
      // 컨테이너 자신(전체글)은 부모와 board 가 같다.
      MainItem(
        siteType: parent.siteType,
        board: parent.board,
        text: '전체글',
        url: parent.url,
        orderBy: 0,
        parentBoard: parent.board,
        parentText: parent.text,
      ),
      for (int i = 0; i < 3; i++)
        MainItem(
          siteType: parent.siteType,
          board: joinBoard(parent.board, '$i'),
          text: '${parent.text}메뉴$i',
          url: parent.url,
          orderBy: i + 1,
          category: i == 0 ? '' : '폴더',
          parentBoard: parent.board,
          parentText: parent.text,
        ),
    ]);
  }
}

/// 담기/빼기가 실제로 저장되는지 보기 위한 메모리 저장소.
class _InMemoryFavoriteRepository() implements FavoriteRepository {
  final List<FavoriteData> favorites = <FavoriteData>[];
  final List<FavoriteGroup> groups = <FavoriteGroup>[];

  @override
  Future<List<FavoriteData>> getAll() async => List.of(favorites);

  @override
  Future<List<FavoriteGroup>> getGroups() async => List.of(groups);

  @override
  Future<void> saveGroups(List<FavoriteGroup> next) async {
    groups
      ..clear()
      ..addAll(next);
  }

  @override
  Future<void> add(FavoriteData data) async => favorites.add(data);

  @override
  Future<void> addAll(List<FavoriteData> items) async =>
      favorites.addAll(items);

  @override
  Future<void> remove(SiteType siteType, String board) => Future.sync(
    () => favorites.removeWhere(
      (favorite) => favorite.siteType == siteType && favorite.board == board,
    ),
  );

  @override
  Future<bool> isFavorite(SiteType siteType, String board) async =>
      favorites.any(
        (favorite) => favorite.siteType == siteType && favorite.board == board,
      );

  @override
  Future<void> updateAll(List<FavoriteData> items) async {
    for (final FavoriteData item in items) {
      final int index = favorites.indexWhere(
        (favorite) =>
            favorite.siteType == item.siteType && favorite.board == item.board,
      );
      if (index >= 0) favorites[index] = item;
    }
  }
}
