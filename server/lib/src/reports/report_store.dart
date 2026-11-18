import 'package:mocl_shared/reports/site_report.dart';
import 'package:sembast/sembast.dart';

/// 받은 신고 한 건(관리 화면에 보이는 모양).
class const StoredReport({
  required final int id,
  required final SiteReport report,
  required final int receivedAt,
  required final bool acked,
}) {
  Map<String, Object?> toJson() => {
    'id': id,
    ...report.toJson(),
    'receivedAt': receivedAt,
    'acked': acked,
  };
}

/// 사이트 문제 신고(`POST /v1/reports`) 저장소. IP · 기기 id 는 저장하지 않는다.
///
/// [keep] 지난 신고와 [maxReports] 를 넘는 옛 신고는 넣을 때 지운다(하루 한 번 이상 돌지 않음).
class ReportStore(
  final Database _db, {
  final Duration keep = const Duration(days: 30),
  final int maxReports = 5000,
}) {
  static final StoreRef<int, Map<String, Object?>> _reports = intMapStoreFactory
      .store('reports');

  int _lastPrune = 0;

  Future<int> count() => _reports.count(_db);

  Future<int> add(SiteReport report, int now) async {
    final int id = await _reports.add(_db, {
      ...report.toJson(),
      'receivedAt': now,
      'acked': false,
    });
    if (now - _lastPrune >= const Duration(hours: 1).inMilliseconds) {
      _lastPrune = now;
      await prune(now);
    }
    return id;
  }

  /// 오래된 신고 · 상한을 넘는 신고를 지운다.
  Future<void> prune(int now) async {
    await _reports.delete(
      _db,
      finder: Finder(
        filter: Filter.lessThan('receivedAt', now - keep.inMilliseconds),
      ),
    );
    final int over = await count() - maxReports;
    if (over > 0) {
      final List<int> oldest = await _reports.findKeys(
        _db,
        finder: Finder(sortOrders: [SortOrder(Field.key)], limit: over),
      );
      await _reports.records(oldest).delete(_db);
    }
  }

  /// 최근 것부터 [limit] 개.
  Future<List<StoredReport>> recent({int limit = 200}) async {
    final List<RecordSnapshot<int, Map<String, Object?>>> rows = await _reports
        .find(
          _db,
          finder: Finder(
            sortOrders: [SortOrder(Field.key, false)],
            limit: limit,
          ),
        );
    return [
      for (final RecordSnapshot<int, Map<String, Object?>> row in rows)
        if (_read(row) case final StoredReport report) report,
    ];
  }

  /// [since] 뒤에 받은 신고를 사이트별로 센다(사이트 없는 의견은 `_`).
  Future<Map<String, int>> countBySite(int since) async {
    final List<RecordSnapshot<int, Map<String, Object?>>> rows = await _reports
        .find(
          _db,
          finder: Finder(
            filter: Filter.greaterThanOrEquals('receivedAt', since),
          ),
        );
    final Map<String, int> counts = {};
    for (final RecordSnapshot<int, Map<String, Object?>> row in rows) {
      final String site = row.value['site'] as String? ?? '_';
      counts[site] = (counts[site] ?? 0) + 1;
    }
    return counts;
  }

  /// 확인함 표시. 없는 id 면 false.
  Future<bool> ack(int id, {bool acked = true}) async =>
      await _reports.record(id).update(_db, {'acked': acked}) != null;

  /// 저장한 뒤 계약이 바뀌어 읽지 못하는 옛 기록은 건너뛴다.
  StoredReport? _read(RecordSnapshot<int, Map<String, Object?>> row) {
    try {
      return StoredReport(
        id: row.key,
        report: SiteReport.fromJson(row.value),
        receivedAt: row.value['receivedAt'] as int? ?? 0,
        acked: row.value['acked'] == true,
      );
    } on FormatException {
      return null;
    }
  }
}
