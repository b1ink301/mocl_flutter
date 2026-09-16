import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/add_main_dialog/domain/usecases/get_main_list_from_json.dart';
import 'package:mocl_flutter/features/add_main_dialog/domain/usecases/get_sub_menu_list.dart';
import 'package:mocl_flutter/features/main_page/application/repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'use_case_provider.g.dart';

@riverpod
GetMainListFromJson getMainListFromJson(Ref ref) {
  final siteType = ref.watch(currentSiteTypeProvider);
  final repository = ref.watch(mainRepositoryProvider(siteType));
  return GetMainListFromJson(mainRepository: repository);
}

/// 하위 메뉴는 '지금 고른 사이트'가 아니라 부모 항목이 속한 사이트로 조회한다.
/// (레일을 옮겨도 이미 받아둔 하위 목록이 엉키지 않는다)
@riverpod
GetSubMenuList getSubMenuList(Ref ref, SiteType siteType) =>
    GetSubMenuList(mainRepository: ref.watch(mainRepositoryProvider(siteType)));
