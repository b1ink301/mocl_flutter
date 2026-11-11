import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/database/data/datasources/local/local_database.dart';
import 'package:mocl_flutter/features/database/domain/entities/post_snapshot.dart';
import 'package:mocl_flutter/features/history/domain/repositories/history_repository.dart';

class const HistoryRepositoryImpl(final LocalDatabase localDatabase)
    implements HistoryRepository {
  @override
  Future<bool> add(PostSnapshot data) => localDatabase.putHistory(data);

  @override
  Future<void> remove(SiteType siteType, int id) =>
      localDatabase.removeHistory(siteType, id);

  @override
  Future<void> clear() => localDatabase.clearHistory();

  @override
  Future<List<PostSnapshot>> getAll() => localDatabase.getHistory();
}
