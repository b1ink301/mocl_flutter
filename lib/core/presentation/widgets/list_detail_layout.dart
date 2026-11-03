import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/presentation/widgets/window_size.dart';

/// 목록과 상세를 넓은 화면에서는 나란히, 좁은 화면에서는 차례로 보여준다.
///
/// - 좁은 화면(< 840dp): [list] 만 그리고, 항목을 누르면 [pushDetail] 로 상세
///   화면을 쌓는다(예전과 같음).
/// - 넓은 화면: 왼쪽에 [list], 오른쪽 칸에 고른 항목의 상세를 그린다.
///
/// 폴드를 접고 펼치거나 회전 · 분할 화면으로 폭이 바뀌면 보던 글을 이어서 보여준다.
/// - 나란히 → 좁게: 오른쪽 칸의 글을 상세 화면으로 쌓는다.
/// - 좁게 → 나란히: 이 목록에서 쌓은 상세가 맨 위에 그대로 있으면 닫고 오른쪽 칸으로
///   옮긴다. 그 위에 사진 뷰어 등이 더 쌓여 있으면 건드리지 않는다.
///
/// 목록은 [GlobalKey] 로 붙여 두어 배치가 바뀌어도 스크롤 위치를 잃지 않는다.
class const ListDetailLayout<T extends Object>({
  required final Widget list,
  required final Widget Function(BuildContext context, T item) detailBuilder,
  required final Future<void> Function(BuildContext context, T item) pushDetail,
  required final Object Function(T item) keyOf,

  /// [pushDetail] 이 쌓는 라우트 경로. 맨 위가 이 화면인지 확인할 때 쓴다.
  required final String detailRoutePath,
  final String placeholder = '글을 선택하세요',
  super.key,
}) extends StatefulWidget {
  /// 목록 칸 폭.
  static double listPaneWidth(WindowSize size) =>
      size == WindowSize.large ? 420 : 380;

  @override
  State<ListDetailLayout<T>> createState() => _ListDetailLayoutState<T>();
}

class _ListDetailLayoutState<T extends Object>()
    extends State<ListDetailLayout<T>> {
  final GlobalKey _listKey = GlobalKey(debugLabel: 'ListDetailLayout.list');

  /// 넓은 화면에서 오른쪽 칸에 보여주는 항목.
  T? _selected;

  /// 좁은 화면에서 쌓은 상세의 항목과, 쌓기 직전 라우터 스택 깊이.
  T? _pushed;
  int _depthAtPush = 0;

  bool? _wasSplit;

  void _open(BuildContext context, Object item) {
    if (item is! T) return;
    if (context.windowSize.isSplit) {
      setState(() => _selected = item);
    } else {
      _push(item);
    }
  }

  void _push(T item) {
    _depthAtPush = GoRouter.of(context)
        .routerDelegate
        .currentConfiguration
        .matches
        .length;
    _pushed = item;
    widget.pushDetail(context, item).whenComplete(() {
      if (identical(_pushed, item)) _pushed = null;
    });
  }

  void _onSplitChanged(bool split) {
    if (!mounted) return;
    if (split) {
      final T? pushed = _pushed;
      if (pushed == null) return;
      final GoRouter router = GoRouter.of(context);
      final config = router.routerDelegate.currentConfiguration;
      final bool detailOnTop =
          config.matches.length == _depthAtPush + 1 &&
          config.last.route.path == widget.detailRoutePath;
      if (!detailOnTop) return;
      _pushed = null;
      router.pop();
      setState(() => _selected = pushed);
    } else {
      final T? selected = _selected;
      if (selected == null) return;
      setState(() => _selected = null);
      // 목록 위에 다른 화면(사진 뷰어 · 로그인 등)이 떠 있으면 그 위로 쌓지 않는다.
      if (ModalRoute.of(context)?.isCurrent ?? false) _push(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final WindowSize size = context.windowSize;
    final bool split = size.isSplit;
    if (_wasSplit != null && _wasSplit != split) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _onSplitChanged(split),
      );
    }
    _wasSplit = split;

    final Widget list = KeyedSubtree(key: _listKey, child: widget.list);
    final T? selected = split ? _selected : null;

    return ListDetailScope(
      isSplit: split,
      selectedKey: selected == null ? null : widget.keyOf(selected),
      open: _open,
      child: split
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: ListDetailLayout.listPaneWidth(size),
                  child: list,
                ),
                const VerticalDivider(width: 1, thickness: 1),
                Expanded(
                  child: selected == null
                      ? _Placeholder(text: widget.placeholder)
                      : ListDetailPane(
                          child: KeyedSubtree(
                            key: ValueKey<Object>(widget.keyOf(selected)),
                            child: widget.detailBuilder(context, selected),
                          ),
                        ),
                ),
              ],
            )
          : list,
    );
  }
}

/// [ListDetailLayout] 이 목록 쪽에 내리는 값.
class const ListDetailScope({
  required final bool isSplit,
  required final Object? selectedKey,
  required final void Function(BuildContext context, Object item) open,
  required super.child,
  super.key,
}) extends InheritedWidget {
  /// 항목을 연다. [ListDetailLayout] 밖이면 false 를 돌려주므로 호출한 쪽이
  /// 직접 상세를 쌓는다.
  static bool tryOpen(BuildContext context, Object item) {
    final scope = context.getInheritedWidgetOfExactType<ListDetailScope>();
    if (scope == null) return false;
    scope.open(context, item);
    return true;
  }

  /// 오른쪽 칸에 이 항목이 열려 있는지(목록에서 강조할 때 쓴다).
  static bool isSelected(BuildContext context, Object key) =>
      context
          .dependOnInheritedWidgetOfExactType<ListDetailScope>()
          ?.selectedKey ==
      key;

  @override
  bool updateShouldNotify(ListDetailScope oldWidget) =>
      isSplit != oldWidget.isSplit || selectedKey != oldWidget.selectedKey;
}

/// 오른쪽 상세 칸 안이라는 표시.
///
/// 칸 안의 상세는 라우트가 아니므로 뒤로가기 버튼 · 마우스 우클릭으로 닫지 않는다.
class const ListDetailPane({required super.child, super.key})
    extends InheritedWidget {
  static bool isPane(BuildContext context) =>
      context.getInheritedWidgetOfExactType<ListDetailPane>() != null;

  @override
  bool updateShouldNotify(ListDetailPane oldWidget) => false;
}

class const _Placeholder({required final String text}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final Color color = theme.colorScheme.onSurfaceVariant;
    return ColoredBox(
      color: theme.scaffoldBackgroundColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 12,
          children: [
            Icon(Icons.article_outlined, size: 48, color: color),
            Text(
              text,
              style: theme.textTheme.bodyLarge?.copyWith(color: color),
            ),
          ],
        ),
      ),
    );
  }
}
