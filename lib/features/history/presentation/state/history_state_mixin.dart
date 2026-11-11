import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/database/domain/entities/post_snapshot.dart';
import 'package:mocl_flutter/features/history/application/history_providers.dart';

mixin class HistoryState() {
  AsyncValue<List<PostSnapshot>> historyState(WidgetRef ref) =>
      ref.watch(historyProvider);
}
