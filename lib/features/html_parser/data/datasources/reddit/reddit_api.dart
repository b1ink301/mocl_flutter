import 'dart:convert';
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

class const RedditApi(super.dio, super.userAgent) extends BaseApi {
  @override
  Future<Either<Failure, Details>> detail(ListItem item, BaseParser parser) =>
      withSyncCookie(parser.baseUrl, () async {
        final String url = parser.urlByDetail(item.url, item.board, item.id);
        final Map<String, String> headers = {'User-Agent': userAgent};

        final Response<dynamic> response = await get(url, headers: headers);
        log('[detail] $url, $headers response = ${response.statusCode}');
        if (response.statusCode != 200) {
          return Left(
            GetDetailFailure(
              message: 'response.statusCode = ${response.statusCode}',
            ),
          );
        }
        await _expandMoreComments(response.data, item.url);
        return parser.detail(response);
      });

  /// Reddit 상세 .json 응답은 깊거나 많은 댓글을 "more"(load-more) 노드로 접어둔다.
  /// 네트워크는 dio 가 있는 메인 isolate 에서만 가능하므로, 여기서 morechildren API
  /// 로 접힌 댓글을 받아와 원본 JSON 트리에 parent_id 기준으로 다시 끼워 넣는다.
  /// 이후 파서는 수정 없이 완성된 트리를 그대로 파싱한다.
  Future<void> _expandMoreComments(dynamic data, String postId36) async {
    try {
      if (data is! List || data.length < 2) return;

      final rootChildren = data[1]['data']['children'] as List<dynamic>;
      final String linkFullname = 't3_$postId36';

      // parent fullname -> 그 자식 댓글을 담는 List (트리에 splice 할 위치)
      final Map<String, List<dynamic>> containerOf = {
        linkFullname: rootChildren,
      };
      final List<String> pendingIds = [];

      _indexChildren(rootChildren, containerOf, pendingIds);

      var requests = 0;
      while (pendingIds.isNotEmpty && requests < 15) {
        final batch = pendingIds.take(100).toList();
        pendingIds.removeRange(0, batch.length);
        requests++;

        final things = await _fetchMoreChildren(linkFullname, batch);
        for (final thing in things) {
          if (thing is! Map) continue;
          final kind = thing['kind'];
          final node = thing['data'];
          if (node is! Map<String, dynamic>) continue;

          if (kind == 't1') {
            _ensureReplies(node, containerOf, pendingIds);
            final parentId = node['parent_id']?.toString();
            final target = containerOf[parentId] ?? rootChildren;
            target.add(thing);
          } else if (kind == 'more') {
            final ids = (node['children'] as List<dynamic>?) ?? const [];
            pendingIds.addAll(ids.map((e) => e.toString()));
          }
        }
      }
    } catch (e) {
      log('[detail] _expandMoreComments error = $e');
    }
  }

  /// 자식 목록을 순회하며 t1 은 replies 를 등록하고, more 노드는 id 를 수집한 뒤
  /// 트리에서 제거한다(접힌 자리는 펼쳐진 댓글로 채워질 것이므로).
  static void _indexChildren(
    List<dynamic> children,
    Map<String, List<dynamic>> containerOf,
    List<String> pendingIds,
  ) {
    children.removeWhere((child) {
      if (child is! Map) return false;
      final kind = child['kind'];
      final node = child['data'];
      if (node is! Map<String, dynamic>) return false;

      if (kind == 't1') {
        _ensureReplies(node, containerOf, pendingIds);
        return false;
      }
      if (kind == 'more') {
        final ids = (node['children'] as List<dynamic>?) ?? const [];
        pendingIds.addAll(ids.map((e) => e.toString()));
        return true;
      }
      return false;
    });
  }

  /// t1 노드의 replies 컨테이너를 보장하고(없으면 빈 Listing 으로 정규화) 등록한 뒤
  /// 하위 트리를 재귀적으로 인덱싱한다.
  static void _ensureReplies(
    Map<String, dynamic> node,
    Map<String, List<dynamic>> containerOf,
    List<String> pendingIds,
  ) {
    final name = node['name']?.toString();
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
    _indexChildren(replyChildren, containerOf, pendingIds);
  }

  /// morechildren API 로 접힌 댓글들을 flat list(things)로 받아온다.
  Future<List<dynamic>> _fetchMoreChildren(
    String linkFullname,
    List<String> ids,
  ) async {
    try {
      final url =
          'https://www.reddit.com/api/morechildren.json'
          '?api_type=json&link_id=$linkFullname'
          '&children=${ids.join(',')}&limit_children=false';
      final Map<String, String> headers = {'User-Agent': userAgent};
      final Response<dynamic> response = await get(url, headers: headers);
      if (response.statusCode != 200) return const [];

      final body = response.data is String
          ? jsonDecode(response.data as String)
          : response.data;
      final things = body['json']?['data']?['things'];
      return things is List<dynamic> ? things : const [];
    } catch (e) {
      log('[detail] _fetchMoreChildren error = $e');
      return const [];
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
      item.text,
      page,
      sortType,
      lastId,
    );
    final String host = Uri.parse(parser.baseUrl).host;
    final Map<String, String> headers = {'Host': host, 'User-Agent': userAgent};
    final Response<dynamic> response = await get(url, headers: headers);
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
  Future<Either<Failure, List<MainItem>>> main(BaseParser parser) =>
      withSyncCookie(parser.baseUrl, () async {
        final String url = parser.urlByMain();
        final Map<String, String> headers = {
          'User-Agent': userAgent,
          'Host': 'www.reddit.com',
        };
        final Response<dynamic> response = await get(url, headers: headers);
        log('[getMain] $url, $headers response = ${response.statusCode}');
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
    log('[searchList] $url, $headers response = ${response.statusCode}');

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
}
