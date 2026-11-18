import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/features/site_health/application/site_health_providers.dart';
import 'package:mocl_flutter/features/site_health/data/site_report_client.dart';
import 'package:mocl_flutter/features/site_health/domain/site_report_target.dart';
import 'package:mocl_flutter/features/site_health/presentation/widgets/site_report_sheet.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/reports/site_report.dart';
import 'package:package_info_plus/package_info_plus.dart';

class _Client(final bool ok) implements SiteReportClient {
  final List<SiteReport> sent = [];

  @override
  bool get available => true;

  @override
  Future<bool> send(SiteReport report) async {
    sent.add(report);
    return ok;
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  setUpAll(
    () => PackageInfo.setMockInitialValues(
      appName: 'mocl',
      packageName: 'net.b1ink.mocl',
      version: '1.6.4',
      buildNumber: '412',
      buildSignature: '',
    ),
  );

  Future<void> open(
    WidgetTester tester,
    _Client client,
    SiteReportTarget target, {
    SiteReportReason reason = SiteReportReason.other,
  }) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [siteReportClientProvider.overrideWithValue(client)],
        child: MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () =>
                    SiteReportFlow.open(context, target, initialReason: reason),
                child: const Text('open'),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('이유 · 메모를 골라 보내면 함께 보내는 정보 그대로 나가고 스낵바가 뜬다', (tester) async {
    final _Client client = _Client(true);
    await open(
      tester,
      client,
      SiteReportTarget.of(
        site: SiteType.clien,
        board: 'park',
        boardTitle: '모두의공원',
        url: 'https://m.clien.net/service/board/park/1',
      ),
      reason: SiteReportReason.content,
    );
    expect(find.textContaining('클리앙 · 모두의공원 · 글 주소'), findsOneWidget);

    await tester.tap(find.text(SiteReportReason.comments.label));
    await tester.enterText(find.byType(TextField), '  댓글이 비어요 ');
    await tester.tap(find.text('보내기'));
    await tester.pumpAndSettle();

    final SiteReport sent = client.sent.single;
    expect(sent.kind, SiteReportKind.user);
    expect(sent.reason, SiteReportReason.comments);
    expect(sent.site, SiteType.clien);
    expect(sent.board, 'park');
    expect(sent.url, 'https://m.clien.net/service/board/park/1');
    expect(sent.message, '댓글이 비어요');
    expect(sent.appVersion, '1.6.4+412');
    expect(find.textContaining('고마워요'), findsOneWidget);
  });

  testWidgets('일반 의견은 이유 칩 없이 내용이 있어야 보낸다', (tester) async {
    final _Client client = _Client(true);
    await open(tester, client, SiteReportTarget.general);
    expect(find.byType(ChoiceChip), findsNothing);
    expect(
      tester.widget<FilledButton>(find.byType(FilledButton)).onPressed,
      isNull,
    );
    await tester.enterText(find.byType(TextField), '다크 모드 좋아요');
    await tester.pump();
    await tester.tap(find.text('보내기'));
    await tester.pumpAndSettle();
    expect(client.sent.single.site, isNull);
    expect(client.sent.single.reason, SiteReportReason.other);
  });

  testWidgets('보내지 못하면 다시 시도하라고 알린다', (tester) async {
    await open(
      tester,
      _Client(false),
      SiteReportTarget.of(site: SiteType.damoang),
    );
    await tester.tap(find.text('보내기'));
    await tester.pumpAndSettle();
    expect(find.textContaining('보내지 못했어요'), findsOneWidget);
  });
}
