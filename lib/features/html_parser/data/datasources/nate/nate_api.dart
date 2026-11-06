import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_shared/entities/last_id.dart';
import 'package:mocl_shared/entities/mocl_comment_item.dart';
import 'package:mocl_shared/entities/mocl_details.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_main_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/entities/sort_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_shared/util/mocl_logger.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_api.dart';

import 'package:mocl_shared/parser/base/base_parser.dart';
import 'package:mocl_shared/parser/nate/nate_parser.dart';

/// 네이트판은 읽기에 로그인이 불필요하나, 일관성을 위해 [getWithCookies] 로
/// 쿠키를 함께 보낸다. 게시판(랭킹) 목록은 asset JSON 사용.
class const NateApi(super.dio, super.userAgent) extends BaseApi {
  @override
  Future<Either<Failure, Details>> detail(
    ListItem item,
    BaseParser parser,
  ) async {
    try {
      final String url = parser.urlByDetail(item.url, item.board, item.id);
      final String host = Uri.parse(parser.baseUrl).host;
      final Map<String, String> headers = {
        'Host': host,
        'User-Agent': userAgent,
      };
      // 글 페이지는 베스트 댓글만 주므로 전체 댓글 페이지를 같이 받는다.
      // 댓글 페이지가 실패해도 글은 보여 준다(파서가 베스트 댓글로 대신한다).
      final Future<Response<dynamic>> replyFuture =
          getWithCookies(
            NateParser.urlByReplies(item.id),
            parser.baseUrl,
            headers: {'User-Agent': userAgent, 'Referer': url},
          ).catchError(
            (_) =>
                Response<dynamic>(data: '', requestOptions: RequestOptions()),
          );
      final Response<dynamic> response = await getWithCookies(
        url,
        parser.baseUrl,
        headers: headers,
      );
      final Response<dynamic> replies = await replyFuture;
      MoclLogger.d(
        () =>
            '[detail] $url response = ${response.statusCode}, '
            'replies = ${replies.statusCode}',
      );
      if (response.statusCode != 200) {
        return Left(
          GetDetailFailure(
            message: 'response.statusCode = ${response.statusCode}',
          ),
        );
      }
      return await parser.detail(
        Response<List<dynamic>>(
          data: [response.data, replies.statusCode == 200 ? replies.data : ''],
          requestOptions: response.requestOptions,
          statusCode: 200,
        ),
      );
    } on DioException catch (e) {
      return Left(failureFromDio(e));
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
      MoclLogger.d(() => '[getList] $url response = ${response.statusCode}');
      return response.statusCode == 200
          ? await parser.list(response, lastId, item.text, isReads)
          : Left(
              GetListFailure(
                message: 'response.statusCode = ${response.statusCode}',
              ),
            );
    } on DioException catch (e) {
      return Left(failureFromDio(e));
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
      MoclLogger.d(() => '[searchList] $url response = ${response.statusCode}');
      return response.statusCode == 200
          ? await parser.list(response, lastId, item.text, isReads)
          : Left(
              GetListFailure(
                message: 'response.statusCode = ${response.statusCode}',
              ),
            );
    } on DioException catch (e) {
      return Left(failureFromDio(e));
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
