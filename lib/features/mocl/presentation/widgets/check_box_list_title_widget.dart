import 'package:flutter/material.dart';

class CheckBoxListTitleWidget extends StatefulWidget {
  final String text;
  final ValueChanged<bool?>? onChanged;
  final bool checked;

  const CheckBoxListTitleWidget({
    super.key,
    required this.text,
    required this.checked,
    this.onChanged,
  });

  @override
  State<StatefulWidget> createState() =>
      _CheckBoxListTitleState()..onChanged = onChanged;
}

class _CheckBoxListTitleState extends State<CheckBoxListTitleWidget> {
  bool _isChecked = false;
  late final ValueChanged<bool?>? onChanged;


  @override
  void initState() {
    super.initState();
    _isChecked = widget.checked;
  }

  @override
  Widget build(BuildContext context) => CheckboxListTile(
        value: _isChecked,
        title: Text(widget.text),
        onChanged: (value) {
          setState(() {
            _isChecked = value!;
            onChanged?.call(_isChecked);
          });
        },
        activeColor: Colors.blueAccent,
        checkColor: Colors.white,
        isThreeLine: false,
        selected: _isChecked,
      );
}
