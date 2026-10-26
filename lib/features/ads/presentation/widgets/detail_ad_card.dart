import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_divider_widget.dart';

import '../../domain/ad_unit_ids.dart';
import '../detail_ad_style.dart';
import 'single_native_ad.dart';

/// 글 상세의 본문과 댓글 사이에 넣는 카드형 광고. 한 글에 하나만 둔다.
///
/// 본문 끝 링크 · 댓글과 붙어 있으면 잘못 누르기 쉬워서(AdMob 정책) 위아래를
/// 구분선과 카드 안 여백으로 띄운다.
class const DetailAdCard({required final AppTextStyles styles, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) => SingleNativeAd(
        adUnitId: AdUnitIds.detailNative,
        look: DetailAdStyle.from(styles, theme, constraints.maxWidth),
        frame: (ad) => Column(
          mainAxisSize: MainAxisSize.min,
          children: [const PlainDividerWidget(indent: 0, endIndent: 0), ad],
        ),
      ),
    );
  }
}
