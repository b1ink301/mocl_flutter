import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_shared/util/mocl_logger.dart';

import '../data/mobile_ads_bootstrap.dart';
import '../domain/ad_unit_ids.dart';
import '../domain/list_ad_placement.dart';
import 'list_ad_style.dart';

/// 목록 한 화면이 쓰는 네이티브 광고들. 광고 자리(슬롯)마다 하나씩 쓴다.
///
/// 스크롤로 멀어진 슬롯은 버리고, 다시 돌아오면 새 광고를 쓴다. 같은 광고를
/// 두 자리에 동시에 그릴 수는 없어서(AdWidget 제약) 슬롯끼리 나눠 쓰지 않는다.
///
/// 광고를 불러오고(`NativeAd.load`) 치우는(`dispose`) 일은 **스크롤이 멈춘 뒤에** 한다.
/// 둘 다 Android 메인 스레드(= Flutter UI 스레드)에서 SDK 가 일하는데, 넘기는 중에 하면
/// 그동안 vsync 를 놓친다. S24 Ultra 에서 목록을 8번 넘길 때 10ms 넘게 밀린 프레임이
/// 20개였고, 멈춘 뒤로 미루자 0개가 됐다.
///
/// 그렇다고 멈춘 뒤에 받기 시작하면 광고가 1~2초 늦게 떠 노출이 준다. 그래서 멈춰 있을 때
/// **여분 광고**([_spareCount]개)를 미리 받아 두고, 스크롤이 멈추면 0.1초 뒤 화면에 붙어 있는
/// 자리에 넣는다(넣는 건 Dart 쪽 일이라 싸다). 쓴 만큼은 다시 조용해졌을 때 채운다.
/// 빠르게 지나친 자리에는 광고를 넣지 않으므로 여분이 헛되이 쓰이지 않는다.
/// 한 번 자리에 넣은 광고는 여분으로 되돌리지 않는다 — 이미 노출된 광고라 다른 자리에
/// 다시 보여도 노출로 세지 않는다.
class ListAdSlots({
  required final String adUnitId,
  required final ListAdPlacement placement,
}) {
  /// 화면에 붙어 있는 슬롯에서 이만큼 넘게 떨어진 슬롯은 버린다.
  static const int _keepDistance = 3;

  /// 미리 받아 둘 여분 광고 수. 한 화면에 광고 자리는 하나쯤이라 두 번 멈출 몫이다.
  static const int _spareCount = 2;

  /// 받아 둔 지 이만큼 지난 여분은 버린다(AdMob 은 받은 광고를 1시간 안에 쓰라고 한다).
  static const Duration _spareMaxAge = Duration(minutes: 50);

  /// 스크롤이 멈추고 이만큼 조용해야 불러오고 치운다. 연달아 넘길 때 손가락을 대는
  /// 순간도 "멈춤" 으로 잡히므로 바로 시작하지 않는다.
  static const Duration _idleDelay = Duration(milliseconds: 300);

  /// 스크롤이 멈추고 이만큼 뒤에 여분을 자리에 넣는다. 연달아 넘길 때 손가락을 댔다
  /// 떼는 짧은 멈춤(실측 10ms 안쪽)에 여분을 지나칠 자리에 써 버리지 않게 한다.
  static const Duration _fillDelay = Duration(milliseconds: 100);

  final Map<int, ListAdSlot> _slots = {};
  final Set<ListAdSlot> _retired = {};
  final List<_SpareAd> _spares = [];
  ListAdStyle? _style;
  bool _disposed = false;

  ValueListenable<bool>? _scrolling;
  Timer? _idleTimer;

  /// 스크롤이 멈추면 치울 광고.
  final List<NativeAd> _disposeLater = [];

  /// 목록의 스크롤 상태(`ScrollPosition.isScrollingNotifier`)를 알려 준다.
  /// 광고 자리가 화면에 붙을 때마다 불러도 된다(같으면 아무 일도 하지 않는다).
  void watchScroll(ValueListenable<bool>? scrolling) {
    if (_disposed || identical(scrolling, _scrolling)) return;
    _scrolling?.removeListener(_onScrollingChanged);
    _scrolling = scrolling?..addListener(_onScrollingChanged);
    _onScrollingChanged();
  }

  bool get _isScrolling => _scrolling?.value ?? false;

  /// 넘기는 중이거나 멈춘 지 얼마 안 됐는지(불러오기 · 치우기를 미룬다).
  bool get _busy => _isScrolling || _idleTimer != null;

  void _onScrollingChanged() {
    _idleTimer?.cancel();
    _idleTimer = null;
    if (_disposed || _isScrolling) return;
    // 멈추면 곧바로 받아 둔 여분을 화면의 자리에 넣고, 더 조용해지면 나머지 일을 한다.
    _idleTimer = Timer(_fillDelay, () {
      _fillSlotsFromSpares();
      _idleTimer = Timer(_idleDelay - _fillDelay, () {
        _idleTimer = null;
        _settle();
      });
    });
  }

  /// 조용해졌을 때 미뤄 둔 일을 한다: 지나간 광고를 치우고, 여분이 모자라 비어 있는
  /// 자리는 직접 받고, 여분을 다시 채운다.
  void _settle() {
    if (_disposed) return;
    for (final NativeAd ad in _disposeLater) {
      ad.dispose();
    }
    _disposeLater.clear();

    final DateTime now = DateTime.now();
    _spares.removeWhere((_SpareAd spare) {
      final DateTime? loadedAt = spare.loadedAt;
      if (loadedAt == null || now.difference(loadedAt) < _spareMaxAge) {
        return false;
      }
      spare.ad.dispose();
      return true;
    });

    _fillSlotsFromSpares();
    for (final ListAdSlot entry in _slots.values.toList(growable: false)) {
      if (entry._wantsAd) _request(entry);
    }
    _refillSpares();
  }

  /// 화면에 붙어 있는데 광고가 없는 자리에 받아 둔 여분을 넣는다.
  void _fillSlotsFromSpares() {
    for (final ListAdSlot entry in _slots.values) {
      if (!entry._wantsAd) continue;
      final NativeAd? ad = _takeSpare();
      if (ad == null) return;
      entry
        .._requested = true
        .._ad = ad
        .._state.value = (ad: ad, failed: false);
      MoclLogger.d(() => '[ads] slot ${entry.index} filled from spare');
    }
  }

  /// 다 받은 여분 하나를 꺼낸다. 없으면 null.
  NativeAd? _takeSpare() {
    final DateTime now = DateTime.now();
    for (int i = 0; i < _spares.length; i++) {
      final DateTime? loadedAt = _spares[i].loadedAt;
      if (loadedAt != null && now.difference(loadedAt) < _spareMaxAge) {
        return _spares.removeAt(i).ad;
      }
    }
    return null;
  }

  void _refillSpares() {
    while (_spares.length < _spareCount) {
      late final _SpareAd spare;
      spare = _SpareAd(
        _newAd(
          onLoaded: () {
            if (!_spares.contains(spare)) return;
            spare.loadedAt = DateTime.now();
            MoclLogger.d(() => '[ads] spare loaded');
            // 조용한 동안 왔으면 기다리던 자리에 바로 넣는다.
            if (!_busy) _fillSlotsFromSpares();
          },
          onFailed: (LoadAdError error) {
            // 다시 받는 건 다음에 조용해졌을 때. 여기서 바로 채우면 광고가 없을 때 계속 요청한다.
            MoclLogger.w(() => '[ads] spare failed: $error');
            if (_spares.remove(spare)) _discard(spare.ad);
          },
        ),
      );
      _spares.add(spare);
      spare.ad.load();
    }
  }

  void _discard(NativeAd ad) {
    if (_busy && !_disposed) {
      _disposeLater.add(ad);
    } else {
      ad.dispose();
    }
  }

  /// [slot] 번째 광고를 화면에 붙인다. 다 쓰면 [release] 로 돌려준다.
  ListAdSlot acquire(int slot, ListAdStyle style) {
    if (style != _style) {
      // 글자 크기 · 테마가 바뀌면 이미 만든 광고 뷰는 옛 모양이라 새로 받는다.
      _style = style;
      _retireAll();
    }
    final ListAdSlot entry = _slots.putIfAbsent(slot, () => ListAdSlot._(slot));
    entry._mounts++;
    _evictFarFrom(slot);
    // 넘기는 중이면 멈춘 뒤([_onScrollingChanged])에 넣는다.
    if (!_busy) {
      _fillSlotsFromSpares();
      if (entry._wantsAd) _request(entry);
      _refillSpares();
    }
    return entry;
  }

  void release(ListAdSlot entry) {
    entry._mounts--;
    if (entry._mounts > 0) return;
    if (_disposed || _retired.remove(entry)) entry._dispose(_discard);
  }

  void dispose() {
    _disposed = true;
    _idleTimer?.cancel();
    _idleTimer = null;
    _scrolling?.removeListener(_onScrollingChanged);
    _scrolling = null;
    for (final ListAdSlot entry in _slots.values) {
      if (entry._mounts == 0) entry._dispose(_discard);
    }
    for (final ListAdSlot entry in _retired) {
      if (entry._mounts == 0) entry._dispose(_discard);
    }
    for (final NativeAd ad in _disposeLater) {
      ad.dispose();
    }
    for (final _SpareAd spare in _spares) {
      spare.ad.dispose();
    }
    _disposeLater.clear();
    _spares.clear();
    _slots.clear();
    _retired.clear();
  }

  /// 여분이 없을 때 이 자리 몫을 직접 받는다.
  void _request(ListAdSlot entry) {
    if (entry._requested || entry._disposed) return;
    entry._requested = true;
    final int slot = entry.index;
    entry._ad = _newAd(
      onLoaded: () {
        if (entry._disposed) return;
        entry._state.value = (ad: entry._ad, failed: false);
        MoclLogger.d(() => '[ads] slot $slot loaded');
      },
      onFailed: (LoadAdError error) {
        // 광고가 없으면(no fill) 자리 표시를 접고 그냥 구분선으로 남는다.
        MoclLogger.w(() => '[ads] slot $slot failed: $error');
        entry._dispose(_discard, failed: true);
      },
    )..load();
  }

  NativeAd _newAd({
    required VoidCallback onLoaded,
    required void Function(LoadAdError error) onFailed,
  }) {
    final ListAdStyle style = _style!;
    return NativeAd(
      adUnitId: adUnitId,
      factoryId: style.factoryId,
      request: const AdRequest(),
      customOptions: style.toOptions(),
      nativeAdOptions: style.nativeAdOptions,
      listener: NativeAdListener(
        onAdLoaded: (Ad _) => onLoaded(),
        onAdFailedToLoad: (Ad _, LoadAdError error) => onFailed(error),
      ),
    );
  }

  void _retireAll() {
    for (final ListAdSlot entry in _slots.values) {
      if (entry._mounts == 0) {
        entry._dispose(_discard);
      } else {
        _retired.add(entry);
      }
    }
    _slots.clear();
    // 여분도 옛 모양으로 만든 광고 뷰다.
    for (final _SpareAd spare in _spares) {
      _discard(spare.ad);
    }
    _spares.clear();
  }

  void _evictFarFrom(int slot) {
    _slots.removeWhere((int key, ListAdSlot entry) {
      if (entry._mounts > 0 || (key - slot).abs() <= _keepDistance) {
        return false;
      }
      entry._dispose(_discard);
      return true;
    });
  }
}

