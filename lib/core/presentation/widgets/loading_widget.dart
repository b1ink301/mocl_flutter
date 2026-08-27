import 'package:material_ui/material_ui.dart';

class const LoadingWidget({super.key}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final focusColor = Theme.of(context).focusColor;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 0, vertical: 16),
      child: Center(
        child: CircularProgressIndicator.adaptive(
          valueColor: AlwaysStoppedAnimation<Color>(focusColor),
        ),
      ),
    );
  }
}
