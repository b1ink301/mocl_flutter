import 'dart:convert';

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

/// 더쿠 읽기는 비로그인도 가능하지만, 로그인 시 회원 전용 글 열람을 위해
/// [getWithCookies] 로 로그인 쿠키를 함께 보낸다.
///
/// 더쿠는 Cloudflare 보안 검사("더쿠 - 보안 검사중", managed challenge)를 걸 때가 있다.
/// 그때 Dio 는 403 을 받고, 웹뷰가 통과해 얻은 `cf_clearance` 쿠키를 실어도 계속 403 이다
/// (쿠키만이 아니라 브라우저 지문까지 본다). 그래서 헤드리스 웹뷰로 페이지를 띄워 렌더된
/// HTML 을 쓰고, 댓글(POST)도 같은 웹뷰 안에서 `fetch` 로 받는다.
/// 한 번 걸리면 [_challengeHold] 동안은 Dio 를 건너뛰고 바로 웹뷰로 받는다.
class const TheQooApi(super.dio, super.userAgent) extends BaseApi {
  static const String _commentUrl = 'https://theqoo.net/index.php';
  static const Duration _challengeHold = Duration(minutes: 10);
  static const List<String> _listMarkers = ['list-link', 'flatBoard'];
  static const List<String> _detailMarkers = ['read-body'];

  /// 보안 검사에 걸려 Dio 를 건너뛰는 기한. 지나면 Dio 를 다시 시도한다.
  static DateTime? _challengedUntil;

  /// 보안 검사를 통과하지 못했을 때. 파서 고장이 아니므로 자동 신고하지 않는다.
  static const ServerFailure blockedFailure = ServerFailure(
    message: '더쿠 보안 검사를 통과하지 못했어요. 잠시 뒤 다시 시도해 주세요.',
  );

  static bool get _challenged =>
      _challengedUntil?.isAfter(DateTime.now()) ?? false;

  /// Dio 로 [request] 를 보낸다. 보안 검사(403)에 걸리면 null 을 돌려준다
  /// (그 뒤 [_challengeHold] 동안은 보내지 않고 바로 null).
  Future<T?> _tryDio<T>(String url, Future<T> Function() request) async {
    if (_challenged) return null;
    try {
      return await request();
    } on DioException catch (e) {
      if (e.response?.statusCode != 403) rethrow;
      MoclLogger.w(() => '[theqoo] $url 403 → 웹뷰 폴백');
      _challengedUntil = DateTime.now().add(_challengeHold);
      return null;
    }
  }

  /// 웹뷰로 렌더된 [url] 페이지. [readyMarkers] 가 보이지 않으면(검사 통과 실패)
  /// [blockedFailure] 를 던진다.
  Future<({String html, Object? scriptResult})> _render(
    String url,
    List<String> readyMarkers, {
    String? script,
  }) async {
    final page = await fetchRenderedPage(
      url,
      readyMarkers: readyMarkers,
      script: script,
    );
    final String? html = page.html;
    MoclLogger.d(() => '[theqoo] $url via webview, htmlLen=${html?.length}');
    if (html == null || !readyMarkers.any(html.contains)) throw blockedFailure;
    return (html: html, scriptResult: page.scriptResult);
  }

  /// [url] 의 HTML 을 받는다. 보안 검사에 걸리면 웹뷰로 받는다.
  Future<Response<dynamic>> _getPage(
    String url,
    String cookieUrl, {
    required Map<String, String> headers,
    required List<String> readyMarkers,
  }) async {
    final Response<dynamic>? response = await _tryDio(
      url,
      () => getWithCookies(url, cookieUrl, headers: headers),
    );
    if (response != null) return response;
    final page = await _render(url, readyMarkers);
    return Response<String>(
      data: page.html,
      requestOptions: RequestOptions(path: url),
      statusCode: 200,
    );
  }

  Map<String, Object> _commentBody(ListItem item) => {
    'act': 'dispTheqooContentCommentListTheqoo',
    'document_srl': item.id,
    'cpage': 0,
  };

