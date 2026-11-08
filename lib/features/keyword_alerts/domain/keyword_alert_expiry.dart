import 'package:mocl_shared/alerts/keyword_alerts.dart';

/// 키워드 알림 하나의 남은 기간(화면 표시용). 서버도 같은 규칙(`KeywordAlerts.isExpired`)으로 끊는다.
class const KeywordAlertExpiry._({required final Duration? remaining}) {
  /// [ttl] 이 null(기한 없음)이거나 [AlertSubscription.startedAt] 을 모르면 기한 없음으로 본다.
  factory of(AlertSubscription sub, Duration? ttl, DateTime now) {
    final int? started = sub.startedAt;
    if (ttl == null || started == null) {
      return const KeywordAlertExpiry._(remaining: null);
    }
    final int left =
        KeywordAlerts.expiresAt(started, ttl) - now.millisecondsSinceEpoch;
    return KeywordAlertExpiry._(
      remaining: Duration(milliseconds: left < 0 ? 0 : left),
    );
  }

  bool get hasLimit => remaining != null;

  bool get isExpired => remaining == Duration.zero;

  /// "3일 남음" · "5시간 남음" · "곧 끝남" · "끝남". 기한이 없으면 null.
  String? get label {
    final Duration? left = remaining;
    if (left == null) return null;
    if (left == Duration.zero) return '끝남';
    if (left.inHours >= 24) return '${(left.inMinutes / (24 * 60)).ceil()}일 남음';
    if (left.inMinutes >= 60) return '${(left.inMinutes / 60).ceil()}시간 남음';
    return '곧 끝남';
  }
}

/// "3일" 처럼 기한을 사람이 읽는 말로. null 이면 null.
String? keywordAlertTtlLabel(Duration? ttl) =>
    ttl == null ? null : '${ttl.inDays}일';
