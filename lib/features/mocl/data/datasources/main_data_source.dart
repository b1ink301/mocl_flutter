import 'package:flutter/foundation.dart';
import 'package:mocl_flutter/core/util/read_json_from_assets.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/local_database.dart';
import 'package:mocl_flutter/features/mocl/data/db/entities/main_item_data.dart';
import 'package:mocl_flutter/features/mocl/data/models/main_item_model.dart';
import 'package:mocl_flutter/features/mocl/data/models/model_mapper.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

abstract class MainDataSource {
  Future<List<MainItem>> get(SiteType siteType);

  Future<List<int>> set(SiteType siteType, List<MainItem> list);

  Future<List<MainItemModel>> getAllFromJson(SiteType siteType);

  Future<void> deleteAll(SiteType siteType);

  Future<bool> hasItem(SiteType siteType, MainItem item);
}

class MainDataSourceImpl extends MainDataSource {
  final LocalDatabase localDatabase;

  MainDataSourceImpl({required this.localDatabase});

  @override
  Future<List<MainItem>> get(
    SiteType siteType,
  ) async {
    final result = await localDatabase.getMainItems(siteType);
    return result.map((item) {
      return item.toMainItemModel().toEntity(siteType);
    }).toList();
  }

  @override
  Future<List<int>> set(
    SiteType siteType,
    List<MainItem> list,
  ) async {
    var entities = list.map((item) {
      var data = MainItemMapper.fromEntityToModel(item);
      return MainItemMapper.fromModelToEntity(data);
    }).toList();
    await localDatabase.deleteAll(siteType);
    return localDatabase.setMainItems(siteType, entities);
  }

  @override
  Future<List<MainItemModel>> getAllFromJson(
    SiteType siteType,
  ) async {
    try {
      final jsonPath = '${siteType.name.toLowerCase()}/board_link.json';
      final decodedData = await readJsonFromAssets<List<dynamic>>(jsonPath);
      return decodedData.map((item) => MainItemModel.fromJson(item)).toList();
    } on Exception catch (e) {
      debugPrint("getAllFromJson - ${e.toString()}");
      return List.empty();
    }
  }

  @override
  Future<void> deleteAll(SiteType siteType) =>
      localDatabase.deleteAll(siteType);

  @override
  Future<bool> hasItem(SiteType siteType, MainItem item) {
    var data = MainItemMapper.fromEntityToModel(item);
    var entity = MainItemMapper.fromModelToEntity(data);
    return localDatabase.hasItem(siteType, entity);
  }
}
