import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// `Override` 타입은 misc.dart 에서 노출된다(앱의 *_event_mixin 과 동일한 경로).
import 'package:flutter_riverpod/misc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/config/mocl_theme.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_comment_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_user_info.dart';
import 'package:mocl_flutter/features/bookmark/application/bookmark_providers.dart';
import 'package:mocl_flutter/features/bookmark/domain/repositories/bookmark_repository.dart';
import 'package:mocl_flutter/features/database/domain/entities/bookmark_data.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_data.dart';
import 'package:mocl_flutter/features/database/domain/entities/favorite_group.dart';
import 'package:mocl_flutter/features/favorite/application/favorite_providers.dart';
import 'package:mocl_flutter/features/favorite/domain/repositories/favorite_repository.dart';
import 'package:mocl_flutter/features/detail_page/application/detail_providers.dart';
import 'package:mocl_flutter/features/detail_page/presentation/mocl_detail_page.dart';
import 'package:mocl_flutter/features/html_parser/application/datasource_provider.dart';
import 'package:mocl_flutter/features/html_parser/data/datasources/base/base_parser.dart';
import 'package:mocl_flutter/features/list_page/application/list_providers.dart';
import 'package:mocl_flutter/features/list_page/presentation/mocl_list_view.dart';
import 'package:mocl_flutter/features/main_page/presentation/mocl_main_view.dart';
import 'package:mocl_flutter/features/network/data/datasources/base_api.dart';

/// 리빌드 테스트용 화면 하네스.
///
/// 각 화면의 **실제 위젯 트리**를 그대로 띄우고, 네트워크/DB/파서/SharedPreferences
/// 같은 데이터 경계 provider 만 가짜로 교체한다. 화면 구조를 건드리지 않기 때문에
/// 리빌드 특성이 실제 앱과 동일하게 재현된다.
///
/// 교체 대상은 최소로 유지한다 — 파생 provider(제목, 스타일, 앱바 높이 등)는
/// 실제 구현이 그대로 돌아야 리빌드 회귀를 잡을 수 있다.
const Size kTestSurface = Size(400, 800);

/// 테스트 화면 크기를 고정한다(앱바 높이 계산이 screenWidth 에 의존한다).
void useFixedSurface(WidgetTester tester, {Size size = kTestSurface}) {
  tester.view.physicalSize = size * tester.view.devicePixelRatio;
  tester.view.devicePixelRatio = tester.view.devicePixelRatio;
  addTearDown(tester.view.resetPhysicalSize);
}

// ─────────────────────────────────────────────────────────────────────────────
// 픽스처
// ─────────────────────────────────────────────────────────────────────────────

/// 닉네임 이미지는 비워둔다(네트워크 이미지 로딩 회피).
UserInfo fakeUserInfo({String nick = '작성자'}) =>
    UserInfo(id: 'uid', nickName: nick, nickImage: '');

List<MainItem> fakeMainItems({int count = 20}) => <MainItem>[
  for (int i = 0; i < count; i++)
    MainItem(
      siteType: SiteType.clien,
      board: 'board$i',
      text: '게시판 $i',
      url: 'https://example.com/board$i',
      orderBy: i,
    ),
];

List<ListItem> fakeListItems({int count = 30}) => <ListItem>[
  for (int i = 0; i < count; i++)
    ListItem(
      id: 1000 + i,
      title: '리스트 항목 $i',
      reply: '$i',
      category: '잡담',
      time: '12:0$i',
      url: 'https://example.com/article/$i',
      info: '작성자$i · 12:00',
      board: 'board',
      boardTitle: '게시판',
      like: '1',
      hit: '10',
      userInfo: fakeUserInfo(nick: '작성자$i'),
      hasImage: false,
      isRead: false,
    ),
];

ListItem fakeListItem() => fakeListItems(count: 1).first;

