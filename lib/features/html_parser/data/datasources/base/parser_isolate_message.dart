import 'dart:isolate';

import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';

class const ParseListMessage({
  required final SendPort replyPort,
  required final Object responseData,
  required final int lastId,
  required final String boardTitle,
  required final String baseUrl,
  required final bool isShowNickImage,
});

class const ParseListRequest(
  final SiteType siteType,
  final ParseListMessage message,
);

class const ParseListError(final String message);
