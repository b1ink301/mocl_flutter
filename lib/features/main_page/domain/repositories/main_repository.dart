import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';

abstract class MainRepository {
  Stream<Either<Failure, List<MainItem>>> getMainListStream({
    required SiteType siteType,
  });

  Future<Either<Failure, List<MainItem>>> getMainList({
    required SiteType siteType,
  });

  Future<Either<Failure, List<MainItem>>> getMainListFromJson({
    required SiteType siteType,
  });

  Future<Either<Failure, List<int>>> setMainList({
    required SiteType siteType,
    required List<MainItem> list,
  });
}
