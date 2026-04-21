import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/add_list_dlg_providers.dart';
import '../models/checkable_main_item.dart';

mixin class AddState {
  AsyncValue<List<CheckableMainItem>> addState(WidgetRef ref) =>
      ref.watch(addListDlgProvider);
}
