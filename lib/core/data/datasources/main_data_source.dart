import 'package:flutter/foundation.dart';
import 'package:mocl_flutter/core/data/datasources/remote/base/base_api.dart';
import 'package:mocl_flutter/core/data/datasources/remote/base/base_parser.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/util/read_json_from_assets.dart';
import 'package:mocl_flutter/features/database/domain/entities/main_item_data.dart';
import 'package:mocl_flutter/features/database/data/datasources/local/local_database.dart';
import 'package:mocl_flutter/features/database/data/models/main_item_model.dart';
import 'package:mocl_flutter/features/database/data/models/model_mapper.dart';

abstract class MainDataSource {
  Future<List<MainItem>> get(SiteType siteType);

  Future<List<int>> set(SiteType siteType, List<MainItem> list);

  Future<List<MainItemModel>> getAllFromJson(SiteType siteType);

  Future<void> deleteAll(SiteType siteType);

  Future<bool> hasItem(SiteType siteType, MainItem item);
}

class MainDataSourceImpl implements MainDataSource {
  final LocalDatabase localDatabase;
  final BaseApi apiClient;
  final BaseParser parser;

  const MainDataSourceImpl({
    required this.localDatabase,
    required this.apiClient,
    required this.parser,
  });

  @override
  Future<List<MainItem>> get(SiteType siteType) async =>
      siteType == SiteType.naverCafe
      ? (await apiClient.main(parser)).getOrElse((Failure f) => throw f)
      : (await localDatabase.getMainData(
          siteType,
        )).map((item) => item.toMainItemModel().toEntity(siteType)).toList();

  @override
  Future<List<int>> set(SiteType siteType, List<MainItem> list) async {
    final entities = list.map((item) {
      final MainItemModel data = MainItemMapper.fromEntityToModel(item);
      return MainItemMapper.fromModelToEntity(data);
    }).toList();
    await localDatabase.deleteAll(siteType);
    return localDatabase.setMainData(siteType, entities);
  }

  @override
  Future<List<MainItemModel>> getAllFromJson(SiteType siteType) async {
    try {
      final String jsonPath = '${siteType.name.toLowerCase()}/board_link.json';
      final List decodedData = await readJsonFromAssets<List<dynamic>>(
        jsonPath,
      );
      return decodedData.map((item) => MainItemModel.fromJson(item)).toList();
    } on Exception catch (e) {
      debugPrint("getAllFromJson - ${e.toString()}");
      return const [];
    }
  }

  @override
  Future<void> deleteAll(SiteType siteType) =>
      localDatabase.deleteAll(siteType);

  @override
  Future<bool> hasItem(SiteType siteType, MainItem item) {
    final data = MainItemMapper.fromEntityToModel(item);
    final entity = MainItemMapper.fromModelToEntity(data);
    return localDatabase.hasItem(siteType, entity);
  }
}
