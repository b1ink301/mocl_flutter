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

class const RedditApi(super.dio, super.userAgent) extends BaseApi {
  /// 레딧은 로그인하지 않으면 .json 엔드포인트를 401/403 으로 막는다.
  /// 예외로 던지지 않고 받아서 [NotLoginFailure] 로 바꾸기 위해 4xx 도 응답으로 받는다.
  Future<Response<dynamic>> _fetch(String url, Map<String, String> headers) =>
      get(
        url,
        headers: headers,
        validateStatus: (status) => status != null && status < 500,
      );

  /// 200 이 아닌 응답을 실패로 바꾼다. 401/403 은 로그인 필요로 본다.
  static Failure _failureOf(
    int? statusCode,
    Failure Function(String message) fallback,
  ) => statusCode == 401 || statusCode == 403
      ? const NotLoginFailure(message: '레딧에 로그인해야 볼 수 있어요.')
      : fallback('response.statusCode = $statusCode');

  @override
  Future<Either<Failure, Details>> detail(
    ListItem item,
    BaseParser parser,
  ) => withSyncCookie(parser.baseUrl, () async {
    final String url = parser.urlByDetail(item.url, item.board, item.id);
    final Map<String, String> headers = {'User-Agent': userAgent};

    final Response<dynamic> response = await _fetch(url, headers);
    MoclLogger.d(
      () =>
          '[detail] $url, ${MoclLogger.redactHeaders(headers)} response = ${response.statusCode}',
    );
    if (response.statusCode != 200) {
      return Left(
        _failureOf(
          response.statusCode,
          (message) => GetDetailFailure(message: message),
        ),
      );
    }
    await _expandMoreComments(response.data, item.url);
    return parser.detail(response);
  });

  /// 레딧 상세 응답은 많거나 깊은 댓글을 "more" 노드로 접어 둔다. 접힌 댓글을
  /// 받아 원본 JSON 트리에 다시 끼워 넣고, 파서는 완성된 트리를 그대로 파싱한다.
  /// (네트워크는 dio 가 있는 메인 isolate 에서만 할 수 있어 여기서 한다.)
  ///
  /// 접힌 댓글을 한꺼번에 주는 morechildren API 는 레딧이 막아 두어서(403) 쓰지
  /// 않고, 열리는 "댓글 하나 + 그 아래 스레드" 조회로 대신한다.
  ///  - 답글이 접혔으면("답글 N개 더" · "이 스레드 계속") 부모 댓글 스레드를 통째로
  ///    다시 받아 그 답글 목록을 바꿔 끼운다.
  ///  - 최상위 댓글이 접혔으면 접힌 댓글을 하나씩 받아 맨 아래에 붙인다.
  Future<void> _expandMoreComments(dynamic data, String postId36) async {
    try {
      if (data is! List || data.length < 2) return;

      final rootChildren = data[1]['data']['children'] as List<dynamic>;
      // 웹과 같은 순서로 받도록 상세가 쓴 정렬(커뮤니티 추천 정렬)을 그대로 쓴다.
      final post = (data[0]['data']['children'] as List<dynamic>).first['data'];
      final String sort =
          post['suggested_sort'] is String &&
              (post['suggested_sort'] as String).isNotEmpty
          ? post['suggested_sort'] as String
          : 'confidence';

      final more = _MoreComments({'t3_$postId36': rootChildren});
      more.index(rootChildren);

      var requests = 0;
      while (requests < _kMaxExpandRequests) {
        if (more.threadParents.isNotEmpty) {
          requests++;
          final String parent = more.threadParents.removeAt(0);
          final Map<String, dynamic>? node = await _fetchCommentNode(
            postId36,
            parent.substring(3),
            sort,
          );
          final List<dynamic>? target = more.containerOf[parent];
          final replies = node?['data']?['replies'];
          if (target == null || replies is! Map) continue;
          final List<dynamic> fresh =
              (replies['data']?['children'] as List<dynamic>?) ?? const [];
          // 이미 받은 답글까지 통째로 오므로 바꿔 끼운다. 그 아래에서 기다리던
          // 접힘은 새 트리를 다시 훑으며 새로 잡는다.
          more.forget(target);
          target
            ..clear()
            ..addAll(fresh);
          more.index(target);
          continue;
        }
        if (more.rootIds.isEmpty) break;

        final int count = (_kMaxExpandRequests - requests).clamp(0, 4);
        final batch = more.rootIds.take(count).toList();
        more.rootIds.removeRange(0, batch.length);
        requests += batch.length;
        final nodes = await Future.wait(
          batch.map((id) => _fetchCommentNode(postId36, id, sort)),
        );
        for (final node in nodes.whereType<Map<String, dynamic>>()) {
          rootChildren.add(node);
          more.index([node]);
        }
      }
    } catch (e) {
      MoclLogger.e('[detail] _expandMoreComments error', error: e);
    }
  }

