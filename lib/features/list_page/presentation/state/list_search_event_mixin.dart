import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';

import 'list_event_mixin.dart';
import '../../application/list_providers.dart';
import '../../application/list_search_proivders.dart';

mixin class ListSearchEvent {
  void handleSearch(WidgetRef ref, String keyword) =>
      ref.read(keywordProvider.notifier).setKeyword(keyword);

  static List<Override> overridesProviderScope(MainItem item) => [
    mainItemProvider.overrideWithValue(item),
  ];

  static List<Override> overridesProviderScopeForRow(
    WidgetRef ref,
    int index,
  ) => ListEvent.overridesProviderScopeForRow(index);
}
