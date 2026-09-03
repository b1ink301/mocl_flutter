import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// `Override` 타입은 misc.dart 에서 노출된다(앱의 *_event_mixin 과 동일한 경로).
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/config/mocl_theme.dart';
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
          ...commonOverrides(siteType: SiteType.clien),
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

  testWidgets('게시판 칩을 누르면 담기고 다시 누르면 빠진다', (tester) async {
    useFixedSurface(tester);
    final _InMemoryFavoriteRepository repo = _InMemoryFavoriteRepository();
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          ...commonOverrides(siteType: SiteType.clien),
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
}

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

class _FakeMainRepository() implements MainRepository {
  @override
  Future<Either<Failure, List<MainItem>>> getMainListFromJson({
    required SiteType siteType,
  }) async => Right(<MainItem>[
    for (int i = 0; i < 12; i++)
      MainItem(
        siteType: siteType,
        board: 'board$i',
        text: '게시판$i',
        url: 'https://example.com/${siteType.name}/$i',
        orderBy: i,
      ),
  ]);
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
