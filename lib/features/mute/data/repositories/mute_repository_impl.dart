import 'package:mocl_flutter/features/database/data/datasources/local/local_database.dart';
import 'package:mocl_flutter/features/database/domain/entities/mute_rule.dart';
import 'package:mocl_flutter/features/mute/domain/repositories/mute_repository.dart';

class const MuteRepositoryImpl(final LocalDatabase localDatabase)
    implements MuteRepository {
  @override
  Future<void> add(MuteRule rule) => localDatabase.addMute(rule);

  @override
  Future<void> remove(MuteRule rule) => localDatabase.removeMute(rule);

  @override
  Future<List<MuteRule>> getAll() => localDatabase.getMutes();
}
