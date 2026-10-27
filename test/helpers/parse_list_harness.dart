import 'dart:async';
import 'dart:isolate';

import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/base_parser.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_message.dart';

/// 각 파서의 static `parseListInWorker` 를 워커 isolate 없이 현재 isolate 에서
/// 실행한다. ReadStatusRequest 핸드셰이크는 [readIds] 로 응답한다.
/// 프로덕션의 ParserIsolateClient.parseList 와 동일한 메시지 규약을 따른다.
Future<List<ListItem>> runParseListWorker(
  Future<void> Function(ParseListMessage) worker, {
  required Object responseData,
  required String baseUrl,
  int lastId = -1,
  String boardTitle = '테스트보드',
  bool isShowNickImage = false,
  List<int> readIds = const [],
}) async {
  final ReceivePort replyPort = ReceivePort();
  final Completer<List<ListItem>> completer = Completer<List<ListItem>>();

  final StreamSubscription<dynamic> sub = replyPort.listen((dynamic message) {
    if (message is ReadStatusRequest) {
      message.responsePort.send(ReadStatusResponse(readIds));
    } else if (message is List<ListItem>) {
      if (!completer.isCompleted) completer.complete(message);
    } else if (message is List) {
      if (!completer.isCompleted) completer.complete(message.cast<ListItem>());
    } else if (message is ParseListError) {
      if (!completer.isCompleted) {
        completer.completeError(StateError(message.message));
      }
    }
  });

  try {
    await worker(
      ParseListMessage(
        replyPort: replyPort.sendPort,
        responseData: responseData,
        lastId: lastId,
        boardTitle: boardTitle,
        baseUrl: baseUrl,
        isShowNickImage: isShowNickImage,
      ),
    );
    return await completer.future.timeout(const Duration(seconds: 5));
  } finally {
    await sub.cancel();
    replyPort.close();
  }
}
