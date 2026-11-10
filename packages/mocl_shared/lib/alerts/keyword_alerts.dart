import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/remote_config/alerts_config.dart';

/// 키워드 알림 계약. 앱(구독 · 표시)과 서버(검증 · 매칭)가 같이 쓴다.
///
/// 흐름: 앱이 `PUT /v1/alerts/{installId}` 로 [AlertRegistration] 을 통째로 올리면
/// 서버가 그 게시판들의 1쪽을 주기적으로 받아 새 글 제목이 키워드에 맞으면 FCM 으로 보낸다.
abstract final class KeywordAlerts() {
  /// 서버가 알림용으로 받을 수 있는 사이트.
  ///
  /// 서버(오라클 데이터센터 IP)에서 실제로 받아 본 결과로 정했다(`server/bin/probe.dart`).
  /// 아카라이브 · 인스티즈 · 더쿠 · 루리웹은 서버 IP 를 막고, 네이버카페 · 레딧은 로그인이
  /// 필요해 뺐다. 뽐뿌는 목록 페이지가 막혀 RSS 로 받는다.
  static const Set<SiteType> sites = {
    SiteType.bobaedream,
    SiteType.clien,
    SiteType.cook82,
    SiteType.damoang,
    SiteType.dcinside,
    SiteType.dogdrip,
    SiteType.geekNews,
    SiteType.inven,
    SiteType.meeco,
    SiteType.mlbpark,
    SiteType.nate,
    SiteType.ppomppu,
  };

  /// 알림을 걸 수 있는 게시판 기본값(사이트 → 게시판 id → 이름).
  /// 원격 설정 `alerts.boards` 가 있으면 그것을 쓴다([AlertsRemoteConfig.effectiveBoards]).
  /// 서버가 사이트에서 받아 오는 양을 관리자가 정한 게시판 수로 묶어 둔다.
  static const Map<SiteType, Map<String, String>> defaultBoards = {
    SiteType.clien: {'park': '모두의공원', 'sold': '회원중고장터'},
    SiteType.damoang: {'free': '자유게시판'},
  };

  /// 한 기기가 알림을 받는 게시판 수 / 게시판당 키워드 수. 앱은 이 한도로 막고,
  /// 서버는 넘는 것을 앞에서부터 잘라 쓴다([AlertRegistration.limited]).
  static const int maxBoards = 3;
  static const int maxKeywordsPerBoard = 5;

  /// 서버가 받아 주는 상한. 한도가 10 이던 옛 앱의 등록이 통째로 거절되지 않게
  /// 여기까지는 받고([AlertRegistration.limited] 로 잘라 쓴다), 넘으면 거절한다.
  static const int acceptBoards = 10;
  static const int acceptKeywordsPerBoard = 10;
  static const int maxKeywordLength = 30;

  /// 게시판 URL 로 허용하는 호스트. 서버가 사용자가 준 URL 을 그대로 요청하므로
  /// 사이트 도메인이 아닌 주소(내부망 등)는 받지 않는다.
  static const Map<SiteType, Set<String>> _hosts = {
    SiteType.bobaedream: {'m.bobaedream.co.kr', 'www.bobaedream.co.kr'},
    SiteType.clien: {'m.clien.net', 'www.clien.net'},
    SiteType.cook82: {'www.82cook.com', 'm.82cook.com'},
    SiteType.damoang: {'damoang.net', 'www.damoang.net'},
    SiteType.dcinside: {'m.dcinside.com', 'gall.dcinside.com'},
    SiteType.dogdrip: {'www.dogdrip.net', 'dogdrip.net'},
    SiteType.geekNews: {'news.hada.io'},
    SiteType.inven: {'m.inven.co.kr', 'www.inven.co.kr'},
    SiteType.meeco: {'meeco.kr', 'www.meeco.kr'},
    SiteType.mlbpark: {'mlbpark.donga.com'},
    SiteType.nate: {'m.pann.nate.com', 'pann.nate.com'},
    SiteType.ppomppu: {'m.ppomppu.co.kr', 'www.ppomppu.co.kr'},
  };