/// 미리 받아 둔 광고. 다 받으면 [loadedAt] 이 찬다.
class _SpareAd(final NativeAd ad) {
  DateTime? loadedAt;
}

/// 광고 자리 하나의 상태. 불러오는 중이면 `ad` 가 null 이고 `failed` 가 false.
typedef ListAdSlotState = ({NativeAd? ad, bool failed});

/// 광고 한 자리. 불러오기가 끝나면 [state] 에 광고(또는 실패)가 들어온다.
class ListAdSlot._(final int index) {
  NativeAd? _ad;
  final ValueNotifier<ListAdSlotState> _state = ValueNotifier<ListAdSlotState>((
    ad: null,
    failed: false,
  ));
  int _mounts = 0;
  bool _disposed = false;

  /// 광고를 넣었거나 요청했는지. 넘기는 중에 만든 자리는 멈춘 뒤에 채운다.
  bool _requested = false;

  /// 화면에 붙어 있는데 아직 광고가 없는지.
  bool get _wantsAd => _mounts > 0 && !_requested && !_disposed;

  ValueListenable<ListAdSlotState> get state => _state;

  /// 화면에서는 바로 내리고, 광고 자체는 [discard] 에 넘겨 치운다(넘기는 중이면 나중에).
  void _dispose(void Function(NativeAd ad) discard, {bool failed = false}) {
    if (_disposed) return;
    _disposed = true;
    _state.value = (ad: null, failed: failed);
    final NativeAd? ad = _ad;
    _ad = null;
    if (ad != null) discard(ad);
  }
}

