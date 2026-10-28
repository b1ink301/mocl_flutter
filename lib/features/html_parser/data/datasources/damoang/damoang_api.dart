import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/domain/entities/last_id.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_comment_write.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_user_info.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_api.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'damoang_parser.dart';
import '../base/base_parser.dart';

class const DamoangApi(super.dio, super.userAgent) extends BaseApi {
  @override
  Future<Either<Failure, Details>> detail(
    ListItem item,
    BaseParser parser,
  ) => withSyncCookie(parser.baseUrl, () async {
    final String url = parser.urlByDetail(item.url, item.board, item.id);
    final Map<String, String> headers = {}; //{'User-Agent': userAgent};

    final Response<dynamic> response = await get(
      url,
      headers: headers,
      responseType: ResponseType.plain,
    );
    MoclLogger.d(
      () =>
          '[detail] $url, ${MoclLogger.redactHeaders(headers)} response = ${response.statusCode}',
    );
    if (response.statusCode != 200) {
      return Left(
        GetDetailFailure(
          message: 'response.statusCode = ${response.statusCode}',
        ),
      );
    }

    final detailResult = await parser.detail(response);

    // Fetch comments from dedicated API (site now uses streaming
    // for comments, so __data.json no longer includes them).
    return detailResult.fold((failure) => Left(failure), (detail) async {
      if (detail.comments.isNotEmpty) return Right(detail);

      try {
        final comments = await _fetchComments(
          parser.baseUrl,
          item.board,
          item.id,
          headers,
        );
        if (comments.isNotEmpty) {
          return Right(detail.copyWith(comments: comments));
        }
      } catch (e) {
        MoclLogger.e('[DamoangApi] comments API error', error: e);
      }
      return Right(detail);
    });
  });

  /// 한 번에 받아올 댓글 수. 서버가 그대로 받아준다(웹은 50을 쓴다).
  static const int _kCommentsPageSize = 100;

  /// 안전장치 — 아무리 많아도 이 페이지 수까지만 이어 받는다.
  static const int _kMaxCommentPages = 10;

  /// 댓글을 `/api/boards/...` 에서 페이지 단위로 모아 온다.
  ///
  /// `/api/v1/boards/...` 는 **삭제된 댓글을 아예 빼고** 주기 때문에, 웹과 달리
  /// 앱에서만 "삭제된 댓글입니다" 자리가 통째로 사라지고 대댓글의 depth 도
  /// 어긋나 보였다. 웹 클라이언트가 쓰는 이 엔드포인트는 삭제분까지 포함해
  /// (`deleted_at` 이 채워진 빈 댓글) 내려준다.
  Future<List<CommentItem>> _fetchComments(
    String baseUrl,
    String board,
    int postId,
    Map<String, String> headers,
  ) async {
    final List<CommentItem> all = [];

    for (int page = 1; page <= _kMaxCommentPages; page++) {
      final url =
          '$baseUrl/api/boards/$board/posts/$postId/comments'
          '?page=$page&limit=$_kCommentsPageSize';
      final response = await get(
        url,
        headers: headers,
        responseType: ResponseType.plain,
      );
      if (response.statusCode != 200) break;

      final (comments, totalPages) = _parseCommentsJson(
        response.data is String
            ? response.data as String
            : response.data.toString(),
        all.length,
      );
      all.addAll(comments);

      if (comments.isEmpty || page >= totalPages) break;
    }

    if (all.isNotEmpty) return all;

    // 새 엔드포인트가 막히거나 형태가 바뀌었을 때를 대비한 폴백.
    // (삭제된 댓글은 빠지지만 댓글이 통째로 사라지는 것보다는 낫다)
    final legacy = await get(
      '$baseUrl/api/v1/boards/$board/posts/$postId/comments',
      headers: headers,
      responseType: ResponseType.plain,
    );
    if (legacy.statusCode != 200) return all;
    final (legacyComments, _) = _parseCommentsJson(
      legacy.data is String ? legacy.data as String : legacy.data.toString(),
      0,
    );
    return legacyComments;
  }

  /// 삭제된 댓글 자리에 넣을 본문. 다모앙 웹과 같은 문구를 쓴다.
  static const String _kDeletedCommentHtml = '<p>삭제된 댓글입니다.</p>';

