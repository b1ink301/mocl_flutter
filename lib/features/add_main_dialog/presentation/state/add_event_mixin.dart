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

  /// 지금 레일에서 고른 사이트로 로그인한다(로그인 화면은 currentSiteType 을
  /// 따르므로 어느 사이트에 로그인하는지 모호하지 않다).
  /// 로그인을 마치면 게시판 목록을 다시 읽어 바로 반영한다.
  Future<void> login(WidgetRef ref, BuildContext context) async {
    final bool? result = await context.push<bool>(Routes.login);
    if (result == true) {
      ref.invalidate(addBoardListProvider);
    }
  }

  /// 목록 불러오기를 다시 시도한다.
  void retry(WidgetRef ref) => ref.invalidate(addBoardListProvider);
}
