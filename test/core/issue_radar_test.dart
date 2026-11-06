import 'dart:convert';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocl_flutter/features/issue_radar/application/issue_radar_providers.dart';
import 'package:mocl_flutter/features/issue_radar/data/issue_radar_api.dart';
import 'package:mocl_flutter/features/issue_radar/data/issue_read_store.dart';
import 'package:mocl_flutter/features/issue_radar/presentation/widgets/issue_time.dart';
import 'package:mocl_flutter/features/settings_page/application/datasource_provider.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_shared/radar/issue_feed.dart';
import 'package:shared_preferences/shared_preferences.dart';

IssuePost _p(SiteType site, String title) =>
    IssuePost(site: site, title: title, url: 'https://x', firstSeenAt: 0);

final IssueFeed _feed = IssueFeed(
  generatedAt: 0,
  communities: const [SiteType.clien, SiteType.meeco, SiteType.dcinside],
  issues: [
    Issue(
      id: 'i_1',
      title: '아이폰 듀오 힌지 사태',
      sites: const [SiteType.clien, SiteType.meeco],
      firstSeenAt: 0,
      lastSeenAt: 0,
      score: 2,
      posts: [
        _p(SiteType.clien, '아이폰 듀오 힌지 사태'),
        _p(SiteType.meeco, '아이폰 듀오 사용 소감'),
      ],
    ),
    Issue(
      id: 'i_2',
      title: '정치 이야기',
      sites: const [SiteType.dcinside],
      firstSeenAt: 0,
      lastSeenAt: 0,
      score: 1,
      posts: [_p(SiteType.dcinside, '정치 이야기')],
    ),
  ],
);

class _Adapter(final ResponseBody Function() respond)
    implements HttpClientAdapter {
  final List<RequestOptions> requests = [];
  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return respond();
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  group('filterMuted', () {
    test('차단 키워드가 든 글을 빼고, 다 빠진 이슈는 지운다', () {
      final IssueFeed out = filterMuted(_feed, ['정치', '힌지']);
      expect(out.issues, hasLength(1));
      final Issue i = out.issues.single;
      expect(i.posts.map((p) => p.title), ['아이폰 듀오 사용 소감']);
      expect(i.title, '아이폰 듀오 사용 소감', reason: '대표 제목이 가려지면 남은 글로');
      expect(i.sites, [SiteType.meeco]);
    });

    test('차단이 없으면 그대로', () {
      expect(identical(filterMuted(_feed, const []), _feed), isTrue);
    });
  });

  test('본 이슈는 최근 것만 남긴다', () async {
    SharedPreferences.setMockInitialValues({});
    final store = IssueReadStore(await SharedPreferences.getInstance());
    for (int i = 0; i < IssueReadStore.limit + 5; i++) {
      await store.add('i_$i');
    }
    final Set<String> read = store.load();
    expect(read, hasLength(IssueReadStore.limit));
    expect(read, isNot(contains('i_0')));
    expect(read, contains('i_${IssueReadStore.limit + 4}'));
  });

  group('메인 이슈 카드', () {
    Future<ProviderContainer> container(Map<String, Object> prefs) async {
      SharedPreferences.setMockInitialValues(prefs);
      final SharedPreferences sp = await SharedPreferences.getInstance();
      final c = ProviderContainer(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(sp),
          visibleIssueFeedProvider.overrideWith((ref) async => _feed),
        ],
      );
      addTearDown(c.dispose);
      return c;
    }

    test('기본은 켜짐, 끄면 저장되어 다음 실행에도 꺼져 있다', () async {
      final c = await container({});
      expect(c.read(issueHomeCardProvider), isTrue);
      await c.read(issueHomeCardProvider.notifier).set(false);
      expect(c.read(issueHomeCardProvider), isFalse);

      final SharedPreferences sp = await SharedPreferences.getInstance();
      final c2 = ProviderContainer(
        overrides: [sharedPreferencesProvider.overrideWithValue(sp)],
      );
      addTearDown(c2.dispose);
      expect(c2.read(issueHomeCardProvider), isFalse);
    });

    test('위쪽 이슈를 다 보면 점이 사라진다', () async {
      final c = await container({});
      c.listen(hasUnreadTopIssuesProvider, (_, _) {});
      expect(c.read(hasUnreadTopIssuesProvider), isFalse, reason: '받기 전');
      await c.read(visibleIssueFeedProvider.future);
      expect(c.read(hasUnreadTopIssuesProvider), isTrue);

      await c.read(readIssuesProvider.notifier).markRead('i_1');
      expect(c.read(hasUnreadTopIssuesProvider), isTrue);
      await c.read(readIssuesProvider.notifier).markRead('i_2');
      expect(c.read(hasUnreadTopIssuesProvider), isFalse);
    });
  });

  test('IssueRadarApi: 304 면 지난 목록을 그대로 쓴다', () async {
    int status = 200;
    final adapter = _Adapter(
      () => status == 200
          ? ResponseBody.fromString(
              jsonEncode(_feed.toJson()),
              200,
              headers: {
                'etag': ['"e1"'],
              },
            )
          : ResponseBody.fromString('', 304),
    );
    final api = IssueRadarApi(
      Dio()..httpClientAdapter = adapter,
      'https://api.test',
    );
    final IssueFeed first = await api.fetch();
    expect(first.issues, hasLength(2));
    status = 304;
    final IssueFeed second = await api.fetch();
    expect(identical(first, second), isTrue);
    expect(adapter.requests.last.headers['If-None-Match'], '"e1"');
  });

  test('시각 표기', () {
    final DateTime now = DateTime(2026, 11, 5, 12);
    int ago(Duration d) => now.subtract(d).millisecondsSinceEpoch;
    expect(issueTimeAgo(ago(const Duration(seconds: 20)), now: now), '방금');
    expect(issueTimeAgo(ago(const Duration(minutes: 7)), now: now), '7분 전');
    expect(issueTimeAgo(ago(const Duration(hours: 3)), now: now), '3시간 전');
  });
}
