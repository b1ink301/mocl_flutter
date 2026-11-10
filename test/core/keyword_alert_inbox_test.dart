import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/keyword_alerts/data/keyword_alert_inbox.dart';
import 'package:mocl_flutter/features/keyword_alerts/domain/inbox_alert.dart';
import 'package:mocl_shared/alerts/keyword_alerts.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';

class _MemoryStorage() implements InboxStorage {
  String? value;
  int writes = 0;

  @override
  Future<String?> read() async => value;

  @override
  Future<void> write(String? v) async {
    writes++;
    value = v;
  }
}

final DateTime _now = DateTime(2026, 11, 10, 12);

InboxAlert _alert(
  String id, {
  Duration ago = Duration.zero,
  bool read = false,
}) => InboxAlert(
  site: SiteType.clien,
  board: 'jirum',
  boardTitle: '알뜰구매',
  title: '글 $id',
  url: 'https://m.clien.net/service/board/jirum/$id',
  keywords: const ['에어팟'],
  receivedAt: _now.subtract(ago).millisecondsSinceEpoch,
  read: read,
);

void main() {
  late _MemoryStorage storage;
  late KeywordAlertInbox inbox;

  setUp(() {
    storage = _MemoryStorage();
    inbox = KeywordAlertInbox(storage, clock: () => _now);
  });

  group('KeywordAlertInbox', () {
    test('최신순으로 쌓고 같은 글은 한 번만 남긴다', () async {
      await inbox.add(_alert('1', ago: const Duration(minutes: 5)));
      await inbox.add(_alert('2'));
      final List<InboxAlert> list = await inbox.add(
        _alert('1', ago: const Duration(minutes: 1)),
      );
      expect(list.map((a) => a.title), ['글 2', '글 1']);
      // 다시 와도 처음 받은 시각 그대로.
      expect(
        list.last.receivedAt,
        _now.subtract(const Duration(minutes: 5)).millisecondsSinceEpoch,
      );
    });

    test('눌러서 들어온 알림은 이미 있어도 읽음으로 바꾼다', () async {
      await inbox.add(_alert('1'));
      final List<InboxAlert> list = await inbox.add(_alert('1'), read: true);
      expect(list.single.read, isTrue);
    });

    test('기한(14일) · 한도(100개)를 넘으면 버린다', () async {
      await inbox.add(_alert('old', ago: const Duration(days: 15)));
      for (int i = 0; i < KeywordAlertInbox.maxItems + 5; i++) {
        await inbox.add(_alert('$i', ago: Duration(minutes: i)));
      }
      final List<InboxAlert> list = await inbox.all();
      expect(list, hasLength(KeywordAlertInbox.maxItems));
      expect(list.first.title, '글 0');
      expect(list.any((a) => a.title == '글 old'), isFalse);
    });

    test('읽음 · 모두 읽음 · 지우기 · 되돌리기 · 모두 지우기', () async {
      await inbox.add(_alert('1', ago: const Duration(minutes: 1)));
      await inbox.add(_alert('2'));
      final String id1 = _alert('1').id;

      var list = await inbox.markRead(id1);
      expect(list.map((a) => a.read), [false, true]);

      list = await inbox.markAllRead();
      expect(list.every((a) => a.read), isTrue);

      final InboxAlert removed = list.last;
      list = await inbox.remove(removed.id);
      expect(list.map((a) => a.title), ['글 2']);

      list = await inbox.restore(removed);
      expect(list.map((a) => a.title), ['글 2', '글 1']);
      expect(list.last.read, isTrue);

      list = await inbox.clear();
      expect(list, isEmpty);
      expect(storage.value, isNull);
    });

    test('겹친 호출도 차례로 돌아 하나도 잃지 않는다', () async {
      await Future.wait([
        for (int i = 0; i < 10; i++) inbox.add(_alert('$i')),
      ]);
      expect(await inbox.all(), hasLength(10));
    });

    test('깨진 저장값 · 모르는 사이트는 건너뛴다', () async {
      storage.value = jsonEncode([
        _alert('1').toJson(),
        {'site': 'nope', 'url': 'x', 'title': 'y', 'receivedAt': 1},
        'garbage',
      ]);
      expect((await inbox.all()).map((a) => a.title), ['글 1']);

      storage.value = '{not json';
      expect(await inbox.all(), isEmpty);
    });

    test('JSON 왕복', () {
      final InboxAlert a = _alert('1', read: true);
      final InboxAlert b = InboxAlert.fromJson(
        jsonDecode(jsonEncode(a.toJson())),
      );
      expect(b.toJson(), a.toJson());
    });
  });

  group('InboxAlert.fromPush', () {
    Map<String, String> payload() => KeywordAlertPayload.build(
      site: SiteType.clien,
      board: 'jirum',
      url: 'https://m.clien.net/service/board/jirum/1',
      title: '에어팟 프로 특가',
      keywords: ['에어팟', '특가'],
    );

    test('payload 와 알림 제목으로 만든다', () {
      final DateTime sent = DateTime(2026, 11, 10, 9);
      final InboxAlert? a = InboxAlert.fromPush(
        payload(),
        notificationTitle: '알뜰구매 · 에어팟, 특가',
        sentAt: sent,
      );
      expect(a, isNotNull);
      expect(a!.site, SiteType.clien);
      expect(a.boardTitle, '알뜰구매');
      expect(a.title, '에어팟 프로 특가');
      expect(a.keywords, ['에어팟', '특가']);
      expect(a.receivedAt, sent.millisecondsSinceEpoch);
      expect(a.read, isFalse);
    });

    test('알림 제목이 없으면 게시판 id, 보낸 시각이 없으면 지금', () {
      final InboxAlert? a = InboxAlert.fromPush(payload(), now: _now);
      expect(a!.boardTitle, 'jirum');
      expect(a.receivedAt, _now.millisecondsSinceEpoch);
    });

    test('키워드 알림이 아니거나 값이 모자라면 null', () {
      expect(InboxAlert.fromPush({...payload(), 'type': 'other'}), isNull);
      expect(InboxAlert.fromPush({...payload(), 'site': 'nope'}), isNull);
      expect(InboxAlert.fromPush({...payload(), 'url': ''}), isNull);
      expect(InboxAlert.fromPush({...payload()}..remove('title')), isNull);
    });
  });
}
