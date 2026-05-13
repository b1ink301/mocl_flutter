import 'package:flutter/material.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_popup_menu_button.dart';

class AdaptivePopupMenu extends StatelessWidget {
  final Widget icon;
  final List<AdaptiveMenuOption> options;

  const AdaptivePopupMenu({
    super.key,
    required this.icon,
    required this.options,
  });

  @override
  Widget build(BuildContext context) => PlainPopupMenuButton<int>(
          icon: icon,
          onSelected: (index) => options[index].onTap?.call(),
          itemBuilder: (_) => options
              .asMap()
              .entries
              .map(
                (e) => PopupMenuItem<int>(
                  value: e.key,
                  child: Text(e.value.label),
                ),
              )
              .toList(),
        );
}

class AdaptiveMenuOption {
  final String label;
  final VoidCallback? onTap;

  const AdaptiveMenuOption({required this.label, this.onTap});
}
