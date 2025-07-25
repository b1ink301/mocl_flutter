import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'di/datasource_provider.dart';
import 'features/app_shell/presentation/app_widget.dart';
import 'firebase_options.dart';
import 'flavors.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  F.appFlavor = Flavor.values.firstWhere(
    (element) => element.name == appFlavor,
  );

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(
          await SharedPreferences.getInstance(),
        ),
        appDatabaseProvider.overrideWithValue(await _database()),
      ],
      child: const AppWidget(),
    ),
  );
}

Future<Database> _database() async {
  final dir = await getApplicationDocumentsDirectory();
  await dir.create(recursive: true);
  final dbPath = join(dir.path, 'mocl-sembast.db');
  return await databaseFactoryIo.openDatabase(dbPath);
}
