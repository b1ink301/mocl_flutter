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
import 'package:mocl_flutter/core/domain/entities/mocl_user_info.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_api.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../base/base_parser.dart';

class DamoangApi extends BaseApi {
  const DamoangApi(super.dio, super.userAgent);

  @override
  Future<Either<Failure, Details>> detail(ListItem item, BaseParser parser) =>
      withSyncCookie(parser.baseUrl, () async {
        final String url = parser.urlByDetail(item.url, item.board, item.id);
        final Map<String, String> headers = {};//{'User-Agent': userAgent};

        final Response response = await get(
          url,
          headers: headers,
          responseType: ResponseType.plain,
        );
        log('[detail] $url, $headers response = ${response.statusCode}');
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
        return detailResult.fold(
          (failure) => Left(failure),
          (detail) async {
            if (detail.comments.isNotEmpty) return Right(detail);

            final commentsUrl =
                '${parser.baseUrl}/api/v1/boards/${item.board}'
                '/posts/${item.id}/comments';
            try {
              final commentsResponse = await get(
                commentsUrl,
                headers: headers,
                responseType: ResponseType.plain,
              );
              if (commentsResponse.statusCode == 200) {
                final comments = _parseCommentsJson(
                  commentsResponse.data is String
                      ? commentsResponse.data as String
                      : commentsResponse.data.toString(),
                );
                if (comments.isNotEmpty) {
                  return Right(detail.copyWith(comments: comments));
                }
              }
            } catch (e) {
              MoclLogger.log('[DamoangApi] comments API error: $e');
            }
            return Right(detail);
          },
        );
      });

  /// Parse the JSON response from /api/v1/boards/.../comments.
  static List<CommentItem> _parseCommentsJson(String jsonStr) {
    try {
      timeago.setLocaleMessages('ko', timeago.KoMessages());
      final Map<String, dynamic> body = jsonDecode(jsonStr);
      final List<dynamic>? data = body['data'] as List<dynamic>?;
      if (data == null) return [];

      return data.asMap().entries.map((entry) {
        final i = entry.key;
        final c = entry.value as Map<String, dynamic>;

        final String author = (c['author'] ?? '').toString();
        final String authorId = (c['author_id'] ?? '').toString();
        final String content = (c['content'] ?? '').toString();
        final int likes = (c['likes'] is int) ? c['likes'] as int : 0;
        final int depth = (c['depth'] is int) ? c['depth'] as int : 0;
        final String createdAt = (c['created_at'] ?? '').toString();

        String parsedTime = '';
        try {
          parsedTime = timeago.format(DateTime.parse(createdAt), locale: 'ko');
        } catch (_) {
          parsedTime = createdAt;
        }

        return CommentItem(
          id: i,
          isReply: depth > 0,
          bodyHtml: content,
          likeCount: likes > 0 ? likes.toString() : '',
          mediaHtml: '',
          isVideo: false,
          time: createdAt,
          info: '$authorㆍ$parsedTime',
          userInfo: UserInfo(id: authorId, nickName: author, nickImage: ''),
          authorId: authorId,
        );
      }).toList();
    } catch (e) {
      MoclLogger.log('[DamoangApi] _parseCommentsJson error: $e');
      return [];
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
    final Map<String, String> headers = {};//{'User-Agent': userAgent};

    final Response response = await get(
      url,
      headers: headers,
      responseType: ResponseType.plain,
    );
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
    final Response response = await get(
      url,
      headers: headers,
      responseType: ResponseType.plain,
    );
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
