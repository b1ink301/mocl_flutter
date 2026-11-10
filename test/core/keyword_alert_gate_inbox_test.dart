import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/features/keyword_alerts/application/keyword_alert_providers.dart';
import 'package:mocl_flutter/features/keyword_alerts/data/keyword_alert_inbox.dart';
import 'package:mocl_flutter/features/keyword_alerts/data/push_messaging.dart';
import 'package:mocl_flutter/features/keyword_alerts/domain/inbox_alert.dart';
import 'package:mocl_flutter/features/keyword_alerts/presentation/widgets/keyword_alert_gate.dart';
import 'package:mocl_flutter/features/settings_page/application/datasource_provider.dart';
import 'package:mocl_shared/alerts/keyword_alerts.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MemoryStorage() implements InboxStorage {
  String? value;

  @override
  Future<String?> read() async => value;

  @override
  Future<void> write(String? v) async => value = v;
}

class _FakeMessaging() implements PushMessaging {
  final StreamController<PushTap> taps = StreamController.broadcast();
  final StreamController<PushTap> foreground = StreamController.broadcast();

  @override
  Future<bool> requestPermission() async => true;
  @override
  Future<String?> token() async => null;
  @override
  Stream<String> get onTokenRefresh => const Stream.empty();
  @override
  Future<PushTap?> initialTap() async => null;
  @override
  Stream<PushTap> get onTap => taps.stream;
  @override
  Stream<PushTap> get onForeground => foreground.stream;
}

PushTap _push(String id) => PushTap(
  KeywordAlertPayload.build(
    site: SiteType.clien,
    board: 'jirum',
    url: 'https://m.clien.net/service/board/jirum/$id',
    title: '에어팟 $id',
    keywords: ['에어팟'],
  ),
  notificationTitle: '알뜰구매 · 에어팟',
);

void main() {
  late _FakeMessaging messaging;
  late ProviderContainer container;
  late GoRouter router;
  final List<Object?> opened = [];

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    messaging = _FakeMessaging();
    opened.clear();
    router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const Scaffold()),
        GoRoute(
          path: '/detail',
          builder: (_, state) {
            opened.add(state.extra);
            return const Scaffold();
          },
        ),
      ],
    );
    container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        keywordAlertsAvailableProvider.overrideWithValue(true),
        pushMessagingProvider.overrideWithValue(messaging),
        // 테스트 zone 안에서 만들도록 늦게 만든다(setUp zone 의 Future 는 fake async 가 돌리지 않는다).
        keywordAlertInboxStoreProvider.overrideWith(
          (ref) => KeywordAlertInbox(_MemoryStorage()),
        ),
      ],
    );
  });

  tearDown(() => container.dispose());

  Future<void> pumpGate(WidgetTester tester) => tester.pumpWidget(
    UncontrolledProviderScope(
      container: container,
      child: MaterialApp.router(
        routerConfig: router,
        builder: (context, child) =>
            KeywordAlertGate(router: router, child: child!),
      ),
    ),
  );

  List<InboxAlert> inbox() =>
      container.read(keywordAlertInboxProvider).value ?? const [];

  Future<void> settle(WidgetTester tester) async {
    for (int i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  testWidgets('앱이 앞에 있을 때 온 알림은 안 읽음으로 쌓인다', (tester) async {
    await pumpGate(tester);
    messaging.foreground.add(_push('1'));
    await settle(tester);

    final List<InboxAlert> list = inbox();
    expect(list.map((a) => a.title), ['에어팟 1']);
    expect(list.single.read, isFalse);
    expect(list.single.boardTitle, '알뜰구매');
    expect(container.read(keywordAlertUnreadCountProvider), 1);
    expect(find.textContaining('에어팟 1'), findsOneWidget); // 스낵바
    await tester.pump(const Duration(seconds: 10));
  });

  testWidgets('알림을 눌러 들어오면 읽음으로 쌓고 상세를 연다', (tester) async {
    await pumpGate(tester);
    messaging.foreground.add(_push('1'));
    await settle(tester);
    messaging.taps.add(_push('1'));
    await settle(tester);

    final List<InboxAlert> list = inbox();
    expect(list, hasLength(1));
    expect(list.single.read, isTrue);
    expect(container.read(keywordAlertUnreadCountProvider), 0);
    expect(opened, hasLength(1));
    await tester.pump(const Duration(seconds: 10));
  });
}
