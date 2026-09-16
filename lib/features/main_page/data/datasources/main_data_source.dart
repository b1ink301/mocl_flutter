import 'dart:convert';

import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';
import 'package:mocl_flutter/core/util/read_json_from_assets.dart';
import 'package:mocl_flutter/features/database/data/models/main_item_model.dart';
import 'package:mocl_flutter/features/database/data/models/model_mapper.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/base_parser.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_api.dart';

/// 원격 게시판 목록(board_link.json)의 base URL.
/// 레포에 이미 커밋된 `assets/{site}/board_link.json` 을 그대로 raw 로 참조한다
/// → 번들 asset 과 단일 소스. 목록만 고쳐 push 하면 배포된 앱에도 즉시 반영된다.
///
/// NOTE: `develop` 은 개발 브랜치라 프로덕션에선 안정 브랜치/태그(예: `main`)로
/// 바꾸는 걸 권장. 값만 교체하면 된다.
const String _boardLinkRemoteBase =
    'https://raw.githubusercontent.com/b1ink301/mocl_flutter/develop/assets';

abstract class MainDataSource() {
  /// 사이트에서 실시간으로 전체 게시판 목록을 파싱해 온다(main()).
  /// main() 미구현 사이트는 UnimplementedError 를 던진다.
  Future<List<MainItem>> getAllLive(SiteType siteType);

  /// GitHub raw 에 호스팅된 큐레이션 게시판 목록(board_link.json)을 원격에서 받아온다.
  /// 앱 재배포 없이 목록을 갱신하기 위한 주 소스. 실패 시 번들 asset 으로 폴백한다.
  Future<List<MainItemModel>> getAllFromRemote(SiteType siteType);

  Future<List<MainItemModel>> getAllFromJson(SiteType siteType);

  /// 컨테이너의 하위 게시판 목록을 실시간으로 받아온다.
  /// 미지원 사이트는 빈 목록.
  Future<List<MainItem>> getSubMenuLive(MainItem parent);

  /// 정적 목록(board_link.json)의 `children` 에서 하위 게시판을 꺼낸다.
  Future<List<MainItem>> getSubMenuFromJson(MainItem parent);
}

class const MainDataSourceImpl({
  required final BaseApi apiClient,
  required final BaseParser parser,
}) implements MainDataSource {
  @override
  Future<List<MainItem>> getAllLive(SiteType siteType) async =>
      (await apiClient.main(parser)).getOrElse((Failure f) => throw f);

  @override
  Future<List<MainItem>> getSubMenuLive(MainItem parent) async {
    if (!parser.supportsSubMenu) return const [];
    return (await apiClient.subMenu(
      parent,
      parser,
    )).getOrElse((Failure f) => throw f);
  }

  @override
  Future<List<MainItem>> getSubMenuFromJson(MainItem parent) async {
    // 큐레이션 목록이 없는 사이트(네이버카페)는 조회 자체가 무의미하다.
    if (!parent.siteType.hasCuratedBoardList) return const [];

    // 게시판 목록과 같은 순서(원격 → 번들)로 찾는다. 원격만 children 이
    // 채워진 사이트에서도 재배포 없이 하위 메뉴가 늘어난다.
    //
    // Future 를 리스트에 담아두면 두 소스가 **동시에 시작**되어, 원격에서
    // 곧바로 return 했을 때 번들 쪽 Future 의 에러를 아무도 받지 않는다
    // (미처리 비동기 에러 → Crashlytics fatal). 그래서 지연 생성한다.
    for (final Future<List<MainItemModel>> Function() source in [
      () => getAllFromRemote(parent.siteType),
      () => getAllFromJson(parent.siteType),
    ]) {
      try {
        final Iterable<MainItemModel> found = (await source()).where(
          (model) => model.board == parent.board && model.children.isNotEmpty,
        );
        if (found.isNotEmpty) {
          return MainItemMapper.childrenToEntity(found.first, parent.siteType);
        }
      } catch (_) {
        // 다음 소스로 진행
      }
    }
    return const [];
  }

  @override
  Future<List<MainItemModel>> getAllFromRemote(SiteType siteType) async {
    final String jsonPath = '${siteType.name.toLowerCase()}/board_link.json';
    final String url = '$_boardLinkRemoteBase/$jsonPath';
    final response = await apiClient.get(url);
    final dynamic body = response.data;
    // raw.githubusercontent 은 board_link.json 을 text/plain 으로 주므로 dio 가
    // 문자열로 반환할 수 있다. content-type 에 따라 이미 디코드된 경우도 처리.
    final List<dynamic> decodedData = body is String
        ? json.decode(body) as List<dynamic>
        : body as List<dynamic>;
    return decodedData
        .map((item) => MainItemModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<MainItemModel>> getAllFromJson(SiteType siteType) async {
    final String jsonPath = '${siteType.name.toLowerCase()}/board_link.json';
    try {
      final List<dynamic> decodedData = await readJsonFromAssets<List<dynamic>>(
        jsonPath,
      );
      return decodedData
          .map((item) => MainItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      // `on Exception` 으로 좁히면 안 된다. asset 로드 실패는 Flutter 가
      // `FlutterError`(= Error, Exception 아님)를 던져서 그 절에 걸리지 않고,
      // 위로 새어 나가 미처리 비동기 에러(Crashlytics fatal)로 기록됐다.
      // 번들에 목록이 없는 건 정상 폴백이므로 경고로만 남긴다.
      MoclLogger.w(() => '[getAllFromJson] assets/$jsonPath 없음 → 폴백: $e');
      return const [];
    }
  }
}
