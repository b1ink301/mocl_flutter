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

/// 루리웹은 글 읽기에 로그인/쿠키가 불필요하므로 단순 GET 으로 처리한다.
class RuliwebApi extends BaseApi {
  const RuliwebApi(super.dio, super.userAgent);

  @override
  Future<Either<Failure, Details>> detail(
    ListItem item,
    BaseParser parser,
  ) async {
    try {
      final String url = parser.urlByDetail(item.url, item.board, item.id);
      final String host = Uri.parse(parser.baseUrl).host;
      final Map<String, String> headers = {'Host': host, 'User-Agent': userAgent};
      final Response<dynamic> response = await get(url, headers: headers);
      log('[detail] $url response = ${response.statusCode}');
      return response.statusCode == 200
          ? parser.detail(response)
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
      final String host = Uri.parse(parser.baseUrl).host;
      final Map<String, String> headers = {'Host': host, 'User-Agent': userAgent};
      final Response<dynamic> response = await get(url, headers: headers);
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
  Future<Either<Failure, List<MainItem>>> main(BaseParser parser) async {
    try {
      final String url = parser.urlByMain();
      // urlByMain 은 www 도메인이므로 Host 는 URL 기준으로 맞춘다.
      final Map<String, String> headers = {
        'Host': Uri.parse(url).host,
        'User-Agent': userAgent,
      };
      final Response<dynamic> response = await get(url, headers: headers);
      log('[getMain] $url response = ${response.statusCode}');
      return response.statusCode == 200
          ? parser.main(response)
          : Left(
              GetMainFailure(
                message: 'response.statusCode = ${response.statusCode}',
              ),
            );
    } on DioException catch (e) {
      return Left(NetworkFailure(message: e.message ?? 'Unknown Error'));
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
