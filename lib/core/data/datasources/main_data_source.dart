import 'package:injectable/injectable.dart';
import 'package:mocl_flutter/core/data/datasources/remote/base/parser_factory.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/util/read_json_from_assets.dart';
import 'package:mocl_flutter/features/database/data/local/local_database.dart';
import 'package:mocl_flutter/features/database/data/models/main_item_model.dart';
import 'package:mocl_flutter/features/database/data/models/model_mapper.dart';
import 'package:mocl_flutter/features/database/domain/entities/main_item_data.dart';

abstract class MainDataSource {
  Future<Result<List<MainItem>>> get(SiteType siteType);

  Future<List<int>> set(SiteType siteType, List<MainItem> list);

  Future<List<MainItemModel>> getAllFromJson(SiteType siteType);

  Future<void> deleteAll(SiteType siteType);

  Future<bool> hasItem(SiteType siteType, MainItem item);
}

@LazySingleton(as: MainDataSource)
class MainDataSourceImpl implements MainDataSource {
  final LocalDatabase localDatabase;
  final ParserFactory parserFactory;

  const MainDataSourceImpl({
    required this.localDatabase,
    required this.parserFactory,
  });

  @override
  Future<Result<List<MainItem>>> get(SiteType siteType) async {
    if (siteType == SiteType.naverCafe) {
      final (parser, api) = parserFactory.buildParser();
      return api.main(parser);
    } else {
      try {
        final List<MainItemData> result = await localDatabase.getMainData(
          siteType,
        );
        final list = result
            .map(
              (MainItemData item) => item.toMainItemModel().toEntity(siteType),
            )
            .toList();
        return ResultSuccess(list);
      } catch (e) {
        return ResultFailure(GetMainFailure(message: e.toString()));
      }
    }
  }

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
    final String jsonPath = '${siteType.name.toLowerCase()}/board_link.json';
    final List decodedData = await readJsonFromAssets<List<dynamic>>(jsonPath);
    return decodedData.map((item) => MainItemModel.fromJson(item)).toList();
  }

  @override
  Future<void> deleteAll(SiteType siteType) =>
      localDatabase.deleteAll(siteType);

  @override
  Future<bool> hasItem(SiteType siteType, MainItem item) {
    final MainItemModel data = MainItemMapper.fromEntityToModel(item);
    final MainItemData entity = MainItemMapper.fromModelToEntity(data);
    return localDatabase.hasItem(siteType, entity);
  }
}
