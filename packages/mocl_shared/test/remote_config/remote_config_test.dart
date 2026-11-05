import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/remote_config/remote_config.dart';
import 'package:test/test.dart';

const Map<UserAgentPreset, String> _builtIn = {
  UserAgentPreset.mobile: 'built-in mobile',
  UserAgentPreset.pc: 'built-in pc',
};

String _ua(RemoteConfig config, SiteType site, UserAgentPreset preset) =>
    config.userAgentFor(site, defaultPreset: preset, builtIn: _builtIn);

void main() {
  group('userAgentFor', () {
    test('설정이 없으면 사이트 기본 프리셋의 내장 값을 쓴다', () {
      expect(
        _ua(RemoteConfig.empty, SiteType.clien, UserAgentPreset.pc),
        'built-in pc',
      );
    });

    test('프리셋 덮어쓰기는 그 프리셋을 쓰는 모든 사이트에 적용된다', () {
      final config = RemoteConfig.fromJson({
        'schemaVersion': 1,
        'userAgents': {'mobile': 'remote mobile'},
      });
      expect(
        _ua(config, SiteType.ppomppu, UserAgentPreset.mobile),
        'remote mobile',
      );
      expect(_ua(config, SiteType.clien, UserAgentPreset.pc), 'built-in pc');
    });

    test('사이트별 설정은 프리셋 이름이나 UA 문자열을 받는다', () {
      final config = RemoteConfig.fromJson({
        'schemaVersion': 1,
        'userAgents': {'mobile': 'remote mobile'},
        'sites': {
          'clien': {'userAgent': 'mobile'},
          'reddit': {'userAgent': 'Custom/1.0'},
        },
      });
      expect(_ua(config, SiteType.clien, UserAgentPreset.pc), 'remote mobile');
      expect(_ua(config, SiteType.reddit, UserAgentPreset.pc), 'Custom/1.0');
    });
  });

  group('fromJson', () {
    final Map<String, Object?> withUnknowns = {
      'schemaVersion': 1,
      'userAgents': {'tablet': 'x', 'pc': 'remote pc'},
      'sites': {
        'futureSite': {'userAgent': 'mobile'},
        'clien': {'userAgent': 'bad\r\nX-Injected: 1'},
        'theqoo': {'userAgent': 'pc'},
      },
      'somethingNew': true,
    };

    test('앱(느슨한 모드)은 모르거나 잘못된 항목만 건너뛴다', () {
      final config = RemoteConfig.fromJson(withUnknowns);
      expect(config.userAgents, {UserAgentPreset.pc: 'remote pc'});
      expect(config.sites.keys, [SiteType.theqoo]);
    });

    test('서버(엄격 모드)는 모르거나 잘못된 항목에 던진다', () {
      expect(
        () => RemoteConfig.fromJson(withUnknowns, strict: true),
        throwsFormatException,
      );
    });

    test('schemaVersion 이 다르면 두 모드 모두 던진다', () {
      expect(
        () => RemoteConfig.fromJson({'schemaVersion': 2}),
        throwsFormatException,
      );
      expect(() => RemoteConfig.fromJson({}), throwsFormatException);
    });

    test('toJson → fromJson 이 같은 값을 돌려준다', () {
      final config = RemoteConfig.fromJson({
        'schemaVersion': 1,
        'userAgents': {'mobile': 'm'},
        'sites': {
          'geekNews': {'userAgent': 'pc'},
        },
      }, strict: true);
      final again = RemoteConfig.fromJson(config.toJson(), strict: true);
      expect(again.toJson(), config.toJson());
    });
  });

  test('UA 검사는 제어 문자와 빈 값을 막는다', () {
    expect(RemoteConfig.isValidUserAgent('Mozilla/5.0'), isTrue);
    expect(RemoteConfig.isValidUserAgent('  '), isFalse);
    expect(RemoteConfig.isValidUserAgent('a\nb'), isFalse);
    expect(RemoteConfig.isValidUserAgent('a' * 513), isFalse);
  });
}
