import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';
import 'package:mocl_flutter/features/favorite/application/favorite_providers.dart';

mixin class FavoriteState() {
  AsyncValue<List<FavoriteData>> favoritesState(WidgetRef ref) =>
      ref.watch(favoritesProvider);

  bool isFavoriteState(WidgetRef ref, SiteType siteType, String board) => ref
      .watch(favoriteButtonProvider(siteType, board))
      .maybeWhen(data: (isOn) => isOn, orElse: () => false);
}
