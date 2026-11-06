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
class const NativeAdSwitcher({
  required final NativeAd? ad,
  required final NativeAdLook look,
  super.key,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final NativeAd? ad = this.ad;
    return SizedBox(
      height: look.height,
      child: AnimatedSwitcher(
        duration: nativeAdTransition(context),
        // 기본은 새 자식을 위에 그린다. 여기서는 나가는 자리 표시를 위에 둔다.
        layoutBuilder: (Widget? current, List<Widget> previous) =>
            Stack(fit: StackFit.expand, children: [?current, ...previous]),
        child: ad == null
            ? KeyedSubtree(
                key: const ValueKey<String>('placeholder'),
                child: look.placeholder(context),
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