/// 이 목록 화면에서 쓸 광고 묶음. 광고를 쓰지 않는 빌드이거나 아직 광고를
/// 요청할 수 없으면(동의 확인 · SDK 초기화 전) null.
/// 화면이 사라질 때 광고도 함께 정리한다. [placement] 는 광고를 넣을 자리.
ListAdSlots? useListAdSlots(ListAdPlacement placement) {
  final bool ready = useValueListenable(mobileAdsReady);
  final ListAdSlots? slots = useMemoized(() {
    final String? adUnitId = AdUnitIds.listNative;
    return adUnitId == null || !ready
        ? null
        : ListAdSlots(adUnitId: adUnitId, placement: placement);
  }, [ready, placement.first, placement.interval]);
  useEffect(() => slots?.dispose, [slots]);
  return slots;
}

/// 목록 아래로 [ListAdSlots] 를 내려준다.
class const ListAdScope({
  required final ListAdSlots? slots,
  required super.child,
  super.key,
}) extends InheritedWidget {
  // 동의 확인 · SDK 초기화가 끝나 slots 가 null 에서 바뀌면, 이미 그려진
  // 구분선도 광고 자리로 다시 그려지도록 의존을 건다(바뀌는 건 한 번뿐이다).
  static ListAdSlots? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ListAdScope>()?.slots;

  @override
  bool updateShouldNotify(ListAdScope oldWidget) => slots != oldWidget.slots;
}
