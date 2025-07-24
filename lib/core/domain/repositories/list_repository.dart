import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/domain/entities/last_id.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/entities/sort_type.dart';

abstract class ListRepository {
  Future<Either<Failure, List<ListItem>>> getList({
    required MainItem item,
    required int page,
    required LastId lastId,
    required SortType sortType,
  });

  Future<Either<Failure, List<ListItem>>> getSearchList({
    required MainItem item,
    required int page,
    required LastId lastId,
    required SortType sortType,
    required String keyword,
  });

  Future<int> setReadFlag({required SiteType siteType, required int boardId});

  Future<bool> getReadFlag({required SiteType siteType, required int boardId});

  Future<List<int>> getReadFlags({
    required SiteType siteType,
    required List<int> boardIds,
  });
}
