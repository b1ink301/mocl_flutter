import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/remote_config/remote_config.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';

import '../config_store.dart';
import '../rate_limiter.dart';
import '../server_log.dart';
import 'admin_page.dart';
import 'config_history.dart';

const int _maxBodyBytes = 64 * 1024;

const Map<String, String> _jsonHeaders = {
  'content-type': 'application/json; charset=utf-8',
  // 설정 · 상태는 캐시에 남기지 않는다.
  'cache-control': 'no-store',
};

/// 관리자 토큰. `.env` 의 `ADMIN_TOKEN`(32자 이상). 짧거나 없으면 관리 화면을 열지 않는다.
class AdminAuth._(final List<int> _digest) {
  static const int minLength = 32;

  static AdminAuth? fromToken(String? token) {
    final String value = token?.trim() ?? '';
    if (value.length < minLength) return null;
    return AdminAuth._(sha256.convert(utf8.encode(value)).bytes);
  }

  /// `Authorization: Bearer {토큰}` 이 맞는지. 길이 · 내용과 상관없이 같은 시간에 비교한다.
  bool check(String? header) {
    if (header == null || !header.startsWith('Bearer ')) return false;
    final List<int> given = sha256
        .convert(utf8.encode(header.substring(7).trim()))
        .bytes;
    int diff = 0;
    for (int i = 0; i < _digest.length; i++) {
      diff |= _digest[i] ^ given[i];
    }
    return diff == 0;
  }
}

