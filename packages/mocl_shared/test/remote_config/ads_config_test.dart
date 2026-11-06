import 'package:mocl_shared/remote_config/remote_config.dart';
import 'package:test/test.dart';

void main() {
  test('ads 가 없으면 기본값(상세 small · 목록 5/15)을 쓴다', () {
    final config = RemoteConfig.fromJson({'schemaVersion': 1});
    expect(config.ads.isEmpty, isTrue);
    expect(config.ads.effectiveDetail, DetailAdSize.small);
    expect(config.ads.effectiveListFirst, 5);
    expect(config.ads.effectiveListInterval, 15);
    expect(config.toJson().containsKey('ads'), isFalse);
  });

  test('ads 값을 읽고 toJson 으로 되돌린다', () {
    final config = RemoteConfig.fromJson({
      'schemaVersion': 1,
      'ads': {
        'detail': 'compact',
        'list': {'first': 3, 'interval': 20},
      },
    }, strict: true);
    expect(config.ads.effectiveDetail, DetailAdSize.compact);
    expect(config.ads.effectiveListFirst, 3);
    expect(config.ads.effectiveListInterval, 20);
    expect(
      RemoteConfig.fromJson(config.toJson(), strict: true).toJson(),
      config.toJson(),
    );
  });

  test('일부만 있으면 나머지는 기본값', () {
    final config = RemoteConfig.fromJson({
      'schemaVersion': 1,
      'ads': {
        'list': {'interval': 30},
      },
    }, strict: true);
    expect(config.ads.effectiveDetail, DetailAdSize.small);
    expect(config.ads.effectiveListFirst, 5);
    expect(config.ads.effectiveListInterval, 30);
  });

  group('잘못된 값', () {
    final Map<String, Object?> bad = {
      'schemaVersion': 1,
      'ads': {
        'detail': 'huge',
        'list': {'first': 2, 'interval': 1},
      },
    };

    test('앱은 그 항목만 건너뛴다', () {
      final config = RemoteConfig.fromJson(bad);
      expect(config.ads.detail, isNull);
      expect(config.ads.listFirst, 2);
      expect(config.ads.listInterval, isNull);
    });

    test('서버는 던진다', () {
      expect(
        () => RemoteConfig.fromJson(bad, strict: true),
        throwsFormatException,
      );
      expect(
        () => RemoteConfig.fromJson({
          'schemaVersion': 1,
          'ads': 'small',
        }, strict: true),
        throwsFormatException,
      );
    });
  });

  test('validate 는 문제를 한꺼번에 모은다', () {
    expect(RemoteConfig.validate({'schemaVersion': 1}), isEmpty);
    expect(RemoteConfig.validate([]), hasLength(1));
    expect(RemoteConfig.validate({'schemaVersion': 9}), hasLength(1));
    final List<String> issues = RemoteConfig.validate({
      'schemaVersion': 1,
      'userAgents': {'tablet': 'x'},
      'ads': {
        'detail': 'huge',
        'list': {'interval': 1},
      },
    });
    expect(issues, hasLength(3));
  });
}
