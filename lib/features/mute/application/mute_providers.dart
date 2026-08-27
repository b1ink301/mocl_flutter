import 'package:mocl_flutter/features/database/application/datasource_provider.dart';
import 'package:mocl_flutter/features/database/domain/entities/mute_rule.dart';
import 'package:mocl_flutter/features/mute/data/repositories/mute_repository_impl.dart';
import 'package:mocl_flutter/features/mute/domain/repositories/mute_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'mute_providers.g.dart';

@Riverpod(keepAlive: true)
MuteRepository muteRepository(Ref ref) =>
    MuteRepositoryImpl(ref.watch(localDatabaseProvider));

/// 전역 뮤트 규칙 목록. 리스트 빌드 시 watch 되어, 규칙이 바뀌면
/// 리스트가 재생성되며 필터가 다시 적용된다.
@Riverpod(keepAlive: true)
class MuteRulesNotifier() extends _$MuteRulesNotifier {
  @override
  Future<List<MuteRule>> build() => ref.watch(muteRepositoryProvider).getAll();

  Future<void> add(MuteRule rule) async {
    await ref.read(muteRepositoryProvider).add(rule);
    ref.invalidateSelf();
  }

  Future<void> remove(MuteRule rule) async {
    await ref.read(muteRepositoryProvider).remove(rule);
    ref.invalidateSelf();
  }
}
