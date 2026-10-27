import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/util/mocl_logger.dart';

import '../../data/mobile_ads_bootstrap.dart';
import '../native_ad_look.dart';

/// 한 자리에 광고 하나만 두는 곳(메인 맨 아래 · 상세 본문 아래)에 쓰는 네이티브 광고.
///
/// 광고를 요청할 수 있게 되면([mobileAdsReady]) 한 번 불러오고, 화면에서 빠질 때
/// 정리한다. 광고가 없거나 아직 오지 않았으면 아무 공간도 차지하지 않는다.
/// [frame] 으로 광고 둘레(구분선 · 여백)를 꾸미며, 광고가 있을 때만 그려진다.
class const SingleNativeAd({
  required final String? adUnitId,
  required final NativeAdLook look,
  final Widget Function(Widget ad)? frame,
  super.key,
}) extends StatefulWidget {
  @override
  State<SingleNativeAd> createState() => _SingleNativeAdState();
}

class _SingleNativeAdState() extends State<SingleNativeAd> {
  NativeAd? _loading;
  NativeAd? _shown;
  bool _failed = false;

  @override
  void initState() {
    super.initState();
    mobileAdsReady.addListener(_maybeLoad);
    _maybeLoad();
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
    _failed = false;
    if (previous != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => previous.dispose());
    }
    _maybeLoad();
  }

  @override
  void dispose() {
    mobileAdsReady.removeListener(_maybeLoad);
    _loading?.dispose();
    _shown?.dispose();
    super.dispose();
  }

  void _maybeLoad() {
    final String? adUnitId = widget.adUnitId;
    if (!mobileAdsReady.value ||
        adUnitId == null ||
        _failed ||
        _loading != null ||
        _shown != null) {
      return;
    }
    final NativeAdLook look = widget.look;
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
          if (ad == _loading) {
            _loading = null;
            _failed = true;
          }
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    final NativeAd? ad = _shown;
    if (ad == null) return const SizedBox.shrink();
    final Widget view = SizedBox(
      height: widget.look.height,
      child: AdWidget(key: ObjectKey(ad), ad: ad),
    );
    return widget.frame?.call(view) ?? view;
  }
}
