import 'package:flutter/foundation.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/database/data/datasources/local/local_database.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

part 'datasource_provider.g.dart';

@riverpod
Future<Database> appDatabase(Ref ref) async {
  if (kIsWeb) {
    final path = join('/assets/db', 'mocl-sembast.db');
    return databaseFactoryWeb.openDatabase(path);
  } else {
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final path = join(dir.path, 'mocl-sembast.db');
    return databaseFactoryIo.openDatabase(path);
  }
}

@riverpod
LocalDatabase localDatabase(Ref ref) => ref
    .watch(appDatabaseProvider)
    .maybeWhen(
      data: (database) => LocalDatabase(database: database),
      orElse: () => throw CallFunctionFailure(message: 'Error: appDatabase()'),
    );
