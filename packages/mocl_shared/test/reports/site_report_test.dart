import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/reports/site_report.dart';
import 'package:test/test.dart';

Map<String, Object?> _json({
  Object? kind = 'auto',
  Object? reason = 'listParse',
  Object? site = 'clien',
  Object? url = 'https://m.clien.net/service/board/park',
  Object? platform = 'android',
  Object? appVersion = '1.6.4+412',
  Object? message,
}) => {
  'kind': kind,
  'reason': reason,
  'site': site,
  'board': 'park',
  'url': url,
  'platform': platform,
  'appVersion': appVersion,
  'message': message,
};

void main() {
  test('toJson → fromJson 이 같은 값을 돌려준다', () {
    const SiteReport report = SiteReport(
      kind: SiteReportKind.user,
      reason: SiteReportReason.comments,
      appVersion: '1.6.4+412',
      platform: 'ios',
      site: SiteType.damoang,
      board: 'free',
      url: 'https://damoang.net/free/123',
      message: '댓글이 비어 있어요',
    );
    final SiteReport read = SiteReport.fromJson(report.toJson());
    expect(read.toJson(), report.toJson());
  });

  test('사이트 없는 사용자 의견은 받는다', () {
    final SiteReport read = SiteReport.fromJson({
      'kind': 'user',
      'reason': 'other',
      'platform': 'android',
      'appVersion': '1.0.0',
      'message': '좋아요',
    });
    expect(read.site, isNull);
    expect(read.toJson().containsKey('site'), isFalse);
  });

  test('자동 신고는 사이트가 있어야 한다', () {
    expect(() => SiteReport.fromJson(_json(site: null)), throwsFormatException);
  });

  test('kind 와 reason 이 맞지 않으면 거절한다', () {
    expect(
      () => SiteReport.fromJson(_json(reason: 'comments')),
      throwsFormatException,
    );
    expect(
      () => SiteReport.fromJson(_json(kind: 'user', reason: 'emptyList')),
      throwsFormatException,
    );
  });

  test('모르는 값 · 잘못된 형식을 거절한다', () {
    for (final Map<String, Object?> bad in [
      _json(kind: 'spam'),
      _json(site: 'naver'),
      _json(platform: 'windows'),
      _json(appVersion: ''),
      _json(url: 'javascript:alert(1)'),
      _json(url: 'file:///etc/passwd'),
      _json(message: 'x' * (SiteReport.maxMessageLength + 1)),
      _json(message: 3),
    ]) {
      expect(
        () => SiteReport.fromJson(bad),
        throwsFormatException,
        reason: '$bad',
      );
    }
    expect(() => SiteReport.fromJson('x'), throwsFormatException);
  });

  test('clip 은 첫 줄만 길이 안으로 남긴다', () {
    expect(SiteReport.clip(null), isNull);
    expect(SiteReport.clip('  \n'), isNull);
    expect(
      SiteReport.clip('FormatException: a\n#0 main'),
      'FormatException: a',
    );
    expect(SiteReport.clip('y' * 900)!.length, SiteReport.maxMessageLength);
  });
}
