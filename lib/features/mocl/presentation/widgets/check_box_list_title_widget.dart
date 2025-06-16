import 'package:flutter/material.dart';

class CheckBoxListTitleWidget<T> extends StatefulWidget {
  final String text;
  final void Function<T>(bool, T?)? onChanged;
  final T? object;
  final bool isChecked;
  final TextStyle? textStyle;

  const CheckBoxListTitleWidget({
    super.key,
    required this.text,
    required this.isChecked,
    this.onChanged,
    this.textStyle,
    this.object,
  });

  @override
  State<StatefulWidget> createState() => _CheckBoxListTitleState();
}

class _CheckBoxListTitleState extends State<CheckBoxListTitleWidget> {
  bool _isChecked = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      _isChecked = widget.isChecked;
    });
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
            widget.onChanged?.call(_isChecked, widget.object);
          });
        },
      contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
        activeColor: Theme.of(context).focusColor,
        checkColor: Colors.white,
        isThreeLine: false,
        selected: _isChecked,
      );
}
