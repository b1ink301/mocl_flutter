import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/app_shell/presentation/models/checkable_main_item.dart';

import 'add_list_dlg_providers.dart';

mixin AddState {
  AsyncValue<List<CheckableMainItem>> addState(WidgetRef ref) =>
      ref.watch(addListDlgProvider);
}
