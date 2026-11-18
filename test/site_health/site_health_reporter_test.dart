import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/site_health/data/site_health_reporter.dart';
import 'package:mocl_flutter/features/site_health/data/site_report_client.dart';
import 'package:mocl_flutter/features/site_health/domain/site_health_classifier.dart';
import 'package:mocl_shared/entities/mocl_details.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/reports/site_report.dart';
import 'package:mocl_shared/util/mocl_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 보낸 신고를 모아 두는 클라이언트.
class _Client() implements SiteReportClient {
  final List<SiteReport> sent = [];

  @override
  bool get available => true;

  @override
  Future<bool> send(SiteReport report) async {
    sent.add(report);
    return true;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Either<Failure, List<ListItem>> _listFail(String message) =>
    Left(GetListFailure(message: message));

final ListItem _item = ListItem.empty().copyWith(
  id: 1,
  board: 'park',
  url: 'https://m.clien.net/service/board/park/1',
);

void main() {
  group('SiteHealthClassifier', () {
    test('파서 예외 · 첫 쪽 0개만 고장으로 본다', () {
      expect(
        SiteHealthClassifier.list(
          _listFail('FormatException: bad'),
          firstPage: false,
        ),
        SiteReportReason.listParse,
      );
      expect(
        SiteHealthClassifier.list(const Right([]), firstPage: true),
        SiteReportReason.emptyList,
      );
      expect(
        SiteHealthClassifier.list(const Right([]), firstPage: false),
        isNull,
      );
      expect(
        SiteHealthClassifier.detail(
          const Left(GetDetailFailure(message: 'container is null')),
        ),
        SiteReportReason.detailParse,
      );
    });

    test('HTTP 실패 · 네트워크 · 로그인 · 요청 제한은 신고하지 않는다', () {
      for (final Failure f in [
        const GetListFailure(message: 'response.statusCode = 403'),
        const NetworkFailure(message: 'offline'),
        const NotLoginFailure(message: '로그인이 필요해요.'),
        const RateLimitFailure(message: '429'),
        const PermissionFailure(message: '등급'),
      ]) {
        expect(
          SiteHealthClassifier.list(Left(f), firstPage: true),
          isNull,
          reason: '$f',
        );
      }
      expect(
        SiteHealthClassifier.detail(
          const Left(GetDetailFailure(message: 'response.statusCode = 404')),
        ),
        isNull,
      );
      expect(SiteHealthClassifier.detail(Right(Details.empty())), isNull);
    });
  });

  group('SiteHealthReporter', () {
    late _Client client;
    late SharedPreferences prefs;
    final List<Object?> crashes = [];
    DateTime now = DateTime(2026, 11, 18, 10);

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      prefs = await SharedPreferences.getInstance();
      client = _Client();
      crashes.clear();
      now = DateTime(2026, 11, 18, 10);
      MoclLogger.onError = (Object error, StackTrace? st, {String? reason}) =>
          crashes.add(error);
    });
    tearDown(() => MoclLogger.onError = null);

    SiteHealthReporter reporter({bool enabled = true}) => SiteHealthReporter(
      prefs: prefs,
      client: client,
      appVersion: () async => '1.6.4+412',
      platform: 'android',
      enabled: enabled,
      clock: () => now,
    );

    Future<void> settle() => Future<void>.delayed(Duration.zero);

    test('고장은 Crashlytics 와 서버로 한 번 보내고, 같은 날 같은 게시판은 다시 보내지 않는다', () async {
      final SiteHealthReporter r = reporter();
      for (int i = 0; i < 3; i++) {
        r.onList(
          SiteType.clien,
          'park',
          'https://m.clien.net/service/board/park',
          _listFail('RangeError: x\n#0 parse'),
          firstPage: true,
        );
        await settle();
      }
      expect(client.sent, hasLength(1));
      final SiteReport sent = client.sent.single;
      expect(sent.kind, SiteReportKind.auto);
      expect(sent.reason, SiteReportReason.listParse);
      expect(sent.site, SiteType.clien);
      expect(sent.board, 'park');
      expect(sent.message, 'RangeError: x');
      expect(crashes.single, isA<SiteParseError>());

      // 다른 이유(상세)는 따로 센다.
      r.onDetail(
        SiteType.clien,
        _item,
        const Left(GetDetailFailure(message: 'container is null')),
      );
      await settle();
      expect(client.sent, hasLength(2));

      // 다음 날 다시 보낸다.
      now = now.add(const Duration(days: 1));
      r.onList(
        SiteType.clien,
        'park',
        'https://m.clien.net/service/board/park',
        _listFail('RangeError: x'),
        firstPage: true,
      );
      await settle();
      expect(client.sent, hasLength(3));
    });

    test('정상 결과 · 차단은 아무것도 보내지 않는다', () async {
      final SiteHealthReporter r = reporter();
      r.onList(
        SiteType.clien,
        'park',
        'https://m.clien.net/service/board/park',
        Right([_item]),
        firstPage: true,
      );
      r.onList(
        SiteType.clien,
        'park',
        'https://m.clien.net/service/board/park',
        _listFail('response.statusCode = 403'),
        firstPage: true,
      );
      await settle();
      expect(client.sent, isEmpty);
      expect(crashes, isEmpty);
    });

    test('계정마다 다른 게시판(네이버카페 · 레딧)은 게시판 · 주소를 빼고 보낸다', () async {
      reporter().onList(
        SiteType.reddit,
        'r/secret',
        'https://www.reddit.com/r/secret',
        _listFail('TypeError'),
        firstPage: true,
      );
      await settle();
      expect(client.sent.single.site, SiteType.reddit);
      expect(client.sent.single.board, isNull);
      expect(client.sent.single.url, isNull);
    });

    test('꺼져 있으면(debug) 보내지 않는다', () async {
      reporter(enabled: false).onList(
        SiteType.clien,
        'park',
        'https://m.clien.net/service/board/park',
        _listFail('boom'),
        firstPage: true,
      );
      await settle();
      expect(client.sent, isEmpty);
      expect(crashes, isEmpty);
    });
  });

  test('서버 주소가 없으면 보내지 않는다', () async {
    final SiteReportClient client = SiteReportClient(Dio(), '');
    expect(client.available, isFalse);
    expect(
      await client.send(
        const SiteReport(
          kind: SiteReportKind.user,
          reason: SiteReportReason.other,
          appVersion: '1',
          platform: 'android',
        ),
      ),
      isFalse,
    );
  });
}
