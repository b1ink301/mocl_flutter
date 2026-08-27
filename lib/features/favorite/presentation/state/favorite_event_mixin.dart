import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/favorite/application/favorite_providers.dart';

mixin class FavoriteEvent() {
  /// 게시판 즐겨찾기 토글(별 버튼). 켜져 있으면 해제, 아니면 추가한다.
  void toggleFavorite(WidgetRef ref, MainItem item) => ref
      .read(favoriteButtonProvider(item.siteType, item.board).notifier)
      .toggle(item, DateTime.now().millisecondsSinceEpoch);

  void removeFavorite(WidgetRef ref, SiteType siteType, String board) =>
      ref.read(favoritesProvider.notifier).remove(siteType, board);
}
