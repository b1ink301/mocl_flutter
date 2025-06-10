import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/last_id.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/sort_type.dart';

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

  Future<Either<Failure, List<MainItem>>> main(Response response) =>
      throw UnimplementedError('main');

  Future<Either<Failure, List<ListItem>>> list(
    Response response,
    LastId lastId,
    String boardTitle,
    Future<List<int>> Function(SiteType, List<int>) isReads,
  );

  Future<Either<Failure, Details>> detail(Response response);

  Future<Either<Failure, List<CommentItem>>> comments(Response response);

  static String parserInfo(
    bool isShowNickImage,
    String nickName,
    String parsedTime,
    String viewCount,
  ) {
    var info = '';
    if (!isShowNickImage && nickName.isNotEmpty) {
      info = nickName;
    }
    if (parsedTime.isNotEmpty) {
      if (info.isNotEmpty) {
        info += " ・ $parsedTime";
      } else {
        info = parsedTime;
      }
    }
    if (viewCount.isNotEmpty) {
      if (info.isNotEmpty) {
        info += " ・ $viewCount 읽음";
      } else {
        info = "$viewCount 읽음";
      }
    }
    return info;
  }
}

class IsolateMessage<T> {
  final SendPort replyPort;
  final T responseData;
  final int lastId;
  final String boardTitle;
  final String baseUrl;
  final bool isShowNickImage;

  const IsolateMessage(
    this.replyPort,
    this.responseData,
    this.lastId,
    this.boardTitle,
    this.baseUrl,
    this.isShowNickImage,
  );
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
