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

  /// 주면 제목 옆에 ▾ 를 붙이고 누를 수 있게 한다(메인: 사이트 고르기).
  final VoidCallback? onTap,

  /// [onTap] 이 있을 때 화면 낭독용 이름.
  final String? semanticLabel,

  /// [onTap] 이 있을 때 붙일 `Semantics(identifier:)`(기기 확인 스크립트용).
  final String? semanticsId,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Widget text = PlainText(
      title,
      style: style,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
    );
    final VoidCallback? onTap = this.onTap;
    return FlexibleSpaceBar(
      collapseMode: CollapseMode.parallax,
      background: Align(
        alignment: AlignmentDirectional.bottomStart,
        child: Padding(
          padding: kLargeTitlePadding,
          child: onTap == null
              ? text
              : Semantics(
                  identifier: semanticsId,
                  button: true,
                  label: semanticLabel,
                  excludeSemantics: semanticLabel != null,
                  // 글자 · 화살표만 누르는 자리라 줄 전체가 아니라 내용 폭만 잡는다.
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onTap,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(child: text),
                        const SizedBox(width: 2),
                        Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: (style.fontSize ?? 28) * 0.9,
                          color: style.color?.withValues(alpha: 0.55),
                        ),
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
