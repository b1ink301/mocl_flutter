import 'package:shelf/shelf.dart';

/// 클라이언트 IP 별 간단한 고정 창 제한. 프로세스 하나라 메모리로 충분하다.
class RateLimiter({
  final int limit = 30,
  final Duration window = const Duration(minutes: 1),
  final DateTime Function() clock = DateTime.now,
}) {
  final Map<String, (int start, int count)> _hits = {};
  int _lastPrune = 0;

  /// 지금 기억하고 있는 IP 수(테스트용).
  int get trackedKeys => _hits.length;

  /// 허용하면 true.
  ///
  /// 창이 지난 기록은 창마다 한 번씩 지운다 — IP 를 [window] 넘게 들고 있지 않는다
  /// (개인정보처리방침: 요청 수 제한을 위해 1분 동안만 쓰고 폐기).
  bool allow(String key) {
    final int now = clock().millisecondsSinceEpoch;
    if (now - _lastPrune >= window.inMilliseconds) prune();
    final (int, int)? hit = _hits[key];
    if (hit == null || now - hit.$1 >= window.inMilliseconds) {
      _hits[key] = (now, 1);
      return true;
    }
    if (hit.$2 >= limit) return false;
    _hits[key] = (hit.$1, hit.$2 + 1);
    return true;
  }

  /// 세지 않고 이미 한도를 넘었는지만 본다.
  bool exceeded(String key) {
    final (int, int)? hit = _hits[key];
    if (hit == null) return false;
    final int now = clock().millisecondsSinceEpoch;
    return now - hit.$1 < window.inMilliseconds && hit.$2 >= limit;
  }

  /// 창이 지난 기록을 지운다. 요청이 없을 때도 지워지도록 서버가 주기적으로 부른다.
  void prune() {
    final int now = clock().millisecondsSinceEpoch;
    _hits.removeWhere((_, v) => now - v.$1 >= window.inMilliseconds);
    _lastPrune = now;
  }

  /// Caddy 뒤에서는 X-Forwarded-For 의 첫 값이 실제 클라이언트다.
  /// (Caddy 는 앞단 헤더를 신뢰하지 않고 자기가 본 주소로 채운다)
  static String clientKey(Request request) {
    final String? forwarded = request.headers['x-forwarded-for'];
    if (forwarded != null && forwarded.isNotEmpty) {
      return forwarded.split(',').first.trim();
    }
    final Object? info = request.context['shelf.io.connection_info'];
    return info?.toString() ?? 'unknown';
  }
}
