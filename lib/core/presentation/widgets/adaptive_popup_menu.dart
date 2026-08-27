import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_popup_menu_button.dart';

class const AdaptivePopupMenu({
  super.key,
  required final Widget icon,
  required final List<AdaptiveMenuOption> options,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => PlainPopupMenuButton<int>(
    icon: icon,
    onSelected: (index) => options[index].onTap?.call(),
    itemBuilder: (_) => options
        .asMap()
        .entries
        .map(
          (e) => PopupMenuItem<int>(value: e.key, child: Text(e.value.label)),
        )
        .toList(),
  );
}

class const AdaptiveMenuOption({
  required final String label,
  final VoidCallback? onTap,
});
