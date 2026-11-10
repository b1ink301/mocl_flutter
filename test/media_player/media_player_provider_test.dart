import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/detail_page/domain/video_link_resolver.dart';
import 'package:mocl_flutter/features/media_player/application/media_player_provider.dart';
import 'package:mocl_flutter/features/settings_page/application/datasource_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late ProviderContainer container;
  MediaPlayerNotifier notifier() =>
      container.read(mediaPlayerProvider.notifier);

  setUp(() => container = ProviderContainer());
  tearDown(() => container.dispose());

  test('열면 펼친 상태로 시작한다', () {
    notifier().open(const YouTubeLink('abcdefghijk'), referer: 'https://a.b');
    final session = container.read(mediaPlayerProvider)!;
    expect(session.expanded, isTrue);
    expect(session.landscape, isFalse);
    expect(session.referer, 'https://a.b');
  });

  test('접으면 미니가 되고 가로 보기도 꺼진다', () {
    notifier()
      ..open(const YouTubeLink('abcdefghijk'))
      ..toggleLandscape();
    expect(container.read(mediaPlayerProvider)!.landscape, isTrue);

    notifier().minimize();
    final session = container.read(mediaPlayerProvider)!;
    expect(session.expanded, isFalse);
    expect(session.landscape, isFalse);
  });

  test('미니에서는 가로 보기를 켜지 않는다', () {
    notifier()
      ..open(const DirectVideoLink('https://a.b/v.mp4'))
      ..minimize()
      ..toggleLandscape();
    expect(container.read(mediaPlayerProvider)!.landscape, isFalse);

    notifier().expand();
    expect(container.read(mediaPlayerProvider)!.expanded, isTrue);
  });

  test('새 영상을 열면 세션이 바뀐다(동시에 하나)', () {
    notifier().open(const YouTubeLink('abcdefghijk'));
    final int first = container.read(mediaPlayerProvider)!.id;
    notifier()
      ..minimize()
      ..open(const DirectVideoLink('https://a.b/v.mp4'));
    final session = container.read(mediaPlayerProvider)!;
    expect(session.id, isNot(first));
    expect(session.link, isA<DirectVideoLink>());
    expect(session.expanded, isTrue);
  });

  test('닫으면 플레이어가 없다', () {
    notifier()
      ..open(const YouTubeLink('abcdefghijk'))
      ..close();
    expect(container.read(mediaPlayerProvider), isNull);
  });

  group('미니 플레이어 폭', () {
    Future<ProviderContainer> containerWith(Map<String, Object> values) async {
      SharedPreferences.setMockInitialValues(values);
      final prefs = await SharedPreferences.getInstance();
      final c = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(c.dispose);
      return c;
    }

    test('맞춘 적 없으면 null(기본 크기)', () async {
      final c = await containerWith({});
      expect(c.read(miniPlayerWidthProvider), isNull);
    });

    test('맞춘 폭을 저장하고 다음 실행에도 읽는다', () async {
      final c = await containerWith({});
      c.read(miniPlayerWidthProvider.notifier).save(240);
      expect(c.read(miniPlayerWidthProvider), 240);

      final prefs = await SharedPreferences.getInstance();
      final next = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(next.dispose);
      expect(next.read(miniPlayerWidthProvider), 240);
    });
  });

  group('플레이어 소리', () {
    Future<ProviderContainer> containerWith(Map<String, Object> values) async {
      SharedPreferences.setMockInitialValues(values);
      final prefs = await SharedPreferences.getInstance();
      final c = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(c.dispose);
      return c;
    }

    test('처음엔 최대 볼륨, 음소거 아님', () async {
      final c = await containerWith({});
      expect(c.read(playerAudioProvider), (volume: 1.0, muted: false));
    });

    test('볼륨은 저장되고, 음소거는 저장하지 않는다', () async {
      final c = await containerWith({});
      c.read(playerAudioProvider.notifier)
        ..setVolume(0.3)
        ..toggleMute();
      expect(c.read(playerAudioProvider), (volume: 0.3, muted: true));

      final prefs = await SharedPreferences.getInstance();
      final next = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(prefs)],
      );
      addTearDown(next.dispose);
      expect(next.read(playerAudioProvider), (volume: 0.3, muted: false));
    });

    test('볼륨을 바꾸면 음소거가 풀린다', () async {
      final c = await containerWith({});
      c.read(playerAudioProvider.notifier)
        ..toggleMute()
        ..setVolume(0.6, save: false);
      expect(c.read(playerAudioProvider), (volume: 0.6, muted: false));
    });

    test('볼륨 0 에서 음소거를 풀면 들리게 올린다', () async {
      final c = await containerWith({});
      c.read(playerAudioProvider.notifier)
        ..setVolume(0)
        ..toggleMute();
      expect(c.read(playerAudioProvider), (volume: 0.5, muted: false));
    });
  });
}
