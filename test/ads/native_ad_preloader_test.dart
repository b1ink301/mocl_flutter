import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mocl_flutter/features/ads/presentation/native_ad_look.dart';
import 'package:mocl_flutter/features/ads/presentation/native_ad_preloader.dart';

/// 상세 광고를 미리 받아 두는 규칙. 광고 SDK 대신 가짜 광고로 본다.
void main() {
  late List<_FakeAd> made;
  late DateTime now;
  late NativeAdPreloader preloader;

  setUp(() {
    made = [];
    now = DateTime(2026, 11, 11, 12);
    preloader = NativeAdPreloader(
      adUnitId: 'test',
      clock: () => now,
      factory: (look, listener) {
        final _FakeAd ad = _FakeAd(listener);
        made.add(ad);
        return ad;
      },
    );
  });

  const _Look small = _Look('small');
  const _Look large = _Look('large');

  NativeAd? shown;
  int failures = 0;
  setUp(() {
    shown = null;
    failures = 0;
  });

  ({NativeAd? ad, PreloadTicket? ticket}) obtain(NativeAdLook look) => preloader
      .obtain(look, onLoaded: (ad) => shown = ad, onFailed: () => failures++);

  test('미리 받아 둔 광고는 자리가 생기면 바로 준다', () {
    preloader.prefetch(small);
    expect(made, hasLength(1));
    made.single.loaded();
    expect(preloader.debugState, 'ready');

    final result = obtain(small);
    expect(result.ad, same(made.single));
    expect(result.ticket, isNull);
    expect(preloader.debugState, 'empty', reason: '꺼낸 광고는 다시 주지 않는다');
  });

  test('받는 중이면 새로 요청하지 않고 다 받았을 때 넘긴다', () {
    preloader.prefetch(small);
    final result = obtain(small);
    expect(result.ad, isNull);
    expect(made, hasLength(1), reason: '같은 광고를 두 번 요청하면 안 된다');

    made.single.loaded();
    expect(shown, same(made.single));
    expect(preloader.debugState, 'empty');
  });

  test('이미 받아 두었거나 받는 중이면 다시 미리 받지 않는다', () {
    preloader.prefetch(small);
    preloader.prefetch(small);
    made.single.loaded();
    preloader.prefetch(small);
    expect(made, hasLength(1));
  });

  test('기다리다 그만둔 광고는 버리지 않고 다음 자리 몫으로 남긴다', () {
    final result = obtain(small);
    result.ticket!.cancel();
    made.single.loaded();
    expect(shown, isNull);
    expect(made.single.disposed, isFalse);
    expect(preloader.debugState, 'ready');
    expect(obtain(small).ad, same(made.single));
  });

  test('모양이 다르면 받아 둔 광고를 버리고 새로 받는다', () {
    preloader.prefetch(small);
    made.single.loaded();

    final result = obtain(large);
    expect(result.ad, isNull);
    expect(made, hasLength(2));
    expect(made.first.disposed, isTrue);
  });

  test('받아 둔 지 오래된 광고는 쓰지 않는다', () {
    preloader.prefetch(small);
    made.single.loaded();
    now = now.add(NativeAdPreloader.maxAge);

    expect(obtain(small).ad, isNull);
    expect(made.first.disposed, isTrue);
    expect(made, hasLength(2));
  });

  test('못 받으면 기다리던 자리에 알리고 비운다', () {
    obtain(small);
    made.single.failed();
    expect(failures, 1);
    expect(made.single.disposed, isTrue);
    expect(preloader.debugState, 'empty');
  });

  test('다른 자리가 기다리는 중이면 그 몫은 두고 따로 받는다', () {
    NativeAd? second;
    obtain(small);
    preloader.obtain(small, onLoaded: (ad) => second = ad, onFailed: () {});
    expect(made, hasLength(2));

    made[1].loaded();
    made[0].loaded();
    expect(second, same(made[1]));
    expect(shown, same(made[0]));
  });
}

class const _Look(final String name) implements NativeAdLook {
  @override
  String get factoryId => name;

  @override
  double get height => 100;

  @override
  NativeAdOptions get nativeAdOptions => NativeAdOptions();

  @override
  Map<String, Object> toOptions() => {};

  @override
  Widget placeholder(BuildContext context) => const SizedBox();

  @override
  bool operator ==(Object other) => other is _Look && other.name == name;

  @override
  int get hashCode => name.hashCode;
}

class _FakeAd extends NativeAd {
  // 상위 생성자에 인자를 넘겨야 해서 주 생성자로 쓰지 않는다.
  // ignore: use_primary_constructors, unnecessary_type_name_in_constructor
  _FakeAd(this._listener)
    : super(
        adUnitId: 'test',
        factoryId: 'test',
        request: const AdRequest(),
        listener: _listener,
      );

  final NativeAdListener _listener;
  bool disposed = false;

  void loaded() => _listener.onAdLoaded!(this);

  void failed() => _listener.onAdFailedToLoad!(
    this,
    LoadAdError(3, 'test', 'no fill', null),
  );

  @override
  Future<void> load() async {}

  @override
  Future<void> dispose() async => disposed = true;
}