Details fakeDetails({int commentCount = 12}) => Details(
  title: '상세 제목 - 리빌드 계측용 긴 제목으로 앱바 높이를 계산한다',
  time: '2026-07-28 14:00',
  viewCount: '123',
  likeCount: '7',
  bodyHtml: '<p>본문 문단입니다.</p><p>두 번째 문단입니다.</p>',
  info: '작성자 · 2026-07-28',
  userInfo: fakeUserInfo(),
  comments: <CommentItem>[
    for (int i = 0; i < commentCount; i++)
      CommentItem(
        id: i,
        bodyHtml: '<p>댓글 $i</p>',
        mediaHtml: '',
        isVideo: false,
        time: '14:0$i',
        info: '댓글작성자$i · 14:00',
        likeCount: '0',
        userInfo: fakeUserInfo(nick: '댓글작성자$i'),
        authorId: 'uid',
        isReply: false,
      ),
  ],
);

// ─────────────────────────────────────────────────────────────────────────────
// 화면별 pump 헬퍼
// ─────────────────────────────────────────────────────────────────────────────

/// 메인 화면(`MainView` = 앱바 + 즐겨찾기 그룹별 게시판 목록).
///
/// `MainPage` 는 Drawer(앱 버전 등 설정 provider 의존)를 포함하므로, 리빌드
/// 계측에는 스크롤 본체인 `MainView` 만 띄운다.
/// 메인은 DB(즐겨찾기)를 그대로 구독하므로, 데이터 경계인 저장소만 교체한다.
Future<void> pumpMainScreen(
  WidgetTester tester, {
  List<MainItem>? items,
  SiteType siteType = SiteType.clien,
}) async {
  useFixedSurface(tester);
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        ...commonOverrides(siteType: siteType),
        favoriteRepositoryProvider.overrideWithValue(
          _FakeFavoriteRepository(items ?? fakeMainItems()),
        ),
      ],
      child: _app(const Scaffold(body: MainView())),
    ),
  );
  await tester.pumpAndSettle();
}

/// 리스트 화면(`MoclListView` = 앱바 + 페이징 목록).
Future<void> pumpListScreen(
  WidgetTester tester, {
  List<ListItem>? items,
  SiteType siteType = SiteType.clien,
}) async {
  useFixedSurface(tester);
  final MainItem mainItem = fakeMainItems(count: 1).first;
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        ...commonOverrides(siteType: siteType),
        mainItemProvider.overrideWithValue(mainItem),
        listPagingControllerProvider.overrideWith(
          () => _FakePagingController(items ?? fakeListItems()),
        ),
      ],
      child: _app(const Scaffold(body: MoclListView())),
    ),
  );
  await tester.pumpAndSettle();
}

/// 상세 화면(`DetailPage` 전체 — 앱바 + 확장 헤더 + 본문/댓글).
Future<void> pumpDetailScreen(
  WidgetTester tester, {
  Details? details,
  ListItem? item,
  SiteType siteType = SiteType.clien,
}) async {
  useFixedSurface(tester);
  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        ...commonOverrides(siteType: siteType),
        listItemProvider.overrideWithValue(item ?? fakeListItem()),
        detailsProvider.overrideWith(
          () => _FakeDetails(details ?? fakeDetails()),
        ),
        bookmarkRepositoryProvider.overrideWithValue(_FakeBookmarkRepository()),
        // 본문 이미지 Referer 계산에만 쓰인다(파서 인스턴스 자체는 사용 안 함).
        currentParserProvider.overrideWith(
          (Ref ref, SiteType siteType) => (_FakeParser(), _FakeApi()),
        ),
      ],
      child: _app(const DetailPage()),
    ),
  );
  await tester.pumpAndSettle();
}

/// 세 화면이 공통으로 필요한 최소 교체 목록.
/// - `screenWidth`: 앱 루트에서 주입하는 값(원본은 UnimplementedError)
/// - `currentSiteType` / `fontSizeDelta`: SharedPreferences 의존 제거
List<Override> commonOverrides({
  SiteType siteType = SiteType.clien,
  double width = 400,
}) => <Override>[
  screenWidthProvider.overrideWithValue(width),
  currentSiteTypeProvider.overrideWith(() => _FakeSiteType(siteType)),
  fontSizeDeltaProvider.overrideWith(_FakeFontSizeDelta.new),
];

