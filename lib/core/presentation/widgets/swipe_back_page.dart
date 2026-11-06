import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' show lerpDouble;

import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:material_ui/material_ui.dart' show Brightness, Theme;

/// 화면 어디서든 오른쪽(RTL 은 왼쪽)으로 끌면 뒤로 가는 페이지.
///
/// 두 가지 입력이 같은 전환 애니메이션(라우트 컨트롤러)을 움직인다.
/// - 본문 드래그: 앱이 직접 받는 가로 드래그. 손가락을 따라 화면이 밀린다.
/// - 시스템 뒤로가기 제스처(Android 14+ predictive back): 화면 양쪽 가장자리
///   스와이프는 OS 가 가져가므로 앱은 진행률만 받는다. 이 진행률로 같은 전환을
///   움직여서, 가장자리에서 끌어도 손을 놓기 전에 이전 화면이 드러난다.
///
/// 전환 모양은 [CupertinoPageTransition](오른쪽에서 밀려 들어오는 전환) 이다.
/// 뒤 화면에는 어두운 막을 깔아서, 앞 화면이 걷힐수록 옅어지게 한다(두 화면의 경계).
class const SwipeBackPage<T>({
  required final WidgetBuilder builder,

  /// false 면 본문 드래그도, 시스템 제스처 애니메이션도 쓰지 않는다
  /// (시스템 뒤로가기 자체는 그대로 동작한다).
  final bool canSwipe = true,
  final bool maintainState = true,
  super.key,
  super.name,
  super.arguments,
  super.restorationId,
}) extends Page<T> {
  @override
  Route<T> createRoute(BuildContext context) => SwipeBackPageRoute<T>(
    builder: builder,
    canSwipe: canSwipe,
    maintainState: maintainState,
    settings: this,
  );
}

