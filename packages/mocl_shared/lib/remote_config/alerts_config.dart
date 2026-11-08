/// 원격 설정의 키워드 알림 항목(`alerts`). 값이 없는 항목은 기본값을 쓴다.
///
/// ```json
/// "alerts": { "ttlDays": 3 }
/// ```
class const AlertsRemoteConfig({
  /// 알림 하나를 걸고(또는 연장하고) 며칠 동안 보낼지. `0` 이면 기한 없음.
  /// `null` 이면 [defaultTtlDays].
  final int? ttlDays,
}) {
  static const int defaultTtlDays = 3;

  /// 받을 수 있는 [ttlDays] 범위(0 = 기한 없음).
  static const int minTtlDays = 0;
  static const int maxTtlDays = 90;

  static const AlertsRemoteConfig empty = AlertsRemoteConfig();

  bool get isEmpty => ttlDays == null;

  int get effectiveTtlDays => ttlDays ?? defaultTtlDays;

  /// 알림 기한. `null` 이면 기한 없음.
  Duration? get ttl =>
      effectiveTtlDays == 0 ? null : Duration(days: effectiveTtlDays);

  /// [fail] 은 모르거나 잘못된 값을 만났을 때 부른다(엄격 모드면 던진다).
  factory fromJson(Object? json, void Function(String message) fail) {
    if (json == null) return empty;
    if (json is! Map) {
      fail('alerts 는 객체여야 한다');
      return empty;
    }
    int? ttlDays;
    final Object? raw = json['ttlDays'];
    if (raw != null) {
      if (raw is int && raw >= minTtlDays && raw <= maxTtlDays) {
        ttlDays = raw;
      } else {
        fail('alerts.ttlDays 는 $minTtlDays~$maxTtlDays 정수여야 한다: $raw');
      }
    }
    return AlertsRemoteConfig(ttlDays: ttlDays);
  }

  Map<String, Object?> toJson() => {'ttlDays': ?ttlDays};
}
