import 'package:material_ui/material_ui.dart';

/// 스크롤 가능한 [child] 위에 "상태바 스트립" 을 오버레이해서, 컨텐츠가 상태바
/// 아래로 스크롤되면 상태바 하단에 그림자를 드리운다.
///
/// floating SliverAppBar 는 스크롤 시 숨겨지고, 그림자를 앱바에 붙이면 앱바와
/// 함께 사라진다. 이 위젯의 그림자는 앱바가 아니라 상태바에 고정된 별도 레이어라
/// **앱바가 숨겨져도 상태바 밑에 그대로 유지**된다.
///
/// 스트립은 [Stack] 최상위(앱바 위)에 그려지며 상태바 높이만큼 불투명 배경으로
/// 덮으므로, 컨텐츠가 상태바 밑으로 비쳐 보이는 것도 함께 막는다. 스크롤할 때는
/// 그림자 투명도만 [ValueNotifier] 로 갱신되어 본문은 리빌드되지 않는다.
class const StatusBarScrollShadow({
  super.key,
  required final Widget child,

  /// 그림자가 최대치에 도달하는 스크롤 거리(px). 조금만 스크롤해도 보이도록 작게.
  final double revealExtent = 20,
}) extends StatefulWidget {
  @override
  State<StatusBarScrollShadow> createState() => _StatusBarScrollShadowState();
}

class _StatusBarScrollShadowState() extends State<StatusBarScrollShadow> {
  final ValueNotifier<double> _t = ValueNotifier<double>(0);

  @override
  void dispose() {
    _t.dispose();
    super.dispose();
  }

  bool _onScroll(ScrollNotification notification) {
    if (notification.metrics.axis != Axis.vertical) return false;
    final extent = widget.revealExtent;
    _t.value = extent <= 0
        ? (notification.metrics.pixels > 0 ? 1.0 : 0.0)
        : (notification.metrics.pixels / extent).clamp(0.0, 1.0);
    return false; // 버블링 유지 (RefreshIndicator 등 상위가 계속 수신)
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final topInset = MediaQuery.paddingOf(context).top;
    final bg =
        theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor;
    final shadowColor = theme.shadowColor;

    return NotificationListener<ScrollNotification>(
      onNotification: _onScroll,
      child: Stack(
        children: [
          widget.child,
          if (topInset > 0)
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child: ValueListenableBuilder<double>(
                  valueListenable: _t,
                  builder: (context, t, _) => Container(
                    height: topInset,
                    decoration: BoxDecoration(
                      color: bg,
                      boxShadow: t <= 0
                          ? null
                          : [
                              BoxShadow(
                                color: shadowColor.withValues(alpha: 0.22 * t),
                                blurRadius: 4,
                                offset: const Offset(0, 3),
                              ),
                            ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
