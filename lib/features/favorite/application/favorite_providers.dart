import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/application/datasource_provider.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';
import 'package:mocl_flutter/features/favorite/data/repositories/favorite_repository_impl.dart';
import 'package:mocl_flutter/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'favorite_providers.g.dart';

@Riverpod(keepAlive: true)
FavoriteRepository favoriteRepository(Ref ref) =>
    FavoriteRepositoryImpl(ref.watch(localDatabaseProvider));

/// 즐겨찾기 게시판 목록(최근 추가순). 추가/삭제 시 invalidate 되어 갱신된다.
@riverpod
class FavoritesNotifier() extends _$FavoritesNotifier {
  @override
  Future<List<FavoriteData>> build() =>
      ref.watch(favoriteRepositoryProvider).getAll();

  Future<void> remove(SiteType siteType, String board) async {
    await ref.read(favoriteRepositoryProvider).remove(siteType, board);
    ref.invalidateSelf();
  }
}

/// 특정 게시판의 즐겨찾기 여부 + 토글. 메인 목록의 별 버튼이 사용한다.
@riverpod
class FavoriteButton() extends _$FavoriteButton {
  @override
  Future<bool> build(SiteType siteType, String board) =>
      ref.watch(favoriteRepositoryProvider).isFavorite(siteType, board);

  Future<void> toggle(MainItem item, int savedAt) async {
    final repo = ref.read(favoriteRepositoryProvider);
    final bool isOn = state.asData?.value ?? false;
    if (isOn) {
      await repo.remove(item.siteType, item.board);
    } else {
      await repo.add(FavoriteData.fromMainItem(item, savedAt));
    }
    ref.invalidateSelf();
    ref.invalidate(favoritesProvider);
  }
}
