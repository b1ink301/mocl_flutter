import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/favorite/application/favorite_providers.dart';

import '../../application/add_list_dlg_providers.dart';

mixin class AddEvent() {
  void onChanged(WidgetRef ref, bool isChecked, MainItem item) =>
      ref.read(addListDlgProvider.notifier).onChanged(isChecked, item);

  /// 담을 그룹을 바꾼다.
  void selectGroup(WidgetRef ref, String groupId) =>
      ref.read(addTargetGroupProvider.notifier).select(groupId);

  /// 펼쳐 볼 사이트 카테고리를 바꾼다(게시판 목록은 사이트를 고를 때 바뀐다).
  void selectCategory(WidgetRef ref, String categoryId) =>
      ref.read(addSelectedCategoryProvider.notifier).select(categoryId);

  /// 게시판 목록을 볼 사이트를 바꾼다. 목록 provider 가 사이트를 구독하므로
  /// 이 한 줄로 목록·기본 그룹이 함께 갱신된다.
  void selectSite(WidgetRef ref, SiteType siteType) =>
      ref.read(currentSiteTypeProvider.notifier).changeSiteType(siteType);

  /// '적용'. 체크한 게시판을 선택한 그룹의 즐겨찾기로 저장하고 화면을 닫는다.
  /// (메인 화면은 즐겨찾기를 구독하므로 별도 새로고침이 필요 없다)
  Future<void> apply(WidgetRef ref, BuildContext context) async {
    final List<MainItem> selected = ref
        .read(addListDlgProvider.notifier)
        .selectedItems();

    if (selected.isNotEmpty) {
      // 그룹이 아직 로딩 중일 수 있으므로 값이 확정될 때까지 기다린다.
      final String groupId = await ref.read(addTargetGroupProvider.future);
      if (groupId.isNotEmpty) {
        await ref.read(favoritesProvider.notifier).addBoards(selected, groupId);
      }
    }
    if (context.mounted) {
      context.pop();
    }
  }

  /// 로그인이 필요한 사이트(레딧 · 네이버카페)의 게시판 목록을 불러오지 못했을 때
  /// 곧바로 로그인으로 보낸다. 로그인에 성공하면 목록을 다시 읽는다.
  Future<void> loginAndRetry(WidgetRef ref, BuildContext context) async {
    final bool? result = await context.push<bool>(Routes.login);
    if (result == true) {
      ref.invalidate(addListDlgProvider);
    }
  }

  /// 검색어를 갱신한다.
  void updateSearchQuery(WidgetRef ref, String query) =>
      ref.read(addListSearchQueryProvider.notifier).update(query);
}
