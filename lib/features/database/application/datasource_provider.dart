import 'package:flutter/foundation.dart';
import 'package:mocl_flutter/features/database/data/datasources/local/database_migrations.dart';
import 'package:mocl_flutter/features/database/data/datasources/local/local_database.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_web/sembast_web.dart';

part 'datasource_provider.g.dart';

Future<Database> openAppDatabase() async {
  if (kIsWeb) {
    final path = join('/assets/db', 'mocl-sembast.db');
    return openVersionedDatabase(databaseFactoryWeb, path);
  } else {
    final dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final path = join(dir.path, 'mocl-sembast.db');
    return openVersionedDatabase(databaseFactoryIo, path);
  }
}

/// 스키마 버전을 맞춰 연다. 버전이 다르면 열면서 마이그레이션한다.
/// (테스트는 메모리 팩토리로 같은 경로를 거친다.)
Future<Database> openVersionedDatabase(DatabaseFactory factory, String path) =>
    factory.openDatabase(
      path,
      version: kAppDatabaseVersion,
      onVersionChanged: onAppDatabaseVersionChanged,
    );

@riverpod
LocalDatabase localDatabase(Ref ref) => throw UnimplementedError(
  'localDatabaseProvider must be overridden in main()',
);
