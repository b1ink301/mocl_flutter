import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

import '../entities/mocl_result.dart';

abstract class MainRepository {
  Stream<Result> getMainListStream({
    required SiteType siteType,
  });

  Future<Result> getMainList({
    required SiteType siteType,
  });

  Future<Result> getMainListFromJson({
    required SiteType siteType,
  });

  Future<Result> setMainList({
    required SiteType siteType,
    required List<MainItem> list,
  });
}
