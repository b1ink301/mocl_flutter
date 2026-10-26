import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';

import '../data/mobile_ads_bootstrap.dart';
import '../domain/ad_unit_ids.dart';
import 'list_ad_style.dart';

/// 목록 한 화면이 쓰는 네이티브 광고들. 광고 자리(슬롯)마다 하나씩 불러 둔다.
///
/// 스크롤로 멀어진 슬롯은 버리고, 다시 돌아오면 새로 불러온다. 같은 광고를
/// 두 자리에 동시에 그릴 수는 없어서(AdWidget 제약) 슬롯끼리 나눠 쓰지 않는다.
class ListAdSlots({required final String adUnitId}) {
  /// 화면에 붙어 있는 슬롯에서 이만큼 넘게 떨어진 슬롯은 버린다.
  static const int _keepDistance = 3;

  final Map<int, ListAdSlot> _slots = {};
  final Set<ListAdSlot> _retired = {};
  ListAdStyle? _style;
  bool _disposed = false;

  /// [slot] 번째 광고를 화면에 붙인다. 다 쓰면 [release] 로 돌려준다.
  ListAdSlot acquire(int slot, ListAdStyle style) {
    if (style != _style) {
      // 글자 크기 · 테마가 바뀌면 이미 만든 광고 뷰는 옛 모양이라 새로 받는다.
      _style = style;
      _retireAll();
    }
    final ListAdSlot entry = _slots.putIfAbsent(slot, () => _load(slot));
    entry._mounts++;
    // 다음 자리도 미리 불러 두어, 스크롤해 내려갔을 때 행이 늦게 끼어드는 걸 줄인다.
    _slots.putIfAbsent(slot + 1, () => _load(slot + 1));
    _evictFarFrom(slot);
    return entry;
  }

  void release(ListAdSlot entry) {
    entry._mounts--;
    if (entry._mounts > 0) return;
    if (_disposed || _retired.remove(entry)) entry._dispose();
  }

  void dispose() {
    _disposed = true;
    for (final ListAdSlot entry in _slots.values) {
      if (entry._mounts == 0) entry._dispose();
    }
    for (final ListAdSlot entry in _retired) {
      if (entry._mounts == 0) entry._dispose();
    }
    _slots.clear();
    _retired.clear();
  }

  ListAdSlot _load(int slot) {
    final ListAdSlot entry = ListAdSlot._(slot);
    final ListAdStyle style = _style!;
    entry._ad = NativeAd(
      adUnitId: adUnitId,
      factoryId: style.factoryId,
      request: const AdRequest(),
      customOptions: style.toOptions(),
      nativeAdOptions: style.nativeAdOptions,
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          if (entry._disposed) return;
          entry._loaded.value = ad as NativeAd;
          MoclLogger.d(() => '[ads] slot $slot loaded');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // 광고가 없으면(no fill) 그 자리는 그냥 구분선으로 남는다.
          MoclLogger.w(() => '[ads] slot $slot failed: $error');
          entry._dispose();
        },
      ),
    )..load();
    return entry;
  }

  void _retireAll() {
    for (final ListAdSlot entry in _slots.values) {
      if (entry._mounts == 0) {
        entry._dispose();
      } else {
        _retired.add(entry);
      }
    }
    _slots.clear();
  }

  void _evictFarFrom(int slot) {
    _slots.removeWhere((int key, ListAdSlot entry) {
      if (entry._mounts > 0 || (key - slot).abs() <= _keepDistance) {
        return false;
      }
      entry._dispose();
      return true;
    });
  }
}

/// 광고 한 자리. 불러오기가 끝나면 [ad] 에 광고가 들어온다.
class ListAdSlot._(final int index) {
  NativeAd? _ad;
  final ValueNotifier<NativeAd?> _loaded = ValueNotifier<NativeAd?>(null);
  int _mounts = 0;
  bool _disposed = false;

  ValueListenable<NativeAd?> get ad => _loaded;

  void _dispose() {
    if (_disposed) return;
    _disposed = true;
    _loaded.value = null;
    _ad?.dispose();
    _ad = null;
  }
}

/// 이 목록 화면에서 쓸 광고 묶음. 광고를 쓰지 않는 빌드이거나 아직 광고를
/// 요청할 수 없으면(동의 확인 · SDK 초기화 전) null.
/// 화면이 사라질 때 광고도 함께 정리한다.
ListAdSlots? useListAdSlots() {
  final bool ready = useValueListenable(mobileAdsReady);
  final ListAdSlots? slots = useMemoized(() {
    final String? adUnitId = AdUnitIds.listNative;
    return adUnitId == null || !ready ? null : ListAdSlots(adUnitId: adUnitId);
  }, [ready]);
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