  static bool isAllowedBoardUrl(SiteType site, String url) {
    final Uri? uri = Uri.tryParse(url);
    if (uri == null || (uri.scheme != 'https' && uri.scheme != 'http')) {
      return false;
    }
    if (uri.hasPort || uri.userInfo.isNotEmpty) return false;
    return _hosts[site]?.contains(uri.host.toLowerCase()) ?? false;
  }

  /// [startedAt](걸거나 연장한 시각, ms)부터 [ttl] 이 지나 끝났는지. [ttl] 이 null 이면 기한 없음.
  static bool isExpired(int startedAt, int now, Duration? ttl) =>
      ttl != null && now >= expiresAt(startedAt, ttl);

  static int expiresAt(int startedAt, Duration ttl) =>
      startedAt + ttl.inMilliseconds;

  /// 키워드 비교용으로 다듬는다: 소문자, 공백 제거.
  /// "에어팟 프로" 와 "에어팟프로" 를 같은 것으로 본다.
  static String normalize(String text) =>
      text.toLowerCase().replaceAll(RegExp(r'\s+'), '');

  /// [title] 에 들어 있는 키워드들(입력 순서).
  static List<String> matchedKeywords(String title, Iterable<String> keywords) {
    final String haystack = normalize(title);
    return [
      for (final String k in keywords)
        if (normalize(k).isNotEmpty && haystack.contains(normalize(k))) k,
    ];
  }
}

/// 알림을 받을 게시판 하나와 그 키워드들.
class const AlertSubscription({
  required final SiteType site,
  required final String board,
  required final String url,
  required final String title,
  required final List<String> keywords,

  /// 알림을 걸거나 연장한 시각(ms, 기기 시계). 기한(원격 설정 `alerts.ttlDays`)은 여기서 센다.
  /// 이 값을 모르는 옛 앱이 올린 구독은 null — 서버는 등록을 받은 시각으로 센다.
  final int? startedAt,
}) {
  /// 같은 게시판인지 가르는 키(서버 크롤 단위).
  String get boardKey => '${site.name}|$board';

  Map<String, Object?> toJson() => {
    'site': site.name,
    'board': board,
    'url': url,
    'title': title,
    'keywords': keywords,
    'startedAt': ?startedAt,
  };

  AlertSubscription copyWith({List<String>? keywords, int? startedAt}) =>
      AlertSubscription(
        site: site,
        board: board,
        url: url,
        title: title,
        keywords: keywords ?? this.keywords,
        startedAt: startedAt ?? this.startedAt,
      );

  /// 검증하며 읽는다. 잘못되면 [FormatException].
  factory fromJson(Object? json) {
    if (json is! Map) throw const FormatException('구독은 객체여야 한다');
    final SiteType? site = SiteType.values
        .where((SiteType s) => s.name == json['site'])
        .firstOrNull;
    if (site == null || !KeywordAlerts.sites.contains(site)) {
      throw FormatException('알림을 지원하지 않는 사이트: ${json['site']}');
    }
    final Object? board = json['board'];
    final Object? url = json['url'];
    final Object? title = json['title'];
    if (board is! String || board.isEmpty || board.length > 200) {
      throw const FormatException('board 가 잘못됐다');
    }
    if (url is! String || !KeywordAlerts.isAllowedBoardUrl(site, url)) {
      throw FormatException('허용하지 않는 게시판 URL: $url');
    }
    if (title is! String || title.length > 100) {
      throw const FormatException('title 이 잘못됐다');
    }
    final Object? rawKeywords = json['keywords'];
    if (rawKeywords is! List) throw const FormatException('keywords 는 배열');
    final List<String> keywords = [];
    for (final Object? k in rawKeywords) {
      if (k is! String) throw const FormatException('키워드는 문자열');
      final String trimmed = k.trim();
      if (KeywordAlerts.normalize(trimmed).isEmpty ||
          trimmed.length > KeywordAlerts.maxKeywordLength) {
        throw FormatException('잘못된 키워드: $k');
      }
      if (!keywords.contains(trimmed)) keywords.add(trimmed);
    }
    if (keywords.isEmpty ||
        keywords.length > KeywordAlerts.acceptKeywordsPerBoard) {
      throw const FormatException('키워드 수가 잘못됐다');
    }
    final Object? startedAt = json['startedAt'];
    if (startedAt != null && (startedAt is! int || startedAt < 0)) {
      throw const FormatException('startedAt 이 잘못됐다');
    }
    return AlertSubscription(
      site: site,
      board: board,
      url: url,
      title: title,
      keywords: keywords,
      startedAt: startedAt as int?,
    );
  }
}