/// 관리 화면(`/admin`)과 그 API(`/admin/api/*`).
///
/// - 화면(HTML)은 비밀이 없어 누구나 받을 수 있고, API 는 모두 관리자 토큰을 요구한다.
/// - 쿠키를 쓰지 않고 헤더로만 인증하므로 다른 사이트가 대신 요청을 보낼 수 없다(CSRF).
/// - 토큰이 틀린 요청은 IP 당 1분에 [failLimit] 번까지만 받는다(그 뒤 429).
class AdminRoutes({
  required final ConfigStore configs,
  required final AdminAuth auth,
  required final ConfigHistory history,
  final Future<Map<String, Object?>> Function()? status,
  final int failLimit = 5,
  final DateTime Function() clock = DateTime.now,
}) {
  late final RateLimiter failures = RateLimiter(limit: failLimit, clock: clock);

  void mount(Router router) {
    router
      ..get('/admin', _page)
      ..get('/admin/', _page)
      ..get('/admin/api/config', _guard(_getConfig))
      ..post('/admin/api/validate', _guard(_validate))
      ..put('/admin/api/config', _guard(_putConfig))
      ..get('/admin/api/history', _guard(_history))
      ..get('/admin/api/history/<id>', (Request request, String id) {
        return _guard((Request r) async => _historyItem(id))(request);
      })
      ..get('/admin/api/status', _guard(_status));
  }

  /// 요청 제한용 IP 를 비운다(서버가 1분마다 부른다).
  void prune() => failures.prune();

  Response _page(Request request) => Response.ok(
    adminPageHtml,
    headers: {
      'content-type': 'text/html; charset=utf-8',
      'cache-control': 'no-store',
      'x-robots-tag': 'noindex, nofollow',
      'x-frame-options': 'DENY',
      'referrer-policy': 'no-referrer',
      'content-security-policy':
          "default-src 'none'; script-src 'unsafe-inline'; "
          "style-src 'unsafe-inline'; connect-src 'self'; img-src data:; "
          "base-uri 'none'; form-action 'none'; frame-ancestors 'none'",
    },
  );

  Handler _guard(Future<Response> Function(Request request) inner) =>
      (Request request) async {
        final String key = RateLimiter.clientKey(request);
        if (failures.exceeded(key)) return _error(429, 'rate_limited');
        if (!auth.check(request.headers['authorization'])) {
          failures.allow(key);
          serverLog('[admin] 인증 실패 ${request.method} ${request.url.path}');
          return _error(401, 'unauthorized');
        }
        return inner(request);
      };

  Future<Response> _getConfig(Request request) async => _json(_state());

  Map<String, Object?> _state() {
    final String text = configs.file.readAsStringSync();
    final ServedConfig served = configs.current;
    return {
      'text': text,
      'fileEtag': _etagOf(text),
      'servedEtag': served.etag,
      'served': served.config.toJson(),
      'modifiedAt': configs.file.lastModifiedSync().millisecondsSinceEpoch,
      'meta': _meta,
    };
  }

  Future<Response> _validate(Request request) async {
    final String? body = await _readLimited(request);
    if (body == null) return _error(413, 'too_large');
    final String? text = _textOf(body);
    if (text == null) return _error(400, 'invalid_body');
    return _json({'issues': _issuesOf(text)});
  }

  Future<Response> _putConfig(Request request) async {
    final String? body = await _readLimited(request);
    if (body == null) return _error(413, 'too_large');
    final Object? json = _tryDecode(body);
    if (json is! Map || json['text'] is! String) {
      return _error(400, 'invalid_body');
    }
    final String text = json['text'] as String;

    final List<String> issues = _issuesOf(text);
    if (issues.isNotEmpty) return _json({'issues': issues}, status: 422);

    // 화면을 연 뒤 다른 곳(다른 탭 · ssh)에서 바뀌었으면 덮어쓰지 않는다.
    final String before = configs.file.readAsStringSync();
    if (json['baseEtag'] != _etagOf(before)) {
      return _error(
        409,
        'conflict',
        detail: '다른 곳에서 설정이 바뀌었다. 새로 불러온 뒤 다시 저장한다.',
      );
    }

    final String pretty =
        '${const JsonEncoder.withIndent('  ').convert(jsonDecode(text))}\n';
    if (pretty == before) return _json({..._state(), 'unchanged': true});

    final String historyId = history.add(
      before,
      clock().millisecondsSinceEpoch,
    );
    // 파일을 새로 만들어 바꿔 끼우지 않고 제자리에 쓴다. 컨테이너(root)가 새 파일을
    // 만들면 호스트 사용자가 ssh 로 고칠 수 없게 된다. 쓰는 동안 이 프로세스는 읽지
    // 않으므로(동기 쓰기) 반쯤 쓴 파일을 내보낼 일은 없다.
    try {
      configs.file.writeAsStringSync(pretty, flush: true);
    } catch (e) {
      // 디스크가 차는 등으로 쓰다 말면 반쯤 쓴 파일이 남아 다음 재시작 때 읽지 못한다.
      // 원래 내용으로 되돌려 둔다(실행 중인 설정은 그대로다).
      try {
        configs.file.writeAsStringSync(before, flush: true);
      } catch (_) {}
      serverLog('[admin] 설정을 쓰지 못해 되돌림: $e', error: true);
      return _error(500, 'write_failed', detail: '$e');
    }
    try {
      configs.reloadNow();
    } catch (e) {
      configs.file.writeAsStringSync(before, flush: true);
      serverLog('[admin] 저장한 설정을 읽지 못해 되돌림: $e', error: true);
      return _error(500, 'reload_failed', detail: '$e');
    }
    serverLog('[admin] 설정 저장 etag=${configs.current.etag} 이전본=$historyId');
    return _json({..._state(), 'historyId': historyId});
  }

  Future<Response> _history(Request request) async => _json({
    'items': [
      for (final ({String id, int bytes}) e in history.list())
        {'id': e.id, 'savedAt': int.parse(e.id), 'bytes': e.bytes},
    ],
  });

  Response _historyItem(String id) {
    final String? text = history.read(id);
    if (text == null) return _error(404, 'not_found');
    return _json({'id': id, 'text': text});
  }

  Future<Response> _status(Request request) async =>
      _json({'servedEtag': configs.current.etag, ...?await status?.call()});

  static final Map<String, Object?> _meta = {
    'schemaVersion': RemoteConfig.schemaVersion,
    'sites': [for (final SiteType s in SiteType.values) s.name],
    'presets': [for (final UserAgentPreset p in UserAgentPreset.values) p.name],
    'detailSizes': [for (final DetailAdSize s in DetailAdSize.values) s.name],
    'defaults': {
      'detail': AdsRemoteConfig.defaultDetail.name,
      'listFirst': AdsRemoteConfig.defaultListFirst,
      'listInterval': AdsRemoteConfig.defaultListInterval,
      'ttlDays': AlertsRemoteConfig.defaultTtlDays,
    },
    'limits': {
      'listFirst': [AdsRemoteConfig.minListFirst, AdsRemoteConfig.maxListFirst],
      'listInterval': [
        AdsRemoteConfig.minListInterval,
        AdsRemoteConfig.maxListInterval,
      ],
      'ttlDays': [AlertsRemoteConfig.minTtlDays, AlertsRemoteConfig.maxTtlDays],
    },
  };

  static List<String> _issuesOf(String text) {
    final Object? json = _tryDecode(text);
    if (json == null) return ['JSON 형식이 아니다'];
    return RemoteConfig.validate(json);
  }

  static String? _textOf(String body) {
    final Object? json = _tryDecode(body);
    return json is Map && json['text'] is String
        ? json['text'] as String
        : null;
  }

  static Object? _tryDecode(String text) {
    try {
      return jsonDecode(text);
    } on FormatException {
      return null;
    }
  }

  static String _etagOf(String text) =>
      sha256.convert(utf8.encode(text)).toString().substring(0, 32);

  static Future<String?> _readLimited(Request request) async {
    final int? length = request.contentLength;
    if (length != null && length > _maxBodyBytes) return null;
    final List<int> bytes = [];
    await for (final List<int> chunk in request.read()) {
      bytes.addAll(chunk);
      if (bytes.length > _maxBodyBytes) return null;
    }
    return utf8.decode(bytes, allowMalformed: true);
  }

  static Response _json(Map<String, Object?> body, {int status = 200}) =>
      Response(status, body: jsonEncode(body), headers: _jsonHeaders);

  static Response _error(int status, String code, {String? detail}) =>
      _json({'error': code, 'detail': ?detail}, status: status);
}
