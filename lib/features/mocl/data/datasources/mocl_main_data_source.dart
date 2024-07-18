import 'package:flutter/foundation.dart';
import 'package:isar/isar.dart';
import 'package:mocl_flutter/core/util/read_json_from_assets.dart';
import 'package:mocl_flutter/features/mocl/data/datasources/mocl_local_database.dart';
import 'package:mocl_flutter/features/mocl/data/models/mocl_main_item_data.dart';
import 'package:mocl_flutter/features/mocl/data/models/mocl_main_item_entity.dart';
import 'package:mocl_flutter/features/mocl/data/models/mocl_model_mapper.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

abstract class MainDataSource {
  Future<List<MainItem>> get(SiteType siteType);
  Future<List<Id>> set(SiteType siteType, List<MainItem> list);
  Future<List<MainItemData>> getAllFromJson(SiteType siteType);
  Future<int> deleteAll(SiteType siteType);
  Future<bool> hasItem(MainItem item);
}

class MainDataSourceImpl extends MainDataSource {
  final LocalDatabase localDatabase;

  MainDataSourceImpl({required this.localDatabase});

  @override
  Future<List<MainItem>> get(
    SiteType siteType,
  ) async {
    var result = await localDatabase.getMainItems(siteType);
    return result
        .map((item) => item.toMainItemModel().toMainItem(siteType))
        .toList();
  }

  @override
  Future<List<Id>> set(
    SiteType siteType,
    List<MainItem> list,
  ) {
    var entities = list.map((item) {
      var data = MainItemMapper.fromMainItemToMainItemData(item);
      return MainItemMapper.fromMainItemToMainItemEntity(data);
    }).toList();

    debugPrint("MainDataSource=${entities.length}, siteType=$siteType");
    return localDatabase.setMainItems(siteType, entities);
  }

  @override
  Future<List<MainItemData>> getAllFromJson(
    SiteType siteType,
  ) async {
    try {
      final jsonPath = '${siteType.name.toLowerCase()}/board_link.json';
      final decodedData = await readJsonFromAssets<List<dynamic>>(jsonPath);
      return decodedData.map((item) => MainItemData.fromJson(item)).toList();
    } on Exception catch (e) {
      debugPrint("getAllFromJson - ${e.toString()}");
      return Future.value(List.empty());
    }
  }

  @override
  Future<int> deleteAll(SiteType siteType) =>
      localDatabase.deleteAll(siteType);

  @override
  Future<bool> hasItem(MainItem item) {
    var data = MainItemMapper.fromMainItemToMainItemData(item);
    var entity = MainItemMapper.fromMainItemToMainItemEntity(data);
    return localDatabase.hasItem(item.siteType, entity);
  }
}
