import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';

class AppVersionWidget extends ConsumerWidget {
  const AppVersionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => FutureBuilder<String>(
    builder: (BuildContext context, AsyncSnapshot<String> snapshot) =>
    snapshot.hasData && snapshot.data != null
        ? ListTile(
      title: Text(snapshot.data!, textAlign: TextAlign.center),
      titleTextStyle: Theme.of(context).textTheme.bodySmall,
    )
        : SizedBox.shrink(),
    future: ref.read(getAppVersionProvider.future),
  );
}
