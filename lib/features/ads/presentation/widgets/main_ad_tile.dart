import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_divider_widget.dart';

import '../../domain/ad_unit_ids.dart';
import '../list_ad_style.dart';
import 'single_native_ad.dart';

/// 메인(담아 둔 게시판 목록) 맨 아래의 광고 한 줄. 목록 광고와 같은 행 모양을 쓴다.
/// 게시판 사이에는 넣지 않는다 — 자주 누르는 메뉴라 잘못 누르기 쉽다.
class const MainAdTile({required final AppTextStyles styles, super.key})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => SingleNativeAd(
    adUnitId: AdUnitIds.mainNative,
    look: ListAdStyle.from(styles, Theme.of(context).scaffoldBackgroundColor),
    frame: (ad) => Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ad,
        const PlainDividerWidget(),
      ],
    ),
  );
}
