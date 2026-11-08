import 'package:mocl_shared/remote_config/remote_config.dart';
import 'package:test/test.dart';

void main() {
  RemoteConfig parse(Object? alerts, {bool strict = false}) =>
      RemoteConfig.fromJson({
        'schemaVersion': RemoteConfig.schemaVersion,
        'alerts': alerts,
      }, strict: strict);

  test('없으면 기본 3일', () {
    final RemoteConfig c = parse(null);
    expect(c.alerts.isEmpty, isTrue);
    expect(c.alerts.ttl, const Duration(days: 3));
    expect(c.toJson().containsKey('alerts'), isFalse);
  });

  test('ttlDays 를 읽고 왕복한다 · 0 은 기한 없음', () {
    expect(parse({'ttlDays': 7}).alerts.ttl, const Duration(days: 7));
    expect(parse({'ttlDays': 0}).alerts.ttl, isNull);
    final RemoteConfig c = parse({'ttlDays': 7});
    expect(RemoteConfig.fromJson(c.toJson()).alerts.ttlDays, 7);
  });

  test('범위 밖 · 모양이 틀리면 엄격 모드에서 던지고, 느슨하면 기본값', () {
    for (final Object? bad in [
      {'ttlDays': -1},
      {'ttlDays': 91},
      {'ttlDays': '3'},
      3,
    ]) {
      expect(() => parse(bad, strict: true), throwsFormatException);
      expect(parse(bad).alerts.ttl, const Duration(days: 3));
    }
    expect(
      RemoteConfig.validate({
        'schemaVersion': RemoteConfig.schemaVersion,
        'alerts': {'ttlDays': 100},
      }),
      hasLength(1),
    );
  });
}
