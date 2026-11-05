import 'dart:convert';

import 'package:mocl_shared/remote_config/remote_config.dart';
import 'package:mocl_shared/util/mocl_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 마지막으로 받은 원격 설정을 기기에 둔다.
///
/// 부팅 때 [load] 로 바로 읽어 쓰고(네트워크를 기다리지 않는다), 새 설정은
/// [RemoteConfigFetcher] 가 받아 [save] 한다. 그래서 새 설정은 다음 실행부터 적용된다.
final class RemoteConfigStore(final SharedPreferences _prefs) {
  static const String _keyBody = 'remote_config_body';
  static const String _keyEtag = 'remote_config_etag';

  /// 저장된 설정. 없거나 읽을 수 없으면(형식 변경 등) 빈 설정 — 앱 기본값을 쓴다.
  RemoteConfig load() {
    final String? body = _prefs.getString(_keyBody);
    if (body == null) return RemoteConfig.empty;
    try {
      return parse(body);
    } catch (e) {
      MoclLogger.w(() => '[remoteConfig] 저장된 설정을 버린다: $e');
      return RemoteConfig.empty;
    }
  }

  /// 조건부 요청(`If-None-Match`)에 쓸 값. 저장된 설정이 없으면 null.
  String? get etag =>
      _prefs.getString(_keyBody) == null ? null : _prefs.getString(_keyEtag);

  Future<void> save(String body, String? etag) async {
    await _prefs.setString(_keyBody, body);
    if (etag == null) {
      await _prefs.remove(_keyEtag);
    } else {
      await _prefs.setString(_keyEtag, etag);
    }
  }

  /// 서버 응답 본문을 읽는다. 앱보다 서버가 새 사이트를 먼저 알 수 있으므로
  /// 모르는 항목은 건너뛴다(느슨한 모드). 형식 버전이 다르면 던진다.
  static RemoteConfig parse(String body) {
    final Object? json = jsonDecode(body);
    if (json is! Map<String, Object?>) {
      throw const FormatException('최상위는 객체여야 한다');
    }
    return RemoteConfig.fromJson(json);
  }
}
