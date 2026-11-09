import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:material_ui/material_ui.dart';

import '../native_ad_look.dart';

/// 광고 칸의 전환 시간. 애니메이션 줄이기 설정이면 바로 바꾼다.
Duration nativeAdTransition(BuildContext context) =>
    MediaQuery.disableAnimationsOf(context)
    ? Duration.zero
    : const Duration(milliseconds: 250);

/// [look] 높이의 광고 칸. 광고([ad])가 오기 전에는 자리 표시를 그리고,
/// 오면 자리 표시를 광고 위에서 서서히 걷어낸다.
///
/// 광고는 플랫폼 뷰라 투명도가 먹지 않을 수 있어서, 광고를 페이드인하지 않고
/// 위에 덮인 자리 표시를 페이드아웃한다. 첫 프레임이 늦게 그려지는 것도 가린다.
///
/// 광고 뷰(플랫폼 뷰)를 붙이는 동안 Android 메인 스레드가 15~20ms 막혀
/// vsync 가 밀린다(S24 Ultra 120Hz 실측, 2~3 프레임이 빠진다). 그래서 스크롤
/// 중에는 자리 표시를 유지하다가 스크롤이 멈추면 붙인다. 한 번 붙은 광고는
/// 스크롤을 다시 시작해도 그대로 둔다.
class const NativeAdSwitcher({
  required final NativeAd? ad,
  required final NativeAdLook look,
  super.key,
}) extends StatefulWidget {
  @override
  State<NativeAdSwitcher> createState() => _NativeAdSwitcherState();
}

class _NativeAdSwitcherState() extends State<NativeAdSwitcher> {
  ValueListenable<bool>? _scrolling;

  /// 화면에 붙인 광고. 스크롤이 멈춰야 [NativeAdSwitcher.ad] 를 여기로 옮긴다.
  NativeAd? _shown;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final ValueListenable<bool>? scrolling = Scrollable.maybeOf(
      context,
    )?.position.isScrollingNotifier;
    if (scrolling != _scrolling) {
      _scrolling?.removeListener(_onScrollingChanged);
      _scrolling = scrolling?..addListener(_onScrollingChanged);
    }
    _shown = _next();
  }

  @override
  void didUpdateWidget(NativeAdSwitcher oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.ad != widget.ad) _shown = _next();
  }

  @override
  void dispose() {
    _scrolling?.removeListener(_onScrollingChanged);
    super.dispose();
  }

  /// 지금 붙여야 할 광고. 광고가 빠지거나 바뀌면 옛 광고는 바로 내린다 —
  /// 정리된 광고를 그리면 안 된다. 새 광고는 스크롤 중이면 자리 표시로 기다린다.
  NativeAd? _next() {
    final NativeAd? ad = widget.ad;
    if (ad == null || ad == _shown) return ad;
    return (_scrolling?.value ?? false) ? null : ad;
  }

  void _onScrollingChanged() {
    final NativeAd? next = _next();
    if (next != _shown) setState(() => _shown = next);
  }

  @override
  Widget build(BuildContext context) {
    final NativeAd? ad = _shown;
    return SizedBox(
      height: widget.look.height,
      child: AnimatedSwitcher(
        duration: nativeAdTransition(context),
        // 기본은 새 자식을 위에 그린다. 여기서는 나가는 자리 표시를 위에 둔다.
        layoutBuilder: (Widget? current, List<Widget> previous) =>
            Stack(fit: StackFit.expand, children: [?current, ...previous]),
        child: ad == null
            ? KeyedSubtree(
                key: const ValueKey<String>('placeholder'),
                child: widget.look.placeholder(context),
              )
            : AdWidget(key: ObjectKey(ad), ad: ad),
      ),
    );
  }
}

/// 광고를 받지 못하면([collapsed]) 칸을 부드럽게 접는다.
class const NativeAdCollapse({
  required final bool collapsed,
  required final Widget child,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => ClipRect(
    child: AnimatedSize(
      duration: nativeAdTransition(context),
      curve: Curves.easeOut,
      alignment: Alignment.topCenter,
      child: collapsed ? const SizedBox(width: double.infinity) : child,
    ),
  );
}
