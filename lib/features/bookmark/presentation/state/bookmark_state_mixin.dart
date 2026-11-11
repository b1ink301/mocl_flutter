import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/bookmark/application/bookmark_providers.dart';
import 'package:mocl_flutter/features/database/domain/entities/post_snapshot.dart';

mixin class BookmarkState() {
  AsyncValue<List<PostSnapshot>> bookmarksState(WidgetRef ref) =>
      ref.watch(bookmarksProvider);
}
