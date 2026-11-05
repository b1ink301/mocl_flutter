import 'package:shelf/shelf.dart';

/// 클라이언트 IP 별 간단한 고정 창 제한. 프로세스 하나라 메모리로 충분하다.
class RateLimiter({
  final int limit = 30,
  final Duration window = const Duration(minutes: 1),
  final DateTime Function() clock = DateTime.now,
}) {
  final Map<String, (int start, int count)> _hits = {};

  /// 허용하면 true.
  bool allow(String key) {
    final int now = clock().millisecondsSinceEpoch;
    if (_hits.length > 10000) {
      _hits.removeWhere((_, v) => now - v.$1 >= window.inMilliseconds);
    }
    final (int, int)? hit = _hits[key];
    if (hit == null || now - hit.$1 >= window.inMilliseconds) {
      _hits[key] = (now, 1);
      return true;
    }
    if (hit.$2 >= limit) return false;
    _hits[key] = (hit.$1, hit.$2 + 1);
    return true;
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
