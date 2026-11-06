import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:mocl_shared/remote_config/remote_config.dart';

import 'server_log.dart';

/// 응답으로 내보낼 원격 설정 한 벌. [body] 는 이미 직렬화한 JSON 이다.
class const ServedConfig(
  final RemoteConfig config,
  final List<int> body,
  final String etag,
) {
  factory of(RemoteConfig config) {
    final List<int> body = utf8.encode(jsonEncode(config.toJson()));
    // 내용이 같으면 재시작해도 같은 ETag 가 나와야 앱 캐시가 살아남는다.
    final String etag = '"${sha256.convert(body).toString().substring(0, 32)}"';
    return ServedConfig(config, body, etag);
  }
}

/// 디스크의 원격 설정 파일을 읽어 둔다.
///
/// 파일이 바뀌면(수정 시각) 다음 요청 때 다시 읽는다. 새 파일이 깨졌으면
/// 마지막으로 읽은 정상 설정을 계속 내보내고 오류만 남긴다 — 편집 실수로
/// 전체 사용자에게 빈 설정이 나가지 않게 한다.
class ConfigStore(
  final File file, {
  final Duration checkInterval = const Duration(seconds: 5),
}) {
  ServedConfig? _current;
  DateTime? _loadedModified;
  DateTime _lastCheck = DateTime.fromMillisecondsSinceEpoch(0);

  /// 시작할 때 부른다. 처음 파일이 깨졌으면 던져서 서버가 뜨지 않게 한다.
  void loadInitial() {
    final (ServedConfig served, DateTime modified) = _read();
    _current = served;
    _loadedModified = modified;
    serverLog('[config] loaded ${file.path} etag=${served.etag}');
  }

  /// 지금 내보낼 설정. 필요하면 파일을 다시 읽는다.
  ServedConfig get current {
    final DateTime now = DateTime.now();
    if (now.difference(_lastCheck) >= checkInterval) {
      _lastCheck = now;
      _reloadIfChanged();
    }
    return _current ?? (throw StateError('loadInitial 을 먼저 불러야 한다'));
  }

  /// 관리 화면이 파일을 고친 직후 부른다. 수정 시각을 기다리지 않고 바로 읽는다.
  /// 파일이 깨졌으면 던지고 지금 설정은 그대로 둔다.
  void reloadNow() {
    final (ServedConfig served, DateTime modified) = _read();
    _current = served;
    _loadedModified = modified;
    _lastCheck = DateTime.now();
    serverLog('[config] reloaded etag=${served.etag}');
  }

  void _reloadIfChanged() {
    try {
      final DateTime modified = file.lastModifiedSync();
      if (modified == _loadedModified) return;
      final (ServedConfig served, DateTime readModified) = _read();
      _loadedModified = readModified;
      if (served.etag == _current?.etag) return;
      _current = served;
      serverLog('[config] reloaded etag=${served.etag}');
    } catch (e) {
      // 같은 깨진 파일로 계속 다시 읽고 로그를 쏟지 않게 시각은 기록해 둔다.
      _loadedModified = _safeModified();
      serverLog('[config] 새 설정을 읽지 못해 이전 설정을 유지한다: $e', error: true);
    }
  }

  (ServedConfig, DateTime) _read() {
    final DateTime modified = file.lastModifiedSync();
    final Object? json = jsonDecode(file.readAsStringSync());
    if (json is! Map<String, Object?>) {
      throw const FormatException('최상위는 객체여야 한다');
    }
    return (
      ServedConfig.of(RemoteConfig.fromJson(json, strict: true)),
      modified,
    );
  }

  DateTime? _safeModified() {
    try {
      return file.lastModifiedSync();
    } catch (_) {
      return null;
    }
  }
}
