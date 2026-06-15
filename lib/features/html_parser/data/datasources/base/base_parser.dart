import 'dart:async';
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

abstract class BaseParser {
  abstract final SiteType siteType;
  abstract final String baseUrl;

  const BaseParser();

  String urlByMain() => throw UnimplementedError('urlByMain');

  String urlByList(
    String url,
    String board,
    int page,
    SortType sortType,
    LastId lastId,
  ) => throw UnimplementedError('urlByList');

  String urlBySearchList(
    String url,
    String board,
    int page,
    String keyword,
    LastId lastId,
  ) => throw UnimplementedError('urlBySearchList');

  String urlByDetail(String url, String board, int id) =>
      throw UnimplementedError('urlByDetail');

  String urlByComments(String url, String board, int id, int page) =>
      throw UnimplementedError('urlByComments');

  Future<Either<Failure, List<MainItem>>> main(Response<dynamic> response) =>
      throw UnimplementedError('main');

  Future<Either<Failure, List<ListItem>>> list(
    Response<dynamic> response,
    LastId lastId,
    String boardTitle,
    Future<List<int>> Function(SiteType, List<int>) isReads,
  );

  Future<Either<Failure, Details>> detail(Response<dynamic> response);

  Future<Either<Failure, List<CommentItem>>> comments(
    Response<dynamic> response,
  ) => throw UnimplementedError('comments');

  static String parserInfo(
    bool isShowNickImage,
    String nickName,
    String parsedTime,
    String viewCount,
  ) {
    var info = '';
    if (!isShowNickImage && nickName.isNotEmpty) {
      info = _truncateNickname(nickName);
    }
    if (parsedTime.isNotEmpty) {
      if (info.isNotEmpty) {
        info += "ㆍ$parsedTime";
      } else {
        info = parsedTime;
      }
    }
    if (viewCount.isNotEmpty) {
      if (info.isNotEmpty) {
        info += "ㆍ$viewCount 읽음";
      } else {
        info = "$viewCount 읽음";
      }
    }
    return info;
  }

  /// 닉네임을 표시 폭 기준으로 자른다.
  /// 한글(및 CJK)은 폭 2, 그 외 ASCII는 폭 1로 계산하여 총 폭 20을 넘지 않게 한다.
  /// 결과: 한글만 → 최대 10자, 영문만 → 최대 20자, 혼합도 비율에 따라 자연스럽게 처리.
  static String _truncateNickname(String nick) {
    const int maxWidth = 20;
    int width = 0;
    for (int i = 0; i < nick.length; i++) {
      final code = nick.codeUnitAt(i);
      final isWide =
          // 한글 음절 (가-힣)
          (code >= 0xAC00 && code <= 0xD7A3) ||
          // 한글 자모
          (code >= 0x1100 && code <= 0x11FF) ||
          (code >= 0x3130 && code <= 0x318F) ||
          // CJK 한자/일본어 등
          (code >= 0x3000 && code <= 0x33FF) ||
          (code >= 0x3400 && code <= 0x9FFF) ||
          (code >= 0xF900 && code <= 0xFAFF) ||
          // 전각 ASCII
          (code >= 0xFF00 && code <= 0xFF60);

      final charWidth = isWide ? 2 : 1;
      if (width + charWidth > maxWidth) {
        return '${nick.substring(0, i)}...';
      }
      width += charWidth;
    }
    return nick;
  }
}

class ReadStatusRequest {
  final List<int> ids;
  final SendPort responsePort;

  const ReadStatusRequest(this.ids, this.responsePort);
}

class ReadStatusResponse {
  final List<int> statuses;

  const ReadStatusResponse(this.statuses);
}

/// 워커에서 파싱한 [items] 의 id 들로 읽음 여부를 메인 isolate 에 질의하고,
/// 그 결과를 `isRead` 에 반영한 리스트를 [replyPort] 로 돌려준다.
///
/// 기존엔 각 파서가 `Map<String,dynamic>` 중간 표현으로 한 번 쌓았다가
/// 읽음 조회 후 `ListItem` 으로 다시 빌드하느라 필드를 두 번 나열했는데,
/// 이 헬퍼로 `ListItem` 을 바로 만들고 `copyWith(isRead:)` 만 적용하면 된다.
Future<void> sendListWithReadStatus(
  SendPort replyPort,
  List<ListItem> items,
) async {
  final List<int> ids = items.map((item) => item.id).toList();

  final ReceivePort readStatusPort = ReceivePort();
  replyPort.send(ReadStatusRequest(ids, readStatusPort.sendPort));
  final ReadStatusResponse response =
      await readStatusPort.first as ReadStatusResponse;
  readStatusPort.close();

  final Set<int> read = response.statuses.toSet();
  replyPort.send(
    items.map((item) => item.copyWith(isRead: read.contains(item.id))).toList(),
  );
}
