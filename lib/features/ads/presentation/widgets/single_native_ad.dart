import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_shared/util/mocl_logger.dart';

import '../../data/mobile_ads_bootstrap.dart';
import '../native_ad_look.dart';
import '../native_ad_preloader.dart';
import 'native_ad_switcher.dart';

/// 한 자리에 광고 하나만 두는 곳(메인 맨 아래 · 상세 본문 아래)에 쓰는 네이티브 광고.
///
/// 광고를 요청할 수 있게 되면([mobileAdsReady]) 한 번 불러오고, 화면에서 빠질 때
/// 정리한다. 받는 동안은 같은 높이의 자리 표시로 칸을 잡아 두어 광고가 들어올 때
/// 아래 내용이 밀리지 않게 하고, 못 받으면 칸을 접는다. 광고를 쓰지 않는
/// 빌드이거나 아직 요청할 수 없으면 아무 공간도 차지하지 않는다.
/// [frame] 으로 칸 둘레(구분선 · 여백)를 꾸민다.
///
/// [preloader] 를 주면 광고를 거기서 꺼내 쓴다(미리 받아 둔 게 있으면 바로 뜬다). 그리고
/// 광고가 뜬 뒤 스크롤이 멈춰 조용해지면 다음 화면 몫을 미리 받아 둔다 — 넘기는 중에
/// 받으면 SDK 가 Android 메인 스레드(= UI 스레드)를 막아 프레임이 밀린다.
///
/// 한 번 받은 광고는 스크롤로 화면에서 멀어져도 놓지 않는다(목록 안에 둘 때
/// [AutomaticKeepAlive] 로 살아 있다). 놓으면 되돌아올 때 다시 받느라 또 늦게 뜬다.
class const SingleNativeAd({
  required final String? adUnitId,
  required final NativeAdLook look,
  final Widget Function(Widget ad)? frame,
  final NativeAdPreloader? preloader,
  super.key,
}) extends StatefulWidget {
  @override
  State<SingleNativeAd> createState() => _SingleNativeAdState();
}

