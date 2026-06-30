import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/util/utilities.dart';
import 'package:mocl_flutter/features/bookmark/application/bookmark_providers.dart';
import 'package:mocl_flutter/features/database/domain/entities/bookmark_data.dart';

import '../../application/detail_providers.dart';

mixin class DetailEvent {
  void handleRefresh(WidgetRef ref) =>
      ref.read(detailsProvider.notifier).refresh();

  void adjustFontSize(WidgetRef ref, double step) =>
      ref.read(appTextStylesFontSizeProvider.notifier).adjustFontSize(step);

  void resetFontSize(WidgetRef ref) =>
      ref.read(appTextStylesFontSizeProvider.notifier).resetFontSize();

  Future<bool> handleOpenBrowser(WidgetRef ref) =>
      ref.read(detailUrlProvider).openBrowser();

  Future<bool> handleShareUrl(WidgetRef ref) =>
      ref.read(detailUrlProvider).shareUrl();

  void toggleBookmark(
    WidgetRef ref,
    SiteType siteType,
    int id,
    BookmarkData data,
  ) => ref.read(bookmarkButtonProvider(siteType, id).notifier).toggle(data);

  static List<Override> overridesProviderScope(double width, ListItem item) => [
    listItemProvider.overrideWithValue(item),
    screenWidthProvider.overrideWithValue(width),
  ];
}
