import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

abstract class MainRepository {
  Stream<Result<List<MainItem>>> getMainListStream({
    required SiteType siteType,
  });

  Future<Result<List<MainItem>>> getMainList({
    required SiteType siteType,
  });

  Future<Result<List<MainItem>>> getMainListFromJson({
    required SiteType siteType,
  });

  Future<Result<List<int>>> setMainList({
    required SiteType siteType,
    required List<MainItem> list,
  });
}
