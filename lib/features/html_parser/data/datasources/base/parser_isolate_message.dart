import 'dart:isolate';

import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';

class ParseListMessage {
  final SendPort replyPort;
  final Object responseData;
  final int lastId;
  final String boardTitle;
  final String baseUrl;
  final bool isShowNickImage;

  const ParseListMessage({
    required this.replyPort,
    required this.responseData,
    required this.lastId,
    required this.boardTitle,
    required this.baseUrl,
    required this.isShowNickImage,
  });
}

class ParseListRequest {
  final SiteType siteType;
  final ParseListMessage message;

  const ParseListRequest(this.siteType, this.message);
}

class ParseListError {
  final String message;

  const ParseListError(this.message);
}
