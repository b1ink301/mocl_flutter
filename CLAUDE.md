# CLAUDE.md — mocl_flutter

코드를 생성/수정할 때 **반드시** 지킬 규칙. 상세 배경은 [README.md](README.md) 참고.

## 도구 (FVM 필수)

- 모든 `flutter` / `dart` 명령은 `fvm` 접두사 사용: `fvm flutter ...`, `fvm dart ...`
- 코드 생성: `fvm dart run build_runner build --delete-conflicting-outputs`
- 시스템 Flutter(비 FVM)는 Dart 버전이 낮아 `pub get` 이 실패할 수 있음 → 항상 `fvm` 사용

## 상태관리: Mixin Class 패턴 (필수)

Riverpod Provider 는 **mixin class 를 통해서만** 접근한다.

- **Event mixin** (`presentation/state/{feature}_event_mixin.dart`): `ref.read()` 로 상태 변경
- **State mixin** (`presentation/state/{feature}_state_mixin.dart`): `ref.watch()` 로 상태 조회
- **위젯/뷰**: Provider 를 직접 import 하지 말고 mixin 을 `with` 로 합성해서 사용

## Import 규칙 (엄수)

위젯/뷰에서 `application/` provider 파일을 **직접 import 금지**.

| 파일 위치 | `application/` import |
|-----------|----------------------|
| `presentation/state/*.dart` (mixin) | ✅ 허용 |
| `presentation/*.dart` (view) | ❌ 금지 |
| `presentation/widgets/*.dart` | ❌ 금지 |

- **예외**: `core/application/` 는 공통 mixin(`AppFontState` 등)이라 허용.
- Provider 접근이 새로 필요하면 → 해당 feature 의 `state/` mixin 에 메서드를 추가하고,
  위젯은 그 mixin 을 통해 호출한다. (위젯에서 provider 를 import 하는 방식으로 해결하지 말 것)
- 커밋 전 검증(사전 커밋 훅에서도 자동 실행):
  ```bash
  fvm dart run tool/check_provider_imports.dart
  ```

## 로깅 (MoclLogger 경유 필수)

`print()` / `debugPrint()` / `dart:developer` 의 `log()` 를 **직접 쓰지 말 것.**
셋 다 릴리즈 빌드에서 제거되지 않아 사용자 단말 logcat 에 그대로 남는다.

```dart
import 'package:mocl_shared/util/mocl_logger.dart';

MoclLogger.d(() => '[getList] $url response = ${response.statusCode}'); // 디버그 전용
MoclLogger.w(() => '웹뷰 폴백');                                          // 경고
MoclLogger.e('DB 업로드 실패', error: e, stackTrace: st);                  // 릴리즈에서도 Crashlytics 로 전송
```

- `d` / `i` / `w` 는 메시지를 **클로저로** 받는다. `kDebugMode` 가 컴파일 타임 상수라
  릴리즈에서는 본문과 클로저가 함께 제거되어 문자열 보간 비용조차 없다.
- `e` 만 릴리즈에서도 `MoclLogger.onError`(= Crashlytics) 로 전달된다. 콘솔 출력은 하지 않는다.
- 헤더는 반드시 `MoclLogger.redactHeaders(headers)` 로 마스킹한다. 쿠키/토큰 직접 보간 금지.
- 커밋 전 검증(사전 커밋 훅에서도 자동 실행):
  ```bash
  fvm dart run tool/check_logging.dart
  ```

## 아키텍처

- Clean Architecture: `domain → data → application → presentation`
- 사이트 파서는 워커 isolate(`ParserIsolateClient`)에서 실행 — 메인 isolate 차단 금지
- 네트워크: dio, connect/receive/send timeout 모두 15초 통일

## 공유 패키지 (`packages/mocl_shared`) · 서버 (`server/`)

- 엔티티(`ListItem` · `Details` · `MainItem` …), `Failure`, `MoclLogger`, 사이트 파서(`*_parser.dart`),
  원격 설정 계약(`RemoteConfig`)은 `packages/mocl_shared` 에 있다. 앱과 서버가 같이 쓰므로
  **Flutter 를 import 하지 말 것**(서버는 순수 Dart VM). 위젯용 확장(`ValueKey` 등)은 앱 쪽에 둔다.
- 사이트 HTTP(`*_api.dart`, 쿠키 · 웹뷰 의존)는 앱의 `features/html_parser/data/datasources/{site}/` 에 남는다.
- 앱의 `core/error/failures.dart` 는 공유 실패 + 앱 전용 실패(`main_failures`)를 함께 내보내는 입구다.
- 패키지 코드 생성 · 테스트는 패키지 폴더에서:
  ```bash
  cd packages/mocl_shared && fvm dart run build_runner build --delete-conflicting-outputs && fvm dart test
  ```
  파서 테스트 · 픽스처는 `packages/mocl_shared/test/` 에 있다(순수 Dart 로 돈다).
- 서버는 `server/`(shelf, Docker + Caddy, arm64 클라우드 VM). 사용법 · 배포는 [server/README.md](server/README.md).
- 사이트 카나리(`server/bin/canary.dart`, GitHub Actions `Site canary` 매일): 실제 사이트에서 목록 · 상세
  (`--search` 는 게시판 검색)를 받아 파서가 아직 읽는지 본다. 파서를 고치면 `cd server && fvm dart run bin/canary.dart {site}` 로 확인한다.
  사이트를 넣고 빼거나 기본 게시판을 바꾸면 `canaryTargets` 도 같이 고친다.
  서버 로그는 `print` 가 아니라 `serverLog`(운영에서도 남음) 또는 `MoclLogger`(개발 실행에서만).
  `pub workspace` 로 묶지 않는다 — 서버 Docker 빌드가 Flutter SDK 없이 의존성을 풀어야 한다.

## 원격 설정 (`features/remote_config/`)

- 서버 `GET /v1/config`(ETag) 로 앱 업데이트 없이 바꿀 값을 받는다. 사이트 요청 UA
  (`userAgents` 프리셋 덮어쓰기 · `sites.{site}.userAgent`)와 광고(`ads`, `AdsRemoteConfig`)가 있다.
  형식은 `RemoteConfig`. 키워드 알림 기한(`alerts.ttlDays`) · 알림 게시판(`alerts.boards`)도 여기 있다(서버 크롤러는 저장 즉시 따른다).
- 부팅 때 저장된 설정만 동기로 읽어 `remoteConfigProvider` 를 덮어쓰고, 서버 요청은 첫 프레임 2초 뒤.
  **새 설정은 다음 실행부터** 적용된다(실행 중 UA 를 바꾸면 만든 클라이언트 · 쿠키와 어긋난다).
- 운영 중 설정 편집은 서버 관리 화면(`/admin`, `server/lib/src/admin/`)으로 한다. 토큰(`ADMIN_TOKEN`)은
  헤더로만 받고 쿠키를 쓰지 않는다. 설정 항목을 늘리면 관리 화면 폼(`admin_page.dart`)도 같이 고친다
  (폼이 모르는 항목은 JSON 편집으로만 바뀐다). 검사 규칙은 `RemoteConfig.validate` 하나를 쓴다.
- 서버 주소는 `MOCL_API_BASE_URL` define(`ads.json` 같은 define 파일에 넣는다). 비면 요청하지 않는다.
  공개 저장소라 서버 주소 · ssh 호스트 · 인스턴스 정보는 소스 · 문서에 적지 않는다(`$MOCL_DOMAIN`, `<서버>` 로 쓴다).
- 서버가 없거나 실패해도 앱은 그대로여야 한다. 서버 쪽 실패(5xx · 오프라인 · 모르는 schemaVersion)는
  `MoclLogger.w` 로만 남기고 Crashlytics 로 올리지 않는다.
