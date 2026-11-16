import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:material_ui/material_ui.dart';

/// 알약형 탭 하나의 정의(아이콘 · 선택 아이콘 · 라벨).
typedef PillTabItem = ({IconData icon, IconData selectedIcon, String label});

/// 알약 바깥 테두리의 둥글기. 선택 표시도 같은 값을 써서 바와 같은 곡률로 보인다.
const double _kPillRadius = 32;

/// 바 테두리와 선택 표시 사이 간격(위아래 · 양옆 같게).
const double _kBarInset = 6;

/// 탭 자리(누르는 영역)의 좌우 여백. 탭은 4등분하지 않고 내용 폭만큼만 차지한다.
const double _kSlotPadding = 10;

/// 선택 표시가 탭 자리 밖으로 나가는 폭. 이웃 탭의 빈 여백과 겹쳐 그려서,
/// 선택 표시는 넉넉하게(좌우 [_kSlotPadding] + 이 값) 두고 탭 사이 간격은 줄인다.
/// 누르는 영역은 탭 자리 안이라 겹친 곳을 눌러도 이웃 탭이 눌린다.
/// 선택 표시는 바에 하나뿐이라(탭을 옮기면 미끄러져 간다) 이웃 표시와 겹쳐 보일 일이 없다.
const double _kFocusOverlap = 4;

/// 탭 내용의 최소 폭. "설정" 처럼 짧은 라벨에서 선택 표시가 동그랗게 줄지 않게.
const double _kMinContentWidth = 40;

/// 선택 표시가 다른 탭으로 옮겨 가는 시간 · 곡선.
const Duration _kMoveDuration = Duration(milliseconds: 250);
const Curve _kMoveCurve = Curves.easeOutCubic;

/// 화면 아래 가운데에 떠 있는 알약형 탭바(홈 · 차단 화면).
///
/// 탭 목록을 밖에서 넘겨받는다. 본문이 바 뒤로 비치도록 Scaffold 는
/// `extendBody: true` 로 두고, 목록은 `MediaQuery.padding.bottom` 만큼 아래
/// 여백을 준다(Scaffold 가 바 높이를 그 값에 더해준다).
///
/// 선택 표시는 탭마다 그리지 않고 탭 줄 뒤에 **하나만** 그려, 탭을 바꾸면 옛 자리에서
/// 새 자리로 미끄러지며 폭도 맞춘다([_PillTabRow]). 탭마다 따로 페이드하면 사라지는
/// 표시와 생기는 표시(+ 눌림 잉크)가 겹친 여백에서 같이 보였다.
class const FloatingPillTabBar({
  super.key,
  required final List<PillTabItem> items,
  required final int selectedIndex,
  required final ValueChanged<int> onSelected,

  /// 아이콘에 점을 붙일 탭(새 소식 알림).
  final Set<int> dots = const <int>{},

  /// 탭마다 붙일 `Semantics(identifier:)`(기기 확인 스크립트용). 없으면 붙이지 않는다.
  final List<String>? semanticsIds,
}) extends StatefulWidget {
  @override
  State<FloatingPillTabBar> createState() => _FloatingPillTabBarState();
}

