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

abstract class const BaseParser() {
  abstract final SiteType siteType;
  abstract final String baseUrl;

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

  /// 메타 문자열을 만든다. 닉네임은 [UserInfo.nickName] 으로 UI 에서 별도 렌더하므로
  /// 여기서는 시간ㆍ조회수만 조합한다(닉네임 제외).
  static String parserInfo(String parsedTime, String viewCount) {
    var info = '';
    if (parsedTime.isNotEmpty) {
      info = parsedTime;
    }
    if (viewCount.isNotEmpty) {
      info = info.isNotEmpty ? "$infoㆍ$viewCount 읽음" : "$viewCount 읽음";
    }
    return info;
  }
}

class const ReadStatusRequest(final List<int> ids, final SendPort responsePort);

class const ReadStatusResponse(final List<int> statuses);

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
