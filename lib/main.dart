import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/mocl/data/di/datasource_provider.dart';
import 'features/mocl/presentation/app_widget.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final SharedPreferences sharedPreferences =
  await SharedPreferences.getInstance();
  final Database database = await _database();

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
        appDatabaseProvider.overrideWithValue(database),
      ],
      child: const AppWidget(),
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