class _SingleNativeAdState()
    extends State<SingleNativeAd>
    with AutomaticKeepAliveClientMixin {
  /// 스크롤이 멈추고 이만큼 조용하면 다음 화면 몫을 미리 받는다.
  static const Duration _idleDelay = Duration(milliseconds: 300);

  NativeAd? _loading;
  PreloadTicket? _ticket;
  NativeAd? _shown;
  bool _failed = false;

  /// 다음 화면 몫을 미리 받으라고 했는지(화면마다 한 번).
  bool _prefetched = false;
  ValueListenable<bool>? _scrolling;
  Timer? _idleTimer;

  @override
  bool get wantKeepAlive => _shown != null;

  /// 모양이 바뀌어 광고를 새로 받을 때마다 올린다. 전환 없이 칸을 새로 그려
  /// 곧 정리될 옛 광고의 AdWidget 이 남지 않게 한다.
  int _generation = 0;

  @override
  void initState() {
    super.initState();
    mobileAdsReady.addListener(_onReadyChanged);
    _maybeLoad();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ValueListenable<bool>? scrolling = Scrollable.maybeOf(context)
        ?.position
        .isScrollingNotifier;
    if (scrolling != _scrolling) {
      _scrolling?.removeListener(_schedulePrefetch);
      _scrolling = scrolling?..addListener(_schedulePrefetch);
    }
    _schedulePrefetch();
  }

  @override
  void didUpdateWidget(SingleNativeAd oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.look == widget.look &&
        oldWidget.adUnitId == widget.adUnitId) {
      return;
    }
    // 글자 크기 · 테마 · 너비가 바뀌면 이미 만든 광고 뷰는 옛 모양이라 새로 받는다.
    // 옛 광고의 AdWidget 은 이번 프레임에 빠지므로 그 뒤에 정리한다.
    final NativeAd? previous = _shown;
    _shown = null;
    _loading?.dispose();
    _loading = null;
    _ticket?.cancel();
    _ticket = null;
    _failed = false;
    _prefetched = false;
    _generation++;
    if (previous != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => previous.dispose());
    }
    _maybeLoad();
  }

  @override
  void dispose() {
    mobileAdsReady.removeListener(_onReadyChanged);
    _scrolling?.removeListener(_schedulePrefetch);
    _idleTimer?.cancel();
    _loading?.dispose();
    // 받는 중이던 광고는 버리지 않고 다음 자리 몫으로 남긴다.
    _ticket?.cancel();
    _shown?.dispose();
    super.dispose();
  }

  /// 광고가 뜨고 스크롤이 멈춘 지 [_idleDelay] 가 지나면 다음 화면 몫을 받는다.
  void _schedulePrefetch() {
    _idleTimer?.cancel();
    _idleTimer = null;
    final NativeAdPreloader? preloader = widget.preloader;
    if (preloader == null || _prefetched || _shown == null) return;
    if (_scrolling?.value ?? false) return;
    _idleTimer = Timer(_idleDelay, () {
      _idleTimer = null;
      if (!mounted || _prefetched || (_scrolling?.value ?? false)) return;
      _prefetched = true;
      preloader.prefetch(widget.look);
    });
  }

  /// 광고가 왔다. [now] 면 지금 빌드 중이라 setState 없이 넣는다.
  void _adopt(NativeAd ad, {bool now = false}) {
    if (!mounted) {
      ad.dispose();
      return;
    }
    void apply() {
      _shown = ad;
      _loading = null;
      _ticket = null;
    }

    if (now) {
      apply();
    } else {
      setState(apply);
    }
    updateKeepAlive();
    MoclLogger.d(() => '[ads] ${widget.look.factoryId} shown');
    _schedulePrefetch();
  }

  void _fail() {
    if (!mounted) return;
    setState(() {
      _loading = null;
      _ticket = null;
      _failed = true;
    });
  }

  void _onReadyChanged() {
    // 요청할 수 있게 되면 자리 표시부터 그린다.
    if (mounted) setState(() {});
    _maybeLoad();
  }

  void _maybeLoad() {
    final String? adUnitId = widget.adUnitId;
    if (!mobileAdsReady.value ||
        adUnitId == null ||
        _failed ||
        _loading != null ||
        _ticket != null ||
        _shown != null) {
      return;
    }
    final NativeAdLook look = widget.look;
    final NativeAdPreloader? preloader = widget.preloader;
    if (preloader != null) {
      final (:NativeAd? ad, :PreloadTicket? ticket) = preloader.obtain(
        look,
        onLoaded: _adopt,
        onFailed: _fail,
      );
      _ticket = ticket;
      if (ad != null) _adopt(ad, now: true);
      return;
    }
    _loading = NativeAd(
      adUnitId: adUnitId,
      factoryId: look.factoryId,
      request: const AdRequest(),
      customOptions: look.toOptions(),
      nativeAdOptions: look.nativeAdOptions,
      listener: NativeAdListener(
        onAdLoaded: (Ad ad) {
          if (!mounted || ad != _loading) {
            ad.dispose();
            return;
          }
          setState(() {
            _shown = ad as NativeAd;
            _loading = null;
          });
          MoclLogger.d(() => '[ads] ${look.factoryId} loaded');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          // 광고가 없으면(no fill) 그 자리는 비워 둔다. 같은 화면에서 다시 조르지 않는다.
          MoclLogger.w(() => '[ads] ${look.factoryId} failed: $error');
          ad.dispose();
          if (mounted && ad == _loading) {
            setState(() {
              _loading = null;
              _failed = true;
            });
          }
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    // 요청할 수 없는 동안(광고 미사용 빌드 · 동의 확인 전)은 자리를 잡지 않는다.
    final bool requestable = widget.adUnitId != null && mobileAdsReady.value;
    if (!requestable && _shown == null) return const SizedBox.shrink();
    final Widget view = NativeAdSwitcher(
      key: ValueKey<int>(_generation),
      ad: _shown,
      look: widget.look,
    );
    return NativeAdCollapse(
      collapsed: _failed && _shown == null,
      child: widget.frame?.call(view) ?? view,
    );
  }
}
