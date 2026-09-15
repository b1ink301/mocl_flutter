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
import 'package:mocl_flutter/core/util/mocl_logger.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_api.dart';

import '../base/base_parser.dart';

/// 오류 상태코드의 본문(사유 JSON)까지 읽기 위해 dio 의 상태코드 검증을 끈다.
bool _acceptAnyStatus(int? status) => status != null;

class const NaverCafeApi(super.dio, super.userAgent) extends BaseApi {
  @override
  Future<Either<Failure, Details>> detail(ListItem item, BaseParser parser) =>
      withSyncCookie(parser.baseUrl, () async {
        final String url = parser.urlByDetail(item.url, item.board, item.id);
        final Map<String, String> headers = {'User-Agent': userAgent};
        // 읽기 권한이 없으면 네이버는 본문 API 를 HTTP 500 + 사유 JSON
        // (errorCode 4005 등), 댓글 API 를 errorCode 9999 로 돌려준다.
        // 상태코드로 끊지 말고 본문을 파서로 넘겨 사유를 읽는다.
        final Future<Response<dynamic>> commentFuture = get(
          '$url/comments',
          headers: headers,
          responseType: ResponseType.json,
          validateStatus: _acceptAnyStatus,
        );
        final Future<Response<dynamic>> detailFuture = get(
          url,
          headers: headers,
          responseType: ResponseType.json,
          validateStatus: _acceptAnyStatus,
        );

        MoclLogger.d(() => '[detail]#1 url=$url');
        MoclLogger.d(() => '[detail]#2 comments=$url/comments');

        final List<Response<dynamic>> responses = await Future.wait([
          detailFuture,
          commentFuture,
        ]);

        MoclLogger.d(
          () =>
              '[detail] status detail=${responses.first.statusCode} '
              'comments=${responses.last.statusCode}',
        );

        final List<dynamic> data = responses
            .map((response) => response.data)
            .toList();
        final Response<List<dynamic>> result = Response<List<dynamic>>(
          data: data,
          requestOptions: RequestOptions(),
        );

        return parser.detail(result);
      });

  @override
  Future<Either<Failure, List<ListItem>>> list(
    MainItem item,
    int page,
    LastId lastId,
    SortType sortType,
    BaseParser parser,
    Future<List<int>> Function(SiteType, List<int>) isReads,
  ) => withSyncCookie<List<ListItem>>(parser.baseUrl, () async {
    final String url = parser.urlByList(
      item.url,
      item.board,
      page,
      sortType,
      lastId,
    );
    final String host = Uri.parse(parser.baseUrl).host;
    final Map<String, String> headers = {'Host': host, 'User-Agent': userAgent};
    final Response<dynamic> response = await get(url, headers: headers);
    MoclLogger.d(
      () =>
          '[getList] $url, ${MoclLogger.redactHeaders(headers)} response = ${response.statusCode}',
    );

    return response.statusCode == 200
        ? parser.list(response, lastId, item.text, isReads)
        : Left(
            GetListFailure(
              message: 'response.statusCode = ${response.statusCode}',
            ),
          );
  });

  @override
  Future<Either<Failure, List<ListItem>>> searchList(
    MainItem item,
    int page,
    LastId lastId,
    SortType sortType,
    String keyword,
    BaseParser parser,
    Future<List<int>> Function(SiteType, List<int>) isReads,
  ) => withSyncCookie<List<ListItem>>(parser.baseUrl, () async {
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
    MoclLogger.d(
      () =>
          '[searchList] $url, ${MoclLogger.redactHeaders(headers)} response = ${response.statusCode}',
    );

    return response.statusCode == 200
        ? parser.list(response, lastId, item.text, isReads)
        : Left(
            GetListFailure(
              message: 'response.statusCode = ${response.statusCode}',
            ),
          );
  });

  @override
  Future<Either<Failure, List<MainItem>>> main(
    BaseParser parser,
  ) => withSyncCookie(parser.baseUrl, () async {
    final String url = parser.urlByMain();
    final Map<String, String> headers = {'User-Agent': userAgent};
    final Response<dynamic> response = await get(url, headers: headers);
    MoclLogger.d(
      () =>
          '[getMain] $url, ${MoclLogger.redactHeaders(headers)} response = ${response.statusCode}',
    );
    return response.statusCode == 200
        ? parser.main(response)
        : Left(
            GetMainFailure(
              message: 'response.statusCode = ${response.statusCode}',
            ),
          );
  });

  @override
  Future<Either<Failure, List<CommentItem>>> comments(
    ListItem item,
    BaseParser parser,
    int page,
  ) {
    // TODO: implement comments
    throw UnimplementedError();
  }
}
