import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/presentation/common/mocl_custom_scroll_behavior.dart';
import 'package:mocl_flutter/features/mocl/presentation/mocl_theme.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  const fatalError = true;
  PlatformDispatcher.instance.onError = (error, stack) {
    if (fatalError) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      // ignore: dead_code
    } else {
      FirebaseCrashlytics.instance.recordError(error, stack);
    }
    return true;
  };
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
