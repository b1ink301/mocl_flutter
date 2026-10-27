import 'package:material_ui/material_ui.dart';

class const ModalBottomSheetPage<T>({
  required final WidgetBuilder builder,
  final bool isScrollControlled = true,
  final Color? backgroundColor = Colors.transparent,
  super.key,
}) extends Page<T> {
  @override
  Route<T> createRoute(BuildContext context) => ModalBottomSheetRoute<T>(
    builder: builder,
    isScrollControlled: isScrollControlled,
    backgroundColor: backgroundColor,
    settings: this,
  );
}
