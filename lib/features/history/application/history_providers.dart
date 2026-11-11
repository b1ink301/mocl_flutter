import 'package:mocl_shared/entities/mocl_details.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/util/mocl_logger.dart';
import 'package:mocl_flutter/features/database/application/datasource_provider.dart';
import 'package:mocl_flutter/features/database/domain/entities/post_snapshot.dart';
import 'package:mocl_flutter/features/history/data/repositories/history_repository_impl.dart';
import 'package:mocl_flutter/features/history/domain/repositories/history_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'history_providers.g.dart';

@Riverpod(keepAlive: true)
HistoryRepository historyRepository(Ref ref) =>
    HistoryRepositoryImpl(ref.watch(localDatabaseProvider));

/// 최근 본 글(최근 본 순). 홈 "히스토리" 탭이 본다.
///
/// 탭이 [IndexedStack] 으로 늘 살아 있어 keepAlive 로 둔다. 상세를 열 때마다
/// [record] 가 새로 읽게 한다.
@Riverpod(keepAlive: true)
class HistoryNotifier() extends _$HistoryNotifier {
  @override
  Future<List<PostSnapshot>> build() =>
      ref.watch(historyRepositoryProvider).getAll();

  /// 상세를 받은 뒤 한 번 부른다. 실패해도 상세 화면에는 영향을 주지 않는다.
  Future<void> record(SiteType siteType, ListItem item, Details details) async {
    try {
      final bool written = await ref
          .read(historyRepositoryProvider)
          .add(
            PostSnapshot.fromDetails(
              siteType,
              item,
              details,
              DateTime.now().millisecondsSinceEpoch,
            ),
          );
      if (written && ref.mounted) ref.invalidateSelf();
    } catch (e, st) {
      MoclLogger.e('최근 본 글 저장 실패', error: e, stackTrace: st);
    }
  }

  Future<void> remove(SiteType siteType, int id) async {
    // 밀어서 지운 행이 다시 그려지지 않게 화면 목록에서 먼저 뺀다.
    final List<PostSnapshot>? items = state.asData?.value;
    if (items != null) {
      state = AsyncData<List<PostSnapshot>>([
        for (final PostSnapshot item in items)
          if (item.siteType != siteType || item.id != id) item,
      ]);
    }
    await ref.read(historyRepositoryProvider).remove(siteType, id);
  }

  Future<void> clear() async {
    state = const AsyncData<List<PostSnapshot>>(<PostSnapshot>[]);
    await ref.read(historyRepositoryProvider).clear();
  }
}
