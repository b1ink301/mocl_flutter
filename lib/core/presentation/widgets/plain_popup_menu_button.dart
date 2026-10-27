import 'package:material_ui/material_ui.dart';

class const PlainPopupMenuButton<T>({
  super.key,
  required final Widget icon,
  required final List<PopupMenuEntry<T>> Function(BuildContext context)
  itemBuilder,
  final ValueChanged<T>? onSelected,
  final EdgeInsetsGeometry padding = const EdgeInsets.all(8),
}) extends StatefulWidget {
  @override
  State<PlainPopupMenuButton<T>> createState() =>
      _PlainPopupMenuButtonState<T>();
}

class _PlainPopupMenuButtonState<T>() extends State<PlainPopupMenuButton<T>> {
  Future<void> _showMenu() async {
    final RenderBox button = context.findRenderObject()! as RenderBox;
    final RenderBox overlay =
        Overlay.of(context).context.findRenderObject()! as RenderBox;
    final RelativeRect position = RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(Offset.zero, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero),
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );

    final T? result = await showMenu<T>(
      context: context,
      position: position,
      items: widget.itemBuilder(context),
    );

    if (result != null && mounted) {
      widget.onSelected?.call(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ❗️ Theme.of / IconTheme.of / PopupMenuTheme.of 호출 없음
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _showMenu,
      child: Padding(padding: widget.padding, child: widget.icon),
    );
  }
}