- 사이트 API 클라이언트는 UA 상수를 직접 쓰지 말고 `network_provider.dart` 의 `_userAgent(ref, site, preset)` 를 거친다.
- 앱은 모르는 항목을 건너뛰고(느슨), 서버는 설정 파일을 엄격하게 검사한다. 호환이 깨지는 변경만
  `RemoteConfig.schemaVersion` 을 올린다(옛 앱은 그 설정을 버리고 기본값을 쓴다).

## 키워드 알림 (`features/keyword_alerts/` · `server/lib/src/alerts/`)

- 사용자가 담은 게시판에 키워드를 걸면 서버가 그 게시판 1쪽을 3분마다 받아, 새 글 제목에 키워드가
  있으면 FCM 으로 보낸다. 계약(`AlertSubscription` · `AlertRegistration` · 지원 사이트 ·
  키워드 매칭 `KeywordAlerts.matchedKeywords`)은 `mocl_shared/alerts/keyword_alerts.dart` 하나에 둔다.
- 알림은 **허용 게시판에서만** 건다: 원격 설정 `alerts.boards`(사이트 → 게시판 id → 이름, 관리 화면
  "키워드 알림 게시판" 에서 편집), 없으면 `KeywordAlerts.defaultBoards`(클리앙 모두의공원 · 회원중고장터, 다모앙 자유게시판),
  빈 객체면 없음. 판정은 `AlertsRemoteConfig.isAlertBoard` 하나로 — 목록 앱바 종 · 게시판 고르기 시트 · 동기화(허용 밖은 안 올림) ·
  서버 등록(`limited(allow:)`, 허용 밖은 거절하지 않고 뺀다 — 옛 앱 호환) · 크롤러가 모두 이걸 쓴다.
  허용 목록에서 빠진 구독은 앱에서 지우지 않고 "알림을 받지 않는 게시판" 으로 보이며 한도(3개)에 세지 않는다.
  게시판을 늘리면 서버 크롤 양도 는다 — 사용자 게시판을 통째로 받던 방식(사이트당 60개 상한에서 조용히 누락)으로 되돌리지 말 것.
- 지원 사이트(`KeywordAlerts.sites`, 허용 게시판을 고를 수 있는 사이트)는 **서버 IP 에서 실제로 받아 본 결과**다(`server/bin/probe.dart`).
  아카라이브 · 인스티즈 · 더쿠 · 루리웹은 오라클 IP 를 막고, 네이버카페 · 레딧은 로그인이 필요해 뺐다.
  뽐뿌는 목록이 막혀 RSS(`rss.php?id=`)로 받는다. 사이트를 넣고 빼기 전에 probe 를 서버에서 돌려 볼 것.
- 앱이 원본이다: 구독은 SharedPreferences 에 두고, 바뀔 때마다 `PUT /v1/alerts/{installId}` 로 통째로 올린다
  (`KeywordAlertSync`, 같으면 안 보냄, 비면 DELETE). 실행할 때와 FCM 토큰이 바뀔 때도 다시 맞춘다.
  `installId` 는 앱이 만든 무작위 값이고 곧 등록을 고칠 권한이다(로그에 남기지 말 것).
- 들어가는 곳: 설정 → 키워드 알림(관리), 목록 앱바의 종 버튼(그 게시판, 지원 게시판에서만 보임 ·
  걸려 있으면 채운 종). 켜기 · 고치기 · 끄기 흐름은 `KeywordAlertFlow`(권한 · 서버 반영 · 스낵바) 하나로 모은다.
- 알림 data 의 `url` 을 `SiteLinkResolver` 로 열어 상세로 간다(`KeywordAlertGate`, `AppUpdateGate` 안쪽).
  앱이 앞에 있으면 시스템이 띄우지 않으므로 스낵바로 보여 준다.
- 받은 알림은 **기기에만** 쌓는다(알림함, `KeywordAlertInbox` · `KeywordAlertInboxPage`).
  서버는 보낸 기록을 두지 않는다. 같은 글(`site:url`)은 한 번만, 최신순 100개 · 14일.
  들어가는 곳은 `KeywordAlertInboxButton`(받은편지함 아이콘 + 안 읽은 수 배지): 홈 게시판 탭 앱바
  (`onlyWhenInUse` — 알림을 걸었거나 받은 알림이 있을 때만) · 키워드 알림 화면 앱바, 그리고 설정 "받은 알림" 줄.
  목록 앱바의 종(그 게시판에 알림 걸기)과 헷갈리니 종 아이콘을 쓰지 말 것.
  모으는 곳은 세 군데: 앞에 있을 때(`onForeground`), 눌러서 들어올 때(`onTap` · `initialTap`, 읽음으로),
  뒤에 있거나 꺼져 있을 때(`keywordAlertBackgroundHandler`, `main.dart` 에서 Firebase 초기화 뒤 등록).
  백그라운드 핸들러는 다른 isolate 라 저장은 `SharedPreferencesAsync`(캐시 없음)로 한다 — sembast 나
  레거시 `SharedPreferences` 로 바꾸지 말 것. 앱 복귀 때 `KeywordAlertGate` 가 다시 읽는다.
  iOS 는 `content-available` 없이 백그라운드 핸들러가 돌지 않아, 뒤에 있을 때 온 알림은 눌렀을 때만 남는다(감수).
- 알림에는 기한이 있다(원격 설정 `alerts.ttlDays`, 기본 3일, 0 = 기한 없음, 관리 화면 "키워드 알림 기한").
  구독의 `startedAt`(걸거나 고치거나 연장한 시각)부터 세고, 서버 크롤러가 지난 구독을 건너뛴다
  (`KeywordAlerts.isExpired`). `startedAt` 이 없거나(옛 앱) 서버가 받은 시각보다 앞서면 등록 시각으로 센다.
  앱은 키워드 저장 · "연장" · "다시 켜기" 때 `startedAt` 을 지금으로 바꾸고(`KeywordAlertsNotifier.upsert`),
  남은 기간은 `KeywordAlertExpiry` 로 보여 준다. 기한이 끝난 게시판은 크롤하지 않고 상태도 지운다(다시 켜면 첫 크롤부터).
- 한도: 기기당 게시판 3개 · 게시판당 키워드 5개(`KeywordAlerts.maxBoards` · `maxKeywordsPerBoard`, 앱이 막는다).
  서버는 옛 앱(한도 10)을 위해 10개까지 받고(`acceptBoards` · `acceptKeywordsPerBoard`) `AlertRegistration.limited()`
  로 앞에서부터 한도만큼만 저장 · 크롤한다. 한도를 바꿀 때 accept 값은 줄이지 말 것(옛 앱 등록이 통째로 거절된다).
- 서버 크롤러(`AlertCrawler`)는 서버 사양을 늘리지 않고 버티게 짰다:
  사이트끼리는 동시에 · 한 사이트 안은 1.5초 간격으로 차례로 받고, 사이트마다 게시판 60개(`maxBoardsPerSite`,
  구독자 많은 순)까지만 본다(넘는 수는 `/healthz/crawl` 의 `skippedBoards`). 알림은 기기마다 차례로, 기기끼리
  16대(`pushConcurrency`)까지 동시에 보낸다. 구독이 모두 기한을 넘기고 7일(`staleGrace`) 지난 기기 등록은 지운다
  (`AlertStore.maxDevices` 자리를 비운다).
- 서버는 사용자가 준 게시판 URL 을 요청하므로 호스트를 `KeywordAlerts.isAllowedBoardUrl` 로 제한한다(SSRF).
  새 기기 · 바뀐 FCM 토큰은 FCM `validate_only` 로 확인해 무효면 `400 invalid_token`(FCM 이 답하지 않으면 통과).
  알림 API 는 IP 당 분당 30회, 이슈 API(`/v1/issues`)는 120회.
  게시판 첫 크롤은 지금 글을 "본 것" 으로만 기록한다(옛 글로 알림 폭탄 방지). 실패하면 간격을 늘린다.
