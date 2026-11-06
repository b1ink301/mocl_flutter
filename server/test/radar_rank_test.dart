import 'dart:convert';

import 'package:mocl_server/server.dart';
import 'package:mocl_server/src/radar/title_features.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/radar/issue_feed.dart';
import 'package:sembast/sembast_memory.dart';
import 'package:shelf/shelf.dart';
import 'package:shelf_router/shelf_router.dart';
import 'package:test/test.dart';

/// 무관한 글(실제 수집분에서 골랐다). 묶기 테스트의 배경 말뭉치.
const List<String> _filler = [
  '중국 야생 고양이',
  '투기와 투자의 차이에 대해 알려드립니다',
  '공화당 개털린 모습에서 지금 민주당이 배워야 할 점',
  '신천지는 어디에나 있죠 회사든 학교든',
  '인도 택배는 냄새가 어마어마 하네요',
  '수능 2주 전 수능 떡 가지러 오랍니다',
  '이세영 예쁘다고 생각했는데',
  '실내화 관리 어떻게 하세요',
  '초고도비만의 위고비 68주 후기',
  '요즘 2000년대 노래에 빠졌네요',
  'hwp 파일이 문제가 되나보네요',
  '메피스토펠레스 완성 제작 과정',
  '야쿠르트 아줌마의 비밀병기',
  '첫 해외 여행 일본 갔다온 망가',
  '제프리 힌턴 AI가 없었더라면',
  '장원영 불가리 임원 볼키스 거절',
  '유해진은 어쩌다가 비호감으로 여론이',
  '관세때랑 비슷한 공포네요',
  '가격으로 보는 한식지수',
  '퇴사하는 직원한테 마지막 날까지 이러는 회사',
  '호남 반도체 언제 삽 뜨나요?',
  'ai 반도체 패권 근황',
  '노스포) 영화 <와일드 호스 나인> 후기에요',
  '노스포 5시간 플레이 후기',
];

/// 흔한 말을 흔하다고 알 만큼 큰 배경 말뭉치(작은 말뭉치에서는 묶음 후보를 찾는
/// 문서 빈도 상한이 3 으로 막혀 같은 말을 쓰는 글끼리도 서로 찾지 못한다).
final List<String> _background = [
  ..._filler,
  for (int i = 0; i < 200; i++) '잡담 n${i}x 글',
];

List<ClusterInput> _inputs(List<(String site, String title)> items) => [
  for (int i = 0; i < items.length; i++)
    ClusterInput('${items[i].$1}|b|$i', items[i].$1, items[i].$2, i),
];

