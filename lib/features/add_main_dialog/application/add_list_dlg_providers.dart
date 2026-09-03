import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'use_case_provider.dart';

part 'add_list_dlg_providers.g.dart';

/// 게시판 추가 화면의 검색어. 화면이 닫히면 자동으로 초기화된다.
@riverpod
class AddListSearchQuery() extends _$AddListSearchQuery {
  @override
  String build() => '';

  void update(String query) => state = query;
}

/// 현재 선택된 사이트가 제공하는 전체 게시판 목록.
/// 담겼는지 여부는 즐겨찾기(favoriteBoardKeys)가 알려주므로 여기선 다루지 않는다.
@riverpod
Future<List<MainItem>> addBoardList(Ref ref) async {
  final SiteType siteType = ref.watch(currentSiteTypeProvider);
  final getMainListFromJson = ref.watch(getMainListFromJsonProvider);
  final result = await getMainListFromJson(siteType);
  return result.fold((failure) => throw failure, (data) => data);
}
