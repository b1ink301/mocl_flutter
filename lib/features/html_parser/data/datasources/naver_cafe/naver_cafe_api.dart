import 'dart:isolate';

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
import 'naver_cafe_parser.dart';

/// 오류 상태코드의 본문(사유 JSON)까지 읽기 위해 dio 의 상태코드 검증을 끈다.
bool _acceptAnyStatus(int? status) => status != null;

class const NaverCafeApi(super.dio, super.userAgent) extends BaseApi {
  /// 영상 재생 정보를 기다리는 최대 시간. 본문 표시가 이보다 늦어지지 않는다
  /// (영상들은 동시에 요청한다). 넘기면 그 영상은 썸네일로 남는다.
  static const Duration _videoPlayTimeout = Duration(seconds: 4);

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

        final Either<Failure, Details> details = await parser.detail(result);
        return switch (details) {
          Right(:final Details value) => Right(
            await _withVideoSources(value, headers).catchError((
              Object e,
              StackTrace st,
            ) {
              // 영상 처리가 깨져도 본문은 썸네일 그대로 보여 준다.
              MoclLogger.e('네이버 카페 영상 처리 실패', error: e, stackTrace: st);
              return value;
            }),
          ),
          _ => details,
        };
      });

  /// 본문 동영상 자리표시자의 재생 주소(mp4)를 받아 `<video>` 로 바꾼다.
  /// 재생 정보는 영상마다 따로 받아야 해서 파서(워커 isolate)가 아니라 여기서
  /// 요청한다. 본문 HTML 파싱은 메인 isolate 를 막지 않도록 워커에서 하고,
  /// 실패하거나 [_videoPlayTimeout] 안에 오지 않은 영상은 썸네일로 남긴다.
  Future<Details> _withVideoSources(
    Details details,
    Map<String, String> headers,
  ) async {
    final String bodyHtml = details.bodyHtml;
    final refs = await Isolate.run(() => NaverCafeParser.videoRefsOf(bodyHtml));
    if (refs.isEmpty) return details;

    final List<MapEntry<String, String>?> resolved = await Future.wait(
      refs.map((ref) async {
        try {
          final Response<dynamic> response = await get(
            NaverCafeParser.urlByVideoPlay(ref.vid, ref.inkey),
            headers: headers,
            responseType: ResponseType.json,
          ).timeout(_videoPlayTimeout);
          final String? source = NaverCafeParser.videoSourceOf(response.data);
          return source == null ? null : MapEntry(ref.vid, source);
        } catch (e) {
          MoclLogger.w(
            () => '[detail] video play info failed vid=${ref.vid}: $e',
          );
          return null;
        }
      }),
    );

    final Map<String, String> sources = Map.fromEntries(
      resolved.whereType<MapEntry<String, String>>(),
    );
    MoclLogger.d(
      () => '[detail] videos resolved ${sources.length}/${refs.length}',
    );
    return sources.isEmpty
        ? details
        : details.copyWith(
            bodyHtml: await Isolate.run(
              () => NaverCafeParser.applyVideoSources(bodyHtml, sources),
            ),
          );
  }

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

  /// 카페 사이드 메뉴는 비공개 카페면 로그인 쿠키가 있어야 응답한다.
  /// 기본 구현과 달리 쿠키를 실어 보내기 위해 감싼다.
  @override
  Future<Either<Failure, List<MainItem>>> subMenu(
    MainItem parent,
    BaseParser parser,
  ) => withSyncCookie(parser.baseUrl, () => super.subMenu(parent, parser));

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
