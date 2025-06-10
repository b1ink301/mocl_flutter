import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_api.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/remote/base/base_parser.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/last_id.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/sort_type.dart';

class MeecoApi extends BaseApi {
  const MeecoApi(super.dio, super.userAgent);

  @override
  Future<Either<Failure, Details>> detail(ListItem item, BaseParser parser) =>
      withSyncCookie(parser.baseUrl, () async {
        final String url = parser.urlByDetail(item.url, item.board, item.id);
        final Map<String, String> headers = {'User-Agent': userAgent};

        final Response response = await get(url, headers: headers);
        log('[detail] $url, $headers response = ${response.statusCode}');
        return response.statusCode == 200
            ? parser.detail(response)
            : Left(
                GetDetailFailure(
                  message: 'response.statusCode = ${response.statusCode}',
                ),
              );
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
    final Response response = await get(url, headers: headers);
    log('[getList] $url, $headers response = ${response.statusCode}');

    return response.statusCode == 200
        ? parser.list(response, lastId, item.text, isReads)
        : Left(
            GetListFailure(
              message: 'response.statusCode = ${response.statusCode}',
            ),
          );
  });

  @override
  Future<Either<Failure, List<MainItem>>> main(BaseParser parser) {
    throw UnimplementedError();
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
    final Response response = await get(url, headers: headers);
    log('[getList] $url, $headers response = ${response.statusCode}');

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
  ) {
    throw UnimplementedError();
  }
}