- Android: 채널 `keyword_alerts` 는 `MainActivity` 가 만들고 매니페스트가 FCM 기본 채널 · 아이콘으로 지정한다.
  iOS 는 Xcode 에서 Push Notifications · Background Modes(remote notification) 와 Firebase 콘솔 APNs 키가 있어야 온다.
- 서버 발송 키는 `server/secrets/firebase-service-account.json`(gitignore). 없으면 dry-run(로그만).

## 이슈 레이더 (`features/issue_radar/` · `server/lib/src/radar/`)

- 서버가 정해 둔 게시판(`radarBoards`, 베스트 위주 · 자유게시판은 가중치 낮게)을 5분마다 받아
  48시간 쌓고(`radar.db`), 제목이 비슷한 글을 묶어 **2개 이상 커뮤니티**(또는 한 곳 3글 이상)에 걸친
  묶음을 이슈로 보여 준다. 계약은 `mocl_shared/radar/issue_feed.dart`(`IssueFeed`, 앱은 모르는 사이트를 건너뜀).
- 글 시각은 사이트 값(형식이 제각각)이 아니라 **서버가 처음 본 시각**. 반응(댓글 · 추천 · 조회)은 사이트마다
  주는 게 달라 같은 사이트 안 순위로만 쓴다.
- 묶기(`Clusterer`): 단어 · 이웃 단어 쌍 · 한글 2-gram 의 TF-IDF 코사인. 코사인 ≥ 0.45 이거나, ≥ 0.2 이면서
  단어 쌍 또는 단어 2개 이상을 공유할 때만 묶는다(단어 하나만 겹치는 오탐 방지).
  증분 방식이라 순서 탓에 갈린 묶음은 다 넣은 뒤 중심끼리 다시 비교해 합친다(약한 기준 0.3, 앞 묶음이 받아 id 유지).
- 점수(`RadarRanker`): 글 점수(게시판 가중치 × 신선도 × (1 + 반응 백분위와 **반응 속도** 백분위의 섞음))를
  사이트별로 순번 감쇠(i번째 글 ÷ √i)해 더하고, **새로움**(묶음 핵심 말이 이슈 시작 전 48시간 기록에 하루 몇 번
  나왔나)으로 보정한다. 늘 나오는 말뿐인 수다("내일 코스피")는 내려가고 처음 나온 말("서킷브레이커")은 남는다.
  이슈 전 기록이 6시간 안 되면 새로움을 보지 않는다.
  규칙을 바꾸면 `server/bin/radar_eval.dart` 로 **실제 쌓인 데이터**에 돌려 보고(`--rank` 는 옛 방식과 상위 이슈 비교)
  골든 테스트(`radar_rank_test`)를 고친다.
- 급상승은 데이터가 1시간 쌓이기 전(서버 재시작 직후)에는 표시하지 않는다.
- 앱: 홈 하단 탭 "지금 이슈"(`IssueRadarPage`) → 이슈 상세(커뮤니티별 글) → `SiteLinkResolver` 로 앱 상세.
- 홈 셸(`MainPage`)은 떠 있는 알약형 탭바(`FloatingPillTabBar`)로 **게시판 · 지금 이슈 · 보관함 · 설정**을 오간다
  (`MainTab`, 서버가 없는 빌드는 이슈 탭을 뺀다). 사이트는 왼쪽 **사이트 드로어**(`SiteDrawer`, `site_drawer`)에서 바꾼다:
  게시판 탭 앱바 왼쪽 메뉴 버튼(`MenuLinesIcon`, `main_drawer`)을 누르거나(`openSiteDrawer`) 본문을 오른쪽으로 끌면
  (화면 왼쪽 절반, `drawerEdgeDragWidth`) 손가락을 따라 열린다. 끌어 열기는 게시판 탭 · 편집 · 검색 중이 아닐 때만.
  큰 제목은 누르지 않는다(`▾` 를 붙여 제목으로 열면 드로어가 있는 줄 모르고, 제자리 펼침처럼 보여 어긋났다).
  드로어에는 **사이트 칩 · 게시판 추가만** 둔다 — 스크랩 · 설정 · 지금 이슈를 넣으면 탭과 이동 경로가 두 갈래가 된다.
  하단 시트로 되돌리지 말 것(엄지로 끌어 바꾸는 동작이 사라진다). 탭은 `IndexedStack` 으로 살려 두고(스크롤 · 상태 유지,
  앱을 켜면 이슈를 바로 받는다), 탭마다 `ScrollController` 를 따로 `PrimaryScrollController` 로 준다
  (하나를 같이 쓰면 컨트롤러에 스크롤뷰가 여럿 붙는다). 보고 있는 탭을 다시 누르면 맨 위로.
  모든 탭이 같은 큰 제목 앱바(`MainAppBar` · `LargeTitleSliverAppBar`)라 탭을 오가도 제목 자리가 같다.
  탭바는 `Flexible` 로 화면 폭에 묶여 있어 좁은 화면 · 큰 글자에서 넘치지 않고 `FittedBox` 로 줄어든다(빼지 말 것).
  본문은 바 뒤까지 확장(`extendBody`)하니 목록 아래 여백은 `MediaQuery.padding.bottom` 으로 준다.
  뒤로가기는 사이트 드로어 → 검색 → 다른 탭이면 게시판 탭 순.
  메인 위 이슈 카드 · 고정 머리는 게시판 목록을 밀어내 걷어냈다(되살리지 말 것).
  안 본 위쪽 이슈가 있으면 탭 아이콘에 점(`hasUnreadTopIssues`). 앱 복귀 때 이슈가 10분 넘었으면 다시 받는다.
- 빈 화면 · 오류 화면은 한 모양으로 그린다: 빈 목록은 `MessageView`(아이콘 · 제목 · 설명 · 주/보조 버튼),
  오류는 `FailureView`(같은 `MessageView` 로 그림). 스크롤뷰 안에서는 `SliverMessageView` 로 감싼다
  (떠 있는 탭바만큼 올려 보이는 영역 가운데에 둔다). 글자 크기 설정을 따르도록 제목 · 설명 스타일을 넘긴다.
  차단(뮤트) 제목 키워드로 글을 거른다(`filterMuted`). 본 이슈는 흐리게(`IssueReadStore`).

## 보관함 · 최근 본 글 (`features/library/` · `features/history/`)

- 홈 "보관함" 탭(`LibraryPage`, id 는 옛 `tab_bookmarks`)은 큰 제목 아래 `스크랩 | 히스토리` 칸 전환
  (`LibrarySegmentControl`, `library_bookmarks` · `library_history`, 큰 제목과 같은 좌우 여백으로 폭을 채움)으로 `BookmarksPage` · `HistoryPage` 를 오간다.
  고른 칸은 SharedPreferences(`library_segment`)에 남는다. 두 목록을 `IndexedStack` 으로 함께 살리지 말 것 —
  홈이 탭마다 준 `PrimaryScrollController` 하나에 스크롤뷰가 둘 붙는다.
  탭을 늘려 따로 빼지 말 것: 5탭이면 360dp 폰에서 탭바가 넘친다(`floating_pill_tab_bar_test`).
- 최근 본 글: 상세를 받은 뒤 `DetailsNotifier` 가
  `HistoryNotifier.record` 를 기다리지 않고 부른다(실패는 `MoclLogger.e`, 상세는 그대로).
- 스크랩과 같은 엔티티 `PostSnapshot`(옛 `BookmarkData`)을 쓴다. `savedAt` 은 그 스토어에 넣은 시각
  (스크랩한 때 · 마지막으로 본 때). 저장된 JSON 과 맞물리니 필드 이름을 바꾸지 말 것.
