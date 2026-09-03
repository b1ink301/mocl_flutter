import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_group.dart';
import 'package:mocl_flutter/features/favorite/application/favorite_providers.dart';

import '../../application/add_list_dlg_providers.dart';
import '../models/checkable_main_item.dart';

mixin class AddState() {
  AsyncValue<List<CheckableMainItem>> addState(WidgetRef ref) =>
      ref.watch(addListDlgProvider);

  /// 검색어를 구독한다(빌드용).
  String searchQuery(WidgetRef ref) => ref.watch(addListSearchQueryProvider);

  /// 검색어를 1회 읽는다(initState 등 non-build 컨텍스트용).
  String readSearchQuery(WidgetRef ref) => ref.read(addListSearchQueryProvider);

  /// 선택한 게시판을 담을 그룹 ID(아직 로딩 중이면 빈 문자열).
  String targetGroupId(WidgetRef ref) =>
      ref.watch(addTargetGroupProvider).value ?? '';

  /// 담을 그룹 후보 목록.
  List<FavoriteGroup> favoriteGroups(WidgetRef ref) =>
      ref.watch(favoriteGroupsProvider).value ?? const [];
}
