import 'package:mocl_server/server.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:test/test.dart';

ListItem _item(int id, String title, {String reply = '3', String hit = ''}) =>
    ListItem.empty().copyWith(
      id: id,
      title: title,
      url: 'https://x/$id',
      reply: reply,
      hit: hit,
    );

const RadarBoard _board = RadarBoard(
  site: SiteType.clien,
  board: 'park',
  url: 'https://m.clien.net/service/board/park',
  title: '모두의공원',
);

void main() {
  late RadarStore store;
  setUp(() async {
    store = RadarStore(
      await databaseFactoryMemory.openDatabase(
        'r${DateTime.now().microsecondsSinceEpoch}',
      ),
    );
  });

  test('처음 본 시각은 유지하고 반응 기록을 쌓는다', () async {
    List<ListItem> page = [_item(1, '첫 글', reply: '2', hit: '1,234')];
    final RadarCollector c = RadarCollector(
      store: store,
      boards: const [_board],
      politeDelay: Duration.zero,
      fetch: (_) async => page,
    );
    await c.collect(1000);
    page = [_item(2, '둘째'), _item(1, '첫 글(수정)', reply: '9')];
    await c.collect(2000);

    final List<RadarPost> posts = await store.posts();
    final RadarPost first = posts.firstWhere((p) => p.id == 1);
    expect(first.firstSeenAt, 1000);
    expect(first.lastSeenAt, 2000);
    expect(first.title, '첫 글(수정)');
    expect(first.samples.map((s) => s.reply), [2, 9]);
    expect(first.samples.first.hit, 1234);
    expect(first.samples.last.rank, 1);
    expect(posts.firstWhere((p) => p.id == 2).firstSeenAt, 2000);
  });

  test('48시간 지난 글은 지우고, 실패한 게시판을 기록한다', () async {
    bool fail = false;
    final RadarCollector c = RadarCollector(
      store: store,
      boards: const [_board],
      politeDelay: Duration.zero,
      fetch: (_) async {
        if (fail) throw const FetchFailure('HTTP', statusCode: 403);
        return [_item(1, '글')];
      },
    );
    await c.collect(0);
    fail = true;
    await c.collect(RadarStore.retention.inMilliseconds + 1);
    expect(await store.count(), 0);
    expect(c.failing, isEmpty, reason: '한 번 실패는 아직 실패로 치지 않는다');
    await c.collect(RadarStore.retention.inMilliseconds + 2);
    expect(c.failing, {'clien|park'});
    fail = false;
    await c.collect(RadarStore.retention.inMilliseconds + 3);
    expect(c.failing, isEmpty);
  });

  test('반응 숫자 표기를 읽는다', () {
    expect(RadarSample.parseCount('1,234'), 1234);
    expect(RadarSample.parseCount('1.2만'), 12000);
    expect(RadarSample.parseCount('3k'), 3000);
    expect(RadarSample.parseCount(''), -1);
    expect(RadarSample.parseCount('[12]'), 12);
  });

  test('BoardCache 는 짧은 시간 같은 게시판을 한 번만 받고, 실패는 다시 받는다', () async {
    int calls = 0;
    bool fail = true;
    DateTime now = DateTime(2026);
    final BoardCache cache = BoardCache((
      site, {
      required board,
      required url,
      boardTitle = '',
    }) async {
      calls++;
      if (fail) throw const FetchFailure('x');
      return [_item(1, 'a')];
    }, clock: () => now);
    Future<List<ListItem>> get() =>
        cache.fetch(SiteType.clien, board: 'park', url: 'u');

    await expectLater(get(), throwsA(isA<FetchFailure>()));
    fail = false;
    await get();
    await get();
    expect(calls, 2, reason: '실패 뒤 한 번 다시 받고, 성공은 재사용');
    now = now.add(const Duration(minutes: 3));
    await get();
    expect(calls, 3);
  });
}