/// [SwipeBackPage] 가 만드는 라우트.
class SwipeBackPageRoute<T>({
  required final WidgetBuilder builder,
  final bool canSwipe = true,
  @override final bool maintainState = true,
  super.settings,
}) extends PageRoute<T> {
  /// 뒤 화면을 덮는 막의 가장 진한 불투명도. 어두운 테마는 배경이 어두워 더 진하게 한다.
  static const double _kMaxScrimOpacityLight = 0.2;
  static const double _kMaxScrimOpacityDark = 0.45;

  /// 뒤 화면을 덮는 막. 테스트에서 찾을 때 쓴다.
  @visibleForTesting
  static const Key scrimKey = ValueKey<String>('SwipeBackPageRoute.scrim');

  // 손을 놓은 뒤 남은 거리를 마저 가는 시간(ms). CupertinoPageRoute 와 같은 값.
  static const int _kMaxDroppedSwipePageForwardAnimationTime = 800;
  static const int _kMaxPageBackAnimationTime = 300;

  // 이 속도(초당 화면 폭) 이상으로 튕기면 위치와 상관없이 방향대로 끝낸다.
  static const double _kMinFlingVelocity = 1;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 500);

  @override
  Color? get barrierColor => null;

  @override
  String? get barrierLabel => null;

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) =>
      nextRoute is SwipeBackPageRoute && !nextRoute.fullscreenDialog;

  @override
  bool get popGestureEnabled {
    if (!canSwipe || fullscreenDialog) return false;
    if (!super.popGestureEnabled) return false;
    // 위 화면이 닫히는 중이면 그게 끝난 뒤에 끌 수 있다.
    if (!secondaryAnimation!.isDismissed) return false;
    // 이미 다른 제스처가 진행 중이다.
    if (popGestureInProgress) return false;
    return true;
  }

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) => Semantics(
    scopesRoute: true,
    explicitChildNodes: true,
    child: builder(context),
  );

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) => CupertinoPageTransition(
    primaryRouteAnimation: animation,
    secondaryRouteAnimation: secondaryAnimation,
    // 제스처 중에는 손가락을 그대로 따라가도록 곡선을 빼고 선형으로 그린다.
    linearTransition: popGestureInProgress,
    child: Stack(
      fit: StackFit.passthrough,
      children: [
        _SwipeBackGestureDetector<T>(route: this, child: child),
        // 이 화면 위에 다른 화면이 올라와 있는 정도(secondaryAnimation)만큼 어둡게 한다.
        // 본문 드래그 · 시스템 제스처 · 버튼으로 닫기 모두 같은 값을 따른다.
        Positioned.fill(
          child: IgnorePointer(
            child: FadeTransition(
              key: scrimKey,
              opacity: secondaryAnimation.drive(
                Tween<double>(
                  begin: 0,
                  end: Theme.of(context).brightness == Brightness.dark
                      ? _kMaxScrimOpacityDark
                      : _kMaxScrimOpacityLight,
                ),
              ),
              child: const ColoredBox(color: Color(0xFF000000)),
            ),
          ),
        ),
      ],
    ),
  );

  // --- 제스처가 컨트롤러를 움직이는 부분 (본문 드래그 · 시스템 제스처 공통) ---

  /// didStartUserGesture 를 부른 Navigator. 짝이 되는 didStopUserGesture 를
  /// 꼭 한 번만 부르려고 둔다. 하나라도 빠지면 Navigator 가 계속 제스처 중으로
  /// 남아 앱 전체에서 스와이프 뒤로가기가 멈춘다.
  NavigatorState? _gestureNavigator;

  void _startGesture() {
    if (_gestureNavigator != null) return;
    _gestureNavigator = navigator!..didStartUserGesture();
  }

  void _stopGesture() {
    final NavigatorState? navigator = _gestureNavigator;
    _gestureNavigator = null;
    navigator?.didStopUserGesture();
  }

  // --- 위 화면이 닫히는 중일 때 이어서 뒤로 가기 ---
  //
  // 뒤로 가기를 놓은 뒤에도 닫히는 애니메이션이 잠깐(최대 0.8초) 이어지고, 그동안은
  // 아래 화면이 제스처를 받을 수 없다(Navigator 가 아직 제스처 중이고 secondaryAnimation 도
  // 안 끝남). 그 사이 바로 다시 엣지 스와이프하면 시스템 제스처가 거절되어 애니메이션 없이
  // pop 됐다. 새 제스처가 오면 닫히던 화면을 그 자리에서 마저 닫고 이어 받는다.

  /// Navigator 마다 지금 닫히는 중인 화면.
  static final Expando<SwipeBackPageRoute<dynamic>> _closingRoutes =
      Expando<SwipeBackPageRoute<dynamic>>('SwipeBackPageRoute.closing');

  NavigatorState? _closingNavigator;

  @override
  bool didPop(T? result) {
    final NavigatorState? navigator = this.navigator;
    final bool popped = super.didPop(result);
    // 드로어 · 지역 기록(LocalHistoryEntry)만 닫힌 pop 은 false 를 돌려주고 화면은 그대로다.
    // 이걸 "닫히는 중" 으로 적어 두면, 다음 화면에서 뒤로 가기를 시작할 때
    // 멀쩡한 이 화면의 컨트롤러를 0 으로 만들어 검은 화면이 된다.
    if (popped && navigator != null) {
      _closingRoutes[navigator] = this;
      _closingNavigator = navigator;
    }
    return popped;
  }

  /// 바로 위 화면이 닫히는 중인지.
  bool get _hasClosingRouteAbove {
    final NavigatorState? navigator = this.navigator;
    if (navigator == null || !isCurrent) return false;
    final SwipeBackPageRoute<dynamic>? closing = _closingRoutes[navigator];
    return closing != null &&
        !identical(closing, this) &&
        // 실제로 닫히는 애니메이션 중일 때만(이미 끝났거나 다시 열린 화면은 건드리지 않는다).
        closing.controller?.status == AnimationStatus.reverse;
  }

  /// 위 화면이 닫히는 중이면 지금 끝낸다. 그 뒤 이 화면이 제스처를 받을 수 있는지 돌려준다.
  bool _settleClosingRouteAbove() {
    if (_hasClosingRouteAbove) {
      // 0 으로 두면 곧바로 dismissed 가 되어 화면이 빠지고 제스처 상태도 풀린다.
      _closingRoutes[navigator!]!.controller?.value = 0;
    }
    return popGestureEnabled;
  }

  /// 지금 뒤로 가기 제스처를 시작할 수 있는지(위 화면이 닫히는 중이면 정리한 뒤 가능).
  bool get _canStartGesture => popGestureEnabled || _hasClosingRouteAbove;

  @override
  void dispose() {
    final NavigatorState? closingNavigator = _closingNavigator;
    if (closingNavigator != null &&
        identical(_closingRoutes[closingNavigator], this)) {
      _closingRoutes[closingNavigator] = null;
    }
    // 제스처 도중에 라우트가 사라지면(딥링크로 스택이 바뀌는 등) 상태를 풀어 준다.
    final NavigatorState? navigator = _gestureNavigator;
    if (navigator != null) {
      _gestureNavigator = null;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (navigator.mounted) navigator.didStopUserGesture();
      });
    }
    super.dispose();
  }

  /// [value] 1 = 화면이 다 보임, 0 = 다 닫힘.
  void _setGestureValue(double value) {
    // 제스처 중에 다른 이동이 일어났으면 더 건드리지 않는다.
    if (!isCurrent) return;
    controller!.value = value;
  }

  void _dragBy(double delta) => _setGestureValue(controller!.value - delta);

  /// 본문 드래그를 놓았을 때. [velocity] 는 초당 화면 폭(뒤로가기 방향이 +).
  void _endDrag(double velocity) {
    final bool pop = velocity.abs() >= _kMinFlingVelocity
        ? velocity > 0
        : controller!.value < 0.5;
    _finishGesture(pop: pop);
  }

  void _finishGesture({required bool pop}) {
    final AnimationController controller = this.controller!;
    final NavigatorState navigator = this.navigator!;
    const Curve curve = Curves.fastLinearToSlowEaseIn;

    if (isCurrent) {
      if (pop) {
        navigator.pop();
        // pop 이 곧바로 끝나지 않았으면 남은 거리에 맞춘 시간으로 닫는다.
        if (controller.isAnimating) {
          unawaited(
            controller.animateBack(
              0,
              duration: Duration(
                milliseconds: lerpDouble(
                  0,
                  _kMaxDroppedSwipePageForwardAnimationTime,
                  controller.value,
                )!.floor(),
              ),
              curve: curve,
            ),
          );
        }
      } else if (!controller.isCompleted) {
        unawaited(
          controller.animateTo(
            1,
            duration: Duration(
              milliseconds: math.min(
                lerpDouble(
                  _kMaxDroppedSwipePageForwardAnimationTime,
                  0,
                  controller.value,
                )!.floor(),
                _kMaxPageBackAnimationTime,
              ),
            ),
            curve: curve,
          ),
        );
      }
    }

    if (controller.isAnimating) {
      // 끝날 때까지 제스처 중으로 두어 전환이 도중에 곡선으로 바뀌지 않게 한다.
      late final AnimationStatusListener listener;
      listener = (AnimationStatus status) {
        controller.removeStatusListener(listener);
        _stopGesture();
      };
      controller.addStatusListener(listener);
    } else {
      _stopGesture();
    }
  }
}

