import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/domain/entities/last_id.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_user_info.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/base_ext.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/base_parser.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_client.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_message.dart';
import 'package:timeago/timeago.dart' as timeago;

class DamoangParser implements BaseParser {
  final bool isShowNickImage;

  const DamoangParser(this.isShowNickImage);

  @override
  SiteType get siteType => SiteType.damoang;

  @override
  String get baseUrl => 'https://damoang.net';

  @override
  Future<Either<Failure, List<MainItem>>> main(Response response) =>
      throw UnimplementedError('main');

  // ──────────────────────────────────────────────────────────────────
  // SvelteKit Devalue helpers
  // ──────────────────────────────────────────────────────────────────

  /// HTML 이스케이프된 미디어 태그(video, audio, iframe)를 디코딩합니다.
  /// 다모앙 서버가 video 등을 &lt;video&gt; 형태로 저장하는 경우 대응.
  static String _unescapeMediaTags(String html) {
    // &lt;video ... &gt; ... &lt;/video&gt; 패턴을 실제 태그로 변환
    return html.replaceAllMapped(
      RegExp(r'&lt;(/?(?:video|audio|source|iframe))\b([^&]*?)&gt;'),
      (m) => '<${m.group(1)}${m.group(2)!.replaceAll('&amp;', '&')}>',
    );
  }

  /// Parse newline-delimited JSON response from __data.json endpoint.
  static List<Map<String, dynamic>> _parseLines(String responseData) {
    final lines = responseData.trim().split('\n');
    return lines
        .where((line) => line.trim().isNotEmpty)
        .map((line) => jsonDecode(line) as Map<String, dynamic>)
        .toList();
  }

  /// Find a chunk with given id from the parsed lines.
  static List<dynamic>? _findChunkData(
    List<Map<String, dynamic>> lines,
    int chunkId,
  ) {
    for (final line in lines) {
      if (line['type'] == 'chunk' && line['id'] == chunkId) {
        return line['data'] as List<dynamic>;
      }
    }
    return null;
  }

  /// Find a data node whose root contains the given [key].
  static List<dynamic>? _findNodeDataByKey(
    List<Map<String, dynamic>> lines,
    String key,
  ) {
    final firstLine = lines.firstOrNull;
    if (firstLine == null || firstLine['type'] != 'data') return null;
    final nodes = firstLine['nodes'] as List<dynamic>?;
    if (nodes == null) return null;
    for (final node in nodes) {
      if (node is! Map || node['type'] != 'data') continue;
      final data = node['data'] as List<dynamic>?;
      if (data == null || data.isEmpty) continue;
      final root = data[0];
      if (root is Map && root.containsKey(key)) {
        return data;
      }
    }
    return null;
  }

  /// Resolve a devalue object at [index] in [data].
  /// Each object value is an index into the data array → replaced with the
  /// actual value at that position.
  static Map<String, dynamic> _resolveObject(List<dynamic> data, int index) {
    if (index < 0 || index >= data.length) return {};
    final obj = data[index];
    if (obj is! Map) return {};
    final result = <String, dynamic>{};
    for (final entry in obj.entries) {
      final key = entry.key as String;
      final valueIndex = entry.value;
      if (valueIndex is int && valueIndex >= 0 && valueIndex < data.length) {
        result[key] = data[valueIndex];
      } else {
        result[key] = valueIndex;
      }
    }
    return result;
  }

  /// Extract the board slug from the initial data line.
  static String _extractBoardSlug(List<Map<String, dynamic>> lines) {
    for (final line in lines) {
      if (line['type'] != 'data') continue;
      final nodes = line['nodes'] as List<dynamic>?;
      if (nodes == null) continue;
      for (final node in nodes) {
        if (node is! Map || node['type'] != 'data') continue;
        final nodeData = node['data'] as List<dynamic>?;
        if (nodeData == null || nodeData.isEmpty) continue;
        final nodeRoot = nodeData[0];
        if (nodeRoot is! Map || !nodeRoot.containsKey('boardId')) continue;
        final boardIdIndex = nodeRoot['boardId'];
        if (boardIdIndex is int &&
            boardIdIndex < nodeData.length &&
            nodeData[boardIdIndex] is String) {
          return nodeData[boardIdIndex] as String;
        }
      }
    }
    return '';
  }

