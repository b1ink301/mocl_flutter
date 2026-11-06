import 'package:dio/dio.dart';
import 'package:mocl_flutter/features/database/domain/entities/mute_rule.dart';
import 'package:mocl_flutter/features/issue_radar/data/issue_radar_api.dart';
import 'package:mocl_flutter/features/issue_radar/data/issue_read_store.dart';
import 'package:mocl_flutter/features/mute/application/mute_providers.dart';
import 'package:mocl_flutter/features/remote_config/data/remote_config_fetcher.dart'
    show moclApiBaseUrl;
import 'package:mocl_flutter/features/settings_page/application/datasource_provider.dart';
import 'package:mocl_shared/radar/issue_feed.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'issue_radar_providers.g.dart';

/// 서버 주소가 있는 빌드에서만 이슈 레이더를 보인다.
@Riverpod(keepAlive: true)
bool issueRadarAvailable(Ref ref) => moclApiBaseUrl.isNotEmpty;

@Riverpod(keepAlive: true)
IssueRadarApi issueRadarApi(Ref ref) {
  final Dio dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
    ),
  );
  ref.onDispose(dio.close);
  return IssueRadarApi(dio, moclApiBaseUrl);
}

/// 서버의 이슈 목록 그대로.
@riverpod
class IssueFeedNotifier() extends _$IssueFeedNotifier {
  @override
  Future<IssueFeed> build() => ref.watch(issueRadarApiProvider).fetch();

  Future<void> refresh() async {
    state = await AsyncValue.guard(ref.read(issueRadarApiProvider).fetch);
  }
}

/// 차단(뮤트)한 제목 키워드가 든 글을 빼고, 글이 다 빠진 이슈는 지운 목록.
/// 글쓴이 차단은 레이더 글에 작성자 정보가 없어 쓰지 않는다.
@riverpod
Future<IssueFeed> visibleIssueFeed(Ref ref) async {
  final IssueFeed feed = await ref.watch(issueFeedProvider.future);
  final List<String> muted = [
    for (final MuteRule r in await ref.watch(muteRulesProvider.future))
      if (r.type == MuteType.keyword && r.pattern.isNotEmpty) r.pattern,
  ];
  return filterMuted(feed, muted);
}

/// [visibleIssueFeed] 의 순수 함수(테스트용). 목록과 같은 규칙(`title.contains`)으로 거른다.
IssueFeed filterMuted(IssueFeed feed, List<String> mutedKeywords) {
  if (mutedKeywords.isEmpty) return feed;
  bool hidden(String title) => mutedKeywords.any(title.contains);
  return IssueFeed(
    generatedAt: feed.generatedAt,
    communities: feed.communities,
    issues: [
      for (final Issue i in feed.issues)
        if (i.posts.where((p) => !hidden(p.title)).toList()
            case final List<IssuePost> kept when kept.isNotEmpty)
          Issue(
            id: i.id,
            title: hidden(i.title) ? kept.first.title : i.title,
            sites: {for (final p in kept) p.site}.toList(),
            firstSeenAt: i.firstSeenAt,
            lastSeenAt: i.lastSeenAt,
            score: i.score,
            trending: i.trending,
            posts: kept,
          ),
    ],
  );
}

@Riverpod(keepAlive: true)
IssueReadStore issueReadStore(Ref ref) =>
    IssueReadStore(ref.watch(sharedPreferencesProvider));

/// 메인 화면 위에 "지금 이슈" 카드를 둘지. 끄면 앱바의 레이더 아이콘만 남는다.
/// 카드의 닫기 버튼과 설정 "메인에 지금 이슈 보기" 가 함께 바꾼다.
@Riverpod(keepAlive: true)
class IssueHomeCardNotifier() extends _$IssueHomeCardNotifier {
  static const String _key = 'issue_radar_home_card';

  @override
  bool build() => ref.watch(sharedPreferencesProvider).getBool(_key) ?? true;

  Future<void> set(bool show) async {
    if (state == show) return;
    state = show;
    await ref.read(sharedPreferencesProvider).setBool(_key, show);
  }
}

/// 위쪽 이슈 중 아직 안 본 게 있는지(앱바 레이더 아이콘의 점).
/// 이슈를 못 받았으면 false.
@riverpod
bool hasUnreadTopIssues(Ref ref) {
  final IssueFeed? feed = ref.watch(visibleIssueFeedProvider).value;
  if (feed == null) return false;
  final Set<String> read = ref.watch(readIssuesProvider);
  return feed.issues
      .take(homeCardIssueCount)
      .any((Issue i) => !read.contains(i.id));
}

/// 메인 카드에 보이는(점으로 알리는) 이슈 수.
const int homeCardIssueCount = 3;

/// 본 이슈 id.
@Riverpod(keepAlive: true)
class ReadIssuesNotifier() extends _$ReadIssuesNotifier {
  @override
  Set<String> build() => ref.watch(issueReadStoreProvider).load();

  Future<void> markRead(String id) async {
    if (state.contains(id)) return;
    state = await ref.read(issueReadStoreProvider).add(id);
  }
}