- 저장은 전역 `history` 스토어, 키 `{site}:{id}`(`PostSnapshot.key`)로 덮어써 맨 앞으로 올린다.
  같은 내용을 1분 안에 다시 쓰지 않는다(sembast 는 쓸 때마다 줄이 는다). 읽음 기록(`{site}_read`)과는
  따로다 — 히스토리를 지워도 읽음 표시는 남는다.
- 링크 · 알림으로 연 글은 목록 항목이 비어 있어 제목 · 작성자를 상세 값으로 채운다(`PostSnapshot.fromDetails`,
  번역문이 아니라 원문 `Details` 를 넘긴다).
- 30일 · 300개(`LocalDatabase.kHistoryTtl` · `kMaxHistory`), 읽음 기록 정리(`pruneReadsIfDue`)에서 같이 지운다.
- 스크랩 폴더 · 메모: 한 글을 여러 폴더에 넣는 태그 방식(`PostSnapshot.folders` = 폴더 id 목록, `memo`).
  두 필드는 `@Default` 라 옛 JSON 도 읽히고, 폴더 목록은 새 스토어 `bookmark_folders`(`BookmarkFolder`, 만든 순)라
  DB 버전은 올리지 않았다. 폴더를 지우면 모든 스크랩에서 그 id 만 뺀다(글은 남음, `deleteBookmarkFolder` 한 트랜잭션).
  폴더 색은 말머리 태그 색(`CategoryTone` 순번). 한도: 폴더 20개 · 이름 20자 · 메모 200자.
- 스크랩 목록(`BookmarksPage`): 칸 전환 아래 폴더 칩(`전체 · 폴더… · ＋`, 선택은 잉크색 채움 · 고른 폴더는 앱이 떠 있는 동안 유지).
  거르기는 `BookmarkFilter` 하나로(제목 · 메모 · 사이트 · 게시판, 띄어 쓴 말은 모두 포함, 히스토리 검색도 같이 쓴다).
- 보관함 검색은 게시판 탭처럼 **앱바에서** 한다(`LargeTitleSliverAppBar(search: AppBarSearch)`, `library_search` →
  툴바 제목 자리가 입력창, 닫기만 남음). 검색어는 `LibrarySearch`(null = 닫힘) 하나를 스크랩 · 히스토리가 같이 쓰고,
  칸 전환의 숫자는 검색어에 맞는 글 수다. 탭을 바꾸면 닫히고(`MainEvent.selectTab`), 뒤로가기는 검색을 먼저 닫는다.
  검색창을 목록 위 한 줄로 되돌리지 말 것(칸 전환 · 검색 · 칩 세 줄이 쌓여 글이 밀린다).
- 칸 전환(`LibrarySegmentControl`)은 회색 트랙 + 흰 손잡이(그림자)로 그리고 **강조색을 쓰지 않는다** —
  폴더 칩 · 탭바 선택과 같은 색이면 어느 쪽이 위 단계인지 헷갈린다.
  행 길게 누르기 = 폴더 · 메모 고치기 · 공유 · 지우기, 칩 길게 누르기 = 폴더 고치기 · 지우기. 흐름은 `BookmarkFlow` 에 모은다.
- 상세의 스크랩 버튼으로 켜면(`BookmarkFlow.afterBookmarked`) 폴더가 있을 때만 폴더 · 메모 시트를 띄우고,
  없으면 "스크랩했어요" 스낵바에 "폴더 · 메모" 버튼만 둔다(폴더를 안 쓰는 사람은 한 번에 끝).

## 강조색 (`config/accent_palette.dart` · `core/application/accent_provider.dart`)

- 설정 → 강조색(`AccentPage`, `Routes.accent`): 기본(코랄) · 사이트 색 · 직접 고르기(7색). **강조색만** 바꾸고 종이 배경 ·
  글자 · 구분선은 그대로 둔다. 설정은 동기 SharedPreferences(`accent_mode` · `accent_custom`)라 첫 프레임부터 그 색이다.
- 테마는 `MoclTheme.light(accent)` · `dark(accent)`(색마다 캐시). 시드도 강조색으로 만든다 — primary 만 덮으면
  secondary 등 다른 역할에 코랄이 남는다. `MoclTheme.lightTheme` 는 코랄 기본값(테스트용).
- 사이트 색은 브랜드색(`AccentPalette.brandOf`, 로고 에셋 · `theme-color`)에서 **색상은 두고 밝기만** 당겨 만든다
  (`derive`: 라이트는 코랄만큼 읽히고 잉크와 구분되는 밝기, 다크는 어두운 배경 대비 4.5 이상). 색을 바꾸려면 기준값만
  고친다. `accent_palette_test` 가 모든 사이트 · 팔레트 색의 대비를 지킨다. 뽐뿌 · 아카라이브 · 다모앙은 잠정값.
- 전역 강조색(`appAccentProvider`)은 사이트 색 모드에서 드로어에서 고른 사이트 색. 목록 · 검색 · 상세는
  `SiteAccentTheme`(지역 `Theme`)으로 **그 화면의 사이트 색**을 덮는다(이슈 · 보관함 · 링크로 연 다른 사이트 글).
  `DetailPage.init(siteType:)` 이 있을 때만 덮는다(없으면 전역 사이트 글).
- 목록 배지 색은 글자 스타일 provider(코랄 고정)가 아니라 화면 테마에서 온다 — 배지를 그리는 곳에서
  `styles.withAccent(Theme.of(context).colorScheme.primary)`(목록 · 검색 · 광고 모양). 새 배지를 그릴 때도 같이 한다.
- 광고 배지 · 버튼도 화면 강조색을 따른다. 다른 사이트 글로 건너가면 미리 받아 둔 상세 광고 1개는 모양이 달라 버려진다(감수).
- 보관함(스크랩 · 히스토리)에서 글을 열 때 전역 사이트를 바꾸지 않는다(`PostSnapshot.siteLink` 로 상세에 사이트를 넘김).
  바꾸면 게시판 탭과 강조색까지 따라 바뀐다.
- 드로어 사이트 칩은 사이트 색 모드에서만 색 점을 찍는다. 삭제(밀어서 지우기 등)는 빨강(`Colors.red` · `error`) 그대로.

## 동영상 플레이어 (`features/media_player/`)

- 본문 링크(유튜브 · mp4/m3u8)와 본문 `<video>` 는 앱 플레이어로 연다(설정 "앱에서 동영상 재생" 이 꺼지면
  유튜브 앱 · 브라우저). 플레이어는 **라우트가 아니라** `MaterialApp.router` builder 의 `MediaPlayerHost`
  (라우터 위 한 층)에 있어서 게시판을 오가도 재생이 이어진다. 상태는 `MediaPlayerNotifier`(`MediaSession`, 동시에 하나).
- 펼침(화면 전체) ↔ 미니(떠 있는 작은 창, 끌어 옮김 · 두 손가락으로 크기 · 아래로 던지면 닫힘)는 **같은 위젯의 크기 · 위치만** 바꾼다.
  `_PlayerLayer` 의 자식 순서 · 종류를 모드마다 바꾸지 말 것 — 웹뷰 · ExoPlayer 가 다시 만들어져 재생이 끊긴다.
- 펼친 동안은 Navigator 에 보이지 않는 라우트(`_GuardRoute`)를 얹어, 뒤로가기 버튼 · 시스템 제스처가 아래 화면을
  닫지 않고 이 라우트를 닫게 한다(닫히면 미니로). 라우터 위라 Navigator 가 없으므로 chewie 의 전체화면 · 옵션 메뉴는 끈다.
- 미니 크기는 두 손가락으로 바꾸고 폭(dp)을 기억한다(`MiniPlayerSizeStore`, 140~640dp, 화면에 들어가게 줄임).
  미니 터치 층은 scale 제스처 하나로 끌기 · 크기를 함께 받는다(pan 과 같이 쓸 수 없다).
