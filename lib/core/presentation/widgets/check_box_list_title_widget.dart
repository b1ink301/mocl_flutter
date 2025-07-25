import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class CheckBoxListTitleWidget extends StatefulWidget {
  final String text;
  final void Function(bool)? onChanged;
  final bool isChecked;
  final TextStyle? textStyle;

  const CheckBoxListTitleWidget({
    super.key,
    required this.text,
    required this.isChecked,
    this.onChanged,
    this.textStyle,
  });

  @override
  State<StatefulWidget> createState() => _CheckBoxListTitleState();
}

class _CheckBoxListTitleState extends State<CheckBoxListTitleWidget> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    setState(() => _isChecked = widget.isChecked);
  }

  @override
  Widget build(BuildContext context) => PlatformListTile(
        material: (context, platform) => MaterialListTileData(
          contentPadding: const EdgeInsets.fromLTRB(16, 2, 8, 2),
        ),
        cupertino: (context, platform) => CupertinoListTileData(
          padding: const EdgeInsets.fromLTRB(16, 2, 8, 2),
        ),
        title: PlatformText(
          widget.text,
          style: widget.textStyle,
        ),
        onTap: () {
          setState(() => _isChecked = !_isChecked);
          widget.onChanged?.call(_isChecked);
        },
        trailing: PlatformCheckbox(
          onChanged: (value) {
            if (value != null) {
              setState(() => _isChecked = value);
              widget.onChanged?.call(_isChecked);
            }
          },
          activeColor: Theme.of(context).focusColor,
          checkColor: Colors.white,
          value: _isChecked,
        ),
      );
}
