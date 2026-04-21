import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../application/add_list_dlg_providers.dart';

mixin class AddEvent {
  void onChanged(WidgetRef ref, bool isChecked, int index) =>
      ref.read(addListDlgProvider.notifier).onChanged(isChecked, index);

  void pop(WidgetRef ref, BuildContext context) =>
      context.pop(ref.read(addListDlgProvider.notifier).selectedItems());
}