- 소리: 펼친 화면 위쪽 바의 음소거 버튼 · 음량 슬라이더(0~100%, 3초 안 만지면 닫힘). 기기 볼륨이 아니라 **플레이어 볼륨**
  (유튜브 IFrame `setVolume`/`mute`, 파일 `VideoPlayerController.setVolume`). 볼륨은 저장(`PlayerVolumeStore`),
  음소거는 앱이 떠 있는 동안만. 플레이어는 `MediaPlayback.audio` 를 듣고 적용한다. chewie 음소거 버튼은 끈다(값이 어긋난다).
- "가로로 보기" 는 `OrientationPolicy.setLandscapeOverride`(켜진 동안 창 크기 정책을 건너뜀). 접기 · 닫기 때 끈다.
- 본문 `<video>` 는 본문 안에서 재생하지 않고 포스터(`_BodyVideoPoster`)만 그린다(여러 개가 동시에 ExoPlayer 를 만들어 힙이 터지던 문제).
- 유튜브 웹뷰는 `useHybridComposition: false`(텍스처 방식). Hybrid Composition 은 웹뷰가 떠 있는 동안 앱 전체
  래스터를 Android 메인 스레드에 묶어, 미니 창을 띄운 채 목록 스크롤 · 상세 진입까지 끊긴다(true 로 되돌리지 말 것).
- 시스템 PiP · 백그라운드 재생은 하지 않는다. Flutter 스크린샷엔 웹뷰가 안 찍히니 기기 확인은 `adb exec-out screencap`.

## 게시판 글 검색 (`list_page` · `ListSearchPage`)

- 목록 앱바의 검색 버튼 → `Routes.search`(`ListSearchPage`, `SwipeBackPage`, 넓은 화면은 `ListDetailLayout`).
  `showSearch`(SearchDelegate)로 되돌리지 말 것 — 루트 Navigator 에 떠서 결과 행이 쓰는 `ListStyleScope` 가 없다.
- 사이트 지원은 `BaseParser.supportsSearch`(기본 false)로 정하고, 끈 사이트는 검색 버튼을 숨긴다.
  지금 끈 곳: 긱뉴스(검색 없음) · 네이버카페(별도 API) · 보배드림(모바일 게시판 검색이 검색어를 무시).
- 검색 URL 은 `parser.searchListUrl(...)` 로 만든다. 검색어를 쿼리 인코딩해 `urlBySearchList` 에 넘기므로
  `urlBySearchList` 는 받은 값을 그대로 쿼리에 넣는다(직접 부르지 말 것). 첫 쪽은 `firstSearchPage`(클리앙 0, 그 외 1).
- 결과 페이지는 목록 파서(`list`)로 읽는다. 사이트가 로그인해야 검색되면(다모앙 · 인스티즈) 빈 목록 대신
  `NotLoginFailure` 를 돌려줘 화면이 "로그인" 버튼을 보이게 한다.
- 입력 중에는 요청하지 않고 제출할 때만 받는다(`SearchQuery`). 쪽은 받은 글 id 로 중복을 거르고 새 글이 없으면 끝.
  최근 검색어는 게시판마다 10개(`SearchHistoryStore`). 결과 제목의 검색어는 `SearchHighlightScope` 로 강조한다.
- 검색 주소 · 파서를 고치면 `cd server && fvm dart run bin/canary.dart --search {site}` 로 실제 사이트를 확인한다
  (CI 카나리도 매일 검색 단계를 돈다). URL 규칙 테스트는 `packages/mocl_shared/test/parsers/search_test.dart`.

## 앱 밖에서 들어오기 (`features/app_entry/`)

- `AppEntryGate`(`KeywordAlertGate` 안쪽)가 두 길을 받는다. 상세 열기는 `SiteLinkResolver`, 탭 고르기는
  `MainEvent.selectMainTab`(탭 순서는 `MainTab.visible` 하나 — 인덱스를 직접 세지 말 것).
- **공유 받기(Android만)**: 매니페스트 `SEND text/plain` → `ShareChannel.kt` ↔ `SharedTextChannel`
  (`net.b1ink.mocl/share`). 꺼져 있다 켜진 공유는 `takeInitial`(한 번만), 떠 있을 때는 `onShared`.
  글자에서 첫 주소를 `SharedText.firstUrl` 로 꺼내고, 지원하지 않는 주소는 스낵바(브라우저로 열기).
  iOS 는 공유 확장(별도 타깃)이 필요해 하지 않았다.
- **앱 바로가기**(`quick_actions`, Android · iOS): `AppShortcut`(지금 이슈 · 스크랩 · 최근 본 글).
  `type` 은 OS 에 등록되는 값이라 바꾸지 말 것. Android 아이콘은 `res/drawable/ic_shortcut_*.xml` 이고
  이름 문자열로 찾으므로 `res/raw/keep_shortcuts.xml` 이 리소스 축소에서 지킨다. iOS 는 아이콘 없음.
- 기기 확인: `adb shell am start -a android.intent.action.SEND -t text/plain --es android.intent.extra.TEXT '<글 주소>' -n <앱 id>/net.b1ink.mocl_flutter.MainActivity`,
  바로가기는 `-a android.intent.action.RUN --es 'some unique action key' history`.

## 목록 · 상세 스크롤 성능

- 측정은 profile 빌드로 한다(debug 는 근거가 못 된다). 프레임이 밀리면 빌드(`buildDuration`) · 래스터 ·
  **vsync 대기**(`vsyncOverhead`, UI 스레드가 다른 일로 막힘) 중 어디인지 `addTimingsCallback` 으로 먼저 가른다.
  Android 는 플랫폼 스레드와 UI 스레드가 하나라, 플러그인 SDK 의 메인 스레드 작업이 그대로 프레임을 민다.
- 목록은 끝에서 10개 남았을 때 다음 쪽을 받는다(`invisibleItemsThreshold`). 기본 3 이면 빠르게 넘길 때
  응답보다 먼저 끝에 닿아 멈췄다가, 붙는 순간 빈 화면만큼의 행을 한 프레임에 그린다.
  쪽이 붙을 때 이미 그려진 행(`MoclListItem`)은 리빌드되지 않는다(`list_screen_rebuild_test`).
- 목록 밀도(설정 "목록 밀도", `ListDensity` · `list_density`): 기본 · 컴팩트. 컴팩트는 제목 한 줄 + 배지를 제목 옆으로,
  닉 이미지 없이 여백을 줄인다(`_CompactRow`). 여백은 화면 세로 길이로 정한다(`compactSpacingFor`: 700dp 이하 9 · 3 →
  900dp 이상 13 · 4) — 세로로 긴 화면에서 행이 너무 빽빽해지지 않게. 픽셀 밀도는 dp 로 이미 보정돼 보지 않는다. 값은 `ListStyleScope.compact` 로 내려 스크롤 중엔 비용이 없고,
  행은 `const MoclListItem` 그대로(`list_screen_rebuild_test` 의 컴팩트 케이스가 지킨다). 컴팩트는 한 화면에 행이 1.4배라
  다음 쪽을 끝에서 15개 남았을 때 받는다. 목록 광고도 같은 값(`ListAdStyle.from(compact:)` → `paddingVertical` ·
  `rowGap` 옵션 ↔ `ListNativeAdFactory.kt`, 옵션이 없으면 상수 14 · 8). 카드형 · 썸네일은 넣지 않았다(목록 데이터에 썸네일
  주소가 없고, 넘기는 중 이미지 디코딩이 프레임을 민다).
- 댓글은 글자와 `<br>` 뿐이면 HTML 위젯 없이 `Text` 로 그린다(`plainTextOfSimpleHtml` · `_CommentBody`).
  HTML 위젯은 짧은 HTML 을 UI 스레드에서 바로 파싱하고 화면 밖으로 나가면 버린다. 받아들이는 범위를 넓히면
  `test/core/simple_html_text_test.dart`(두 경로의 글자 · 크기 비교)에 샘플을 더한다.
