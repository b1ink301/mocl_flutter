import 'package:flutter/material.dart';

class CheckBoxListTitleWidget extends StatefulWidget {
  final String text;
  final ValueChanged<bool?>? onChanged;
  final bool checked;
  final TextStyle? textStyle;

  const CheckBoxListTitleWidget({
    super.key,
    required this.text,
    required this.checked,
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
    _isChecked = widget.checked;
  }

  @override
  Widget build(BuildContext context) => CheckboxListTile(
        value: _isChecked,
        title: Text(
          widget.text,
          style: widget.textStyle,
        ),
        onChanged: (value) {
          setState(() {
            _isChecked = value!;
            widget.onChanged?.call(_isChecked);
          });
        },
        activeColor: Colors.blueAccent,
        checkColor: Colors.white,
        isThreeLine: false,
        selected: _isChecked,
      );
}
