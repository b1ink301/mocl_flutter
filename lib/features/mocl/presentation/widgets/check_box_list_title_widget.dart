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
  Widget build(BuildContext context) => CheckboxListTile(
        value: _isChecked,
        title: Text(
          widget.text,
          style: widget.textStyle,
        ),
        onChanged: (value) {
          setState(() => _isChecked = value!);
          widget.onChanged?.call(_isChecked);
        },
        activeColor: Theme.of(context).indicatorColor,
        checkColor: Colors.white,
        isThreeLine: false,
        selected: _isChecked,
      );
}
