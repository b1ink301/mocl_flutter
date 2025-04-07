import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_api.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/last_id.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/sort_type.dart';

class NaverCafeApi extends BaseApi {
  const NaverCafeApi(super.dio, super.userAgent);

  @override
  Future<Result<Details>> detail(ListItem item, BaseParser parser) =>
      withSyncCookie(parser.baseUrl, () async {
        final String url = parser.urlByDetail(item.url, item.board, item.id);
        final Map<String, String> headers = {'User-Agent': userAgent};
        final Future<Response> commentFuture = get(
          '$url/comments',
          headers: headers,
          responseType: ResponseType.json,
        );
        final Future<Response> detailFuture = get(
          url,
          headers: headers,
          responseType: ResponseType.json,
        );
        final List<Response> responses = await Future.wait([
          detailFuture,
          commentFuture,
        ]);

        if (responses.first.statusCode != 200 ||
            responses.last.statusCode != 200) {
          throw GetDetailFailure(message: 'response.statusCode = not 200');
        }

        final List data = responses.map((response) => response.data).toList();
        final Response<List> result = Response<List<dynamic>>(
          data: data,
          requestOptions: RequestOptions(),
        );

        return parser.detail(result);
      });

  @override
  Future<Result<List<ListItem>>> list(
    MainItem item,
    int page,
    LastId lastId,
    SortType sortType,
    BaseParser parser,
    Future<List<int>> Function(SiteType, List<int>) isReads,
  ) =>
      withSyncCookie<List<ListItem>>(parser.baseUrl, () async {
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
          'User-Agent': userAgent
        };
        final Response response = await get(url, headers: headers);
        log('[getList] $url, $headers response = ${response.statusCode}');

        return response.statusCode == 200
            ? parser.list(response, lastId, item.text, isReads)
            : Result.failure(
                GetListFailure(
                  message: 'response.statusCode = ${response.statusCode}',
                ),
              );
      });

  @override
  Future<Result<List<ListItem>>> searchList(
    MainItem item,
    int page,
    LastId lastId,
    SortType sortType,
    String keyword,
    BaseParser parser,
    Future<List<int>> Function(SiteType, List<int>) isReads,
  ) =>
      withSyncCookie<List<ListItem>>(parser.baseUrl, () async {
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
        final Response response = await get(url, headers: headers);
        log('[searchList] $url, $headers response = ${response.statusCode}');

        return response.statusCode == 200
            ? parser.list(response, lastId, item.text, isReads)
            : Result.failure(
                GetListFailure(
                  message: 'response.statusCode = ${response.statusCode}',
                ),
              );
      });

  @override
  Future<Result<List<MainItem>>> main(BaseParser parser) =>
      withSyncCookie(parser.baseUrl, () async {
        final String url = parser.urlByMain();
        final Map<String, String> headers = {'User-Agent': userAgent};
        final Response response = await get(url, headers: headers);
        log('[getMain] $url, $headers response = ${response.statusCode}');
        return response.statusCode == 200
            ? parser.main(response)
            : Result.failure(
                GetMainFailure(
                  message: 'response.statusCode = ${response.statusCode}',
                ),
              );
      });

  @override
  Future<Result<List<CommentItem>>> comments(
    ListItem item,
    BaseParser parser,
    int page,
  ) =>
      throw UnimplementedError();
}
