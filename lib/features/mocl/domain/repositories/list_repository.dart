import 'package:mocl_flutter/features/mocl/domain/entities/last_id.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/sort_type.dart';

abstract class ListRepository {
  Future<Result<List<ListItem>>> getList({
    required MainItem item,
    required int page,
    required LastId lastId,
    required SortType sortType,
  });

  Future<Result<List<ListItem>>> getSearchList({
    required MainItem item,
    required int page,
    required LastId lastId,
    required SortType sortType,
    required String keyword,
  });

  Future<int> setReadFlag({
    required SiteType siteType,
    required int boardId,
  });

  Future<bool> getReadFlag({
    required SiteType siteType,
    required int boardId,
  });

  Future<List<int>> getReadFlags({
    required SiteType siteType,
    required List<int> boardIds,
  });
}
