import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/large_title_metrics.dart';

import 'plain_text.dart';

/// 앱바 확장 영역에 들어가는 큰 제목.
///
/// 메인 · 목록 · 상세가 같은 리듬으로 접히고 펼쳐지도록 세 화면이 이 위젯을
/// 공유한다. 치수는 [large_title_metrics.dart] 한 곳에서 온다.
class const LargeTitleFlexibleSpace({
  super.key,
  required final String title,
  required final TextStyle style,
  final int maxLines = 1,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => FlexibleSpaceBar(
    collapseMode: CollapseMode.parallax,
    background: Align(
      alignment: AlignmentDirectional.bottomStart,
      child: Padding(
        padding: kLargeTitlePadding,
        child: PlainText(
          title,
          style: style,
          maxLines: maxLines,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    ),
  );
}
