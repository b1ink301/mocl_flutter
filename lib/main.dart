import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/mocl/data/di/datasource_provider.dart';
import 'features/mocl/presentation/app_widget.dart';
import 'firebase_options.dart';

Future<void> main() async {
  SentryWidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  unawaited(_firebase());
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  final Database database = await _database();

  await SentryFlutter.init(
    (options) {
      options.dsn =
          'https://6dfe8c0776dd308db231083174773363@o4507983399813120.ingest.us.sentry.io/4507983631876096';
      options.tracesSampleRate = 1.0;
      options.profilesSampleRate = 1.0;
    },
    appRunner:
        () => runApp(
          ProviderScope(
            overrides: [
              sharedPreferencesProvider.overrideWithValue(sharedPreferences),
              appDatabaseProvider.overrideWithValue(database),
            ],
            child: const AppWidget(),
          ),
        ),
  );
}

Future<Database> _database() async {
  final Directory dir = await getApplicationDocumentsDirectory();
  await dir.create(recursive: true);
  final String dbPath = join(dir.path, 'mocl-sembast.db');
  final Database database = await databaseFactoryIo.openDatabase(dbPath);
  return database;
}

Future<void> _firebase() async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  PlatformDispatcher.instance.onError = (error, stack) {
    FirebaseCrashlytics.instance.recordError(error, stack);
    return true;
  };
}
