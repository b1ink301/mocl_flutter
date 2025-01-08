import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/config/mocl_theme.dart';
import 'package:mocl_flutter/features/mocl/presentation/common/mocl_custom_scroll_behavior.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';

class AppWidget extends ConsumerWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
        debugShowCheckedModeBanner: false,
        scrollBehavior: CustomScrollBehavior(),
        theme: MoclTheme.lightTheme,
        darkTheme: MoclTheme.darkTheme,
        routerConfig: ref.read(appRouterProvider),
      );
}
