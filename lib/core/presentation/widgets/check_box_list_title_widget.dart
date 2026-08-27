// ignore_for_file: unnecessary_import

// import 'package:cupertino_ui/cupertino_ui.dart';
import 'package:material_ui/material_ui.dart';

class const CheckBoxListTitleWidget({
  super.key,
  required final String text,
  required final bool isChecked,
  final void Function(bool)? onChanged,
  final TextStyle? textStyle,
}) extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CheckBoxListTitleState();
}

class _CheckBoxListTitleState() extends State<CheckBoxListTitleWidget> {
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
