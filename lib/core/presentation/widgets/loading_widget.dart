import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

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