  /// 접힌 댓글을 펼치려고 보내는 요청 수 상한(상세 한 번에).
  static const int _kMaxExpandRequests = 16;

  /// 댓글 [commentId36] 하나와 그 아래 스레드를 받는다(kind=t1 노드).
  Future<Map<String, dynamic>?> _fetchCommentNode(
    String postId36,
    String commentId36,
    String sort,
  ) async {
    try {
      final body = await _getJson(
        'https://api.reddit.com/comments/$postId36/_/$commentId36'
        '?sort=$sort&limit=500',
      );
      if (body is! List || body.length < 2) return null;
      final children = body[1]['data']['children'] as List<dynamic>;
      for (final child in children) {
        if (child is Map<String, dynamic> &&
            child['data']?['name'] == 't1_$commentId36') {
          return child;
        }
      }
      return null;
    } catch (e) {
      MoclLogger.e('[detail] _fetchCommentNode error', error: e);
      return null;
    }
  }

  Future<dynamic> _getJson(String url) async {
    final Map<String, String> headers = {'User-Agent': userAgent};
    final Response<dynamic> response = await _fetch(url, headers);
    if (response.statusCode != 200) return null;
    return response.data is String
        ? jsonDecode(response.data as String)
        : response.data;
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
      item.text,
      page,
      sortType,
      lastId,
    );
    final Map<String, String> headers = {'User-Agent': userAgent};
    final Response<dynamic> response = await _fetch(url, headers);
    MoclLogger.d(
      () =>
          '[getList] $url, ${MoclLogger.redactHeaders(headers)} response = ${response.statusCode}',
    );

    return response.statusCode == 200
        ? parser.list(response, lastId, item.text, isReads)
        : Left(
            _failureOf(
              response.statusCode,
              (message) => GetListFailure(message: message),
            ),
          );
  });

  /// 로그인한 계정이 구독한 커뮤니티 전체를 받는다(네이버카페의 "담은 카페"와 같은
  /// 방식). 한 번에 100개씩 `after` 커서로 넘기며 모은 뒤 파서에 한 Listing 으로 넘긴다.
  @override
  Future<Either<Failure, List<MainItem>>> main(
    BaseParser parser,
  ) => withSyncCookie(parser.baseUrl, () async {
    final Map<String, String> headers = {'User-Agent': userAgent};
    final List<dynamic> children = [];
    String after = '';

    for (var page = 0; page < 10; page++) {
      final String url =
          parser.urlByMain() + (after.isEmpty ? '' : '&after=$after');
      final Response<dynamic> response = await _fetch(url, headers);
      MoclLogger.d(
        () =>
            '[getMain] $url, ${MoclLogger.redactHeaders(headers)} response = ${response.statusCode}',
      );
      if (response.statusCode != 200) {
        return Left(
          _failureOf(
            response.statusCode,
            (message) => GetMainFailure(message: message),
          ),
        );
      }

      final dynamic body = response.data is String
          ? _tryDecode(response.data as String)
          : response.data;
      // 로그인 안 된 세션은 JSON 대신 로그인 페이지(HTML)로 돌려보내기도 한다.
      final dynamic data = (body is Map) ? body['data'] : null;
      if (data is! Map || data['children'] is! List) {
        MoclLogger.w(
          () =>
              '[getMain] 구독 목록이 아님: ${response.realUri} '
              '${response.headers.value('content-type')}',
        );
        return const Left(
          NotLoginFailure(message: '레딧에 로그인해야 구독 커뮤니티를 볼 수 있어요.'),
        );
      }
      children.addAll(data['children'] as List<dynamic>);
      after = data['after'] is String ? data['after'] as String : '';
      if (after.isEmpty) break;
    }

    return parser.main(
      Response<dynamic>(
        data: <String, dynamic>{
          'data': <String, dynamic>{'children': children},
        },
        statusCode: 200,
        requestOptions: RequestOptions(path: parser.urlByMain()),
      ),
    );
  });

  static dynamic _tryDecode(String text) {
    try {
      return jsonDecode(text);
    } on FormatException {
      return null;
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
    final Map<String, String> headers = {
      'Referer': item.url,
      'User-Agent': userAgent,
    };
    final Response<dynamic> response = await _fetch(url, headers);
    MoclLogger.d(
      () =>
          '[searchList] $url, ${MoclLogger.redactHeaders(headers)} response = ${response.statusCode}',
    );

    return response.statusCode == 200
        ? parser.list(response, lastId, item.text, isReads)
        : Left(
            _failureOf(
              response.statusCode,
              (message) => GetListFailure(message: message),
            ),
          );
  });

  @override
  Future<Either<Failure, List<CommentItem>>> comments(
    ListItem item,
    BaseParser parser,
    int page,
  ) => throw UnimplementedError();
}

