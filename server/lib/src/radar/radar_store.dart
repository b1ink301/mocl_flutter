import 'package:sembast/sembast.dart';

/// 크롤 때마다 남기는 반응 기록. 사이트가 주지 않는 값은 -1.
class const RadarSample(
  final int at,
  final int reply,
  final int hit,
  final int like,

  /// 게시판 1쪽에서의 순서(0 이 맨 위).
  final int rank,
) {
  List<int> toJson() => [at, reply, hit, like, rank];

  factory fromJson(List<Object?> j) => RadarSample(
    j[0]! as int,
    j[1]! as int,
    j[2]! as int,
    j[3]! as int,
    j[4]! as int,
  );

  /// "1,234" · "1.2만" · "" 같은 사이트 표기를 숫자로. 못 읽으면 -1.
  static int parseCount(String raw) {
    final String s = raw.replaceAll(',', '').trim();
    if (s.isEmpty) return -1;
    final RegExpMatch? man = RegExp(r'^(\d+(?:\.\d+)?)\s*만$').firstMatch(s);
    if (man != null) return (double.parse(man.group(1)!) * 10000).round();
    final RegExpMatch? k = RegExp(r'^(\d+(?:\.\d+)?)\s*[kK]$').firstMatch(s);
    if (k != null) return (double.parse(k.group(1)!) * 1000).round();
    return int.tryParse(RegExp(r'\d+').stringMatch(s) ?? '') ?? -1;
  }
}

/// 레이더가 본 글 하나. 제목 · 링크 · 숫자만 둔다(본문 X).
class const RadarPost({
  required final String site,
  required final String board,
  required final int id,
  required final String title,
  required final String url,
  required final int firstSeenAt,
  required final int lastSeenAt,
  final List<RadarSample> samples = const [],
}) {
  String get key => '$site|$board|$id';

  RadarSample? get latest => samples.isEmpty ? null : samples.last;

  Map<String, Object?> toJson() => {
    'site': site,
    'board': board,
    'id': id,
    'title': title,
    'url': url,
    'firstSeenAt': firstSeenAt,
    'lastSeenAt': lastSeenAt,
    'samples': [for (final s in samples) s.toJson()],
  };

  factory fromJson(Map<String, Object?> j) => RadarPost(
    site: j['site']! as String,
    board: j['board']! as String,
    id: j['id']! as int,
    title: j['title']! as String,
    url: j['url']! as String,
    firstSeenAt: j['firstSeenAt']! as int,
    lastSeenAt: j['lastSeenAt']! as int,
    samples: [
      for (final Object? s in j['samples'] as List? ?? const [])
        RadarSample.fromJson(s! as List<Object?>),
    ],
  );
}

/// 레이더 글 저장소(sembast, 알림과 다른 파일). 48시간이 지나면 지운다.
class RadarStore(final Database _db) {
  static final StoreRef<String, Map<String, Object?>> _posts =
      stringMapStoreFactory.store('posts');

  /// 글 하나에 남길 반응 기록 수.
  static const int maxSamples = 20;
  static const Duration retention = Duration(hours: 48);

  Future<List<RadarPost>> posts({int? since}) async {
    final records = await _posts.find(
      _db,
      finder: since == null
          ? null
          : Finder(filter: Filter.greaterThanOrEquals('lastSeenAt', since)),
    );
    return [for (final r in records) RadarPost.fromJson(r.value)];
  }

  /// 크롤 결과를 반영한다. 처음 보는 글은 지금 시각을 firstSeenAt 으로 한다.
  Future<int> upsert(
    String site,
    String board,
    List<(int id, String title, String url, RadarSample sample)> items,
    int now,
  ) => _db.transaction((txn) async {
    int fresh = 0;
    for (final (int id, String title, String url, RadarSample sample)
        in items) {
      final String key = '$site|$board|$id';
      final Map<String, Object?>? old = await _posts.record(key).get(txn);
      final RadarPost? prev = old == null ? null : RadarPost.fromJson(old);
      if (prev == null) fresh++;
      final List<RadarSample> samples = [...?prev?.samples, sample];
      await _posts
          .record(key)
          .put(
            txn,
            RadarPost(
              site: site,
              board: board,
              id: id,
              // 제목은 고쳐질 수 있어 최신 값을 쓴다.
              title: title,
              url: url,
              firstSeenAt: prev?.firstSeenAt ?? now,
              lastSeenAt: now,
              samples: samples.length > maxSamples
                  ? samples.sublist(samples.length - maxSamples)
                  : samples,
            ).toJson(),
          );
    }
    return fresh;
  });

  Future<int> prune(int now) => _posts.delete(
    _db,
    finder: Finder(
      filter: Filter.lessThan('lastSeenAt', now - retention.inMilliseconds),
    ),
  );

  Future<int> count() => _posts.count(_db);
}
