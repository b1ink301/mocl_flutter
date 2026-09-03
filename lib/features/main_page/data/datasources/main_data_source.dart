import 'dart:convert';

import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';
import 'package:mocl_flutter/core/util/read_json_from_assets.dart';
import 'package:mocl_flutter/features/database/data/models/main_item_model.dart';
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
}

class const MainDataSourceImpl({
  required final BaseApi apiClient,
  required final BaseParser parser,
}) implements MainDataSource {
  @override
  Future<List<MainItem>> getAllLive(SiteType siteType) async =>
      (await apiClient.main(parser)).getOrElse((Failure f) => throw f);

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
    try {
      final String jsonPath = '${siteType.name.toLowerCase()}/board_link.json';
      final List<dynamic> decodedData = await readJsonFromAssets<List<dynamic>>(
        jsonPath,
      );
      return decodedData
          .map((item) => MainItemModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on Exception catch (e) {
      MoclLogger.log("getAllFromJson - ${e.toString()}");
      return const [];
    }
  }
}
