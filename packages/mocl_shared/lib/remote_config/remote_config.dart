import 'package:mocl_shared/entities/mocl_site_type.dart';

import 'ads_config.dart';
import 'alerts_config.dart';

export 'ads_config.dart';
export 'alerts_config.dart';

/// 사이트 요청에 쓰는 기본 UA 묶음. 값(실제 UA 문자열)은 앱이 갖고,
/// 원격 설정은 이름으로 고르거나 값을 덮어쓴다.
enum UserAgentPreset() {
  mobile,
  pc;

  static UserAgentPreset? tryParse(String name) {
    for (final UserAgentPreset preset in values) {
      if (preset.name == name) return preset;
    }
    return null;
  }
}

/// 사이트 하나에 대한 원격 설정.
class const SiteRemoteConfig({
  /// `mobile` · `pc`(프리셋 이름) 또는 UA 문자열 그대로. `null` 이면 앱 기본값.
  final String? userAgent,
}) {
  Map<String, Object?> toJson() => {'userAgent': ?userAgent};
}

/// 서버가 내려주는 원격 설정(`GET /v1/config`).
///
/// 앱과 서버가 같은 클래스로 읽고 쓴다. 앱 업데이트 없이 바꿀 값만 둔다.
/// - [userAgents]: 프리셋 UA 를 통째로 바꾼다(브라우저 버전 올리기 등).
/// - [sites]: 사이트별로 다른 프리셋이나 UA 를 쓴다(차단 회피).
/// - [ads]: 광고 크기 · 목록 광고 간격([AdsRemoteConfig]).
/// - [alerts]: 키워드 알림 기한([AlertsRemoteConfig]). 서버 크롤러도 이 값을 따른다.
///
/// JSON 예:
/// ```json
/// {
///   "schemaVersion": 1,
///   "userAgents": { "mobile": "Mozilla/5.0 (Linux; Android 16; ...)" },
///   "sites": { "geekNews": { "userAgent": "mobile" } },
///   "ads": { "detail": "small", "list": { "first": 5, "interval": 15 } },
///   "alerts": { "ttlDays": 3 }
/// }
/// ```
class const RemoteConfig({
  final Map<UserAgentPreset, String> userAgents = const {},
  final Map<SiteType, SiteRemoteConfig> sites = const {},
  final AdsRemoteConfig ads = AdsRemoteConfig.empty,
  final AlertsRemoteConfig alerts = AlertsRemoteConfig.empty,
}) {
  /// 이 형식의 버전. 호환되지 않게 바꿀 때만 올린다. 앱은 모르는 버전을 버린다.
  static const int schemaVersion = 1;

  static const RemoteConfig empty = RemoteConfig();

  bool get isEmpty =>
      userAgents.isEmpty && sites.isEmpty && ads.isEmpty && alerts.isEmpty;

  /// JSON 을 읽는다.
  ///
  /// [strict] 가 true 면(서버가 설정 파일을 읽을 때) 모르는 사이트 · 프리셋 ·
  /// 잘못된 값에 [FormatException] 을 던져 운영자가 실수를 바로 알게 한다.
  /// false 면(앱) 그런 항목만 건너뛴다 — 서버가 앱보다 새 사이트를 먼저 알 수 있다.
  /// 어느 쪽이든 [schemaVersion] 이 다르면 던진다.
  /// [onIssue] 는 모르거나 잘못된 항목마다 불린다(관리 화면이 문제를 한꺼번에 보여 줄 때).
  factory fromJson(
    Map<String, Object?> json, {
    bool strict = false,
    void Function(String message)? onIssue,
  }) {
    void fail(String message) {
      onIssue?.call(message);
      if (strict) throw FormatException(message);
    }

    final Object? version = json['schemaVersion'];
    if (version != schemaVersion) {
      throw FormatException('지원하지 않는 schemaVersion: $version');
    }

    final Map<UserAgentPreset, String> userAgents = {};
    final Object? rawUserAgents = json['userAgents'];
    if (rawUserAgents is Map) {
      rawUserAgents.forEach((Object? key, Object? value) {
        final UserAgentPreset? preset = UserAgentPreset.tryParse('$key');
        if (preset == null) return fail('모르는 UA 프리셋: $key');
        if (value is! String || !isValidUserAgent(value)) {
          return fail('잘못된 UA($key): $value');
        }
        userAgents[preset] = value;
      });
    } else if (rawUserAgents != null) {
      fail('userAgents 는 객체여야 한다');
    }

    final Map<SiteType, SiteRemoteConfig> sites = {};
    final Object? rawSites = json['sites'];
    if (rawSites is Map) {
      rawSites.forEach((Object? key, Object? value) {
        final SiteType? site = SiteType.values
            .where((SiteType s) => s.name == key)
            .firstOrNull;
        if (site == null) return fail('모르는 사이트: $key');
        if (value is! Map) return fail('sites.$key 는 객체여야 한다');
        final Object? userAgent = value['userAgent'];
        if (userAgent != null &&
            (userAgent is! String ||
                (UserAgentPreset.tryParse(userAgent) == null &&
                    !isValidUserAgent(userAgent)))) {
          return fail('잘못된 sites.$key.userAgent: $userAgent');
        }
        sites[site] = SiteRemoteConfig(userAgent: userAgent as String?);
      });
    } else if (rawSites != null) {
      fail('sites 는 객체여야 한다');
    }

    return RemoteConfig(
      userAgents: userAgents,
      sites: sites,
      ads: AdsRemoteConfig.fromJson(json['ads'], fail),
      alerts: AlertsRemoteConfig.fromJson(json['alerts'], fail),
    );
  }

  /// [json] 의 문제를 모두 모은다. 비어 있으면 서버가 받아들이는 설정이다
  /// (`fromJson(strict: true)` 와 같은 규칙).
  static List<String> validate(Object? json) {
    if (json is! Map<String, Object?>) return ['최상위는 객체여야 한다'];
    final List<String> issues = [];
    try {
      RemoteConfig.fromJson(json, onIssue: issues.add);
    } on FormatException catch (e) {
      issues.add(e.message);
    }
    return issues;
  }

  Map<String, Object?> toJson() => {
    'schemaVersion': schemaVersion,
    'userAgents': {
      for (final MapEntry<UserAgentPreset, String> e in userAgents.entries)
        e.key.name: e.value,
    },
    'sites': {
      for (final MapEntry<SiteType, SiteRemoteConfig> e in sites.entries)
        e.key.name: e.value.toJson(),
    },
    if (!ads.isEmpty) 'ads': ads.toJson(),
    if (!alerts.isEmpty) 'alerts': alerts.toJson(),
  };

  /// [site] 요청에 쓸 UA.
  ///
  /// [defaultPreset] 은 사이트의 기본 프리셋, [builtIn] 은 앱에 박힌 프리셋 값이다.
  /// 사이트 설정이 프리셋 이름이면 그 프리셋을(원격 덮어쓰기 포함), UA 문자열이면
  /// 그대로, 없으면 기본 프리셋을 쓴다.
  String userAgentFor(
    SiteType site, {
    required UserAgentPreset defaultPreset,
    required Map<UserAgentPreset, String> builtIn,
  }) {
    String preset(UserAgentPreset p) => userAgents[p] ?? builtIn[p]!;

    final String? override = sites[site]?.userAgent;
    if (override == null) return preset(defaultPreset);
    final UserAgentPreset? named = UserAgentPreset.tryParse(override);
    return named != null ? preset(named) : override;
  }

  /// HTTP 헤더에 그대로 넣어도 되는 UA 인지. 제어 문자(줄바꿈 등)가 들어가면
  /// 헤더가 깨지거나 다른 헤더를 끼워 넣을 수 있다.
  static bool isValidUserAgent(String value) =>
      value.trim().isNotEmpty &&
      value.length <= 512 &&
      !value.codeUnits.any((int c) => c < 0x20 || c == 0x7f);
}
