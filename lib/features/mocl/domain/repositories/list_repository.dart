import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_result.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';

abstract class ListRepository {
  Future<Result<List<ListItem>>> getList({
    required MainItem item,
    required int page,
    required int lastId,
  });

  Future<int> setReadFlag({
    required SiteType siteType,
    required int boardId,
  });

  Future<bool> getReadFlag({
    required SiteType siteType,
    required int boardId,
  });

  Future<Map<int, bool>> getReadFlags({
    required SiteType siteType,
    required List<int> boardIds,
  });
}