  @override
  Future<Either<Failure, Details>> detail(
    ListItem item,
    BaseParser parser,
  ) async {
    try {
      final String url = parser.urlByDetail(item.url, item.board, item.id);
      final Map<String, String> headers = {
        'User-Agent': userAgent,
        'origin': 'https://theqoo.net',
      };
      MoclLogger.d(() => '[getDetail] $url, commentUrl=$_commentUrl');

      final List<Response<dynamic>>? responses = await _tryDio(
        url,
        () => Future.wait([
          getWithCookies(url, parser.baseUrl, headers: headers),
          postUri(
            _commentUrl,
            data: _commentBody(item),
            headers: headers,
            responseType: ResponseType.json,
          ),
        ]),
      );

      final List<dynamic> data;
      if (responses != null) {
        if (responses.any((r) => r.statusCode != 200)) {
          return Left(
            GetDetailFailure(message: 'response.statusCode = not 200'),
          );
        }
        data = responses.map((r) => r.data).toList();
      } else {
        // 보안 검사 → 본문은 웹뷰로, 댓글은 그 웹뷰 안에서 같은 요청을 fetch 로.
        final page = await _render(
          url,
          _detailMarkers,
          script:
              '''
const r = await fetch('/index.php', {
  method: 'POST',
  headers: {'Content-Type': 'application/json'},
  body: JSON.stringify(${jsonEncode(_commentBody(item))}),
});
return r.ok ? await r.text() : null;
''',
        );
        final Object? comments = page.scriptResult;
        if (comments is! String) {
          MoclLogger.w(() => '[theqoo] 웹뷰 댓글 요청 실패 → 댓글 없이 보여 준다');
        }
        data = [
          page.html,
          comments is String
              ? jsonDecode(comments) as Map<String, dynamic>
              : null,
        ];
      }

      return await parser.detail(
        Response<List<dynamic>>(data: data, requestOptions: RequestOptions()),
      );
    } on DioException catch (e) {
      return Left(failureFromDio(e));
    } on Failure catch (e) {
      return Left(e);
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
      final Response<dynamic> response = await _getPage(
        url,
        parser.baseUrl,
        headers: headers,
        readyMarkers: _listMarkers,
      );
      MoclLogger.d(
        () =>
            '[getList] $url, ${MoclLogger.redactHeaders(headers)} response = ${response.statusCode}',
      );

      return response.statusCode == 200
          ? await parser.list(response, lastId, item.text, isReads)
          : Left(
              GetListFailure(
                message: 'response.statusCode = ${response.statusCode}',
              ),
            );
    } on DioException catch (e) {
      return Left(failureFromDio(e));
    } on Failure catch (e) {
      return Left(e);
    } catch (e) {
      return Left(GetListFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MainItem>>> main(BaseParser parser) async {
    try {
      final String url = parser.urlByMain();
      final String host = Uri.parse(parser.baseUrl).host;
      final Map<String, String> headers = {
        'Host': host,
        'User-Agent': userAgent,
      };
      final Response<dynamic> response = await _getPage(
        url,
        parser.baseUrl,
        headers: headers,
        readyMarkers: const ['cate_index_mobile'],
      );
      MoclLogger.d(() => '[getMain] $url response = ${response.statusCode}');
      return response.statusCode == 200
          ? await parser.main(response)
          : Left(
              GetMainFailure(
                message: 'response.statusCode = ${response.statusCode}',
              ),
            );
    } on DioException catch (e) {
      return Left(failureFromDio(e));
    } on Failure catch (e) {
      return Left(e);
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
      final String url = parser.searchListUrl(
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
      final Response<dynamic> response = await _getPage(
        url,
        parser.baseUrl,
        headers: headers,
        readyMarkers: _listMarkers,
      );
      MoclLogger.d(
        () =>
            '[searchList] $url, ${MoclLogger.redactHeaders(headers)} response = ${response.statusCode}',
      );

      return response.statusCode == 200
          ? await parser.list(response, lastId, item.text, isReads)
          : Left(
              GetListFailure(
                message: 'response.statusCode = ${response.statusCode}',
              ),
            );
    } on DioException catch (e) {
      return Left(failureFromDio(e));
    } on Failure catch (e) {
      return Left(e);
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
