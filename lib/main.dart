import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/data/db/app_database.dart';
import 'package:mocl_flutter/features/mocl/data/di/datasource_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/app_widget.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    systemNavigationBarContrastEnforced: false,
    systemNavigationBarColor: Colors.transparent,
    systemStatusBarContrastEnforced: false,
  ));

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  // await configureDependencies();
  unawaited(_firebase());

  final sharedPreferences = await SharedPreferences.getInstance();
  final appDatabase =
  await $FloorAppDatabase.databaseBuilder('mocl.db').build();

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://6dfe8c0776dd308db231083174773363@o4507983399813120.ingest.us.sentry.io/4507983631876096';
      // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
      // We recommend adjusting this value in production.
      options.tracesSampleRate = 1.0;
      // The sampling rate for profiling is relative to tracesSampleRate
      // Setting to 1.0 will profile 100% of sampled transactions:
      options.profilesSampleRate = 1.0;
    },
    appRunner: () => runApp(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sharedPreferences),
          appDatabaseProvider.overrideWithValue(appDatabase),
        ],
        child: const AppWidget(),
      ),
    ),
  );
}

Future<void> _firebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
    return true;
  };
}
