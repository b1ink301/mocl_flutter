import 'dart:async';

import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:mocl_flutter/app_widget.dart';
import 'package:mocl_flutter/firebase_options.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/database/application/datasource_provider.dart';
import 'features/database/data/datasources/local/local_database.dart';
import 'features/settings_page/application/datasource_provider.dart';
import 'flavors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge, overlays: [.top, .bottom]);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  F.appFlavor = Flavor.values.firstWhere(
    (element) => element.name == appFlavor,
  );

  final sharedPrefs = await SharedPreferences.getInstance();
  final database = await openAppDatabase();

  runApp(
    ProviderScope(
      retry: retry,
      observers: [if (kDebugMode) Logger()],
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPrefs),
        localDatabaseProvider.overrideWithValue(
          LocalDatabase(database: database),
        ),
      ],
      child: const AppWidget(),
    ),
  );
}

final class Logger extends ProviderObserver {
  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) {
    debugPrint(
      'Provider: ${context.provider.name ?? context.provider.runtimeType}, error: $error, stackTrace: $stackTrace',
    );
  }
}

Duration? retry(int retryCount, Object error) {
  // Stop retrying on ProviderException
  if (retryCount >= 3) return null;
  // Ignore ProviderException
  if (error is ProviderException) return null;

  return Duration(milliseconds: 300 * (1 << retryCount)); // Exponential backoff
}
