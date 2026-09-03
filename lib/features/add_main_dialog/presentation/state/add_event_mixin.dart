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
  /// 게시판을 담거나 뺀다. 누르는 즉시 저장돼 메인 화면에 반영된다.
  void toggleBoard(WidgetRef ref, MainItem item) =>
      ref.read(favoritesProvider.notifier).toggleBoard(item);

  /// 게시판 목록을 볼 사이트를 바꾼다. 목록 provider 가 사이트를 구독하므로
  /// 이 한 줄로 목록이 갱신된다.
  void selectSite(WidgetRef ref, SiteType siteType) =>
      ref.read(currentSiteTypeProvider.notifier).changeSiteType(siteType);

  /// 검색어를 갱신한다.
  void updateSearchQuery(WidgetRef ref, String query) =>
      ref.read(addListSearchQueryProvider.notifier).update(query);

  /// 로그인해야 목록을 받아오는 사이트(레딧 · 네이버카페)를 위해
  /// 곧바로 로그인으로 보낸다. 성공하면 목록을 다시 읽는다.
  Future<void> loginAndRetry(WidgetRef ref, BuildContext context) async {
    final bool? result = await context.push<bool>(Routes.login);
    if (result == true) {
      ref.invalidate(addBoardListProvider);
    }
  }
}
