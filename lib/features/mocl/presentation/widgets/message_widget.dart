import 'package:flutter/material.dart';

class MessageWidget extends StatelessWidget {
  final String message;
  final double? fontSize;

  const MessageWidget({
    super.key,
    required this.message,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
        child: Text(
          message,
          style: TextStyle(
            fontSize: fontSize ?? 16,
            // backgroundColor: Colors.black12,
          ),
          textAlign: TextAlign.start,
        ),
      );
}
