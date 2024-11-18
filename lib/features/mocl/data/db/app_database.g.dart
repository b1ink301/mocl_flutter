// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

abstract class $AppDatabaseBuilderContract {
  /// Adds migrations to the builder.
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations);

  /// Adds a database [Callback] to the builder.
  $AppDatabaseBuilderContract addCallback(Callback callback);

  /// Creates the database and initializes it.
  Future<AppDatabase> build();
}

// ignore: avoid_classes_with_only_static_members
class $FloorAppDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract databaseBuilder(String name) =>
      _$AppDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static $AppDatabaseBuilderContract inMemoryDatabaseBuilder() =>
      _$AppDatabaseBuilder(null);
}

class _$AppDatabaseBuilder implements $AppDatabaseBuilderContract {
  _$AppDatabaseBuilder(this.name);

  final String? name;

  final List<Migration> _migrations = [];

  Callback? _callback;

  @override
  $AppDatabaseBuilderContract addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  @override
  $AppDatabaseBuilderContract addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  @override
  Future<AppDatabase> build() async {
    final path = name != null
        ? await sqfliteDatabaseFactory.getDatabasePath(name!)
        : ':memory:';
    final database = _$AppDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$AppDatabase extends AppDatabase {
  _$AppDatabase([StreamController<String>? listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  MainDao? _mainDaoInstance;

  IsReadDao? _isReadDaoInstance;

  Future<sqflite.Database> open(
    String path,
    List<Migration> migrations, [
    Callback? callback,
  ]) async {
    final databaseOptions = sqflite.OpenDatabaseOptions(
      version: 1,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
        await callback?.onConfigure?.call(database);
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `main` (`board` TEXT NOT NULL, `orderBy` INTEGER NOT NULL, `type` INTEGER NOT NULL, `text` TEXT NOT NULL, `url` TEXT NOT NULL, `siteType` INTEGER NOT NULL, PRIMARY KEY (`board`, `siteType`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `is_read` (`id` INTEGER NOT NULL, `siteType` INTEGER NOT NULL, PRIMARY KEY (`id`, `siteType`))');

        await callback?.onCreate?.call(database, version);
      },
    );
    return sqfliteDatabaseFactory.openDatabase(path, options: databaseOptions);
  }

  @override
  MainDao get mainDao {
    return _mainDaoInstance ??= _$MainDao(database, changeListener);
  }

  @override
  IsReadDao get isReadDao {
    return _isReadDaoInstance ??= _$IsReadDao(database, changeListener);
  }
}

class _$MainDao extends MainDao {
  _$MainDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _mainItemDataInsertionAdapter = InsertionAdapter(
            database,
            'main',
            (MainItemData item) => <String, Object?>{
                  'board': item.board,
                  'orderBy': item.orderBy,
                  'type': item.type,
                  'text': item.text,
                  'url': item.url,
                  'siteType': item.siteType.index
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<MainItemData> _mainItemDataInsertionAdapter;

  @override
  Future<List<MainItemData>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM main ORDER BY orderBy ASC',
        mapper: (Map<String, Object?> row) => MainItemData(
            board: row['board'] as String,
            orderBy: row['orderBy'] as int,
            type: row['type'] as int,
            text: row['text'] as String,
            url: row['url'] as String,
            siteType: SiteType.values[row['siteType'] as int]));
  }

  @override
  Future<List<MainItemData>> findBySiteType(SiteType siteType) async {
    return _queryAdapter.queryList(
        'SELECT * FROM main WHERE siteType = ?1 ORDER BY orderBy ASC',
        mapper: (Map<String, Object?> row) => MainItemData(
            board: row['board'] as String,
            orderBy: row['orderBy'] as int,
            type: row['type'] as int,
            text: row['text'] as String,
            url: row['url'] as String,
            siteType: SiteType.values[row['siteType'] as int]),
        arguments: [siteType.index]);
  }

  @override
  Future<MainItemData?> findByBoard(
    SiteType siteType,
    String board,
  ) async {
    return _queryAdapter.query(
        'SELECT * FROM main WHERE siteType = ?1 AND board = ?2',
        mapper: (Map<String, Object?> row) => MainItemData(
            board: row['board'] as String,
            orderBy: row['orderBy'] as int,
            type: row['type'] as int,
            text: row['text'] as String,
            url: row['url'] as String,
            siteType: SiteType.values[row['siteType'] as int]),
        arguments: [siteType.index, board]);
  }

  @override
  Future<void> deleteAll() async {
    await _queryAdapter.queryNoReturn('DELETE FROM main');
  }

  @override
  Future<void> deleteAllBySiteType(SiteType siteType) async {
    await _queryAdapter.queryNoReturn('DELETE FROM main WHERE siteType = ?1',
        arguments: [siteType.index]);
  }

  @override
  Future<int> insertItem(MainItemData entity) {
    return _mainItemDataInsertionAdapter.insertAndReturnId(
        entity, OnConflictStrategy.replace);
  }

  @override
  Future<List<int>> insertList(List<MainItemData> list) {
    return _mainItemDataInsertionAdapter.insertListAndReturnIds(
        list, OnConflictStrategy.replace);
  }
}

class _$IsReadDao extends IsReadDao {
  _$IsReadDao(
    this.database,
    this.changeListener,
  )   : _queryAdapter = QueryAdapter(database),
        _readItemDataInsertionAdapter = InsertionAdapter(
            database,
            'is_read',
            (ReadItemData item) => <String, Object?>{
                  'id': item.id,
                  'siteType': item.siteType.index
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  final InsertionAdapter<ReadItemData> _readItemDataInsertionAdapter;

  @override
  Future<List<ReadItemData>> findAll() async {
    return _queryAdapter.queryList('SELECT * FROM is_read',
        mapper: (Map<String, Object?> row) => ReadItemData(
            id: row['id'] as int,
            siteType: SiteType.values[row['siteType'] as int]));
  }

  @override
  Future<ReadItemData?> findById(int id) async {
    return _queryAdapter.query('SELECT * FROM is_read WHERE id = ?1',
        mapper: (Map<String, Object?> row) => ReadItemData(
            id: row['id'] as int,
            siteType: SiteType.values[row['siteType'] as int]),
        arguments: [id]);
  }

  @override
  Future<List<ReadItemData>> findByIds(List<int> ids) async {
    const offset = 1;
    final _sqliteVariablesForIds =
        Iterable<String>.generate(ids.length, (i) => '?${i + offset}')
            .join(',');
    return _queryAdapter.queryList(
        'SELECT * FROM is_read WHERE id IN (' + _sqliteVariablesForIds + ')',
        mapper: (Map<String, Object?> row) => ReadItemData(
            id: row['id'] as int,
            siteType: SiteType.values[row['siteType'] as int]),
        arguments: [...ids]);
  }

  @override
  Future<int> insert(ReadItemData entity) {
    return _readItemDataInsertionAdapter.insertAndReturnId(
        entity, OnConflictStrategy.ignore);
  }
}

// ignore_for_file: unused_element
final _dateTimeConverter = DateTimeConverter();
final _siteTypeConverter = SiteTypeConverter();
