import 'dart:isolate';

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
