import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/data/network/api_client.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/list_data_source.dart';
import 'package:mocl_flutter/features/mocl/data/db/local_database.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/base_parser.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/parser/damoang_parser.dart';
import 'package:mocl_flutter/features/mocl/data/di/datasource_provider.dart';
import 'package:mocl_flutter/features/mocl/data/models/main_item_model.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sembast/sembast_io.dart';

import 'mocl_list_data_source_test.mocks.dart';

@GenerateMocks([ApiClient])
void main() {
  const SiteType siteType = SiteType.damoang;
  late final ListDataSource listDataSource;
  late final BaseParser parser;
  late final MockApiClient mockApiClient;
  late final LocalDatabase localDatabase;
  late final ProviderContainer container;

  const mainItemModel = MainItemModel(
    orderBy: 1,
    board: "free",
    type: 0,
    text: "free",
    url: "https://damoang.net/free",
    siteType: siteType,
  );

  setUpAll(() async {
    TestWidgetsFlutterBinding.ensureInitialized();

    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
            const MethodChannel('plugins.flutter.io/path_provider'),
            (MethodCall methodCall) async {
      return './';
    });

    final Directory dir = await getApplicationDocumentsDirectory();
    await dir.create(recursive: true);
    final String dbPath = join(dir.path, 'mocl-sembast.db');
    final Database database = await databaseFactoryIo.openDatabase(dbPath);
    localDatabase = LocalDatabase(database: database);

    parser = DamoangParser();
    mockApiClient = MockApiClient();
    container = ProviderContainer(
      overrides: [
        listDatasourceProvider.overrideWithValue(ListDataSourceImpl(
            apiClient: mockApiClient, localDatabase: localDatabase))
      ],
    );

    listDataSource = container.read(listDatasourceProvider);
  });

  test('list remote datasource test. (success)', () async {
    // arrange
    provideDummyBuilder<Either<Failure, List<ListItem>>>(
        (_, __) => Right(const <ListItem>[]));

    when(mockApiClient.getList(any, any, any, any, any))
        .thenAnswer((_) async => Right(const <ListItem>[]));

    final item = mainItemModel.toEntity(siteType);
    log("result=$item");

    // act
    final Either<Failure, List<ListItem>> result =
        await listDataSource.getList(item, 0, -1, parser);
    // assert
    expect(result.isRight(), true);

    expect(result.getRight().toNullable(), isA<List<ListItem>>());
  });

  test('list remote datasource test. (failed)', () async {
    //arrange
    provideDummyBuilder<Either<Failure, List<ListItem>>>(
            (_, __) => Left(GetListFailure(message: '----')));

    when(mockApiClient.getList(any, any, any, any, any))
        .thenAnswer((_) async => Left(GetListFailure(message: '----')));

    //act
    final MainItem item = mainItemModel.toEntity(siteType);
    final Either<Failure, List<ListItem>> result =
        await listDataSource.getList(item, 0, -1, parser);
    expect(result.isLeft(), true);
    expect(result.getLeft().toNullable(), isA<GetListFailure>());
  });
}
