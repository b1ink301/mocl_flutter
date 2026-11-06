import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_divider_widget.dart';
import 'package:mocl_shared/remote_config/ads_config.dart';

import '../../domain/ad_unit_ids.dart';
import '../detail_ad_style.dart';
import '../detail_small_ad_style.dart';
import '../list_ad_style.dart';
import '../native_ad_look.dart';
import '../state/ads_state_mixin.dart';
import 'single_native_ad.dart';

/// 글 상세의 본문과 댓글 사이에 넣는 광고. 한 글에 하나만 둔다.
/// 크기([DetailAdSize])는 원격 설정(`ads.detail`)을 따르고 기본은 small.
///
/// 본문 끝 링크 · 댓글과 붙어 있으면 잘못 누르기 쉬워서(AdMob 정책) 위아래를
/// 구분선과 카드 안 여백으로 띄운다.
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
        look: _look(size, theme, constraints.maxWidth),
        frame: (ad) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [const PlainDividerWidget(indent: 0, endIndent: 0), ad],
        ),
      ),
    );
  }

  NativeAdLook _look(DetailAdSize size, ThemeData theme, double width) =>
      switch (size) {
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
}
