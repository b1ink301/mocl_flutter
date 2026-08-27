import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';

import '../../application/add_list_dlg_providers.dart';

mixin class AddEvent() {
  void onChanged(WidgetRef ref, bool isChecked, MainItem item) =>
      ref.read(addListDlgProvider.notifier).onChanged(isChecked, item);

  void pop(WidgetRef ref, BuildContext context) =>
      context.pop(ref.read(addListDlgProvider.notifier).selectedItems());

  /// 검색어를 갱신한다.
  void updateSearchQuery(WidgetRef ref, String query) =>
      ref.read(addListSearchQueryProvider.notifier).update(query);
}
