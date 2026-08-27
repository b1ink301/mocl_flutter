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

/// 긱뉴스는 쿠키/로그인이 불필요하므로 withSyncCookie를 사용하지 않습니다.
class const GeekNewsApi(super.dio, super.userAgent) extends BaseApi {
  @override
  Future<Either<Failure, Details>> detail(
    ListItem item,
    BaseParser parser,
  ) async {
    try {
      final String url = parser.urlByDetail(item.url, item.board, item.id);
      final Map<String, String> headers = {'User-Agent': userAgent};
      final Response<dynamic> response = await get(
        url,
        headers: headers,
        responseType: ResponseType.plain,
      );
      log('[detail] $url response = ${response.statusCode}');
      return response.statusCode == 200
          ? await parser.detail(response)
          : Left(
              GetDetailFailure(
                message: 'response.statusCode = ${response.statusCode}',
              ),
            );
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
      final Map<String, String> headers = {'User-Agent': userAgent};
      final Response<dynamic> response = await get(
        url,
        headers: headers,
        responseType: ResponseType.plain,
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
  ) {
    throw UnimplementedError('GeekNews does not support search');
  }

  @override
  Future<Either<Failure, List<CommentItem>>> comments(
    ListItem item,
    BaseParser parser,
    int page,
  ) {
    throw UnimplementedError();
  }
}
