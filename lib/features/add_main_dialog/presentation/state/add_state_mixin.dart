import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/favorite/application/favorite_providers.dart';

import '../../application/add_list_dlg_providers.dart';

mixin class AddState() {
  /// 현재 사이트의 전체 게시판 목록.
  AsyncValue<List<MainItem>> boardListState(WidgetRef ref) =>
      ref.watch(addBoardListProvider);

  /// 검색어를 구독한다(빌드용).
  String searchQuery(WidgetRef ref) => ref.watch(addListSearchQueryProvider);

  /// 검색어를 1회 읽는다(initState 등 non-build 컨텍스트용).
  String readSearchQuery(WidgetRef ref) => ref.read(addListSearchQueryProvider);

  /// 지금 게시판 목록을 보고 있는 사이트.
  SiteType currentSite(WidgetRef ref) => ref.watch(currentSiteTypeProvider);

  /// 이미 담아둔 게시판 키(사이트+게시판) 집합.
  Set<String> addedBoardKeys(WidgetRef ref) =>
      ref.watch(favoriteBoardKeysProvider);
}
