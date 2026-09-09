import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/bookmark/application/bookmark_providers.dart';
import 'package:mocl_flutter/features/database/domain/entities/bookmark_data.dart';

mixin class BookmarkEvent() {
  void addBookmark(WidgetRef ref, BookmarkData data) =>
      ref.read(bookmarksProvider.notifier).add(data);

  void removeBookmark(WidgetRef ref, SiteType siteType, int id) =>
      ref.read(bookmarksProvider.notifier).remove(siteType, id);
}
