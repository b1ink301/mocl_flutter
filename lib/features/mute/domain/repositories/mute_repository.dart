import 'package:mocl_flutter/features/database/domain/entities/mute_rule.dart';

abstract class MuteRepository() {
  Future<void> add(MuteRule rule);
  Future<void> remove(MuteRule rule);
  Future<List<MuteRule>> getAll();
}
