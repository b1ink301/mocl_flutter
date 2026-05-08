import 'dart:async';
import 'dart:isolate';

import 'package:mocl_flutter/core/domain/entities/last_id.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:mocl_flutter/features/html_parser/data/datasources/base/base_parser.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/parser_isolate_message.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/clien/clien_parser.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/damoang/damoang_parser.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/geek_news/geek_news_parser.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/meeco/meeco_parser.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/naver_cafe/naver_cafe_parser.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/reddit/reddit_parser.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/theqoo/theqoo_parser.dart';

typedef IsReadsFn = Future<List<int>> Function(SiteType, List<int>);

class ParserIsolateClient {
  ParserIsolateClient._();

  static final ParserIsolateClient instance = ParserIsolateClient._();

  Isolate? _isolate;
  SendPort? _workerSend;
  Future<SendPort>? _initFuture;

  Future<SendPort> _ensureWorker() {
    final existing = _workerSend;
    if (existing != null) return Future.value(existing);
    final pending = _initFuture;
    if (pending != null) return pending;

    final completer = Completer<SendPort>();
    _initFuture = completer.future;

    final initPort = ReceivePort();
    initPort.listen((message) {
      if (message is SendPort && !completer.isCompleted) {
        _workerSend = message;
        completer.complete(message);
        initPort.close();
      }
    });

    Isolate.spawn(_workerEntry, initPort.sendPort)
        .then((isolate) {
          _isolate = isolate;
          isolate.addOnExitListener(initPort.sendPort, response: 'exit');
        })
        .catchError((Object e, StackTrace st) {
          if (!completer.isCompleted) {
            completer.completeError(e, st);
          }
          _initFuture = null;
          initPort.close();
        });

    return completer.future;
  }

  Future<List<ListItem>> parseList({
    required SiteType siteType,
    required Object responseData,
    required LastId lastId,
    required String boardTitle,
    required String baseUrl,
    required bool isShowNickImage,
    required IsReadsFn isReads,
  }) async {
    final SendPort workerSend = await _ensureWorker();

    final ReceivePort replyPort = ReceivePort();
    final Completer<List<ListItem>> completer = Completer<List<ListItem>>();

    replyPort.listen((dynamic message) async {
      if (message is ReadStatusRequest) {
        final List<int> statuses = await isReads(siteType, message.ids);
        message.responsePort.send(ReadStatusResponse(statuses));
      } else if (message is List<ListItem>) {
        if (!completer.isCompleted) completer.complete(message);
        replyPort.close();
      } else if (message is List) {
        // 빈 List<dynamic> 등 type cast 안전망
        if (!completer.isCompleted) {
          completer.complete(message.cast<ListItem>());
        }
        replyPort.close();
      } else if (message is ParseListError) {
        if (!completer.isCompleted) {
          completer.completeError(StateError(message.message));
        }
        replyPort.close();
      }
    });

    workerSend.send(
      ParseListRequest(
        siteType,
        ParseListMessage(
          replyPort: replyPort.sendPort,
          responseData: responseData,
          lastId: lastId.intId,
          boardTitle: boardTitle,
          baseUrl: baseUrl,
          isShowNickImage: isShowNickImage,
        ),
      ),
    );

    return completer.future;
  }

  /// 테스트나 핫리스타트 시 명시적으로 워커를 재시작하고 싶을 때.
  void shutdown() {
    _isolate?.kill(priority: Isolate.immediate);
    _isolate = null;
    _workerSend = null;
    _initFuture = null;
  }
}

void _workerEntry(SendPort mainPort) {
  final ReceivePort cmdPort = ReceivePort();
  mainPort.send(cmdPort.sendPort);

  // timeago 한국어 메시지는 워커 isolate 생명주기 동안 한 번만 등록.
  timeago.setLocaleMessages('ko', timeago.KoMessages());

  cmdPort.listen((dynamic request) async {
    if (request is! ParseListRequest) return;
    final ParseListMessage msg = request.message;
    try {
      switch (request.siteType) {
        case SiteType.clien:
          await ClienParser.parseListInWorker(msg);
          break;
        case SiteType.damoang:
          await DamoangParser.parseListInWorker(msg);
          break;
        case SiteType.geekNews:
          await GeekNewsParser.parseListInWorker(msg);
          break;
        case SiteType.meeco:
          await MeecoParser.parseListInWorker(msg);
          break;
        case SiteType.naverCafe:
          await NaverCafeParser.parseListInWorker(msg);
          break;
        case SiteType.reddit:
          await RedditParser.parseListInWorker(msg);
          break;
        case SiteType.theqoo:
          await TheQooParser.parseListInWorker(msg);
          break;
        case SiteType.settings:
          msg.replyPort.send(
            const ParseListError('settings는 list 파싱 대상이 아닙니다.'),
          );
          break;
      }
    } catch (e, st) {
      MoclLogger.log('[ParserWorker] dispatch error: $e\n$st');
      msg.replyPort.send(ParseListError(e.toString()));
    }
  });
}
