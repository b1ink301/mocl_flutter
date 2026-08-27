import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/domain/entities/last_id.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/base_parser.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_api.dart';

class const ArcaliveApi(super.dio, super.userAgent) extends BaseApi {
  /// 아카라이브 글 보기는 Cloudflare 로 보호되어 Dio 단순 GET 은 403 이 난다.
  /// 헤드리스 웹뷰로 페이지를 띄워 JS 챌린지를 통과시킨 뒤, 렌더된 HTML 을
  /// 그대로 파서에 넘긴다. (통과 시 cf_clearance 쿠키가 공유 쿠키스토어에
  /// 저장되어 이후 Dio 요청에도 도움이 된다.)
  @override
  Future<Either<Failure, Details>> detail(
    ListItem item,
    BaseParser parser,
  ) async {
    try {
      final String url = parser.urlByDetail(item.url, item.board, item.id);
      final String? html = await fetchRenderedHtml(
        url,
        readyMarkers: const ['article-content', 'fr-view'],
      );
      log('[detail] $url via webview, htmlLen=${html?.length}');
      if (html == null) {
        return Left(GetDetailFailure(message: 'Cloudflare 챌린지 통과 실패(timeout)'));
      }
      final Response<String> response = Response<String>(
        data: html,
        requestOptions: RequestOptions(path: url),
        statusCode: 200,
      );
      return await parser.detail(response);
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Unknown Error'));
    } catch (e) {
      return Left(GetDetailFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ListItem>>> list(
    MainItem item,
    int page,
    LastId lastId,
    SortType sortType,
    BaseParser parser,
    Future<List<int>> Function(SiteType, List<int>) isReads,
  ) => withSyncCookie<List<ListItem>>(item.url, () async {
    final String url = parser.urlByList(
      item.url,
      item.board,
      page,
      sortType,
      lastId,
    );
    final String host = Uri.parse(parser.baseUrl).host;
    final Map<String, String> headers = {'Host': host, 'User-Agent': userAgent};

    log('[getList] url=$url, headers=$headers');
    Response<dynamic>? response;
    try {
      response = await get(url, headers: headers);
    } on DioException catch (e) {
      // 일부 채널(예: breaking/hotdeal)은 단순 GET 이 Cloudflare 403 을 받는다.
      log('[getList] dio ${e.response?.statusCode} → 웹뷰 폴백');
      response = null;
    }

    if (response?.statusCode == 200) {
      return parser.list(response!, lastId, item.text, isReads);
    }

    // Cloudflare 차단(403 등) → 헤드리스 웹뷰로 렌더된 목록 HTML 을 받아 파싱.
    final String? html = await fetchRenderedHtml(
      url,
      readyMarkers: const ['vrow'],
    );
    if (html == null) {
      return Left(GetListFailure(message: 'Cloudflare 챌린지 통과 실패(timeout)'));
    }
    final Response<String> rendered = Response<String>(
      data: html,
      requestOptions: RequestOptions(path: url),
      statusCode: 200,
    );
    return parser.list(rendered, lastId, item.text, isReads);
  });

  @override
  Future<Either<Failure, List<MainItem>>> main(BaseParser parser) async {
    try {
      final String url = parser.urlByMain();
      // Cloudflare 보호 → 헤드리스 웹뷰로 채널 링크가 렌더될 때까지 받아온다.
      final String? html = await fetchRenderedHtml(
        url,
        readyMarkers: const ['href="/b/'],
      );
      log('[getMain] $url via webview, htmlLen=${html?.length}');
      if (html == null) {
        return Left(GetMainFailure(message: '채널 목록 로드 실패'));
      }
      final Response<String> response = Response<String>(
        data: html,
        requestOptions: RequestOptions(path: url),
        statusCode: 200,
      );
      return await parser.main(response);
    } catch (e) {
      return Left(GetMainFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ListItem>>> searchList(
    MainItem item,
    int page,
    LastId lastId,
    SortType sortType,
    String keyword,
    BaseParser parser,
    Future<List<int>> Function(SiteType, List<int>) isReads,
  ) => withSyncCookie<List<ListItem>>(item.url, () async {
    final String url = parser.urlBySearchList(
      item.url,
      item.board,
      page,
      keyword,
      lastId,
    );
    final String host = Uri.parse(parser.baseUrl).host;
    final Map<String, String> headers = {
      'Host': host,
      'Referer': item.url,
      'User-Agent': userAgent,
    };
    final Response<dynamic> response = await get(url, headers: headers);
    log('[searchList] $url, $headers response = ${response.statusCode}');

    return response.statusCode == 200
        ? parser.list(response, lastId, item.text, isReads)
        : Left(
            GetListFailure(
              message: 'response.statusCode = ${response.statusCode}',
            ),
          );
  });

  @override
  Future<Either<Failure, List<CommentItem>>> comments(
    ListItem item,
    BaseParser parser,
    int page,
  ) => throw UnimplementedError();

  //https://www.clien.net/service/board/articleWriterList/b1ink
  //https://www.clien.net/service/board/commentWriterList/b1ink
}
