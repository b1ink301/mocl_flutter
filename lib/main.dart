import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/presentation/mocl_theme.dart';

import 'features/mocl/presentation/common/mocl_custom_scroll_behavior.dart';
import 'features/mocl/presentation/injection.dart';
import 'features/mocl/presentation/routes/mocl_app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await configureDependencies();
  runApp(const ProviderScope(
    child: MoclApp(),
  ));
}

class MoclApp extends StatelessWidget {
  const MoclApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
        scrollBehavior: CustomScrollBehavior(),
        theme: MoclTheme.lightTheme,
        darkTheme: MoclTheme.darkTheme,
        routerConfig: AppPages.router,
      );
}
