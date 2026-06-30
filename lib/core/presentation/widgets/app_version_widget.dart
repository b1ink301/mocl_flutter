import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/settings_page/application/datasource_provider.dart';

class AppVersionWidget extends ConsumerWidget {
  const AppVersionWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final versionAsync = ref.watch(getAppVersionProvider);
    final bodySmall = Theme.of(context).textTheme.bodySmall;
    return versionAsync.maybeWhen(
      data: (version) =>
          Padding(
            padding: const EdgeInsets.only(bottom:  4),
            child: Text(version, textAlign: TextAlign.center, style: bodySmall),
          ),
      orElse: () => const SizedBox.shrink(),
    );
  }
}
