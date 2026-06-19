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
import 'package:mocl_flutter/features/network/data/datasources/base_api.dart';

import '../base/base_parser.dart';

/// 인벤 읽기는 비로그인도 가능하지만, 로그인 시 회원 전용 글을 보려면 쿠키가
/// 필요하므로 [getWithCookies] 로 로그인 쿠키를 함께 보낸다.
/// 댓글은 본문 HTML 에 없고 `comment.json.php` 로 비동기 로드되므로, 상세 요청 시
/// 본문 HTML 과 댓글 JSON 을 동시에 받아 `[html, json]` 으로 파서에 넘긴다.
class InvenApi extends BaseApi {
  const InvenApi(super.dio, super.userAgent);

  static const String _commentUrl =
      'https://www.inven.co.kr/common/board/comment.json.php';

  @override
  Future<Either<Failure, Details>> detail(
    ListItem item,
    BaseParser parser,
  ) async {
    try {
      final String url = parser.urlByDetail(item.url, item.board, item.id);
      final String host = Uri.parse(parser.baseUrl).host;
      final Map<String, String> headers = {'Host': host, 'User-Agent': userAgent};

      final Future<Response<dynamic>> htmlFuture = getWithCookies(
        url,
        parser.baseUrl,
        headers: headers,
      );
      final Future<Response<dynamic>> commentFuture = postUri(
        _commentUrl,
        data: {
          'act': 'list',
          'comeidx': item.board,
          'articlecode': item.id,
          'typecode': item.board,
          'dbtype': 'bbs',
          'out': 'json',
          'sortorder': 'date',
          'pidx': 0,
          'listoption': '',
        },
        headers: {
          'User-Agent': userAgent,
          'Referer': url,
          'X-Requested-With': 'XMLHttpRequest',
        },
        responseType: ResponseType.json,
        contentType: Headers.formUrlEncodedContentType,
      ).catchError(
        // 댓글 로드 실패는 본문 표시를 막지 않도록 무시.
        (_) => Response<dynamic>(data: null, requestOptions: RequestOptions()),
      );

      final List<Response<dynamic>> responses = await Future.wait([
        htmlFuture,
        commentFuture,
      ]);
      final Response<dynamic> htmlResponse = responses.first;
      log('[detail] $url response = ${htmlResponse.statusCode}');

      if (htmlResponse.statusCode != 200) {
        return Left(
          GetDetailFailure(
            message: 'response.statusCode = ${htmlResponse.statusCode}',
          ),
        );
      }

      final Response<List<dynamic>> combined = Response<List<dynamic>>(
        data: [htmlResponse.data, responses.last.data],
        requestOptions: htmlResponse.requestOptions,
        statusCode: 200,
      );
      return parser.detail(combined);
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
  ) async {
    try {
      final String url = parser.urlByList(
        item.url,
        item.board,
        page,
        sortType,
        lastId,
      );
      final String host = Uri.parse(parser.baseUrl).host;
      final Map<String, String> headers = {'Host': host, 'User-Agent': userAgent};
      final Response<dynamic> response = await getWithCookies(
        url,
        parser.baseUrl,
        headers: headers,
      );
      log('[getList] $url response = ${response.statusCode}');
      return response.statusCode == 200
          ? parser.list(response, lastId, item.text, isReads)
          : Left(
              GetListFailure(
                message: 'response.statusCode = ${response.statusCode}',
              ),
            );
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Unknown Error'));
    } catch (e) {
      return Left(GetListFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MainItem>>> main(BaseParser parser) =>
      throw UnimplementedError();

  @override
  Future<Either<Failure, List<ListItem>>> searchList(
    MainItem item,
    int page,
    LastId lastId,
    SortType sortType,
    String keyword,
    BaseParser parser,
    Future<List<int>> Function(SiteType, List<int>) isReads,
  ) async {
    try {
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
      final Response<dynamic> response = await getWithCookies(
        url,
        parser.baseUrl,
        headers: headers,
      );
      log('[searchList] $url response = ${response.statusCode}');
      return response.statusCode == 200
          ? parser.list(response, lastId, item.text, isReads)
          : Left(
              GetListFailure(
                message: 'response.statusCode = ${response.statusCode}',
              ),
            );
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Unknown Error'));
    } catch (e) {
      return Left(GetListFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CommentItem>>> comments(
    ListItem item,
    BaseParser parser,
    int page,
  ) => throw UnimplementedError();
}
