import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/settings_page/application/datasource_provider.dart';

class AppVersionWidget extends ConsumerWidget {
  const AppVersionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versionAsync = ref.watch(getAppVersionProvider);

    return versionAsync.maybeWhen(
      data: (version) => ListTile(
        title: Text(version, textAlign: TextAlign.center),
        titleTextStyle: Theme.of(context).textTheme.bodySmall,
      ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}
