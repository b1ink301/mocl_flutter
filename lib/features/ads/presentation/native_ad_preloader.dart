import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mocl_shared/util/mocl_logger.dart';

import '../domain/ad_unit_ids.dart';
import 'native_ad_look.dart';

/// 광고 하나를 받는 함수. 테스트에서 가짜 광고로 바꾼다.
typedef NativeAdFactory = NativeAd Function(
  NativeAdLook look,
  NativeAdListener listener,
);

/// 한 자리 광고(상세 본문 아래 등)를 **미리 하나** 받아 두는 곳.
///
/// 광고는 요청하고 1~2초 뒤에 온다. 자리가 화면에 붙을 때 요청하면 그만큼 자리 표시만
/// 보이다가 늦게 뜬다(상세는 본문이 길면 끝에 다다라서야 자리가 생겨 더 늦다). 그래서
/// 화면을 열 때나 앞 화면에서 조용할 때 받아 두고, 자리가 생기면 바로 꺼내 쓴다.
///
/// 들고 있는 광고는 하나뿐이다(받는 중이거나 다 받은 것). 모양([NativeAdLook])이 다르면
/// 쓰지 않는다 — 글자 크기 · 테마가 바뀌면 옛 모양 광고는 버리고 새로 받는다.
/// 받아 둔 지 [maxAge] 가 지나면 버린다(AdMob 은 받은 광고를 1시간 안에 쓰라고 한다).
class NativeAdPreloader({
  required final String adUnitId,
  final NativeAdFactory? factory,
  final DateTime Function()? clock,
}) {
  static const Duration maxAge = Duration(minutes: 50);

  /// 상세 본문 아래 광고. 광고를 쓰지 않는 빌드면 null.
  static final NativeAdPreloader? detail = switch (AdUnitIds.detailNative) {
    final String id => NativeAdPreloader(adUnitId: id),
    null => null,
  };

  _Preload? _current;

  DateTime _now() => clock?.call() ?? DateTime.now();

  /// [look] 모양 광고를 달라고 한다.
  ///
  /// - 받아 둔 게 있으면 `ad` 로 바로 준다.
  /// - 받는 중이면 `ticket` 을 주고, 다 받으면 [onLoaded] · 못 받으면 [onFailed] 를 부른다.
  /// - 없으면 새로 받기 시작하고 `ticket` 을 준다.
  ///
  /// 기다리다 그만두려면 `ticket.cancel()`. 그 뒤에 온 광고는 버리지 않고 다음 자리 몫으로 남는다.
  ({NativeAd? ad, PreloadTicket? ticket}) obtain(
    NativeAdLook look, {
    required ValueChanged<NativeAd> onLoaded,
    required VoidCallback onFailed,
  }) {
    _dropUnusable(look);
    final _Preload? current = _current;
    if (current != null && current.waiter == null) {
      if (current.loadedAt != null) {
        _current = null;
        MoclLogger.d(() => '[ads] ${look.factoryId} preloaded ad used');
        return (ad: current.ad, ticket: null);
      }
      return (ad: null, ticket: current.wait(onLoaded, onFailed));
    }
    if (current != null) {
      // 다른 자리가 이미 기다리고 있다(상세 위에 상세를 연 경우). 그 몫은 두고 따로 받는다.
      final _Preload own = _start(look, keep: false);
      return (ad: null, ticket: own.wait(onLoaded, onFailed));
    }
    final _Preload own = _start(look);
    return (ad: null, ticket: own.wait(onLoaded, onFailed));
  }

  /// [look] 모양 광고를 미리 받아 둔다. 이미 받아 두었거나 받는 중이면 아무것도 하지 않는다.
  void prefetch(NativeAdLook look) {
    _dropUnusable(look);
    if (_current != null) return;
    _start(look);
    MoclLogger.d(() => '[ads] ${look.factoryId} prefetch');
  }

  /// 받아 둔 광고가 [look] 과 모양이 다르거나 오래됐으면 버린다(기다리는 자리가 없을 때만).
  void _dropUnusable(NativeAdLook look) {
    final _Preload? current = _current;
    if (current == null || current.waiter != null) return;
    final DateTime? loadedAt = current.loadedAt;
    final bool stale =
        loadedAt != null && _now().difference(loadedAt) >= maxAge;
    if (current.look == look && !stale) return;
    _current = null;
    current.ad.dispose();
  }

  /// 광고를 받기 시작한다. [keep] 이면 [_current] 로 들고 있는다.
  _Preload _start(NativeAdLook look, {bool keep = true}) {
    late final _Preload preload;
    final NativeAdListener listener = NativeAdListener(
      onAdLoaded: (Ad _) => _onLoaded(preload),
      onAdFailedToLoad: (Ad _, LoadAdError error) {
        MoclLogger.w(() => '[ads] ${look.factoryId} failed: $error');
        _onFailed(preload);
      },
    );
    final NativeAdFactory create = factory ?? _createNativeAd(adUnitId);
    preload = _Preload(look, create(look, listener));
    if (keep) _current = preload;
    preload.ad.load();
    return preload;
  }

  void _onLoaded(_Preload preload) {
    final _PreloadWaiter? waiter = preload.waiter;
    if (waiter != null) {
      // 기다리던 자리에 넘기고 손에서 놓는다.
      preload.waiter = null;
      if (identical(_current, preload)) _current = null;
      waiter.onLoaded(preload.ad);
      return;
    }
    if (identical(_current, preload)) {
      preload.loadedAt = _now();
    } else {
      // 따로 받던 몫인데 기다리던 자리가 그만뒀다.
      preload.ad.dispose();
    }
  }

  void _onFailed(_Preload preload) {
    // 광고가 없으면(no fill) 그냥 비운다. 다음에 자리가 생기거나 다시 미리 받을 때 또 요청한다.
    final _PreloadWaiter? waiter = preload.waiter;
    preload.waiter = null;
    if (identical(_current, preload)) _current = null;
    preload.ad.dispose();
    waiter?.onFailed();
  }

  /// 테스트용: 들고 있는 광고가 다 받은 것인지 · 받는 중인지 · 없는지.
  @visibleForTesting
  String get debugState => switch (_current) {
    null => 'empty',
    _Preload(loadedAt: null) => 'loading',
    _ => 'ready',
  };
}

NativeAdFactory _createNativeAd(String adUnitId) =>
    (NativeAdLook look, NativeAdListener listener) => NativeAd(
      adUnitId: adUnitId,
      factoryId: look.factoryId,
      request: const AdRequest(),
      customOptions: look.toOptions(),
      nativeAdOptions: look.nativeAdOptions,
      listener: listener,
    );

/// 받는 중이거나 다 받은 광고 하나.
class _Preload(final NativeAdLook look, final NativeAd ad) {
  DateTime? loadedAt;
  _PreloadWaiter? waiter;

  PreloadTicket wait(ValueChanged<NativeAd> onLoaded, VoidCallback onFailed) {
    final _PreloadWaiter w = _PreloadWaiter(onLoaded, onFailed);
    waiter = w;
    return PreloadTicket._(this, w);
  }
}

class _PreloadWaiter(
  final ValueChanged<NativeAd> onLoaded,
  final VoidCallback onFailed,
);

/// 받는 중인 광고를 기다리는 표. [cancel] 하면 더는 알리지 않는다.
class PreloadTicket._(final _Preload _preload, final _PreloadWaiter _waiter) {
  void cancel() {
    if (identical(_preload.waiter, _waiter)) _preload.waiter = null;
  }
}