  /// 댓글 JSON 을 파싱해 `(댓글 목록, 전체 페이지 수)` 를 돌려준다.
  ///
  /// `/api/boards/...` 는 `data.comments` / `data.total_pages` 형태로 주고,
  /// 구버전 `/api/v1/boards/...` 는 `data` 자체가 배열이다. 둘 다 받아들인다.
  /// [idOffset] 은 페이지를 이어 받을 때 [CommentItem.id] 가 겹치지 않게 한다.
  static (List<CommentItem>, int) _parseCommentsJson(
    String jsonStr,
    int idOffset,
  ) {
    try {
      timeago.setLocaleMessages('ko', timeago.KoMessages());
      final Map<String, dynamic> body =
          jsonDecode(jsonStr) as Map<String, dynamic>;

      final dynamic data = body['data'];
      final List<dynamic>? rawComments = switch (data) {
        List<dynamic> list => list,
        Map<String, dynamic> map => map['comments'] as List<dynamic>?,
        _ => null,
      };
      if (rawComments == null) return (const <CommentItem>[], 0);

      final int totalPages = (data is Map<String, dynamic>)
          ? (data['total_pages'] is int ? data['total_pages'] as int : 1)
          : 1;

      final comments = rawComments.asMap().entries.map((entry) {
        final c = entry.value as Map<String, dynamic>;

        final String author = (c['author'] ?? '').toString();
        final String authorId = (c['author_id'] ?? '').toString();
        final String content = (c['content'] ?? '').toString();
        final int likes = (c['likes'] is int) ? c['likes'] as int : 0;
        final int depth = (c['depth'] is int) ? c['depth'] as int : 0;
        final String createdAt = (c['created_at'] ?? '').toString();

        // 삭제된 댓글은 author/content 가 빈 채로 deleted_at 만 채워져 온다.
        // 그냥 두면 본문도 작성자도 없는 빈 줄이 되므로 웹과 같은 안내를 넣는다.
        final bool isDeleted = (c['deleted_at'] ?? '').toString().isNotEmpty;

        String parsedTime = '';
        try {
          parsedTime = timeago.format(DateTime.parse(createdAt), locale: 'ko');
        } catch (_) {
          parsedTime = createdAt;
        }

        return CommentItem(
          id: idOffset + entry.key,
          isReply: depth > 0,
          bodyHtml: isDeleted
              ? _kDeletedCommentHtml
              : DamoangParser.normalizeContentHtml(content),
          likeCount: likes > 0 ? likes.toString() : '',
          mediaHtml: '',
          isVideo: false,
          time: createdAt,
          info: parsedTime,
          userInfo: UserInfo(id: authorId, nickName: author, nickImage: ''),
          authorId: authorId,
          commentId: (c['id'] ?? '').toString(),
        );
      }).toList();

      return (comments, totalPages);
    } catch (e) {
      MoclLogger.e('[DamoangApi] _parseCommentsJson error', error: e);
      return (const <CommentItem>[], 0);
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
  ) => withSyncCookie<List<ListItem>>(parser.baseUrl, () async {
    final String url = parser.urlByList(
      item.url,
      item.board,
      page,
      sortType,
      lastId,
    );
    // final String host = Uri.parse(parser.baseUrl).host;
    final Map<String, String> headers = {}; //{'User-Agent': userAgent};

    final Response<dynamic> response = await get(
      url,
      headers: headers,
      responseType: ResponseType.plain,
    );
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
  Future<Either<Failure, List<MainItem>>> main(BaseParser parser) async {
    try {
      final String url = parser.urlByMain();
      // 다모앙은 비브라우저 요청을 403 으로 막으므로 헤드리스 웹뷰로 렌더.
      // 일반 게시판은 홈 사이드바, 소모임은 /groups/__data.json(JSON) 에서 받는다.
      // '자유게시판'(텍스트)은 하이드레이션 전 임베디드 데이터에도 있어 너무 일찍
      // 반환될 수 있으므로, 실제 렌더된 사이드바 링크가 나타날 때까지 기다린다.
      final String? homeHtml = await fetchRenderedHtml(
        url,
        readyMarkers: const ['href="/free"'],
      );
      final String? groupsJson = await fetchRenderedHtml(
        'https://damoang.net/groups/__data.json',
        readyMarkers: const ['당"', 'board_path'],
      );
      MoclLogger.d(
        () => '[getMain] home=${homeHtml?.length} groups=${groupsJson?.length}',
      );
      if (homeHtml == null && groupsJson == null) {
        return Left(GetMainFailure(message: '게시판 목록 로드 실패'));
      }
      final Response<List<dynamic>> response = Response<List<dynamic>>(
        data: [homeHtml ?? '', groupsJson ?? ''],
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
    final Response<dynamic> response = await get(
      url,
      headers: headers,
      responseType: ResponseType.plain,
    );
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
  Future<Either<Failure, List<CommentItem>>> comments(
    ListItem item,
    BaseParser parser,
    int page,
  ) {
    throw UnimplementedError();
  }

  @override
  bool get supportsCommentWrite => true;

  /// `POST /api/v1/boards/{board}/posts/{id}/comments` 에 JSON
  /// `{content, parent_id}` 를 보낸다.
  ///
  /// 인증은 상세 `__data.json` 이 준 accessToken(Bearer) + 웹뷰 쿠키다.
  /// 토큰이 만료돼 401 이 오면 레이아웃 `__data.json` 에서 새로 받아 한 번만
  /// 다시 보낸다.
  @override
  Future<Either<Failure, Unit>> writeComment(
    CommentWrite write,
    BaseParser parser,
  ) => withSyncCookie(parser.baseUrl, () async {
    final Details details = write.details;
    if (!details.isLoggedIn) {
      return const Left(NotLoginFailure(message: '로그인이 필요해요.'));
    }
    final String url =
        '${parser.baseUrl}/api/v1/boards/${write.item.board}'
        '/posts/${write.item.id}/comments';
    final int? parentId = int.tryParse(write.parent?.commentId ?? '');
    final Map<String, dynamic> body = {
      'content': write.content,
      'parent_id': ?parentId,
    };

    Future<Response<dynamic>> send(String accessToken, String csrf) {
      final Map<String, String> headers = {
        'User-Agent': userAgent,
        'Accept': 'application/json',
        'Origin': parser.baseUrl,
        'Referer': '${parser.baseUrl}/${write.item.board}/${write.item.id}',
        if (accessToken.isNotEmpty) 'Authorization': 'Bearer $accessToken',
        if (csrf.isNotEmpty) 'X-CSRF-Token': csrf,
      };
      MoclLogger.d(
        () => '[writeComment] $url, ${MoclLogger.redactHeaders(headers)}',
      );
      return postUri(
        url,
        headers: headers,
        data: jsonEncode(body),
        contentType: Headers.jsonContentType,
        responseType: ResponseType.plain,
        validateStatus: (_) => true,
      );
    }

    Response<dynamic> response = await send(
      details.commentParams['accessToken'] ?? '',
      details.csrf,
    );
    if (response.statusCode == 401) {
      final (loggedIn, accessToken, csrf) = await _refreshAuth(parser.baseUrl);
      if (!loggedIn) {
        return const Left(NotLoginFailure(message: '로그인이 필요해요.'));
      }
      response = await send(accessToken, csrf);
    }
    MoclLogger.d(() => '[writeComment] response = ${response.statusCode}');

    final int status = response.statusCode ?? 0;
    if (status >= 200 && status < 300) return const Right(unit);
    if (status == 401) {
      return const Left(NotLoginFailure(message: '로그인이 필요해요.'));
    }
    final String message = _errorMessage(response.data);
    return Left(
      WriteCommentFailure(
        message: message.isNotEmpty ? message : '댓글을 쓰지 못했어요 (HTTP $status).',
      ),
    );
  });

  /// 쿠키를 실어 레이아웃 `__data.json` 을 다시 받아 새 토큰을 꺼낸다.
  Future<(bool, String, String)> _refreshAuth(String baseUrl) async {
    final response = await get(
      '$baseUrl/__data.json?x-sveltekit-invalidated=1',
      headers: const {},
      responseType: ResponseType.plain,
      validateStatus: (_) => true,
    );
    if (response.statusCode != 200) return (false, '', '');
    return DamoangParser.parseAuth(
      response.data is String ? response.data as String : '',
    );
  }

  /// `{"error": "..."}` · `{"error": {"message": "..."}}` · `{"message": "..."}`
  /// 어느 꼴이든 사람이 읽을 사유를 꺼낸다.
  static String _errorMessage(dynamic data) {
    try {
      final decoded = jsonDecode(data is String ? data : data.toString());
      if (decoded is! Map) return '';
      final error = decoded['error'];
      if (error is String) return error;
      if (error is Map && error['message'] is String) {
        return error['message'] as String;
      }
      final message = decoded['message'];
      return message is String ? message : '';
    } catch (_) {
      return '';
    }
  }
}