/// 본문 드래그와 시스템 뒤로가기 제스처를 받아 [SwipeBackPageRoute] 로 넘긴다.
class const _SwipeBackGestureDetector<T>({
  required final SwipeBackPageRoute<T> route,
  required final Widget child,
}) extends StatefulWidget {
  @override
  State<_SwipeBackGestureDetector<T>> createState() =>
      _SwipeBackGestureDetectorState<T>();
}

class _SwipeBackGestureDetectorState<T>()
    extends State<_SwipeBackGestureDetector<T>>
    with WidgetsBindingObserver {
  late final _BackDragGestureRecognizer _recognizer;

  /// 본문 드래그 중.
  bool _dragging = false;

  /// 시스템 뒤로가기 제스처 중.
  bool _systemGesture = false;

  SwipeBackPageRoute<T> get _route => widget.route;

  @override
  void initState() {
    super.initState();
    _recognizer =
        _BackDragGestureRecognizer(
            debugOwner: this,
            isBackward: (double dx) => _toLogical(dx) > 0,
          )
          ..onStart = _handleDragStart
          ..onUpdate = _handleDragUpdate
          ..onEnd = _handleDragEnd
          ..onCancel = _handleDragCancel
          // 누른 자리에 다른 제스처가 없으면 누르는 순간 드래그가 시작된다.
          // 그러면 탭만 해도 제스처가 시작되므로(닫히던 위 화면이 튀는 등) 실제로 끌 때만 시작한다.
          ..onlyAcceptDragOnThreshold = true;
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _recognizer.dispose();
    super.dispose();
  }

  double _toLogical(double value) => switch (Directionality.of(context)) {
    TextDirection.rtl => -value,
    TextDirection.ltr => value,
  };

  // --- 본문 드래그 ---

  void _handlePointerDown(PointerDownEvent event) {
    if (_systemGesture || !_route._canStartGesture) return;
    // 제스처 내비게이션의 양쪽 가장자리는 OS 가 뒤로가기 제스처로 가져간다.
    // OS 는 판정 전까지 터치를 앱에도 보내므로, 여기서 본문 드래그를 시작하면
    // 시스템 제스처와 겹친다. 이 영역은 시스템 제스처([handleStartBackGesture])에 맡긴다.
    final EdgeInsets insets = MediaQuery.systemGestureInsetsOf(context);
    final double x = event.position.dx;
    if (x < insets.left ||
        x > MediaQuery.sizeOf(context).width - insets.right) {
      return;
    }
    _recognizer.addPointer(event);
  }

  void _handleDragStart(DragStartDetails details) {
    // 위 화면이 닫히는 중이었으면 실제로 끌기 시작할 때 정리한다
    // (누르기만 해도 정리하면 탭 · 스크롤에 화면이 튄다).
    if (!_route._settleClosingRouteAbove()) return;
    _dragging = true;
    _route._startGesture();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    if (!_dragging) return;
    _route._dragBy(_toLogical(details.primaryDelta! / context.size!.width));
  }

  void _handleDragEnd(DragEndDetails details) {
    if (!_dragging) return;
    _dragging = false;
    _route._endDrag(
      _toLogical(details.velocity.pixelsPerSecond.dx / context.size!.width),
    );
  }

  void _handleDragCancel() {
    // 시작 전(누르기만 하고 거절된 경우)에도 불린다.
    if (!_dragging) return;
    _dragging = false;
    _route._endDrag(0);
  }

  // --- 시스템 뒤로가기 제스처 (WidgetsBindingObserver) ---

  @override
  bool handleStartBackGesture(PredictiveBackEvent backEvent) {
    // 3버튼 내비게이션의 뒤로 버튼은 애니메이션 없이 평소처럼 pop 된다.
    if (backEvent.isButtonEvent || !_route.isCurrent) return false;
    if (_dragging) {
      // 가장자리 터치가 본문 드래그로 먼저 잡혔다. 시스템 제스처가 넘겨받고,
      // 곧 올 포인터 취소는 무시한다.
      _dragging = false;
    } else if (!_route._settleClosingRouteAbove()) {
      return false;
    }
    _systemGesture = true;
    _route._startGesture();
    _route._setGestureValue(1 - backEvent.progress);
    return true;
  }

  @override
  void handleUpdateBackGestureProgress(PredictiveBackEvent backEvent) {
    if (!_systemGesture) return;
    _route._setGestureValue(1 - backEvent.progress);
  }

  @override
  void handleCommitBackGesture() {
    if (!_systemGesture) return;
    _systemGesture = false;
    _route._finishGesture(pop: true);
  }

  @override
  void handleCancelBackGesture() {
    if (!_systemGesture) return;
    _systemGesture = false;
    _route._finishGesture(pop: false);
  }

  // 감지기를 본문 "위"에 투명하게 겹친다. 본문을 감싸기만 하면 본문 안의
  // 가로 드래그(상세의 SelectionArea 등)가 경쟁에서 먼저 받아 가 버린다.
  // 위에 두면 이 recognizer 가 먼저 등록되고, translucent 라 본문 터치는 그대로 간다.
  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.passthrough,
    children: [
      widget.child,
      Positioned.fill(
        child: Listener(
          onPointerDown: _handlePointerDown,
          behavior: HitTestBehavior.translucent,
        ),
      ),
    ],
  );
}

