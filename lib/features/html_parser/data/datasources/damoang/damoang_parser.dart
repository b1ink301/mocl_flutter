import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:html/parser.dart';
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

class DamoangParser extends BaseParser {
  final bool isShowNickImage;

  const DamoangParser(this.isShowNickImage);

  @override
  SiteType get siteType => SiteType.damoang;

  @override
  String get baseUrl => 'https://damoang.net';

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
  // Attachments
  // ──────────────────────────────────────────────────────────────────

  /// post 의 videos / downloads / link1 / link2 를 본문 뒤에 붙일 HTML 로 변환.
  /// 첨부가 없으면 빈 문자열.
  static String _buildAttachmentsHtml(
    Map<String, dynamic> post,
    List<dynamic> postNodeData,
  ) {
    final List<Map<String, String>> files = [];

    void collect(dynamic indexList) {
      if (indexList is! List) return;
      for (final idx in indexList) {
        if (idx is! int || idx < 0 || idx >= postNodeData.length) continue;
        final resolved = _resolveObject(postNodeData, idx);
        final url = (resolved['url'] ?? '').toString();
        if (url.isEmpty) continue;
        final filename = (resolved['filename'] ?? '').toString();
        final size = resolved['size'];
        files.add({
          'url': url,
          'filename': filename.isEmpty ? url.split('/').last : filename,
          'size': (size is int && size > 0) ? _formatBytes(size) : '',
        });
      }
    }

    collect(post['videos']);
    collect(post['downloads']);

    // URL 기준 dedupe — videos 와 downloads 는 동일 파일을 가리키는 경우가 많음
    final Map<String, Map<String, String>> uniqueByUrl = {};
    for (final f in files) {
      uniqueByUrl.putIfAbsent(f['url']!, () => f);
    }

    // 외부 링크 (link1, link2)
    final List<String> externalLinks = [];
    for (final key in const ['link1', 'link2']) {
      final v = (post[key] ?? '').toString().trim();
      if (v.isNotEmpty) externalLinks.add(v);
    }

    if (uniqueByUrl.isEmpty && externalLinks.isEmpty) return '';

    final buf = StringBuffer();

    if (uniqueByUrl.isNotEmpty) {
      buf.write('<hr><p><b>📎 첨부파일</b></p>');
      for (final f in uniqueByUrl.values) {
        final url = f['url']!;
        final name = f['filename']!;
        final size = f['size']!;
        final label = size.isEmpty ? name : '$name ($size)';
        final lower = url.toLowerCase();
        if (lower.endsWith('.mp4') ||
            lower.endsWith('.webm') ||
            lower.endsWith('.mov') ||
            lower.endsWith('.m4v')) {
          buf.write('<p><video controls src="$url"></video></p>');
          buf.write('<p><a href="$url">$label</a></p>');
        } else if (lower.endsWith('.jpg') ||
            lower.endsWith('.jpeg') ||
            lower.endsWith('.png') ||
            lower.endsWith('.gif') ||
            lower.endsWith('.webp')) {
          buf.write('<p><img src="$url" alt="$name"></p>');
          buf.write('<p><a href="$url">$label</a></p>');
        } else {
          buf.write('<p><a href="$url">$label</a></p>');
        }
      }
    }

    if (externalLinks.isNotEmpty) {
      buf.write('<hr><p><b>🔗 링크</b></p>');
      for (final url in externalLinks) {
        buf.write('<p><a href="$url">$url</a></p>');
      }
    }

    return buf.toString();
  }

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)}KB';
    }
    if (bytes < 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(1)}MB';
    }
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)}GB';
  }

  // ──────────────────────────────────────────────────────────────────
  // Detail parsing
  // ──────────────────────────────────────────────────────────────────

  @override
  Future<Either<Failure, Details>> detail(Response<dynamic> response) async {
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
      final info = BaseParser.parserInfo(parsedTime, viewCount);

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

      // 2-1. 첨부파일 / 외부 링크 추가
      //      transformedPostContent 에는 본문 텍스트만 들어가고,
      //      에디터로 업로드된 첨부(videos/downloads)와 link1/link2 가
      //      누락되므로 본문 뒤에 명시적으로 append.
      final String attachmentsHtml = _buildAttachmentsHtml(post, postNodeData);
      if (attachmentsHtml.isNotEmpty) {
        bodyHtml = '$bodyHtml$attachmentsHtml';
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
              if (totalIndex is int && totalIndex < commentsNodeData.length) {
                totalComments = commentsNodeData[totalIndex] as int? ?? 0;
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
                  final comment = _resolveObject(commentsNodeData, cIndex);

                  final String cAuthor = (comment['author'] ?? '').toString();
                  final String cAuthorImage = (comment['author_image'] ?? '')
                      .toString();
                  final String cContent = (comment['content'] ?? '').toString();
                  final int cLikes = (comment['likes'] is int)
                      ? comment['likes'] as int
                      : 0;
                  final int cDepth = (comment['depth'] is int)
                      ? comment['depth'] as int
                      : 0;
                  final String cCreatedAt = (comment['created_at'] ?? '')
                      .toString();

                  String cParsedTime = '';
                  try {
                    final dateTime = DateTime.parse(cCreatedAt);
                    cParsedTime = timeago.format(dateTime, locale: 'ko');
                  } catch (e) {
                    cParsedTime = cCreatedAt;
                  }

                  final String cInfo = cParsedTime;

                  comments.add(
                    CommentItem(
                      id: commentIdx++,
                      isReply: cDepth > 0,
                      bodyHtml: cContent,
                      likeCount: cLikes > 0 ? cLikes.toString() : '',
                      mediaHtml: '',
                      isVideo: false,
                      time: cCreatedAt,
                      info: cInfo,
                      userInfo: UserInfo(
                        id: cAuthor,
                        nickName: cAuthor,
                        nickImage: isShowNickImage ? cAuthorImage : '',
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
    Response<dynamic> response,
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

    final List<ListItem> items = <ListItem>[];

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
        final String info = BaseParser.parserInfo(parsedTime, hit);

        items.add(
          ListItem(
            id: id,
            title: title,
            reply: reply,
            category: category,
            time: createdAt,
            info: info,
            url: url,
            board: board,
            boardTitle: boardTitle,
            like: like,
            hit: hit,
            userInfo: UserInfo(id: authorId, nickName: author, nickImage: ''),
            hasImage: thumbnail.isNotEmpty,
            isRead: false,
          ),
        );
      }
    } catch (e) {
      MoclLogger.log('[DamoangParser] Error parsing list: $e');
    }

    await sendListWithReadStatus(replyPort, items);
  }

  // ──────────────────────────────────────────────────────────────────
  // Date parsing
  // ──────────────────────────────────────────────────────────────────

  // ──────────────────────────────────────────────────────────────────
  // URL builders
  // ──────────────────────────────────────────────────────────────────

  @override
  String urlByDetail(String url, String board, int id) =>
      '$baseUrl/$board/$id/__data.json?x-sveltekit-invalidated=1001';

  @override
  String urlByMain() => 'https://damoang.net/';

  /// 다모앙 게시판 목록을 구성한다. [DamoangApi] 가 `[홈HTML, 소모임JSON]`을 넘긴다.
  /// - 일반 게시판: 홈(Svelte) 사이드바의 `/{slug}` 링크 중 이름이 단축키 문자로
  ///   끝나는 것(예: "자유게시판 F")만 추림 → 상점/포인트 등 기능 링크 제외.
  /// - 소모임: `/groups/__data.json` 의 `"슬러그","이름당"` 쌍(이름이 "~당").
  @override
  Future<Either<Failure, List<MainItem>>> main(Response<dynamic> response) {
    final dynamic data = response.data;
    return Isolate.run(() => _parseMain(data));
  }

  // static final RegExp _boardName = RegExp(r'^(.*)\s([A-Z])$');
  static final RegExp _groupPair = RegExp(
    r'"([a-z][a-z0-9_]{1,20})","([^"]{1,16}당)"',
  );

  static Either<Failure, List<MainItem>> _parseMain(dynamic data) {
    MoclLogger.log('_parseMain data=${data.runtimeType}');
    String homeHtml = '';
    String groupsJson = '';
    if (data is List) {
      MoclLogger.log('_parseMain #2 data=${data.length}');
      homeHtml = data.isNotEmpty ? (data[0] as String? ?? '') : '';
      groupsJson = data.length > 1 ? (data[1] as String? ?? '') : '';
    } else if (data is String) {
      homeHtml = data;
    }

    final items = <MainItem>[];
    final seen = <String>{};
    var orderBy = 0;

    // 일반 게시판(홈 사이드바)
    if (homeHtml.isNotEmpty) {
      final document = parse(homeHtml);
      for (final nav in document.querySelectorAll('nav')) {
        for (final a in nav.querySelectorAll('a[href]')) {
          MoclLogger.log('_parseMain a=${a.outerHtml}');
          final href = a.attributes['href']?.trim() ?? '';
          final slug = RegExp(r'^/([a-z0-9_]+)$').firstMatch(href)?.group(1);
          if (slug == null || !seen.add(slug)) continue;
          final name = a.text;

          items.add(
            MainItem(
              siteType: SiteType.damoang,
              board: slug,
              text: name,
              url: 'https://damoang.net/$slug',
              orderBy: orderBy++,
              category: '게시판',
            ),
          );
        }
      }

      // for (final a in document.querySelectorAll('a[href]')) {
      //   final href = a.attributes['href']?.trim() ?? '';
      //   final slug = RegExp(r'^/([a-z0-9_]+)$').firstMatch(href)?.group(1);
      //   if (slug == null || !seen.add(slug)) continue;
      //   final raw = a.text.trim();
      //   final match = _boardName.firstMatch(raw);
      //   if (match == null) continue;
      //   final name = match.group(1)!.trim();
      //   if (name.isEmpty || name.length > 20) continue;
      //   items.add(
      //     MainItem(
      //       siteType: SiteType.damoang,
      //       board: slug,
      //       text: name,
      //       url: 'https://damoang.net/$slug',
      //       orderBy: orderBy++,
      //       category: '게시판',
      //     ),
      //   );
      // }
    }

    // 소모임(/groups/__data.json)
    for (final m in _groupPair.allMatches(groupsJson)) {
      final slug = m.group(1)!;
      if (!seen.add(slug)) continue;
      final name = m.group(2)!.trim();
      items.add(
        MainItem(
          siteType: SiteType.damoang,
          board: slug,
          text: name,
          url: 'https://damoang.net/$slug',
          orderBy: orderBy++,
          category: '소모임',
        ),
      );
    }

    if (items.isEmpty) {
      return Left(GetMainFailure(message: '게시판 목록을 찾지 못했습니다.'));
    }
    return Right(items);
  }

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
}
