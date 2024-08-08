import 'package:flutter/material.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Center(
          child: CircularProgressIndicator(
        color: Theme.of(context).indicatorColor,
      )),
    );
  }
}