/// 뒤로가기 방향으로 움직일 때만 받는 가로 드래그.
///
/// 반대 방향(LTR 에서 왼쪽)으로 먼저 움직이면 일찍 포기해서, 왼쪽으로 미는
/// 다른 제스처(북마크 지우기 [Dismissible] 등)에 양보한다.
class _BackDragGestureRecognizer({
  required final bool Function(double dx) isBackward,
  super.debugOwner,
}) extends HorizontalDragGestureRecognizer {
  /// 드래그가 시작되기 전까지 포인터별로 움직인 가로 거리.
  final Map<int, double> _pendingDx = <int, double>{};
  bool _started = false;

  @override
  void addAllowedPointer(PointerDownEvent event) {
    _pendingDx[event.pointer] = 0;
    super.addAllowedPointer(event);
  }

  @override
  void handleEvent(PointerEvent event) {
    if (!_started && event is PointerMoveEvent) {
      final double dx = (_pendingDx[event.pointer] ?? 0) + event.delta.dx;
      _pendingDx[event.pointer] = dx;
      // 손떨림은 봐주고, 반대 방향으로 터치 슬롭 절반을 넘게 가면 포기한다.
      // (슬롭을 넘기 전에 포기해야 가로 드래그로 받아들여지지 않는다.)
      final double slop = computeHitSlop(event.kind, gestureSettings);
      if (!isBackward(dx) && dx.abs() > slop / 2) {
        stopTrackingPointer(event.pointer);
        return;
      }
    }
    super.handleEvent(event);
  }

  // 방향 검사는 드래그가 실제로 시작될 때까지 한다. 경쟁에서 이긴 시점(acceptGesture)은
  // 혼자일 때 누르는 순간이라 너무 이르다.
  @override
  set onStart(GestureDragStartCallback? callback) =>
      super.onStart = callback == null
      ? null
      : (DragStartDetails details) {
          _started = true;
          callback(details);
        };

  @override
  void stopTrackingPointer(int pointer) {
    _pendingDx.remove(pointer);
    super.stopTrackingPointer(pointer);
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    _started = false;
    super.didStopTrackingLastPointer(pointer);
  }
}