- 테두리 없이 줄마다 칸이 하나뿐인 표(글을 감싼 자리 잡기용)는 `display: block` 으로 푼다(`_isLayoutTable`).
  fwfh 표는 칸마다 레이아웃을 두세 번 한다. 칸이 여럿이거나 테두리를 준 표는 그대로 표로 그린다.
- 본문 이미지의 비율을 알아내는 로드도 `ScrollAwareImageProvider` 로 감싼다. `provider.resolve` 를 직접 부르면
  빠르게 넘기는 중에도 내려받기 · 디코딩이 시작돼 `Image` 위젯의 지연 로드가 소용없어진다.

## 부팅 (`main.dart`)

- 초기화는 `_prepareApp()` 안에서만 한다. `BootGuard` 가 감싸서, 던지면 실패 화면 +
  재시도, 10초 안에 안 끝나면 지연 화면을 띄운다. `runApp` 앞에서 그냥 `await` 하는
  코드를 `main()` 에 추가하지 말 것 — 실패 시 스플래시에서 영원히 멈춘다.
- `PlatformDispatcher.onError` 에서 `true` 를 고정으로 돌려주지 말 것(디버그 콘솔까지
  사라져 원인이 숨는다). 무거운 작업(DB 정리 등)은 첫 프레임 뒤로 미룬다.

## 큰 화면 (폴드 · 태블릿 · iPad)

- 창 크기는 `WindowSize`(`core/presentation/widgets/window_size.dart`, 600 / 840 / 1200dp)로 판단한다.
  화면 폭을 라우트 진입 시점에 provider 로 박아 두지 말 것 — 폴드 접기/펼치기 · 회전 · 분할 화면에서
  폭이 바뀐다. 폭이 필요하면 레이아웃에서 읽는다(상세 앱바는 `DetailWidthScope`).
- 방향: 폰(짧은 변 < 600dp)만 세로 고정, 그 외 회전 허용(`OrientationPolicy`, 창 크기 변화마다 재적용).
- 본문 폭: 목록 · 설정류는 `SliverReadableWidth`(840dp), 상세 본문은 `ReadableWidth.detail`(720dp).
- 840dp 이상이면 `ListDetailLayout` 이 목록 옆 칸에 상세를 연다(글 목록 · 스크랩).
  항목 탭은 `ListDetailScope.tryOpen` 을 먼저 부르고 false 일 때만 push 한다.
  옆 칸 안인지는 `ListDetailPane.isPane` 으로 본다(뒤로가기 버튼 · 우클릭 닫기 없음).

## 스와이프 뒤로가기 (`SwipeBackPage`)

- 화면 라우트는 `SwipeBackPage`(`core/presentation/widgets/swipe_back_page.dart`)로 만든다.
  패키지(`swipeable_page_route`)는 쓰지 않는다 — `CupertinoPageRoute` 기반이라 Android 시스템
  뒤로가기 제스처(predictive back)에 애니메이션이 붙지 않는다.
- 본문 어디서든 오른쪽으로 끄는 드래그와 Android 시스템 제스처(양쪽 가장자리)가 **같은 라우트
  컨트롤러**를 움직인다. 전환 모양은 `CupertinoPageTransition`.
  뒤 화면에는 `secondaryAnimation` 만큼 어두운 막을 깐다(라이트 0.2 · 다크 0.45, 경계 구분용).
- 제스처 내비게이션의 가장자리(`MediaQuery.systemGestureInsets`)에서 시작한 터치는 본문 드래그로
  받지 않는다. OS 가 판정 전까지 터치를 앱에도 보내서, 받으면 시스템 제스처와 겹쳐 애니메이션 없이 닫힌다.
- `didStartUserGesture` / `didStopUserGesture` 는 라우트의 `_startGesture` / `_stopGesture` 로만
  부른다. 짝이 하나라도 어긋나면 Navigator 가 계속 제스처 중으로 남아 앱 전체에서 스와이프가 멈춘다.
- 뒤로 가기를 놓은 뒤 닫히는 애니메이션 동안 아래 화면에서 다시 뒤로 가기를 시작하면, 닫히던 화면을
  그 자리에서 마저 닫고(`_settleClosingRouteAbove`) 이어 받는다. 이걸 빼면 연달아 엣지 스와이프할 때
  두 번째가 애니메이션 없이 pop 된다. 본문 드래그는 `onlyAcceptDragOnThreshold` 로 실제로 끌 때만 시작한다.
- 가로로 끄는 동작이 따로 있는 화면(영상 탐색 막대 등)은 `SwipeBackPage` 대신 `builder:` 를 쓰거나
  `canSwipe: false` 로 끈다.

## 로컬 DB (sembast)

- 저장 구조를 바꾸면 `database_migrations.dart` 의 `kAppDatabaseVersion` 을 올리고
  `onAppDatabaseVersionChanged` 에 단계를 추가한다. Drive 복원도 reopen 시 이 경로를
  타므로 옛 백업도 자동으로 옮겨진다. 마이그레이션은 데이터 문제로 던지지 않는다
  (던지면 DB 열기가 실패해 앱이 안 뜬다).
- 읽음 기록 `{site}_read` 는 `글 id → 읽은 시각(ms)`. 180일 지난 기록은 하루 한 번 정리.
- 본 댓글 수 `{site}_read_reply` 는 `글 id → {c: 댓글 수, t: 기록 시각}`, 14일 보관(같은 정리에서 지운다).
  상세를 받은 뒤 한 번 남기고(목록 값 · 상세 댓글 수 중 큰 값, 같으면 쓰지 않음), 목록을 받을 때
  `ListDataSourceImpl` 이 비교해 `ListItem.newReplyCount` 를 채운다. 목록 행은 읽은 글에
  `[17 | +3]` 배지(`_NewReplyBadge`, +N 칸은 안 읽은 댓글 배지와 같은 색)로 보이고, 다시 열면 지운다(`readableStateProvider` 는 같은 글도 알리게 순번을 붙인다).
  댓글 수 문자열은 `parseReplyCount`(정확한 수가 아니면 null → 비교 안 함).

## release 빌드 / 의존성 업그레이드

- `pubspec.lock` 이 바뀌면 커밋 전에 기기를 연결하고 실행한다(사전 커밋 훅이 확인):
  ```bash
  tool/release_smoke_test.sh            # 빌드 → R8 keep 검사 → 설치 → 기동 확인
  ```
  debug 는 R8 축소를 하지 않아 release 전용 문제가 보이지 않고, 빌드 성공도 런타임을
  보장하지 않는다.
- 릴리스 전 기기 확인(수동): 실제 사이트로 사이트마다 게시판 → 글 → 끝까지 스크롤 · 실패 화면 ·
  Flutter 오류 · 글자 크기 범위를 본다. AI 없이 Marionette CLI(화면 읽기 · 누르기 · scroll-to)와
  adb(설치 · 재시작 · VM service 포워딩)만 쓴다. debug 빌드, 스크린샷은 `build/device_check/`.
  ```bash
  fvm dart pub global activate marionette_cli      # 한 번
  fvm dart run tool/device_check.dart              # 전체
  fvm dart run tool/device_check.dart nate clien   # 일부(SiteType 이름, font)
  ```
  화면 요소는 글자 · `Semantics(identifier:)` · 위젯 종류로 찾는다. 스크립트가 누르는 id
  (`main_drawer` · `main_add` · `add_board_close` · `tab_settings` · `detail_footer`)를 바꾸면 스크립트도 고친다.
  Flutter 오류는 debug 에서 `MoclLogger` 로도 남겨(`main.dart`) `get-logs` 로 검사한다 — debug 의 오류 콘솔
  출력이 logcat 에 남지 않고, 오류 화면(ErrorWidget)은 위젯 트리 목록에 나오지 않는다.
  아이콘만 있는 `PlainIconButton` 에는 `semanticLabel` 을 준다(없으면 화면 낭독에서 이름 없는 버튼이 된다).
