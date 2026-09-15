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
  /// 칩을 눌렀을 때. 하위 메뉴를 가진 항목은 담는 게 아니라 들어간다.
  /// (UI 는 사이트를 알 필요 없이 [MainItem.hasItem] 만 본다)
  void tapBoard(WidgetRef ref, MainItem item) =>
      item.hasItem ? enterBoard(ref, item) : toggleBoard(ref, item);

  /// 게시판을 담거나 뺀다. 누르는 즉시 저장돼 메인 화면에 반영된다.
  void toggleBoard(WidgetRef ref, MainItem item) =>
      ref.read(favoritesProvider.notifier).toggleBoard(item);

  /// 컨테이너(카페 등) 안으로 들어간다. 검색어는 단계마다 범위가 달라지므로 비운다.
  void enterBoard(WidgetRef ref, MainItem parent) {
    ref.read(addContainerPickerOpenProvider.notifier).close();
    ref.read(addListSearchQueryProvider.notifier).update('');
    ref.read(addDrillDownProvider.notifier).enter(parent);
  }

  /// 컨테이너에서 빠져나와 최상위 목록으로 돌아간다.
  void exitBoard(WidgetRef ref) {
    ref.read(addContainerPickerOpenProvider.notifier).close();
    ref.read(addListSearchQueryProvider.notifier).update('');
    ref.read(addDrillDownProvider.notifier).exit();
  }

  /// 컨테이너 전환 드롭다운을 열거나 닫는다.
  void toggleContainerPicker(WidgetRef ref) =>
      ref.read(addContainerPickerOpenProvider.notifier).toggle();

  void closeContainerPicker(WidgetRef ref) =>
      ref.read(addContainerPickerOpenProvider.notifier).close();

  /// 지금 보고 있는 하위 메뉴 목록을 다시 받아온다(캐시를 버린다).
  void refreshSubMenu(WidgetRef ref) {
    final MainItem? parent = ref.read(addDrillDownProvider);
    if (parent != null) {
      ref.invalidate(subMenuListProvider(parent));
    }
  }

  /// 시트의 뒤로가기. 컨테이너 안이면 한 단계만 나가고 시트는 닫지 않는다.
  /// 처리했으면 true.
  bool handleBack(WidgetRef ref) {
    if (ref.read(addContainerPickerOpenProvider)) {
      closeContainerPicker(ref);
      return true;
    }
    if (ref.read(addDrillDownProvider) != null) {
      exitBoard(ref);
      return true;
    }
    return false;
  }

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
  void retry(WidgetRef ref) {
    final MainItem? parent = ref.read(addDrillDownProvider);
    if (parent == null) {
      ref.invalidate(addBoardListProvider);
    } else {
      ref.invalidate(subMenuListProvider(parent));
    }
  }
}
