import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/bookmark/application/bookmark_providers.dart';
import 'package:mocl_flutter/features/database/domain/entities/bookmark_data.dart';

mixin class BookmarkState {
  AsyncValue<List<BookmarkData>> bookmarksState(WidgetRef ref) =>
      ref.watch(bookmarksProvider);
}