- 개발 중 AI 확인(Marionette): debug 빌드는 `MarionetteBinding` 으로 뜬다(`core/dev/marionette_setup.dart`,
  release 에는 들어가지 않음). AI 에이전트가 VM service 로 붙어 위젯 트리를 읽고 누르며 실제 사이트로 확인한다.
  ```bash
  fvm flutter run -d <기기> --flavor dev --dart-define-from-file=ads.json --vm-service-port=9101 --disable-service-auth-codes
  marionette register mocl ws://127.0.0.1:9101/ws     # CLI(dart pub global activate marionette_cli)
  marionette -i mocl tap --identifier tab_settings     # MCP 서버(marionette_mcp)로도 같은 동작
  ```
  `get_logs` 는 `MoclLogger` 로그를 돌려준다. Flutter 밖(AdMob 네이티브 광고 · 로그인 웹뷰 · 권한 창)은 보지 못한다.
  binding 은 앱에 하나뿐이니 `main()` 에서 `WidgetsFlutterBinding.ensureInitialized` 대신 `ensureAppBinding()` 을 쓴다.
- `package:jni` 를 쓰는 플러그인은 Dart 가 Java/Kotlin 클래스를 이름 문자열로 찾으므로
  R8 이 지우거나 줄이면 런타임에 멈춘다. `fvm dart run tool/check_jni_keep.dart` 가
  실패하면 `android/app/proguard-rules.pro` 의 "package:jni" 항목에 keep 을 추가한다.

## iOS · macOS 네이티브 의존성 (Swift Package Manager)

- CocoaPods 는 쓰지 않는다(`pubspec.yaml` 의 `flutter: config: enable-swift-package-manager: true`).
  Podfile 을 다시 만들지 말 것. 버전 고정은 `Runner.xcworkspace/xcshareddata/swiftpm/Package.resolved`.
- `firebase_core` 5.x(firebase-ios-sdk 13)는 `google_sign_in_ios` 6.4.0+(GoogleSignIn 10)와만 SPM 해석이 된다
  (`gtm-session-fetcher` 범위). 그래서 `google_sign_in_ios: ^6.4.0` 을 직접 의존성으로 둔다 — 낮추지 말 것.
- flavor 스킴(`dev` · `prd` · `Runner`)마다 빌드 pre-action "Run Prepare Flutter Framework Script" 가
  있어야 한다. 스킴을 새로 만들면 같이 넣는다.
- Crashlytics 심볼 업로드 빌드 단계는 `SourcePackages/checkouts/firebase-ios-sdk/Crashlytics/upload-symbols`
  를 찾아 쓰고, dSYM 이 없는 Debug 구성은 건너뛴다.

## 앱 아이콘 / 스플래시

- 밀도별 리소스를 직접 수정하지 말 것. `branding/` 의 소스 PNG 교체 후 재생성:
  ```bash
  fvm dart run flutter_launcher_icons -f flutter_launcher_icons.yaml
  fvm dart run flutter_native_splash:create --path=flutter_native_splash.yaml
  ```

## 광고 (AdMob, 현재 Android 만)

- 자리 세 곳(`features/ads/`), 광고 단위도 자리마다 따로(`AdUnitIds`):
  - 게시판 목록 글 사이 — `ListAdPlacement` · `ListAdSlots`, 모양 `ListAdStyle` ↔ `ListNativeAdFactory.kt`(`listTile`)
  - 메인 게시판 목록 맨 아래 하나 — `MainAdTile`(편집 · 검색 중엔 없음), 모양은 `listTile` 재사용.
    **현재 꺼 둠**(광고가 너무 많아서). 소스는 남겨 두고 `mocl_main_widgets.dart` 에서 주석 처리했다.
  - 상세 본문과 댓글 사이 하나 — `DetailAdCard`. 크기는 원격 설정 `ads.detail`(`DetailAdSize`, 기본 small):
    - compact(~71dp) — `ListAdStyle`(좌우 여백 0) ↔ `listTile`
    - small(~144dp, 정사각 미디어 120) — `DetailSmallAdStyle` ↔ `DetailSmallNativeAdFactory.kt`(`detailSmall`)
    - medium(미디어 폭×0.4, 120~160) · large(16:9, 120~280) — `DetailAdStyle` ↔ `DetailNativeAdFactory.kt`(`detailCard`)
    - off — 넣지 않음
- 목록 광고 자리(`ListAdPlacement`, 기본 5번째 글 뒤 · 15개마다)는 원격 설정 `ads.list.first` · `interval`.
  위젯은 `AdsState` mixin(`ads/presentation/state/`)으로 읽는다. 미디어 칸은 120dp 아래로 줄이지 말 것(AdMob 정책).
- Dart 스타일과 Kotlin 팩토리는 같은 여백 상수로 높이를 맞춘다(한쪽을 바꾸면 다른 쪽도 함께).
  한 자리에 하나만 두는 광고는 `SingleNativeAd` 를 쓴다.
- 광고를 받는 동안은 같은 높이의 자리 표시(`NativeAdLook.placeholder`, 회색 막대만)로 칸을 잡아 두고,
  오면 자리 표시를 광고 **위에서** 페이드아웃한다(`NativeAdSwitcher` — 플랫폼 뷰는 투명도가 안 먹을 수
  있어 광고를 페이드인하지 않는다). 못 받으면 `NativeAdCollapse` 로 칸을 접는다.
  광고를 새로 받을 때(모양 변경 등)는 스위처 key 를 바꿔 전환 없이 그린다 — 옛 `AdWidget` 이
  전환 중에 남아 있으면 다음 프레임에 정리된 광고를 그리게 된다.
  스위처는 **스크롤 중에는 광고 뷰를 붙이지 않고** 자리 표시를 두었다가 멈추면 붙인다. 플랫폼 뷰를
  붙이는 동안 Android 메인 스레드가 15~20ms 막혀 vsync 가 밀리기 때문이다(S24 Ultra 실측, 플링 중
  2~3 프레임 손실). 이 대기를 빼지 말 것.
- 목록 광고(`ListAdSlots`)는 넘기는 중에 불러오거나(`NativeAd.load`) 치우지(`dispose`) 않는다.
  둘 다 SDK 가 Android 메인 스레드(= Flutter UI 스레드)에서 일해서, 넘기는 중에 하면 vsync 를 놓친다
  (S24 Ultra 실측: 8번 넘길 때 10ms 넘게 밀린 프레임 20개 → 0개). 대신 조용할 때(멈추고 0.3초 뒤) **여분 광고 2개**를
  미리 받아 두고, 멈추면 0.1초 뒤 화면에 붙은 자리에 넣는다(멈춘 뒤에 받기 시작하면 1~2초 늦게 떠 노출이 준다).
  여분이 없을 때만 그 자리 몫을 직접 받는다. 자리에 넣었던 광고는 여분으로 되돌리지 않는다(이미 노출된 광고).
  광고 자리(`_ListAdTile`)가 `watchScroll` 로 목록의 스크롤 상태를 넘긴다. 자리마다 바로 불러오게 되돌리지 말 것.
