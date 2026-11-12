import 'dart:async';

import 'package:flutter/services.dart';
import 'package:mocl_shared/util/mocl_logger.dart';

/// 다른 앱에서 "공유" 로 보낸 글자를 받는다. Android 의 `ShareChannel.kt` 와 짝.
///
/// iOS 는 공유 확장(Share Extension)이 없어 받지 않는다 — 채널이 없으면
/// [takeInitial] 은 null, [onShared] 는 아무것도 내보내지 않는다.
class SharedTextChannel() {
  static const MethodChannel _channel = MethodChannel('net.b1ink.mocl/share');

  final StreamController<String> _shared = StreamController<String>.broadcast(
    sync: false,
  );

  /// 앱이 떠 있는 동안 받은 공유.
  Stream<String> get onShared => _shared.stream;

  /// 듣기 시작한다. [takeInitial] 보다 먼저 불러야 사이에 온 공유를 놓치지 않는다.
  void listen() {
    _channel.setMethodCallHandler((MethodCall call) async {
      if (call.method == 'onShared' && call.arguments is String) {
        _shared.add(call.arguments as String);
      }
      return null;
    });
  }

  /// 앱을 켠 공유(꺼져 있다가 공유로 켜졌을 때). 한 번만 돌려준다.
  Future<String?> takeInitial() async {
    try {
      return await _channel.invokeMethod<String>('takeInitial');
    } on MissingPluginException {
      return null;
    } on PlatformException catch (e) {
      MoclLogger.w(() => '[share] takeInitial 실패: ${e.code}');
      return null;
    }
  }

  void dispose() {
    _channel.setMethodCallHandler(null);
    unawaited(_shared.close());
  }
}
