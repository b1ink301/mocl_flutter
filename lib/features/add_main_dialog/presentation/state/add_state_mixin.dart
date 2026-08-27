import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../application/add_list_dlg_providers.dart';
import '../models/checkable_main_item.dart';

mixin class AddState() {
  AsyncValue<List<CheckableMainItem>> addState(WidgetRef ref) =>
      ref.watch(addListDlgProvider);

  /// 검색어를 구독한다(빌드용).
  String searchQuery(WidgetRef ref) => ref.watch(addListSearchQueryProvider);

  /// 검색어를 1회 읽는다(initState 등 non-build 컨텍스트용).
  String readSearchQuery(WidgetRef ref) => ref.read(addListSearchQueryProvider);
}
