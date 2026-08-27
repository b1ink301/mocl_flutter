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

/// MLBPARK 읽기는 비로그인도 가능하지만, 로그인 시 회원 기능을 위해
/// [getWithCookies] 로 쿠키를 함께 보낸다. 댓글은 `m=reply` 로 별도 로드되므로
/// 상세 요청 시 본문 HTML 과 댓글 HTML 을 동시에 받아 `[html, reply]` 로 넘긴다.
class const MlbparkApi(super.dio, super.userAgent) extends BaseApi {
  @override
  Future<Either<Failure, Details>> detail(
    ListItem item,
    BaseParser parser,
  ) async {
    try {
      final String url = parser.urlByDetail(item.url, item.board, item.id);
      final String board = item.board.isNotEmpty ? item.board : 'bullpen';
      final String replyUrl =
          'https://mlbpark.donga.com/mp/b.php?b=$board&id=${item.id}&m=reply';
      final String host = Uri.parse(parser.baseUrl).host;
      final Map<String, String> headers = {
        'Host': host,
        'User-Agent': userAgent,
      };

      final Future<Response<dynamic>> htmlFuture = getWithCookies(
        url,
        parser.baseUrl,
        headers: headers,
      );
      final Future<Response<dynamic>> replyFuture =
          getWithCookies(
            replyUrl,
            parser.baseUrl,
            headers: {'User-Agent': userAgent, 'Referer': url},
          ).catchError(
            (_) =>
                Response<dynamic>(data: '', requestOptions: RequestOptions()),
          );

      final responses = await Future.wait([htmlFuture, replyFuture]);
      final htmlResponse = responses.first;
      log('[detail] $url response = ${htmlResponse.statusCode}');
      if (htmlResponse.statusCode != 200) {
        return Left(
          GetDetailFailure(
            message: 'response.statusCode = ${htmlResponse.statusCode}',
          ),
        );
      }

      final combined = Response<List<dynamic>>(
        data: [htmlResponse.data, responses.last.data],
        requestOptions: htmlResponse.requestOptions,
        statusCode: 200,
      );
      return await parser.detail(combined);
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
      final Response<dynamic> response = await getWithCookies(
        url,
        parser.baseUrl,
        headers: headers,
      );
      log('[getList] $url response = ${response.statusCode}');
      return response.statusCode == 200
          ? await parser.list(response, lastId, item.text, isReads)
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
          ? await parser.list(response, lastId, item.text, isReads)
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
