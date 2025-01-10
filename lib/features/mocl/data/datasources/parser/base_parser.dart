import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

abstract class BaseParser {
  abstract final SiteType siteType;
  abstract final String baseUrl;

  Either<Failure, List<MainItem>> main(
    Response response,
  ) =>
      Left(GetMainFailure(message: 'UnimplementedError()!'));

  Future<Either<Failure, List<ListItem>>> list(
    Response response,
    int lastId,
    String boardTitle,
    Future<List<int>> Function(SiteType, List<int>) isReads,
  );

  Future<Either<Failure, Details>> detail(Response response);

  Future<Result> comment(Response response);

  static String covertUrl(
    String baseUrl,
    String path,
  ) =>
      path.isNotEmpty && !path.startsWith("http") ? '$baseUrl$path' : path;

  static String parserInfo(
    String nickName,
    String parsedTime,
    String viewCount,
  ) {
    var info = '';
    if (nickName.isNotEmpty) {
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

  IsolateMessage(
    this.replyPort,
    this.responseData,
    this.lastId,
    this.boardTitle,
    this.baseUrl,
  );
}

class ReadStatusRequest {
  final List<int> ids;
  final SendPort responsePort;

  ReadStatusRequest(this.ids, this.responsePort);
}

class ReadStatusResponse {
  final List<int> statuses;

  ReadStatusResponse(this.statuses);
}
