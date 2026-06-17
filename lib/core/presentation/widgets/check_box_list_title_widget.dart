// ignore_for_file: unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  Widget build(BuildContext context) {
    final focusColor = Theme.of(context).focusColor;
    final trailing = Checkbox.adaptive(
      onChanged: (value) {
        if (value != null) {
          setState(() => _isChecked = value);
          widget.onChanged?.call(_isChecked);
        }
      },
      activeColor: focusColor,
      checkColor: Colors.white,
      value: _isChecked,
    );

    final title = Text(widget.text, style: widget.textStyle);

    void onTap() {
      setState(() => _isChecked = !_isChecked);
      widget.onChanged?.call(_isChecked);
    }

    return ListTile(
      contentPadding: const EdgeInsets.fromLTRB(16, 2, 8, 2),
      title: title,
      onTap: onTap,
      trailing: trailing,
    );
  }
}
