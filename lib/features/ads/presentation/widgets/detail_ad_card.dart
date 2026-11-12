import 'dart:async';

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_divider_widget.dart';
import 'package:mocl_shared/remote_config/ads_config.dart';

import '../../data/mobile_ads_bootstrap.dart';
import '../../domain/ad_unit_ids.dart';
import '../detail_ad_style.dart';
import '../detail_small_ad_style.dart';
import '../list_ad_style.dart';
import '../native_ad_look.dart';
import '../native_ad_preloader.dart';
import '../state/ads_state_mixin.dart';
import 'single_native_ad.dart';

/// 글 상세의 본문과 댓글 사이에 넣는 광고. 한 글에 하나만 둔다.
/// 크기([DetailAdSize])는 원격 설정(`ads.detail`)을 따르고 기본은 small.
///
/// 본문 끝 링크 · 댓글과 붙어 있으면 잘못 누르기 쉬워서(AdMob 정책) 위아래를
/// 구분선과 카드 안 여백으로 띄운다.
///
/// 광고는 [NativeAdPreloader.detail] 에서 꺼낸다. 화면이 열릴 때 [DetailAdPrefetch] 가
/// 받아 두고(본문이 길면 자리가 끝에서야 생기므로), 앞 글에서 받아 둔 게 있으면 그걸 쓴다.
/// 한 번 받은 광고를 스크롤로 멀어져도 놓지 않도록 `SliverList` 안에 둔다(keep-alive).
class const DetailAdCard({required final AppTextStyles styles, super.key})
    extends ConsumerWidget
    with AdsState {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final DetailAdSize size = detailAdSizeState(ref);
    if (size == DetailAdSize.off) return const SizedBox.shrink();

    final ThemeData theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) => SingleNativeAd(
        adUnitId: AdUnitIds.detailNative,
        look: detailAdLook(size, styles, theme, constraints.maxWidth),
        preloader: NativeAdPreloader.detail,
        frame: (ad) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [const PlainDividerWidget(indent: 0, endIndent: 0), ad],
        ),
      ),
    );
  }
}

/// 상세 광고 모양. [DetailAdCard] 와 [DetailAdPrefetch] 가 같은 값을 써야 미리 받은 광고를 쓴다.
NativeAdLook detailAdLook(
  DetailAdSize size,
  AppTextStyles appStyles,
  ThemeData theme,
  double width,
) {
  // 배지 · 버튼은 이 화면의 강조색(설정 · 사이트 색)을 따른다.
  final AppTextStyles styles = appStyles.withAccent(theme.colorScheme.primary);
  return _detailAdLook(size, styles, theme, width);
}

NativeAdLook _detailAdLook(
  DetailAdSize size,
  AppTextStyles styles,
  ThemeData theme,
  double width,
) => switch (size) {
  // 본문 좌우 여백 안에 들어가므로 목록 행의 좌우 여백은 뺀다.
  DetailAdSize.compact => ListAdStyle.from(
    styles,
    theme.scaffoldBackgroundColor,
    paddingStart: 0,
    paddingEnd: 0,
  ),
  DetailAdSize.small ||
  DetailAdSize.off => DetailSmallAdStyle.from(styles, theme),
  DetailAdSize.medium => DetailAdStyle.from(
    styles,
    theme,
    width,
    compactMedia: true,
  ),
  DetailAdSize.large => DetailAdStyle.from(styles, theme, width),
};

/// 상세 화면이 열리면 광고를 미리 받아 두는 빈 칸. [DetailAdCard] 와 **같은 폭**을 받는
/// 자리(본문과 같은 여백 안, 맨 위)에 둔다.
///
/// 광고 자리는 본문 끝에 있어 본문이 길면 끝에 다다라서야 만들어진다. 그때 요청하면
/// 1~2초 자리 표시만 보인다. 그래서 화면이 열리고 전환이 끝난 뒤(전환 중에 요청하면
/// SDK 가 메인 스레드를 막아 전환이 끊긴다) 받아 둔다. 이미 받아 두었으면 아무것도 하지 않는다.
class const DetailAdPrefetch({required final AppTextStyles styles, super.key})
    extends ConsumerStatefulWidget {
  @override
  ConsumerState<DetailAdPrefetch> createState() => _DetailAdPrefetchState();
}

class _DetailAdPrefetchState()
    extends ConsumerState<DetailAdPrefetch>
    with AdsState {
  /// 전환이 끝나고 본문이 자리를 잡을 때까지 기다리는 시간.
  static const Duration _settleDelay = Duration(milliseconds: 300);

  double? _width;
  Animation<double>? _route;
  Timer? _timer;
  bool _done = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final Animation<double>? route = ModalRoute.of(context)?.animation;
    if (route != _route) {
      _route?.removeStatusListener(_onRouteStatus);
      _route = route?..addStatusListener(_onRouteStatus);
    }
  }

  @override
  void dispose() {
    _route?.removeStatusListener(_onRouteStatus);
    _timer?.cancel();
    super.dispose();
  }

  void _onRouteStatus(AnimationStatus _) => _schedule();

  void _schedule() {
    if (_done || _timer != null || _width == null) return;
    if (!(_route?.isCompleted ?? true)) return;
    _timer = Timer(_settleDelay, () {
      _timer = null;
      if (!mounted || _done) return;
      if (!(_route?.isCompleted ?? true)) return;
      final bool scrolling =
          Scrollable.maybeOf(context)?.position.isScrollingNotifier.value ??
          false;
      if (scrolling) {
        // 바로 넘기기 시작했으면 조금 뒤에 다시 본다.
        _schedule();
        return;
      }
      _done = true;
      _prefetch();
    });
  }

  void _prefetch() {
    final NativeAdPreloader? preloader = NativeAdPreloader.detail;
    final double? width = _width;
    if (preloader == null || width == null || !mobileAdsReady.value) return;
    final DetailAdSize size = detailAdSizeState(ref);
    if (size == DetailAdSize.off) return;
    preloader.prefetch(
      detailAdLook(size, widget.styles, Theme.of(context), width),
    );
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) {
      final bool first = _width == null;
      _width = constraints.maxWidth;
      if (first) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _schedule());
      }
      return const SizedBox.shrink();
    },
  );
}
