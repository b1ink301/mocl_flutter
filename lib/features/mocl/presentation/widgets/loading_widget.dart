import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key});

  @override
  Widget build(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: 0, vertical: isCupertino(context) ? 20 : 16),
      child: Center(
        child: PlatformCircularProgressIndicator(
          material: (context, _) => MaterialProgressIndicatorData(
            color: Theme.of(context).indicatorColor,
          ),
          cupertino: (context, _) => CupertinoProgressIndicatorData(
            color: Theme.of(context).indicatorColor,
          ),
        ),
      ));
}
