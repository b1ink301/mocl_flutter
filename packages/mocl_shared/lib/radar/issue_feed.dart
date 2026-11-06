import 'package:mocl_shared/entities/mocl_site_type.dart';

/// 이슈 레이더 계약(`GET /v1/issues`). 앱과 서버가 같은 클래스로 읽고 쓴다.
///
/// 앱은 모르는 사이트가 섞여 와도 그 글만 건너뛴다(서버가 사이트를 먼저 늘릴 수 있다).

SiteType? _site(Object? name) =>
    SiteType.values.where((s) => s.name == name).firstOrNull;

/// 이슈에 묶인 글 하나. [url] 을 앱의 SiteLinkResolver 로 연다.
class const IssuePost({
  required final SiteType site,
  required final String title,
  required final String url,
  required final int firstSeenAt,

  /// 댓글 수. 사이트가 주지 않으면 -1.
  final int reply = -1,
}) {
  Map<String, Object?> toJson() => {
    'site': site.name,
    'title': title,
    'url': url,
    'firstSeenAt': firstSeenAt,
    'reply': reply,
  };

  /// 모르는 사이트 · 잘못된 값이면 null.
  static IssuePost? tryParse(Object? j) {
    if (j is! Map) return null;
    final SiteType? site = _site(j['site']);
    final Object? title = j['title'];
    final Object? url = j['url'];
    final Object? at = j['firstSeenAt'];
    if (site == null || title is! String || url is! String || at is! int) {
      return null;
    }
    final Object? reply = j['reply'];
    return IssuePost(
      site: site,
      title: title,
      url: url,
      firstSeenAt: at,
      reply: reply is int ? reply : -1,
    );
  }
}

/// 여러 글이 묶인 이슈 하나.
class const Issue({
  /// 묶음이 커져도 유지되는 id(가장 먼저 본 글 기준).
  required final String id,

  /// 대표 제목(묶음 중심에 가장 가까운 글).
  required final String title,

  /// 걸친 커뮤니티(글이 많은 순).
  required final List<SiteType> sites,
  required final int firstSeenAt,
  required final int lastSeenAt,
  required final double score,

  /// 최근 30분 동안 눈에 띄게 늘었는지.
  final bool trending = false,
  required final List<IssuePost> posts,
}) {
  Map<String, Object?> toJson() => {
    'id': id,
    'title': title,
    'sites': [for (final s in sites) s.name],
    'firstSeenAt': firstSeenAt,
    'lastSeenAt': lastSeenAt,
    'score': double.parse(score.toStringAsFixed(3)),
    'trending': trending,
    'posts': [for (final p in posts) p.toJson()],
  };

  static Issue? tryParse(Object? j) {
    if (j is! Map) return null;
    final Object? id = j['id'];
    final Object? title = j['title'];
    final Object? first = j['firstSeenAt'];
    final Object? last = j['lastSeenAt'];
    final Object? score = j['score'];
    if (id is! String || title is! String || first is! int || last is! int) {
      return null;
    }
    final List<IssuePost> posts = [
      for (final Object? p in j['posts'] as List? ?? const [])
        ?IssuePost.tryParse(p),
    ];
    if (posts.isEmpty) return null;
    return Issue(
      id: id,
      title: title,
      sites: [
        for (final Object? s in j['sites'] as List? ?? const []) ?_site(s),
      ],
      firstSeenAt: first,
      lastSeenAt: last,
      score: score is num ? score.toDouble() : 0,
      trending: j['trending'] == true,
      posts: posts,
    );
  }
}

/// 이슈 목록 전체.
class const IssueFeed({
  required final int generatedAt,

  /// 지금 레이더가 보는 커뮤니티(받기 실패 중인 곳은 뺀다). 화면에 "기준" 으로 밝힌다.
  required final List<SiteType> communities,
  required final List<Issue> issues,
}) {
  static const int schemaVersion = 1;

  Map<String, Object?> toJson() => {
    'schemaVersion': schemaVersion,
    'generatedAt': generatedAt,
    'communities': [for (final s in communities) s.name],
    'issues': [for (final i in issues) i.toJson()],
  };

  /// 형식이 다르면 [FormatException]. 항목 단위 오류는 건너뛴다.
  factory fromJson(Object? j) {
    if (j is! Map) throw const FormatException('최상위는 객체여야 한다');
    if (j['schemaVersion'] != schemaVersion) {
      throw FormatException('지원하지 않는 schemaVersion: ${j['schemaVersion']}');
    }
    final Object? at = j['generatedAt'];
    if (at is! int) throw const FormatException('generatedAt 이 없다');
    return IssueFeed(
      generatedAt: at,
      communities: [
        for (final Object? s in j['communities'] as List? ?? const [])
          ?_site(s),
      ],
      issues: [
        for (final Object? i in j['issues'] as List? ?? const [])
          ?Issue.tryParse(i),
      ],
    );
  }
}