Widget _app(Widget home) =>
    MaterialApp(theme: MoclTheme.lightTheme, home: home);

// ─────────────────────────────────────────────────────────────────────────────
// 가짜 Notifier / Repository
// ─────────────────────────────────────────────────────────────────────────────

/// 영속화된 폰트 델타 대신 메모리 값을 쓴다.
/// `adjustFontSize`/`resetFontSize` 는 실제 경로(appTextStyles → 화면)를 그대로 태운다.
class _FakeFontSizeDelta() extends FontSizeDelta {
  @override
  double build() => 0;

  @override
  void update(double step) => state = state + step;

  @override
  void reset() => state = 0;
}

class _FakeSiteType(final SiteType _siteType) extends CurrentSiteTypeNotifier {
  @override
  SiteType build() => _siteType;

  @override
  void changeSiteType(SiteType siteType) => state = siteType;
}

/// 메인 화면이 읽는 즐겨찾기 저장소를 메모리로 대체한다.
/// 그룹은 기본 그룹 하나만 두고, 주어진 게시판을 전부 거기에 담는다.
class _FakeFavoriteRepository(final List<MainItem> _items)
    implements FavoriteRepository {
  static const String _groupId = 'community';

  List<FavoriteData> get _favorites => <FavoriteData>[
    for (int i = 0; i < _items.length; i++)
      FavoriteData.fromMainItem(_items[i], i, group: _groupId, orderBy: i),
  ];

  @override
  Future<List<FavoriteData>> getAll() async => _favorites;

  @override
  Future<List<FavoriteGroup>> getGroups() async => <FavoriteGroup>[
    const FavoriteGroup(id: _groupId, name: '커뮤니티', orderBy: 0),
  ];

  @override
  Future<void> add(FavoriteData data) async {}

  @override
  Future<void> addAll(List<FavoriteData> items) async {}

  @override
  Future<void> remove(SiteType siteType, String board) async {}

  @override
  Future<bool> isFavorite(SiteType siteType, String board) async => true;

  @override
  Future<void> updateAll(List<FavoriteData> items) async {}

  @override
  Future<void> saveGroups(List<FavoriteGroup> groups) async {}
}

class _FakeDetails(final Details _details) extends DetailsNotifier {
  @override
  Future<Details> build() async {
    // 실제 구현은 getDetail() await 이후에 제목을 갱신한다. 동기 초기화 구간에서
    // 다른 provider 를 수정하면 Riverpod 이 assert 하므로 await 지점을 만들어준다.
    await Future<void>.delayed(Duration.zero);
    ref.read(detailTitleStateProvider.notifier).update(_details.title);
    return _details;
  }
}

/// 네트워크 fetch 없이 한 페이지를 즉시 돌려주는 PagingController.
class _FakePagingController(final List<ListItem> _items)
    extends ListPagingController {
  @override
  PagingController<int, ListItem> build() {
    final PagingController<int, ListItem> controller =
        PagingController<int, ListItem>(
          // 첫 페이지만 로드하고 종료.
          getNextPageKey: (PagingState<int, ListItem> state) =>
              state.keys == null ? 1 : null,
          fetchPage: (int pageKey) async => _items,
        );
    ref.onDispose(controller.dispose);
    return controller;
  }
}

class _FakeBookmarkRepository() implements BookmarkRepository {
  final Set<(SiteType, int)> _bookmarks = <(SiteType, int)>{};

  @override
  Future<void> add(BookmarkData data) async =>
      _bookmarks.add((data.siteType, data.id));

  @override
  Future<void> remove(SiteType siteType, int id) async =>
      _bookmarks.remove((siteType, id));

  @override
  Future<bool> isBookmarked(SiteType siteType, int id) async =>
      _bookmarks.contains((siteType, id));

  @override
  Future<List<BookmarkData>> getAll() async => const <BookmarkData>[];
}

/// `baseUrl` 만 사용되므로 나머지는 noSuchMethod 로 남긴다.
class _FakeParser() implements BaseParser {
  @override
  final String baseUrl = 'https://example.com';

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _FakeApi() implements BaseApi {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
