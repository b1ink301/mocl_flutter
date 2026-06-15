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

/// 더쿠는 쿠키/로그인이 불필요하므로 withSyncCookie를 사용하지 않습니다.
class TheQooApi extends BaseApi {
  const TheQooApi(super.dio, super.userAgent);

  @override
  Future<Either<Failure, Details>> detail(
    ListItem item,
    BaseParser parser,
  ) async {
    try {
      final String url = parser.urlByDetail(item.url, item.board, item.id);
      final String commentUrl = 'https://theqoo.net/index.php';
      final Map<String, String> headers = {
        'User-Agent': userAgent,
        'origin': 'https://theqoo.net',
      };

      final Future<Response<dynamic>> commentFuture = postUri(
        commentUrl,
        data: {
          'act': 'dispTheqooContentCommentListTheqoo',
          'document_srl': item.id,
          'cpage': 0,
        },
        headers: headers,
        responseType: ResponseType.json,
      );
      final Future<Response<dynamic>> detailFuture = get(url, headers: headers);
      final List<Response<dynamic>> responses = await Future.wait([
        detailFuture,
        commentFuture,
      ]);

      log('[getDetail] $url, commentUrl=$commentUrl');

      if (responses.first.statusCode == 200 &&
          responses.last.statusCode == 200) {
        final List<dynamic> data = responses
            .map((response) => response.data)
            .toList();
        final Response<List<dynamic>> result = Response<List<dynamic>>(
          data: data,
          requestOptions: RequestOptions(),
        );
        return parser.detail(result);
      } else {
        return Left(
          GetDetailFailure(message: 'response.statusCode = not 200'),
        );
      }
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
      final Map<String, String> headers = {
        'Host': host,
        'User-Agent': userAgent,
      };
      final Response<dynamic> response = await get(url, headers: headers);
      log('[getList] $url, $headers response = ${response.statusCode}');

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
      final Response<dynamic> response = await get(url, headers: headers);
      log('[searchList] $url, $headers response = ${response.statusCode}');

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
