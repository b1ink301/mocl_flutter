import 'dart:developer';
import 'dart:typed_data';

import 'package:cp949_codec/cp949_codec.dart';
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

/// 뽐뿌는 EUC-KR(CP949) 인코딩이므로 응답을 bytes 로 받아 CP949 로 디코딩한 뒤
/// UTF-8 String 으로 파서에 넘긴다. 로그인 시 회원 전용 글 열람을 위해
/// [getWithCookies] 로 로그인 쿠키를 함께 보낸다.
class const PpomppuApi(super.dio, super.userAgent) extends BaseApi {
  /// bytes 응답을 CP949 로 디코딩한 String Response 로 변환.
  Future<Response<dynamic>> _getDecoded(
    String url,
    Map<String, String> headers,
  ) async {
    final Response<dynamic> response = await getWithCookies(
      url,
      'https://m.ppomppu.co.kr',
      headers: headers,
      responseType: ResponseType.bytes,
    );
    final List<int> bytes = response.data is List<int>
        ? response.data as List<int>
        : Uint8List.fromList((response.data as String).codeUnits);
    final String decoded = cp949.decode(bytes, allowInvalid: true);
    return Response<String>(
      data: decoded,
      requestOptions: response.requestOptions,
      statusCode: response.statusCode,
      headers: response.headers,
    );
  }

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
      final Response<dynamic> response = await _getDecoded(url, headers);
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
      final String host = Uri.parse(parser.baseUrl).host;
      final Map<String, String> headers = {
        'Host': host,
        'User-Agent': userAgent,
      };
      final Response<dynamic> response = await _getDecoded(url, headers);
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
  Future<Either<Failure, List<MainItem>>> main(BaseParser parser) async {
    try {
      final String url = parser.urlByMain();
      // 뽐뿌 PC 홈은 JS 로 메뉴를 렌더하므로 헤드리스 웹뷰로 받아온다.
      final String? html = await fetchRenderedHtml(
        url,
        readyMarkers: const ['id=freeboard', 'id=ppomppu'],
      );
      log('[getMain] $url via webview, htmlLen=${html?.length}');
      if (html == null) {
        return Left(GetMainFailure(message: '게시판 목록 로드 실패'));
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
      final Response<dynamic> response = await _getDecoded(url, headers);
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