class _FloatingPillTabBarState()
    extends State<FloatingPillTabBar>
    with SingleTickerProviderStateMixin {
  // 처음에는 이미 제자리(1.0). 탭이 바뀔 때만 0 → 1 로 옮겨 간다.
  late final AnimationController _move = AnimationController(
    vsync: this,
    duration: _kMoveDuration,
    value: 1,
  );

  @override
  void didUpdateWidget(FloatingPillTabBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedIndex == widget.selectedIndex) return;
    if (MediaQuery.disableAnimationsOf(context)) {
      _move.value = 1;
    } else {
      _move.forward(from: 0);
    }
  }

  @override
  void dispose() {
    _move.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color barColor =
        theme.appBarTheme.backgroundColor ?? theme.scaffoldBackgroundColor;
    final List<PillTabItem> items = widget.items;

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        // Scaffold 는 bottomNavigationBar 를 화면 높이까지 열린 제약으로 재므로
        // Center 대신 Row 로 가로만 가운데 정렬한다(세로는 내용만큼).
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Row 는 자식에게 폭 제한을 주지 않으므로 Flexible 로 감싸야 바가 화면 폭에
            // 묶이고, 아래 FittedBox 가 좁은 화면 · 큰 글자에서 넘치는 대신 줄인다.
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  color: barColor,
                  borderRadius: BorderRadius.circular(_kPillRadius),
                  border: Border.all(color: theme.dividerColor),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: isDark ? 0.45 : 0.13,
                      ),
                      blurRadius: 20,
                      offset: const Offset(0, 7),
                    ),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Material(
                  type: MaterialType.transparency,
                  child: Padding(
                    // 선택 표시와 바 테두리 사이를 위아래 · 양옆 모두 [_kBarInset] 으로 맞춘다
                    // (둘 다 양 끝이 반원이라 간격이 같아야 곡선이 나란해 보인다).
                    // 선택 표시는 탭 자리 밖으로 [_kFocusOverlap] 만큼 나가므로 그만큼 더 띄운다.
                    padding: const EdgeInsets.symmetric(
                      horizontal: _kBarInset + _kFocusOverlap,
                      vertical: _kBarInset,
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: _PillTabRow(
                        selectedIndex: widget.selectedIndex,
                        animation: _move,
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.15,
                        ),
                        children: [
                          for (int i = 0; i < items.length; i++)
                            _PillTabItemView(
                              item: items[i],
                              isSelected: i == widget.selectedIndex,
                              dot: widget.dots.contains(i),
                              semanticsId: widget.semanticsIds?[i],
                              onTap: () => widget.onSelected(i),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 탭을 가로로 늘어놓고, 그 뒤에 선택 표시 하나를 그리는 줄.
///
/// 탭 폭이 내용마다 달라서 선택 표시 자리는 레이아웃이 끝나야 안다. 그래서 위젯으로
/// 재서 다음 프레임에 놓지 않고 렌더 객체가 그릴 때 바로 계산한다(첫 프레임부터 제자리,
/// FittedBox 로 줄어도 같이 줄어든다). 움직이는 동안은 다시 그리기만 하고 레이아웃은 없다.
class const _PillTabRow({
  required final int selectedIndex,
  required final Animation<double> animation,
  required final Color color,
  required super.children,
}) extends MultiChildRenderObjectWidget {
  @override
  _RenderPillTabRow createRenderObject(BuildContext context) =>
      _RenderPillTabRow(
        selectedIndex: selectedIndex,
        animation: animation,
        color: color,
      );

  @override
  void updateRenderObject(
    BuildContext context,
    _RenderPillTabRow renderObject,
  ) {
    renderObject
      ..selectedIndex = selectedIndex
      ..animation = animation
      ..color = color;
  }
}

class _PillTabParentData() extends ContainerBoxParentData<RenderBox>;

class _RenderPillTabRow({
  required int selectedIndex,
  required Animation<double> animation,
  required Color color,
}) extends RenderBox
    with
        ContainerRenderObjectMixin<RenderBox, _PillTabParentData>,
        RenderBoxContainerDefaultsMixin<RenderBox, _PillTabParentData> {
  int _selectedIndex = selectedIndex;
  set selectedIndex(int value) {
    if (value == _selectedIndex) return;
    // 지금 화면에 그려진 자리에서 출발한다. 움직이는 중에 또 누르면 그 자리에서 방향을 튼다.
    // (State 가 애니메이션을 0 으로 되돌린 뒤라 애니메이션 값으로는 지금 자리를 알 수 없다.)
    _from = _painted;
    _selectedIndex = value;
    markNeedsPaint();
  }

  Animation<double> _animation = animation;
  set animation(Animation<double> value) {
    if (identical(value, _animation)) return;
    if (attached) _animation.removeListener(markNeedsPaint);
    _animation = value;
    if (attached) _animation.addListener(markNeedsPaint);
    markNeedsPaint();
  }

  Color _color = color;
  set color(Color value) {
    if (value == _color) return;
    _color = value;
    markNeedsPaint();
  }

  /// 옮겨 가기 시작한 자리 · 마지막으로 그린 자리(탭 자리 기준, 이 상자 좌표).
  Rect? _from;
  Rect? _painted;

  @override
  void attach(PipelineOwner owner) {
    super.attach(owner);
    _animation.addListener(markNeedsPaint);
  }

  @override
  void detach() {
    _animation.removeListener(markNeedsPaint);
    super.detach();
  }

  @override
  void setupParentData(RenderBox child) {
    if (child.parentData is! _PillTabParentData) {
      child.parentData = _PillTabParentData();
    }
  }

  Size _layout(BoxConstraints constraints, {required bool dry}) {
    final BoxConstraints childConstraints = BoxConstraints(
      maxHeight: constraints.maxHeight,
    );
    double width = 0;
    double height = 0;
    for (RenderBox? child = firstChild; child != null;) {
      final Size size = dry
          ? child.getDryLayout(childConstraints)
          : (child..layout(childConstraints, parentUsesSize: true)).size;
      width += size.width;
      height = math.max(height, size.height);
      child = childAfter(child);
    }
    if (!dry) {
      double x = 0;
      for (RenderBox? child = firstChild; child != null;) {
        final _PillTabParentData data = child.parentData! as _PillTabParentData;
        data.offset = Offset(x, (height - child.size.height) / 2);
        x += child.size.width;
        child = data.nextSibling;
      }
    }
    return constraints.constrain(Size(width, height));
  }

  @override
  void performLayout() => size = _layout(constraints, dry: false);

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      _layout(constraints, dry: true);

  double _sum(double Function(RenderBox child) f) {
    double total = 0;
    for (RenderBox? c = firstChild; c != null; c = childAfter(c)) {
      total += f(c);
    }
    return total;
  }

  double _max(double Function(RenderBox child) f) {
    double result = 0;
    for (RenderBox? c = firstChild; c != null; c = childAfter(c)) {
      result = math.max(result, f(c));
    }
    return result;
  }

  @override
  double computeMinIntrinsicWidth(double height) =>
      _sum((c) => c.getMinIntrinsicWidth(height));

  @override
  double computeMaxIntrinsicWidth(double height) =>
      _sum((c) => c.getMaxIntrinsicWidth(height));

  @override
  double computeMinIntrinsicHeight(double width) =>
      _max((c) => c.getMinIntrinsicHeight(double.infinity));

  @override
  double computeMaxIntrinsicHeight(double width) =>
      _max((c) => c.getMaxIntrinsicHeight(double.infinity));

  /// [index] 번째 탭 자리(줄 높이 전체).
  Rect? _slot(int index) {
    if (index < 0) return null;
    RenderBox? child = firstChild;
    for (int i = 0; child != null && i < index; i++) {
      child = childAfter(child);
    }
    if (child == null) return null;
    final _PillTabParentData data = child.parentData! as _PillTabParentData;
    return Rect.fromLTWH(data.offset.dx, 0, child.size.width, size.height);
  }

  @override
  void paint(PaintingContext context, Offset offset) {
    final Rect? target = _slot(_selectedIndex);
    if (target == null) {
      _painted = null;
    } else {
      final double t = _kMoveCurve.transform(_animation.value);
      final Rect? from = _from;
      final Rect rect = from == null || t >= 1
          ? target
          : Rect.lerp(from, target, t)!;
      _painted = rect;
      // 탭 자리보다 양옆으로 [_kFocusOverlap] 씩 넓게(이웃 탭의 빈 여백까지) 그린다.
      context.canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTRB(
            rect.left - _kFocusOverlap,
            rect.top,
            rect.right + _kFocusOverlap,
            rect.bottom,
          ).shift(offset),
          const Radius.circular(_kPillRadius),
        ),
        Paint()..color = _color,
      );
    }
    defaultPaint(context, offset);
  }

  @override
  bool hitTestChildren(BoxHitTestResult result, {required Offset position}) =>
      defaultHitTestChildren(result, position: position);
}

class const _PillTabItemView({
  required final PillTabItem item,
  required final bool isSelected,
  required final bool dot,
  required final String? semanticsId,
  required final VoidCallback onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color focusColor = theme.colorScheme.primary;
    final Color mutedColor =
        theme.textTheme.bodySmall?.color ?? theme.colorScheme.onSurfaceVariant;
    final Color tint = isSelected ? focusColor : mutedColor;

    // 눌림 잉크(회색 물결 · 하이라이트)는 그리지 않는다. 옮겨 가는 선택 표시가 곧 눌린
    // 표시이고, 잉크가 있으면 다시 두 모양이 겹친다. 키보드 포커스 표시만 남긴다.
    final Widget tab = InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(_kPillRadius),
      splashFactory: NoSplash.splashFactory,
      overlayColor: WidgetStateProperty.resolveWith(
        (states) =>
            states.contains(WidgetState.focused) ? null : Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: _kSlotPadding,
          vertical: 8,
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(minWidth: _kMinContentWidth),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Badge(
                isLabelVisible: dot,
                smallSize: 7,
                child: Icon(
                  isSelected ? item.selectedIcon : item.icon,
                  size: 22,
                  color: tint,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item.label,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 11.5,
                  height: 1.1,
                  color: tint,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
    final Widget labeled = Semantics(
      selected: isSelected,
      value: dot ? '새 소식 있음' : null,
      child: tab,
    );
    return semanticsId == null
        ? labeled
        : Semantics(identifier: semanticsId, child: labeled);
  }
}