void main() {
  group('TitleFeatures', () {
    test('말머리 · 확장자 · ㅋㅋ · 숫자만 · 불용어를 뺀다', () {
      expect(TitleFeatures.words('[유머] 속보) 고양이 근황.gif ㅋㅋㅋ 2026 아이폰17'), [
        '고양이',
        '아이폰17',
      ]);
    });

    test('조사가 달라도 2-gram 이 겹친다', () {
      final a = TitleFeatures.raw('윤석열이 말했다').keys.toSet();
      final b = TitleFeatures.raw('윤석열은 답했다').keys.toSet();
      expect(a.intersection(b), containsAll(['b:윤석', 'b:석열']));
    });
  });

  group('Clusterer(골든)', () {
    final List<(String, String)> items = [
      for (final t in _filler) ('dcinside', t),
      ('bobaedream', '국결한 아내에게 도태녀라고 댓글 단 페미의 최후'),
      ('inven', '국제결혼 아내에게 도태녀라고 댓글 단 페미의 최후'),
      ('dogdrip', '아이폰 듀오 힌지사태 의문'),
      ('meeco', '아이폰 듀오 4일 사용중 소감'),
      ('clien', '아이폰 듀오 힌지 문제 심각하네요'),
    ];
    late List<Cluster> clusters;
    setUpAll(() => clusters = const Clusterer().run(_inputs(items)));

    Cluster clusterOf(String title) =>
        clusters.firstWhere((c) => c.members.any((m) => m.title == title));

    test('같은 이야기를 다르게 쓴 제목은 한 묶음이다', () {
      expect(clusterOf('국결한 아내에게 도태녀라고 댓글 단 페미의 최후').sites, {
        'bobaedream',
        'inven',
      });
      expect(clusterOf('아이폰 듀오 힌지사태 의문').members, hasLength(3));
    });

    test('단어 하나만 겹치는 무관한 제목은 묶지 않는다', () {
      expect(clusterOf('호남 반도체 언제 삽 뜨나요?').members, hasLength(1));
      expect(clusterOf('노스포 5시간 플레이 후기').members, hasLength(1));
    });

    test('순서 탓에 갈린 묶음은 다 묶은 뒤 합친다(첫 글 · 순서 유지)', () {
      // 실제 수집분. "국대" 와 "국가대표" 로 갈려 두 묶음이 생기지만 중심끼리는 닮았다.
      final List<(String, String)> split = [
        for (final t in _background) ('dcinside', t),
        ('mlbpark', '호날두 국대 은퇴'),
        ('inven', '호날두 국가대표 은퇴선언'),
        ('mlbpark', '호날두, 국대 공식 은퇴'),
        ('dcinside', '[속보] 크리스티아누 호날두, 국가대표 선수 은퇴'),
        ('mlbpark', '호날두  국대  은퇴하네유'),
        ('clien', '호날두 국가대표 은퇴선언'),
        ('inven', '호날두 국가대표 은퇴'),
      ];
      final List<ClusterInput> inputs = _inputs(split);
      List<Cluster> about(List<Cluster> cs) => [
        for (final c in cs)
          if (c.members.any((m) => m.title.contains('호날두'))) c,
      ];
      expect(
        about(const Clusterer(merge: false).run(inputs)),
        hasLength(2),
        reason: '합치기 전에는 갈려 있어야 의미 있는 테스트',
      );
      final List<Cluster> merged = const Clusterer().run(inputs);
      final Cluster c = about(merged).single;
      expect(c.members, hasLength(7));
      expect(c.members.first.title, '호날두 국대 은퇴');
      expect(
        c.members.map((m) => m.at),
        orderedEquals([...c.members.map((m) => m.at)]..sort()),
      );
      expect(merged.where((c) => c.members.length > 1), hasLength(1));
    });

    test('대표 제목은 묶음 안의 글이다', () {
      final Cluster c = clusterOf('아이폰 듀오 힌지사태 의문');
      expect(c.members.map((m) => m.title), contains(c.representative.title));
    });
  });

  group('RadarRanker', () {
    const int hour = 3600 * 1000;
    const int now = 100 * hour;
    int seq = 0;

    RadarPost post(
      String site,
      String title, {
      int ageMin = 60,
      int reply = 5,
      List<RadarSample>? samples,
    }) {
      seq++;
      return RadarPost(
        site: site,
        board: 'b',
        id: seq,
        title: title,
        url: 'https://x/$seq',
        firstSeenAt: now - ageMin * 60 * 1000,
        lastSeenAt: now,
        samples: samples ?? [RadarSample(now, reply, -1, -1, 0)],
      );
    }

    List<RadarPost> corpus() => [
      for (final t in _filler) post('dcinside', t),
      post('clien', '아이폰 듀오 힌지 문제 심각하네요'),
      post('meeco', '아이폰 듀오 4일 사용중 소감'),
      post('dogdrip', '아이폰 듀오 힌지사태 의문', ageMin: 10),
      post('bobaedream', '국결한 아내에게 도태녀라고 댓글 단 페미의 최후', ageMin: 600),
      post('inven', '국제결혼 아내에게 도태녀라고 댓글 단 페미의 최후', ageMin: 590),
      post('clien', '어제 일', ageMin: 25 * 60),
    ];

    test('여러 커뮤니티에 걸친 · 최근 이슈가 위에 오고, 혼자인 글은 빠진다', () {
      final IssueFeed feed = const RadarRanker().rank(corpus(), now);
      expect(feed.issues, hasLength(2));
      expect(feed.issues.first.sites, hasLength(3));
      expect(feed.issues.first.posts, hasLength(3));
      expect(feed.issues.first.score, greaterThan(feed.issues.last.score));
      expect(feed.issues.first.trending, isTrue, reason: '30분 안에 새 커뮤니티 합류');
      expect(feed.issues.last.trending, isFalse);
    });

    test('데이터가 1시간 안 됐으면 급상승을 표시하지 않는다', () {
      final List<RadarPost> fresh = [
        post('clien', '아이폰 듀오 힌지 문제 심각하네요', ageMin: 20),
        post('meeco', '아이폰 듀오 4일 사용중 소감', ageMin: 15),
        post('dogdrip', '아이폰 듀오 힌지사태 의문', ageMin: 5),
        for (final t in _filler) post('dcinside', t, ageMin: 20),
      ];
      final IssueFeed feed = const RadarRanker().rank(fresh, now);
      expect(feed.issues.first.trending, isFalse);
    });

    test('받기 실패 중인 커뮤니티는 기준 목록에서 뺀다', () {
      final IssueFeed feed = const RadarRanker().rank(
        corpus(),
        now,
        failing: {'clien|park'},
      );
      expect(feed.communities, isNot(contains(SiteType.clien)));
      expect(feed.communities, contains(SiteType.dcinside));
    });

    test('이슈 id 는 첫 글 기준으로 다시 계산해도 같다', () {
      final List<RadarPost> posts = corpus();
      final String a = const RadarRanker().rank(posts, now).issues.first.id;
      final String b = const RadarRanker()
          .rank(posts, now + 60000)
          .issues
          .first
          .id;
      expect(a, b);
      expect(a, startsWith('i_'));
    });

    test('늘 나오던 말뿐인 묶음은 새로 나온 말의 묶음보다 내려간다', () {
      final List<RadarPost> posts = [
        // 묶기 범위(24시간) 밖, 이슈 전 하루 동안 "내일 코스피" 가 꾸준히 나왔다.
        for (int h = 25; h < 48; h++) ...[
          post('mlbpark', '내일 코스피 어떨까요', ageMin: h * 60),
          post('clien', '코스피 차트 보는 법', ageMin: h * 60 + 5),
        ],
        for (final t in _background) post('dcinside', t),
        post('mlbpark', '내일 코스피 어떨까요 오늘', ageMin: 30),
        post('clien', '내일 코스피 어떨까요 진짜', ageMin: 25),
        post('inven', '서킷브레이커 발동 증시 폭락', ageMin: 30),
        post('damoang', '서킷브레이커 발동 증시', ageMin: 25),
      ];
      final List<ScoredIssue> scored = const RadarRanker().score(posts, now);
      ScoredIssue of(String word) =>
          scored.firstWhere((s) => s.issue.title.contains(word));
      expect(of('서킷브레이커').novelty, greaterThan(0.9));
      expect(of('내일 코스피').novelty, lessThan(0.5));
      expect(
        scored.indexOf(of('서킷브레이커')),
        lessThan(scored.indexOf(of('내일 코스피'))),
      );

      // 이슈 전 기록이 짧으면(서버를 막 켰을 때) 판단하지 않는다.
      final List<ScoredIssue> early = const RadarRanker().score([
        for (final t in _background) post('dcinside', t, ageMin: 40),
        post('mlbpark', '내일 코스피 어떨까요 오늘', ageMin: 30),
        post('clien', '내일 코스피 어떨까요 진짜', ageMin: 25),
      ], now);
      expect(early.single.novelty, 1);
    });

    test('반응 속도: 최근 30분에 늘어난 양 · 밀려난 글은 0 · 모르면 -1', () {
      const int min = 60 * 1000;
      RadarSample s(int agoMin, int reply) =>
          RadarSample(now - agoMin * min, reply, -1, -1, 0);
      double v(List<RadarSample> samples) => RadarRanker.velocity(
        post('clien', 'x', samples: samples),
        now,
        const Duration(minutes: 30),
      );
      expect(v([s(60, 0), s(30, 10), s(15, 20), s(0, 40)]), 60);
      expect(v([s(60, 0), s(20, 50)]), 0, reason: '1쪽에서 밀려남');
      expect(v([s(2, 0), s(0, 10)]), -1, reason: '기록이 너무 짧음');
      expect(v([s(0, 10)]), -1);
    });

    test('한 사이트가 같은 이야기를 많이 올려도 점수가 그만큼 불지 않는다', () {
      final List<RadarPost> posts = [
        for (final t in _background) post('dcinside', t),
        for (int i = 0; i < 8; i++)
          post('mlbpark', '나스닥 필반 폭락 하락 $i', ageMin: 30 + i),
        post('clien', '나스닥 필반 폭락 하락 실화', ageMin: 30),
      ];
      final ScoredIssue decayed = const RadarRanker(noveltyWeight: 0)
          .score(posts, now)
          .first;
      final ScoredIssue flat = const RadarRanker(
        noveltyWeight: 0,
        siteDecay: 0,
      ).score(posts, now).first;
      expect(decayed.issue.posts, hasLength(9));
      expect(decayed.base, lessThan(flat.base * 0.6));
    });

    test('JSON 으로 왕복하고, 앱은 모르는 사이트 글만 건너뛴다', () {
      final IssueFeed feed = const RadarRanker().rank(corpus(), now);
      final Map<String, Object?> json =
          jsonDecode(jsonEncode(feed.toJson())) as Map<String, Object?>;
      ((json['issues']! as List).first as Map)['posts'] = [
        ...((json['issues']! as List).first as Map)['posts'] as List,
        {'site': 'futureSite', 'title': 'x', 'url': 'u', 'firstSeenAt': 1},
      ];
      final IssueFeed back = IssueFeed.fromJson(json);
      expect(back.issues.first.posts, hasLength(3));
      expect(back.issues.first.title, feed.issues.first.title);
    });
  });

  test('/v1/issues: 계산 전 503, 이후 ETag · 304, 상세 조회', () async {
    final RadarStore store = RadarStore(
      await databaseFactoryMemory.openDatabase(
        'feed${DateTime.now().microsecondsSinceEpoch}',
      ),
    );
    await store.upsert('clien', 'park', [
      (
        1,
        '아이폰 듀오 힌지 문제',
        'https://m.clien.net/service/board/park/1',
        const RadarSample(0, 1, -1, -1, 0),
      ),
    ], 1000);
    await store.upsert('meeco', 'free', [
      (
        2,
        '아이폰 듀오 힌지 사태',
        'https://meeco.kr/free/2',
        const RadarSample(0, 1, -1, -1, 0),
      ),
    ], 1000);
    final RadarFeed feed = RadarFeed(store);
    final Router router = Router();
    feed.mount(router);
    Future<Response> get(String path, {String? etag}) async =>
        await router.call(
          Request(
            'GET',
            Uri.parse('http://localhost$path'),
            headers: {'if-none-match': ?etag},
          ),
        );

    expect((await get('/v1/issues')).statusCode, 503);
    await feed.rebuild(2000);
    final Response ok = await get('/v1/issues');
    expect(ok.statusCode, 200);
    final IssueFeed parsed = IssueFeed.fromJson(
      jsonDecode(await ok.readAsString()),
    );
    expect(parsed.issues.single.sites.toSet(), {
      SiteType.clien,
      SiteType.meeco,
    });
    expect((await get('/v1/issues', etag: ok.headers['etag'])).statusCode, 304);
    expect(
      (await get('/v1/issues/${parsed.issues.single.id}')).statusCode,
      200,
    );
    expect((await get('/v1/issues/i_nope')).statusCode, 404);
  });
}