/// 기기 하나의 알림 등록 전체. 앱은 바뀔 때마다 통째로 올린다.
class const AlertRegistration({
  required final String fcmToken,
  required final String platform,
  required final List<AlertSubscription> subscriptions,
}) {
  static const Set<String> platforms = {'android', 'ios'};

  /// 한도([KeywordAlerts.maxBoards] · [KeywordAlerts.maxKeywordsPerBoard])에 맞춘 등록.
  /// [allow] 가 있으면 허용 게시판이 아닌 구독을 **먼저** 걸러 낸 뒤(옛 앱이 허용 밖 게시판을
  /// 앞에 두어도 허용 게시판이 잘리지 않게), 넘는 게시판 · 키워드를 앞에서부터 한도만큼만 남긴다
  /// (앱 목록 순서 = 화면 순서). 서버가 저장 · 크롤할 때 쓴다. 앱의 로컬 구독은 자르지 않는다.
  AlertRegistration limited({bool Function(AlertSubscription sub)? allow}) {
    final List<AlertSubscription> allowed = allow == null
        ? subscriptions
        : subscriptions.where(allow).toList();
    final bool within =
        allowed.length == subscriptions.length &&
        allowed.length <= KeywordAlerts.maxBoards &&
        allowed.every(
          (AlertSubscription s) =>
              s.keywords.length <= KeywordAlerts.maxKeywordsPerBoard,
        );
    if (within) return this;
    return AlertRegistration(
      fcmToken: fcmToken,
      platform: platform,
      subscriptions: [
        for (final AlertSubscription s in allowed.take(KeywordAlerts.maxBoards))
          s.keywords.length <= KeywordAlerts.maxKeywordsPerBoard
              ? s
              : s.copyWith(
                  keywords: s.keywords
                      .take(KeywordAlerts.maxKeywordsPerBoard)
                      .toList(),
                ),
      ],
    );
  }

  Map<String, Object?> toJson() => {
    'fcmToken': fcmToken,
    'platform': platform,
    'subscriptions': [for (final s in subscriptions) s.toJson()],
  };

  factory fromJson(Object? json) {
    if (json is! Map) throw const FormatException('등록은 객체여야 한다');
    final Object? token = json['fcmToken'];
    final Object? platform = json['platform'];
    final Object? subs = json['subscriptions'];
    if (token is! String || token.isEmpty || token.length > 4096) {
      throw const FormatException('fcmToken 이 잘못됐다');
    }
    if (platform is! String || !platforms.contains(platform)) {
      throw FormatException('모르는 platform: $platform');
    }
    if (subs is! List || subs.length > KeywordAlerts.acceptBoards) {
      throw const FormatException('subscriptions 가 잘못됐다');
    }
    final List<AlertSubscription> parsed = [
      for (final Object? s in subs) AlertSubscription.fromJson(s),
    ];
    final Set<String> keys = parsed.map((s) => s.boardKey).toSet();
    if (keys.length != parsed.length) {
      throw const FormatException('같은 게시판이 두 번 있다');
    }
    return AlertRegistration(
      fcmToken: token,
      platform: platform,
      subscriptions: parsed,
    );
  }
}

/// 알림 푸시의 data 필드. 앱은 [url] 로 상세를 연다(SiteLinkResolver).
abstract final class KeywordAlertPayload() {
  static const String type = 'keyword_alert';

  static Map<String, String> build({
    required SiteType site,
    required String board,
    required String url,
    required String title,
    required List<String> keywords,
  }) => {
    'type': type,
    'site': site.name,
    'board': board,
    'url': url,
    'title': title,
    'keywords': keywords.join(','),
  };
}
