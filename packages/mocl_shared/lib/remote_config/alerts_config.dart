import 'package:mocl_shared/alerts/keyword_alerts.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';

/// 원격 설정의 키워드 알림 항목(`alerts`). 값이 없는 항목은 기본값을 쓴다.
///
/// ```json
/// "alerts": {
///   "ttlDays": 3,
///   "boards": { "clien": { "park": "모두의공원" }, "damoang": { "free": "자유게시판" } }
/// }
/// ```
class const AlertsRemoteConfig({
  /// 알림 하나를 걸고(또는 연장하고) 며칠 동안 보낼지. `0` 이면 기한 없음.
  /// `null` 이면 [defaultTtlDays].
  final int? ttlDays,

  /// 알림을 걸 수 있는 게시판(사이트 → 게시판 id → 보일 이름).
  /// `null` 이면 [KeywordAlerts.defaultBoards], 빈 맵이면 알림 게시판 없음.
  final Map<SiteType, Map<String, String>>? boards,
}) {
  static const int defaultTtlDays = 3;

  /// 받을 수 있는 [ttlDays] 범위(0 = 기한 없음).
  static const int minTtlDays = 0;
  static const int maxTtlDays = 90;

  /// [boards] 상한(사이트당 · 전체). 서버 크롤 부담의 상한이기도 하다.
  static const int maxBoardsPerSite = 20;
  static const int maxBoardsTotal = 60;
  static const int maxBoardTitleLength = 50;

  static const AlertsRemoteConfig empty = AlertsRemoteConfig();

  bool get isEmpty => ttlDays == null && boards == null;

  int get effectiveTtlDays => ttlDays ?? defaultTtlDays;

  /// 알림 기한. `null` 이면 기한 없음.
  Duration? get ttl =>
      effectiveTtlDays == 0 ? null : Duration(days: effectiveTtlDays);

  /// 알림을 걸 수 있는 게시판(설정이 없으면 기본값).
  Map<SiteType, Map<String, String>> get effectiveBoards =>
      boards ?? KeywordAlerts.defaultBoards;

  /// [site] 의 [board] 에 알림을 걸 수 있는지.
  bool isAlertBoard(SiteType site, String board) =>
      KeywordAlerts.sites.contains(site) &&
      (effectiveBoards[site]?.containsKey(board) ?? false);

  /// [fail] 은 모르거나 잘못된 값을 만났을 때 부른다(엄격 모드면 던진다).
  factory fromJson(Object? json, void Function(String message) fail) {
    if (json == null) return empty;
    if (json is! Map) {
      fail('alerts 는 객체여야 한다');
      return empty;
    }
    int? ttlDays;
    final Object? raw = json['ttlDays'];
    if (raw != null) {
      if (raw is int && raw >= minTtlDays && raw <= maxTtlDays) {
        ttlDays = raw;
      } else {
        fail('alerts.ttlDays 는 $minTtlDays~$maxTtlDays 정수여야 한다: $raw');
      }
    }
    return AlertsRemoteConfig(
      ttlDays: ttlDays,
      boards: _parseBoards(json['boards'], fail),
    );
  }

  static Map<SiteType, Map<String, String>>? _parseBoards(
    Object? raw,
    void Function(String message) fail,
  ) {
    if (raw == null) return null;
    if (raw is! Map) {
      fail('alerts.boards 는 객체여야 한다');
      return null;
    }
    final Map<SiteType, Map<String, String>> boards = {};
    int total = 0;
    raw.forEach((Object? key, Object? value) {
      final SiteType? site = SiteType.values
          .where((SiteType s) => s.name == key)
          .firstOrNull;
      if (site == null || !KeywordAlerts.sites.contains(site)) {
        return fail('알림을 지원하지 않는 사이트: alerts.boards.$key');
      }
      if (value is! Map) return fail('alerts.boards.$key 는 객체여야 한다');
      final Map<String, String> siteBoards = {};
      value.forEach((Object? id, Object? title) {
        if (id is! String || id.isEmpty || id.length > 200) {
          return fail('잘못된 게시판 id: alerts.boards.$key.$id');
        }
        if (title is! String ||
            title.trim().isEmpty ||
            title.length > maxBoardTitleLength) {
          return fail('잘못된 게시판 이름: alerts.boards.$key.$id');
        }
        if (siteBoards.length >= maxBoardsPerSite) {
          return fail('alerts.boards.$key 는 $maxBoardsPerSite개까지');
        }
        if (total >= maxBoardsTotal) {
          return fail('alerts.boards 는 모두 $maxBoardsTotal개까지');
        }
        siteBoards[id] = title.trim();
        total++;
      });
      if (siteBoards.isNotEmpty) boards[site] = siteBoards;
    });
    return boards;
  }

  Map<String, Object?> toJson() => {
    'ttlDays': ?ttlDays,
    if (boards != null)
      'boards': {
        for (final MapEntry<SiteType, Map<String, String>> e in boards!.entries)
          e.key.name: e.value,
      },
  };
}
