import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:sembast/sembast.dart';

/// 앱 DB 스키마 버전. 올릴 때마다 [onAppDatabaseVersionChanged] 에 단계를 더한다.
///
/// - 1: 읽음 기록 = `자동 증가 키 → 글 id`
/// - 2: 읽음 기록 = `글 id 키 → 읽은 시각(ms)`
const int kAppDatabaseVersion = 2;

/// 사이트별 읽음 기록 스토어. 키는 글 id, 값은 읽은 시각(epoch ms).
StoreRef<int, int> readStoreOf(SiteType siteType) =>
    StoreRef<int, int>('${siteType.name}_read');

/// sembast 의 `onVersionChanged`. DB 를 열 때 파일의 버전이 [kAppDatabaseVersion]
/// 과 다르면 한 트랜잭션 안에서 불린다. 여기서 던지면 열기 자체가 실패하므로
/// 데이터 문제로는 던지지 않는다.
///
/// Drive 복원도 `close → 파일 교체 → reopen` 으로 이 경로를 다시 타므로,
/// 옛 버전에서 올린 백업을 받아도 열리는 순간 옮겨진다.
Future<void> onAppDatabaseVersionChanged(
  Database db,
  int oldVersion,
  int newVersion,
) async {
  // 처음 만들어진 DB 는 옮길 데이터가 없다.
  if (oldVersion == 0) return;
  if (oldVersion < 2) {
    await migrateReadStoresToV2(
      db,
      readAt: DateTime.now().millisecondsSinceEpoch,
    );
  }
}

/// v1 읽음 기록(`자동 증가 키 → 글 id`)을 v2(`글 id → 읽은 시각`)로 바꾼다.
///
/// 읽은 시각은 남아 있지 않으므로 전부 [readAt] 으로 채운다. 이전 기록이
/// 첫 정리에서 한꺼번에 지워지지 않도록 TTL 은 이 시점부터 센다.
///
/// 먼저 다 읽고 → 스토어를 비운 뒤 → 다시 쓴다. 제자리에서 바꾸면 글 id 가
/// 아직 옮기지 않은 레코드의 자동 증가 키와 같을 때(예: 글 5 와 5번째 기록)
/// 그 기록을 덮어써 잃는다.
Future<void> migrateReadStoresToV2(
  DatabaseClient client, {
  required int readAt,
}) async {
  for (final SiteType siteType in SiteType.values) {
    final StoreRef<int, Object?> legacy = StoreRef<int, Object?>(
      readStoreOf(siteType).name,
    );
    final records = await legacy.find(client);
    if (records.isEmpty) continue;

    // 같은 글을 여러 번 열어 생긴 중복도 여기서 하나로 합쳐진다.
    final List<int> ids = {
      for (final record in records)
        if (record.value case final int id) id,
    }.toList();

    await legacy.delete(client);
    await readStoreOf(siteType)
        .records(ids)
        .put(client, List<int>.filled(ids.length, readAt));
  }
}