  /// Find the post data node from the initial data line (detail pages).
  /// Looks for a node whose root object has a "post" field.
  static List<dynamic>? _findPostNodeData(List<Map<String, dynamic>> lines) {
    final firstLine = lines.firstOrNull;
    if (firstLine == null || firstLine['type'] != 'data') return null;
    final nodes = firstLine['nodes'] as List<dynamic>?;
    if (nodes == null) return null;
    for (final node in nodes) {
      if (node is! Map || node['type'] != 'data') continue;
      final data = node['data'] as List<dynamic>?;
      if (data == null || data.isEmpty) continue;
      final root = data[0];
      if (root is Map && root.containsKey('post')) {
        return data;
      }
    }
    return null;
  }

  // ──────────────────────────────────────────────────────────────────
  // Detail parsing
  // ──────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, Details>> detail(Response response) async {
    final responseData = response.data is String
        ? response.data as String
        : response.data.toString();
    final showNickImage = isShowNickImage;
    return Isolate.run(() => _parseDetail(responseData, showNickImage));
  }

  static Either<Failure, Details> _parseDetail(
    String responseData,
    bool isShowNickImage,
  ) {
    try {
      timeago.setLocaleMessages('ko', timeago.KoMessages());

      final lines = _parseLines(responseData);

      // 1. Extract post metadata from the initial data node
      final postNodeData = _findPostNodeData(lines);
      if (postNodeData == null) {
        return Left<Failure, Details>(
          GetDetailFailure(message: 'Post node data not found'),
        );
      }

      final rootMap = postNodeData[0] as Map;
      final postIndex = rootMap['post'];
      if (postIndex is! int) {
        return Left<Failure, Details>(
          GetDetailFailure(message: 'Post index not found'),
        );
      }

      final post = _resolveObject(postNodeData, postIndex);

      final String title = post['title'].toString();
      final String author = post['author'].toString();
      final String content = post['content'].toString();
      final int views = post['views'] as int? ?? 0;
      final int likes = post['likes'] as int? ?? 0;
      final String createdAt = post['created_at'].toString();

      final String viewCount = views.toString();
      final String likeCount = likes.toString();

      // Parse time
      String parsedTime = '';
      try {
        final dateTime = DateTime.parse(createdAt);
        parsedTime = timeago.format(dateTime, locale: 'ko');
      } catch (e) {
        parsedTime = createdAt;
      }

      // damoang has no nick images — always show author as text
      final info = BaseParser.parserInfo(false, author, parsedTime, viewCount);

      // 2. Get transformedPostContent from auxiliary chunk (id=1)
      //    This has plugins applied (emoticons, auto-embed, etc.)
      String bodyHtml = _unescapeMediaTags(content);
      final auxChunkData = _findChunkData(lines, 1);
      if (auxChunkData != null && auxChunkData.isNotEmpty) {
        final auxRoot = auxChunkData[0];
        if (auxRoot is Map) {
          final transformedIndex = auxRoot['transformedPostContent'];
          if (transformedIndex is int &&
              transformedIndex < auxChunkData.length &&
              auxChunkData[transformedIndex] is String) {
            bodyHtml = _unescapeMediaTags(
              auxChunkData[transformedIndex] as String,
            );
          }
        }
      }

      // 3. Extract comments
      //    commentsData may live in the same node as post OR a separate node,
      //    so search all nodes when the post node doesn't contain it.
      final List<CommentItem> comments = [];
      int totalComments = 0;

      List<dynamic>? commentsNodeData;
      int? commentsDataIndex;

      // Try post node first (legacy layout)
      final postCommentsIdx = rootMap['commentsData'];
      if (postCommentsIdx is int && postCommentsIdx < postNodeData.length) {
        commentsNodeData = postNodeData;
        commentsDataIndex = postCommentsIdx;
      }

      // Fallback: search all nodes for a 'commentsData' key
      if (commentsNodeData == null) {
        final found = _findNodeDataByKey(lines, 'commentsData');
        if (found != null && found.isNotEmpty && found[0] is Map) {
          final foundRoot = found[0] as Map;
          final idx = foundRoot['commentsData'];
          if (idx is int && idx < found.length) {
            commentsNodeData = found;
            commentsDataIndex = idx;
          }
        }
      }

      if (commentsNodeData != null && commentsDataIndex != null) {
        final commentsDataObj = commentsNodeData[commentsDataIndex];
        if (commentsDataObj is Map) {
          final commentsObjIndex = commentsDataObj['comments'];
          if (commentsObjIndex is int &&
              commentsObjIndex < commentsNodeData.length) {
            final commentsObjMap = commentsNodeData[commentsObjIndex];
            if (commentsObjMap is Map) {
              final totalIndex = commentsObjMap['total'];
              if (totalIndex is int &&
                  totalIndex < commentsNodeData.length) {
                totalComments =
                    commentsNodeData[totalIndex] as int? ?? 0;
              }
              final itemsIndex = commentsObjMap['items'];
              if (itemsIndex is int &&
                  itemsIndex < commentsNodeData.length &&
                  commentsNodeData[itemsIndex] is List) {
                final commentIndices =
                    commentsNodeData[itemsIndex] as List<dynamic>;
                int commentIdx = 0;
                for (final cIndex in commentIndices) {
                  if (cIndex is! int) continue;
                  final comment =
                      _resolveObject(commentsNodeData, cIndex);

                  final String cAuthor =
                      (comment['author'] ?? '').toString();
                  final String cAuthorImage =
                      (comment['author_image'] ?? '').toString();
                  final String cContent =
                      (comment['content'] ?? '').toString();
                  final int cLikes = (comment['likes'] is int)
                      ? comment['likes'] as int
                      : 0;
                  final int cDepth = (comment['depth'] is int)
                      ? comment['depth'] as int
                      : 0;
                  final String cCreatedAt =
                      (comment['created_at'] ?? '').toString();

                  String cParsedTime = '';
                  try {
                    final dateTime = DateTime.parse(cCreatedAt);
                    cParsedTime =
                        timeago.format(dateTime, locale: 'ko');
                  } catch (e) {
                    cParsedTime = cCreatedAt;
                  }

                  final String cInfo = '$cAuthorㆍ$cParsedTime';

                  comments.add(
                    CommentItem(
                      id: commentIdx++,
                      isReply: cDepth > 0,
                      bodyHtml: cContent,
                      likeCount:
                          cLikes > 0 ? cLikes.toString() : '',
                      mediaHtml: '',
                      isVideo: false,
                      time: cCreatedAt,
                      info: cInfo,
                      userInfo: UserInfo(
                        id: cAuthor,
                        nickName: cAuthor,
                        nickImage:
                            isShowNickImage ? cAuthorImage : '',
                      ),
                      authorId: '',
                    ),
                  );
                }
              }
            }
          }
        }
      } else {
        MoclLogger.log(
          '[DamoangParser] commentsData node not found in any data node',
        );
      }

      final detail = Details(
        title: title,
        viewCount: viewCount,
        likeCount: likeCount,
        csrf: '',
        time: createdAt,
        info: info,
        userInfo: UserInfo(id: author, nickName: author, nickImage: ''),
        comments: comments,
        bodyHtml: bodyHtml,
        extraData: totalComments > comments.length
            ? {'totalComments': totalComments}
            : null,
      );

      return Right<Failure, Details>(detail);
    } catch (e) {
      return Left<Failure, Details>(GetDetailFailure(message: e.toString()));
    }
  }

  // ──────────────────────────────────────────────────────────────────
  // List parsing
  // ──────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, List<ListItem>>> list(
    Response response,
    LastId lastId,
    String boardTitle,
    Future<List<int>> Function(SiteType, List<int>) isReads,
  ) async {
    try {
      final responseData = response.data is String
          ? response.data as String
          : response.data.toString();

      final items = await ParserIsolateClient.instance.parseList(
        siteType: siteType,
        responseData: responseData,
        lastId: lastId,
        boardTitle: boardTitle,
        baseUrl: baseUrl,
        isShowNickImage: isShowNickImage,
        isReads: isReads,
      );
      return Right(items);
    } catch (e) {
      return Left(GetListFailure(message: e.toString()));
    }
  }

  static Future<void> parseListInWorker(ParseListMessage message) async {
    final replyPort = message.replyPort;
    final String responseData = message.responseData as String;
    final lastId = message.lastId;
    final String boardTitle = message.boardTitle;
    final String baseUrl = message.baseUrl;
    // final isShowNickImage = message.isShowNickImage;

    final List<Map<String, dynamic>> parsedItems = <Map<String, dynamic>>[];
    final List<int> ids = <int>[];

    try {
      final lines = _parseLines(responseData);

      // Extract board slug from initial data (e.g. "free", "qa", ...)
      final String board = _extractBoardSlug(lines);

      // Find posts data from node with 'postsData' key
      final nodeData = _findNodeDataByKey(lines, 'postsData');
      if (nodeData == null || nodeData.isEmpty) {
        MoclLogger.log('[DamoangParser] postsData node not found');
        replyPort.send(<ListItem>[]);
        return;
      }

      final nodeRoot = nodeData[0] as Map;
      final postsDataIndex = nodeRoot['postsData'];
      if (postsDataIndex is! int || postsDataIndex >= nodeData.length) {
        MoclLogger.log('[DamoangParser] postsData index not found');
        replyPort.send(<ListItem>[]);
        return;
      }

      final postsDataObj = nodeData[postsDataIndex];
      if (postsDataObj is! Map) {
        MoclLogger.log('[DamoangParser] postsData is not a Map');
        replyPort.send(<ListItem>[]);
        return;
      }

      final postsIndex = postsDataObj['posts'];
      if (postsIndex is! int || postsIndex >= nodeData.length) {
        MoclLogger.log('[DamoangParser] Posts index not found');
        replyPort.send(<ListItem>[]);
        return;
      }

      final postIndices = nodeData[postsIndex];
      if (postIndices is! List) {
        MoclLogger.log('[DamoangParser] Posts array not found');
        replyPort.send(<ListItem>[]);
        return;
      }

      for (final pIndex in postIndices) {
        if (pIndex is! int) continue;

        final post = _resolveObject(nodeData, pIndex);

        final int id = (post['id'] is int) ? post['id'] as int : -1;
        if (id <= 0) continue;
        if (lastId > 0 && id >= lastId) {
          MoclLogger.log('[SKIP] id=$id, lastId=$lastId');
          continue;
        }

        // Skip notice posts
        if (post['is_notice'] == true) continue;

        final String title = (post['title'] ?? '').toString();
        final String author = (post['author'] ?? '').toString();
        final String authorId = (post['author_id'] ?? '').toString();
        final int commentsCount = (post['comments_count'] is int)
            ? post['comments_count'] as int
            : 0;
        final String createdAt = (post['created_at'] ?? '').toString();
        final int views = (post['views'] is int) ? post['views'] as int : 0;
        final int likes = (post['likes'] is int) ? post['likes'] as int : 0;
        final String thumbnail = (post['thumbnail'] ?? '').toString();
        final String category = (post['category'] ?? '').toString();

        final String url = '$baseUrl/$board/$id';
        final String reply = commentsCount.toString();

        // Parse time
        String parsedTime = '';
        try {
          final dateTime = DateTime.parse(createdAt);
          parsedTime = timeago.format(dateTime, locale: 'ko');
        } catch (e) {
          parsedTime = createdAt;
        }

        final String hit = views.toString();
        final String like = likes > 0 ? likes.toString() : '';

        // damoang has no nick images — always show author as text
        final String info = BaseParser.parserInfo(
          false,
          author,
          parsedTime,
          hit,
        );

        final Map<String, Object> parsedItem = {
          'id': id,
          'title': title,
          'reply': reply,
          'category': category,
          'time': createdAt,
          'info': info,
          'url': url,
          'board': board,
          'boardTitle': boardTitle,
          'like': like,
          'hit': hit,
          'userInfo': UserInfo(id: authorId, nickName: author, nickImage: ''),
          'hasImage': thumbnail.isNotEmpty,
        };

        parsedItems.add(parsedItem);
        ids.add(id);
      }
    } catch (e) {
      MoclLogger.log('[DamoangParser] Error parsing list: $e');
    }

    final ReceivePort readStatusPort = ReceivePort();
    replyPort.send(ReadStatusRequest(ids, readStatusPort.sendPort));
    final ReadStatusResponse readStatusResponse =
        await readStatusPort.first as ReadStatusResponse;
    readStatusPort.close();

    final List<ListItem> resultList = parsedItems
        .map(
          (item) => ListItem(
            id: item['id'],
            title: item['title'],
            reply: item['reply'],
            category: item['category'],
            time: item['time'],
            url: item['url'],
            info: item['info'],
            board: item['board'],
            boardTitle: item['boardTitle'],
            like: item['like'],
            hit: item['hit'],
            userInfo: item['userInfo'],
            hasImage: item['hasImage'],
            isRead: readStatusResponse.statuses.contains(item['id']),
          ),
        )
        .toList();

    replyPort.send(resultList);
  }

  // ──────────────────────────────────────────────────────────────────
  // Date parsing
  // ──────────────────────────────────────────────────────────────────

  static DateTime parseDateTime(String dateTimeString) {
    // ISO 8601 (e.g. "2026-03-13T11:04:59+09:00")
    try {
      return DateTime.parse(dateTimeString);
    } catch (_) {}

    // Korean format: "2026년 3월 12일 오후 03:10"
    final koreanDateRegex = RegExp(
      r'(\d{4})년\s*(\d{1,2})월\s*(\d{1,2})일\s*(오전|오후)\s*(\d{1,2}):(\d{2})',
    );
    final koreanMatch = koreanDateRegex.firstMatch(dateTimeString);
    if (koreanMatch != null) {
      final year = int.parse(koreanMatch.group(1)!);
      final month = int.parse(koreanMatch.group(2)!);
      final day = int.parse(koreanMatch.group(3)!);
      final isPm = koreanMatch.group(4) == '오후';
      var hour = int.parse(koreanMatch.group(5)!);
      final minute = int.parse(koreanMatch.group(6)!);
      if (isPm && hour < 12) hour += 12;
      if (!isPm && hour == 12) hour = 0;
      return DateTime(year, month, day, hour, minute);
    }

    // Legacy: "년.월.일 시:분" or "월.일 시:분"
    if (dateTimeString.contains(' ')) {
      final parts = dateTimeString.split(' ');
      final dateParts = parts[0].split('.');
      final timeParts = parts[1].split(':');
      if (dateParts.length == 3) {
        return DateTime(
          int.parse(dateParts[0]),
          int.parse(dateParts[1]),
          int.parse(dateParts[2]),
          int.parse(timeParts[0]),
          int.parse(timeParts[1]),
        );
      } else if (dateParts.length == 2) {
        final now = DateTime.now();
        return DateTime(
          now.year,
          int.parse(dateParts[0]),
          int.parse(dateParts[1]),
          int.parse(timeParts[0]),
          int.parse(timeParts[1]),
        );
      } else {
        throw Exception('Error parsing $dateTimeString');
      }
    } else if (dateTimeString.contains(':')) {
      final now = DateTime.now();
      final timeParts = dateTimeString.split(':');
      return DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(timeParts[0]),
        int.parse(timeParts[1]),
      );
    } else if (dateTimeString == '어제') {
      final now = DateTime.now();
      return now.subtract(const Duration(days: 1));
    } else {
      throw Exception('Error parsing $dateTimeString');
    }
  }

  // ──────────────────────────────────────────────────────────────────
  // URL builders
  // ──────────────────────────────────────────────────────────────────

  @override
  String urlByDetail(String url, String board, int id) =>
      '$baseUrl/$board/$id/__data.json?x-sveltekit-invalidated=1001';

  @override
  String urlByList(
    String url,
    String board,
    int page,
    SortType sortType,
    LastId lastId,
  ) =>
      '$url/__data.json?page=$page&x-sveltekit-invalidated=101${sortType.toQuery(siteType)}';

  @override
  String urlBySearchList(
    String url,
    String board,
    int page,
    String keyword,
    LastId lastId,
  ) =>
      '$url/__data.json?page=$page&sfl=wr_subject&sop=and&stx=$keyword&x-sveltekit-invalidated=101';

  @override
  String urlByMain() {
    throw UnimplementedError('urlByMain');
  }

  @override
  Future<Either<Failure, List<CommentItem>>> comments(Response response) {
    throw UnimplementedError();
  }

  @override
  String urlByComments(String url, String board, int id, int page) {
    throw UnimplementedError();
  }
}
