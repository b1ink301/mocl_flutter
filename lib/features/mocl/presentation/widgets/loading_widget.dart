import 'package:flutter/material.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
          child: Center(
              child: CircularProgressIndicator(
            color: Theme.of(context).indicatorColor,
          )),
        ),
      const DividerWidget(),
    ],
  );
}
