import 'package:mocl_shared/alerts/keyword_alerts.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';

/// 알림함(받은 알림)의 한 줄. 기기에만 둔다.
final class const InboxAlert({
  required final SiteType site,
  required final String board,

  /// 게시판 이름(알림 제목의 ` · ` 앞). 없으면 [board].
  required final String boardTitle,

  /// 글 제목.
  required final String title,
  required final String url,
  required final List<String> keywords,

  /// FCM 이 보낸 시각(없으면 받은 시각), ms.
  required final int receivedAt,
  final bool read = false,
}) {
  /// 같은 글은 한 번만 남긴다.
  String get id => idOf(site, url);

  static String idOf(SiteType site, String url) => '${site.name}:$url';

  DateTime get receivedTime => DateTime.fromMillisecondsSinceEpoch(receivedAt);

  InboxAlert copyWith({bool? read}) => InboxAlert(
    site: site,
    board: board,
    boardTitle: boardTitle,
    title: title,
    url: url,
    keywords: keywords,
    receivedAt: receivedAt,
    read: read ?? this.read,
  );

  /// 푸시 data(`KeywordAlertPayload`)에서 만든다. 키워드 알림이 아니거나 값이 모자라면 null.
  static InboxAlert? fromPush(
    Map<String, String> data, {
    String? notificationTitle,
    DateTime? sentAt,
    DateTime? now,
  }) {
    if (data['type'] != KeywordAlertPayload.type) return null;
    final SiteType? site = _site(data['site']);
    final String url = data['url'] ?? '';
    final String title = data['title'] ?? '';
    if (site == null || url.isEmpty || title.isEmpty) return null;
    final String board = data['board'] ?? '';
    return InboxAlert(
      site: site,
      board: board,
      boardTitle: _boardTitle(notificationTitle) ?? board,
      title: title,
      url: url,
      keywords: [
        for (final String k in (data['keywords'] ?? '').split(','))
          if (k.trim().isNotEmpty) k.trim(),
      ],
      receivedAt: (sentAt ?? now ?? DateTime.now()).millisecondsSinceEpoch,
    );
  }

  /// 서버는 알림 제목을 `'{게시판} · {키워드, 키워드}'` 로 만든다.
  static String? _boardTitle(String? notificationTitle) {
    if (notificationTitle == null) return null;
    final int at = notificationTitle.lastIndexOf(' · ');
    final String name =
        (at < 0 ? notificationTitle : notificationTitle.substring(0, at))
            .trim();
    return name.isEmpty ? null : name;
  }

  static SiteType? _site(String? name) =>
      SiteType.values.where((s) => s.name == name).firstOrNull;

  Map<String, Object?> toJson() => {
    'site': site.name,
    'board': board,
    'boardTitle': boardTitle,
    'title': title,
    'url': url,
    'keywords': keywords,
    'receivedAt': receivedAt,
    'read': read,
  };

  /// 잘못되면 [FormatException].
  factory fromJson(Object? json) {
    if (json is! Map) throw const FormatException('알림은 객체여야 한다');
    final SiteType? site = _site(json['site'] as String?);
    final Object? url = json['url'];
    final Object? title = json['title'];
    final Object? receivedAt = json['receivedAt'];
    if (site == null ||
        url is! String ||
        title is! String ||
        receivedAt is! int) {
      throw FormatException('알림 형식이 아니다: ${json['site']}');
    }
    final String board = json['board'] as String? ?? '';
    return InboxAlert(
      site: site,
      board: board,
      boardTitle: json['boardTitle'] as String? ?? board,
      title: title,
      url: url,
      keywords: [
        for (final Object? k in json['keywords'] as List? ?? const [])
          if (k is String) k,
      ],
      receivedAt: receivedAt,
      read: json['read'] == true,
    );
  }
}
