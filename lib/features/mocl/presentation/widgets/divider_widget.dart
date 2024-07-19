import 'package:flutter/material.dart';

class DividerWidget extends StatelessWidget {
  const DividerWidget({super.key});

  @override
  Widget build(BuildContext context) => Divider(
      height: 1,
      thickness: 1,
      indent: 12,
      endIndent: 8,
    );
}