/// 상세 댓글 트리에서 접힌 자리("more" 노드)를 찾아 펼칠 일감으로 모은다.
class _MoreComments(
  /// 부모 fullname(t3_ · t1_) → 그 자식 댓글이 담긴 List(트리에 끼워 넣을 자리).
  final Map<String, List<dynamic>> containerOf,
) {
  /// 답글이 접힌 부모 댓글(t1_ fullname). 스레드째 다시 받는다.
  final List<String> threadParents = [];

  /// 접힌 최상위 댓글 id(접두어 없음). 하나씩 받는다.
  final List<String> rootIds = [];

  /// [children] 을 훑어 t1 의 답글 자리를 등록하고 more 노드는 일감으로 옮긴 뒤
  /// 트리에서 뺀다(펼친 댓글로 채워질 자리라서).
  void index(List<dynamic> children) {
    children.removeWhere((child) {
      if (child is! Map) return false;
      final node = child['data'];
      if (node is! Map<String, dynamic>) return false;

      if (child['kind'] == 't1') {
        _register(node);
        return false;
      }
      if (child['kind'] != 'more') return false;

      final String parentId = node['parent_id']?.toString() ?? '';
      if (parentId.startsWith('t1_')) {
        if (!threadParents.contains(parentId)) threadParents.add(parentId);
      } else {
        final ids = (node['children'] as List<dynamic>?) ?? const [];
        rootIds.addAll(ids.map((e) => e.toString()));
      }
      return true;
    });
  }

  /// t1 노드의 답글 자리를 보장하고(없으면 빈 Listing) 등록한 뒤 아래를 훑는다.
  void _register(Map<String, dynamic> node) {
    final String? name = node['name']?.toString();
    if (name == null) return;

    var replies = node['replies'];
    if (replies is! Map<String, dynamic>) {
      replies = <String, dynamic>{
        'kind': 'Listing',
        'data': <String, dynamic>{'children': <dynamic>[]},
      };
      node['replies'] = replies;
    }
    final replyChildren = replies['data']['children'] as List<dynamic>;
    containerOf[name] = replyChildren;
    index(replyChildren);
  }

  /// [children] 아래 댓글들이 기다리던 스레드 일감을 지운다(곧 통째로 바뀐다).
  void forget(List<dynamic> children) {
    for (final child in children) {
      if (child is! Map) continue;
      final String? name = child['data']?['name']?.toString();
      if (name == null) continue;
      threadParents.remove(name);
      final List<dynamic>? replies = containerOf.remove(name);
      if (replies != null) forget(replies);
    }
  }
}
