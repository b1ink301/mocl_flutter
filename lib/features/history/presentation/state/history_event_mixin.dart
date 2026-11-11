import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/history/application/history_providers.dart';

mixin class HistoryEvent() {
  Future<void> removeHistory(WidgetRef ref, SiteType siteType, int id) =>
      ref.read(historyProvider.notifier).remove(siteType, id);

  Future<void> clearHistory(WidgetRef ref) =>
      ref.read(historyProvider.notifier).clear();
}