- 상세 광고는 미리 받아 둔다(`NativeAdPreloader.detail`, 들고 있는 광고는 하나). 자리(`DetailAdCard`)가 본문 끝에
  있어 본문이 길면 끝에 다다라서야 만들어지고, 그때 요청하면 1~2초 자리 표시만 보였다.
  화면이 열리고 전환이 끝나면(0.3초 뒤) `DetailAdPrefetch`(본문 맨 위, 광고와 같은 폭을 받는 빈 칸)가 받아 두고,
  광고가 뜬 뒤 스크롤이 멈춰 조용하면 `SingleNativeAd` 가 다음 글 몫을 받아 둔다. 둘이 같은 모양을 쓰도록
  모양은 `detailAdLook` 하나로 만든다(모양이 다르면 받아 둔 광고를 버린다). 자리는 `SliverList` 안이라
  받은 광고가 스크롤로 멀어져도 살아 있다(keep-alive, 되돌아올 때 다시 받지 않는다).
  `NativeAdSwitcher` 는 스크롤 중뿐 아니라 화면 전환 중에도 광고 뷰를 붙이지 않는다.
- ID 는 **저장소에 두지 않는다.** 루트의 `ads.json`(gitignore, 형식은 `ads.example.json`)에 두고
  `--dart-define-from-file=ads.json` 으로 넣는다. 앱 ID 는 `build.gradle.kts` 가 같은
  define(`MOCL_ADMOB_APP_ID`) 또는 `-PmoclAdmobAppId` 에서 읽고, 광고 단위는 `AdUnitIds` 가 읽는다.
  iOS 앱 ID 는 따로(`MOCL_ADMOB_IOS_APP_ID`, AdMob 앱 ID 는 플랫폼마다 다름) —
  `ios/scripts/inject_admob_app_id.sh` 빌드 단계가 `DART_DEFINES` 에서 꺼내 `Info.plist` 의
  `GADApplicationIdentifier` 에 넣는다. 이 키가 없으면 SDK 가 시작 시 앱을 죽인다.
  값이 없으면 Google 테스트 ID 로 떨어진다. CI 는 Secrets `ADS_JSON` 으로 `ads.json` 을 만든다.
  debug · profile 은 값이 있어도 테스트 단위만 쓴다. 개발 중 실제 ID 로 노출/클릭하지 말 것(계정 정지).
- 광고 요청은 동의(UMP) 확인 → `canRequestAds()` → SDK 초기화가 끝난 뒤(`mobileAdsReady`)
  에만 한다. 이 순서를 건너뛰고 `NativeAd` 를 만들지 말 것. 동의 화면 문구는 AdMob 콘솔
  "개인 정보 보호 및 메시지" 의 GDPR 메시지로 관리한다.
- play-services-ads 가 끌어오는 room-runtime 2.2.5 는 keep 규칙이 없어
  `proguard-rules.pro` 의 RoomDatabase keep 이 필요하다(빠지면 release 가 시작 즉시 죽는다).

## 앱 업데이트 (`features/app_update/`)

- 우리 서버가 아니라 **스토어 버전과 비교**한다. 앱 실행 3초 뒤 `AppUpdateGate` 가 한 번 확인하고,
  설정 "앱 정보 → 업데이트 확인" 으로 직접 확인한다(미룸 무시).
  - Android: `in_app_update`(Play 인앱 업데이트). 유연 업데이트로 받고, 다 받으면 "다시 시작"
    스낵바. Play 우선순위(Developer API 의 `inAppUpdatePriority`) 4 이상이면 즉시 업데이트.
    Play 에서 설치하지 않은 빌드(debug · 사이드로드 · dev flavor)는 확인 불가로 조용히 끝난다.
    실제 동작은 Play 내부 앱 공유 · 내부 테스트 트랙으로 확인한다.
  - iOS: `upgrader` 를 **조회 엔진으로만** 쓴다(iTunes lookup, KR 스토어). 패키지의 `UpgradeAlert`
    는 `package:flutter/material` 다이얼로그라 `material_ui` 테마 · 지역화를 못 보므로 쓰지 말고,
    안내 다이얼로그는 `AppUpdateGate` 가 `AlertDialog.adaptive` 로 그린다.
- 같은 버전은 `AppUpdatePromptStore.interval`(3일) 동안 다시 묻지 않는다(두 플랫폼 공통).

## 댓글 쓰기 (클리앙 · 다모앙)

- 사이트별 `BaseApi.writeComment` 오버라이드 + `supportsCommentWrite => true` 로 켠다.
  나머지 사이트는 기본 구현(미지원)이라 상세에 쓰기 버튼이 나오지 않는다.
- 로그인 여부 · CSRF · 사이트별 값은 상세 파싱 때 `Details.isLoggedIn` / `csrf` /
  `commentParams` 에 담고, 대댓글 부모는 `CommentItem.commentId`(클리앙은 한 단계만
  받으므로 대댓글엔 `parentCommentId`)로 가리킨다.
  - 클리앙: `POST /service/api/board/{boardCd}/{boardSn}/comment/regist`, form
    `boardSn` + JSON `param`, 헤더 `X-CSRF-TOKEN`(페이지 `$.ajaxSetup` 값).
  - 다모앙: `POST /api/v1/boards/{board}/posts/{id}/comments`, JSON `{content, parent_id}`,
    `Authorization: Bearer {__data.json 의 accessToken}`. 401 이면 토큰을 다시 받아 한 번만 재시도.
- 토큰 · CSRF · 댓글 본문은 로그에 남기지 않는다(헤더는 `redactHeaders`).

## 레딧

- 데이터는 **`api.reddit.com`** 에서 받는다(같은 `.reddit.com` 로그인 쿠키, 응답 형식 동일).
  `www.reddit.com` 은 정렬을 경로에 넣은 `.json`(`/new/.json` · `/r/x/hot/.json`)을 로그인해도 403 으로 막는다.
  접힌 댓글을 한꺼번에 주는 `morechildren` 은 두 호스트 모두 403 이라, 댓글 하나 + 스레드 조회
  (`/comments/{글}/_/{댓글}`)로 펼친다(`RedditApi._expandMoreComments`, 요청 상한 있음).
- 게시판 목록은 `board_link.json` 이 아니라 로그인한 계정의 구독 커뮤니티
  (`/subreddits/mine/subscriber`, `after` 로 넘김)다. 네이버카페처럼
  `hasCuratedBoardList` 가 false 이고, 로그인 안 됐으면 `NotLoginFailure` 로 로그인 화면을 띄운다.
- reddit.com 첫 화면(홈 피드)은 `RedditParser.pinnedBoards` 로 목록 맨 앞에 항상 붙는다.
- `.json` 요청은 `RedditApi._fetch`(4xx 를 응답으로 받음)를 쓰고, 401/403 은 `NotLoginFailure` 로 바꾼다.
- 상세 댓글은 트리를 깊이 우선으로 펼친 평평한 목록이다(화면은 `replies` 를 그리지 않는다).
- 상세 번역(앱바 번역 버튼)은 `BaseParser.supportsTranslation` 이 true 인 사이트(현재 레딧만)에서 보인다.
  번역은 기기 안에서 한다(무료): Android 는 ML Kit(`TranslationChannel.kt`, gradle 의존성),
  iOS 18+ · macOS 15+ 는 Apple Translation(`{ios,macos}/Runner/TranslationChannel.swift`, 두 파일은 같은 내용).
  ML Kit Flutter 플러그인은 iOS 가 CocoaPods 전용이라 쓰지 않고 채널(`net.b1ink.mocl/translation`)을 직접 둔다.
  HTML 은 `HtmlTextTranslator` 가 글자만 번역한다(코드 · 링크 · 이미지는 그대로).
- 목록 앱바 번역 버튼은 설정 "번역해서 보기"(`AutoTranslateNotifier`, 앱을 다시 켜도 유지)를 켜고 끈다.
  켜면 목록 제목을 쪽마다 묶어 번역하고(`TitleTranslationsNotifier`, 원문 제목 → 번역문, 앱이 떠 있는
  동안 유지), 상세도 열자마자 번역한다. 행 데이터(`ListItem`)는 원문 그대로 두고 화면에서만 바꿔
  그린다(스크랩 · 뮤트 · 상세 요청은 원문 기준).
