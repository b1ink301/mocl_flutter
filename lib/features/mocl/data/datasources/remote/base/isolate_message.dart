import 'dart:async';
import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/last_id.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/sort_type.dart';

class IsolateMessage<T> {
  final SendPort replyPort;
  final T responseData;
  final int lastId;
  final String boardTitle;
  final String baseUrl;

  const IsolateMessage(
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

  const ReadStatusRequest(this.ids, this.responsePort);
}

class ReadStatusResponse {
  final List<int> statuses;

  const ReadStatusResponse(this.statuses);
}
