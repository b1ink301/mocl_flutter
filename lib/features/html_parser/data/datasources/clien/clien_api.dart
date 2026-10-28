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
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/base_parser.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_api.dart';

class const ClienApi(super.dio, super.userAgent) extends BaseApi {
  @override
  Future<Either<Failure, Details>> detail(
    ListItem item,
    BaseParser parser,
  ) => withSyncCookie(parser.baseUrl, () async {
    final String url = parser.urlByDetail(item.url, item.board, item.id);
    final Map<String, String> headers = {'User-Agent': userAgent};
    final Response<dynamic> response = await get(url, headers: headers);
    MoclLogger.d(
      () =>
          '[detail] $url, ${MoclLogger.redactHeaders(headers)} response = ${response.statusCode}',
    );
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
  ) => withSyncCookie<List<ListItem>>(item.url, () async {
    final String url = parser.urlByList(
      item.url,
      item.board,
      page,
      sortType,
      lastId,
    );
    final String host = Uri.parse(parser.baseUrl).host;
    final Map<String, String> headers = {'Host': host, 'User-Agent': userAgent};

    MoclLogger.d(
      () => '[getList] url=$url, headers=${MoclLogger.redactHeaders(headers)}',
    );
    final Response<dynamic> response = await get(url, headers: headers);

    return response.statusCode == 200
        ? parser.list(response, lastId, item.text, isReads)
        : Left(
            GetListFailure(
              message: 'response.statusCode = ${response.statusCode}',
            ),
          );
  });

  @override
  Future<Either<Failure, List<MainItem>>> main(BaseParser parser) =>
      withSyncCookie(parser.baseUrl, () async {
        final String url = parser.urlByMain();
        final Map<String, String> headers = {'User-Agent': userAgent};
        final Response<dynamic> response = await get(url, headers: headers);
        MoclLogger.d(() => '[getMain] $url response = ${response.statusCode}');
        return response.statusCode == 200
            ? parser.main(response)
            : Left(
                GetMainFailure(
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
  ) => withSyncCookie<List<ListItem>>(item.url, () async {
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
  Future<Either<Failure, List<CommentItem>>> comments(
    ListItem item,
    BaseParser parser,
    int page,
  ) => throw UnimplementedError();

  @override
  bool get supportsCommentWrite => true;

  /// 웹의 `app.commentWrite()` 와 같은 요청을 보낸다.
  ///
  /// `POST /service/api/board/{boardCd}/{boardSn}/comment/regist` 에
  /// `boardSn` 과 JSON 문자열 `param` 을 form 으로 싣고, 페이지의 CSRF 를
  /// `X-CSRF-TOKEN` 헤더로 넣는다. 로그인은 웹뷰 쿠키로 한다.
  @override
  Future<Either<Failure, Unit>> writeComment(
    CommentWrite write,
    BaseParser parser,
  ) => withSyncCookie(parser.baseUrl, () async {
    final Details details = write.details;
    if (!details.isLoggedIn) {
      return const Left(NotLoginFailure(message: '로그인이 필요해요.'));
    }
    final String boardCd = details.commentParams['boardCd'] ?? '';
    final String boardSn = details.commentParams['boardSn'] ?? '';
    if (boardCd.isEmpty || boardSn.isEmpty || details.csrf.isEmpty) {
      return const Left(
        WriteCommentFailure(message: '글 정보를 읽지 못했어요. 새로고침 후 다시 시도해 주세요.'),
      );
    }

    final CommentItem? parent = write.parent;
    final String reCommentSn = parent == null
        ? ''
        : (parent.isReply ? parent.parentCommentId : parent.commentId);
    final Map<String, dynamic> param = {
      'comment': _withMention(write.content, parent),
      'images': <dynamic>[],
      'articleRegister': details.commentParams['writer'] ?? '',
      if (reCommentSn.isNotEmpty) 'reCommentSn': int.tryParse(reCommentSn),
    };

    final String url =
        '${parser.baseUrl}/service/api/board/$boardCd/$boardSn/comment/regist';
    // 웹 요청(jQuery `$.ajax`)과 같은 헤더. Referer 는 글 주소로 맞춘다.
    final Map<String, String> headers = {
      'User-Agent': userAgent,
      'Accept': '*/*',
      'X-CSRF-TOKEN': details.csrf,
      'X-Requested-With': 'XMLHttpRequest',
      'Origin': parser.baseUrl,
      'Referer': '${parser.baseUrl}/service/board/$boardCd/$boardSn',
    };
    final Response<dynamic> response = await postUri(
      url,
      headers: headers,
      data: <String, dynamic>{'boardSn': boardSn, 'param': jsonEncode(param)},
      // charset 이 없으면 서버가 form 값을 ISO-8859-1 로 읽어 한글이 깨진다.
      contentType: '${Headers.formUrlEncodedContentType}; charset=UTF-8',
      responseType: ResponseType.plain,
      validateStatus: (_) => true,
    );
    MoclLogger.d(
      () =>
          '[writeComment] $url, ${MoclLogger.redactHeaders(headers)} response = ${response.statusCode}',
    );

    final int status = response.statusCode ?? 0;
    if (status >= 200 && status < 300) return const Right(unit);
    return Left(_writeFailure(status, response.data));
  });

  /// 대댓글이면 웹처럼 `｢@닉네임＊아이디＊님｣ ` 을 앞에 붙인다.
  /// 클리앙은 이 표기로 대상자에게 알림을 보내고 화면에 멘션으로 그린다.
  static String _withMention(String content, CommentItem? parent) {
    final String userId = parent?.userInfo.id ?? '';
    if (parent == null || userId.isEmpty) return content;
    final String nick = parent.userInfo.nickName.isEmpty
        ? userId
        : parent.userInfo.nickName;
    return '｢@$nick＊$userId＊님｣ $content';
  }

  static Failure _writeFailure(int status, dynamic body) {
    Map<String, dynamic>? json;
    try {
      final decoded = jsonDecode(body is String ? body : body.toString());
      if (decoded is Map<String, dynamic>) json = decoded;
    } catch (_) {}
    if (status == 401) {
      return const NotLoginFailure(message: '로그인이 필요해요.');
    }
    if (status == 403 && json?['result'] == 'EMAIL_NOT_VERIFIED') {
      return const WriteCommentFailure(
        message: '이메일 인증을 마친 뒤 댓글을 쓸 수 있어요. 브라우저에서 인증해 주세요.',
      );
    }
    final String message = (json?['message'] ?? '').toString();
    return WriteCommentFailure(
      message: message.isNotEmpty ? message : '댓글을 쓰지 못했어요 (HTTP $status).',
    );
  }

  //https://www.clien.net/service/board/articleWriterList/b1ink
  //https://www.clien.net/service/board/commentWriterList/b1ink
}
