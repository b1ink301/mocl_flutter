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
import 'package:mocl_flutter/core/util/mocl_logger.dart';

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
- 제스처 내비게이션의 가장자리(`MediaQuery.systemGestureInsets`)에서 시작한 터치는 본문 드래그로
  받지 않는다. OS 가 판정 전까지 터치를 앱에도 보내서, 받으면 시스템 제스처와 겹쳐 애니메이션 없이 닫힌다.
- `didStartUserGesture` / `didStopUserGesture` 는 라우트의 `_startGesture` / `_stopGesture` 로만
  부른다. 짝이 하나라도 어긋나면 Navigator 가 계속 제스처 중으로 남아 앱 전체에서 스와이프가 멈춘다.
- 가로로 끄는 동작이 따로 있는 화면(영상 탐색 막대 등)은 `SwipeBackPage` 대신 `builder:` 를 쓰거나
  `canSwipe: false` 로 끈다.

## 로컬 DB (sembast)

- 저장 구조를 바꾸면 `database_migrations.dart` 의 `kAppDatabaseVersion` 을 올리고
  `onAppDatabaseVersionChanged` 에 단계를 추가한다. Drive 복원도 reopen 시 이 경로를
  타므로 옛 백업도 자동으로 옮겨진다. 마이그레이션은 데이터 문제로 던지지 않는다
  (던지면 DB 열기가 실패해 앱이 안 뜬다).
- 읽음 기록 `{site}_read` 는 `글 id → 읽은 시각(ms)`. 180일 지난 기록은 하루 한 번 정리.

## release 빌드 / 의존성 업그레이드

- `pubspec.lock` 이 바뀌면 커밋 전에 기기를 연결하고 실행한다(사전 커밋 훅이 확인):
  ```bash
  tool/release_smoke_test.sh            # 빌드 → R8 keep 검사 → 설치 → 기동 확인
  ```
  debug 는 R8 축소를 하지 않아 release 전용 문제가 보이지 않고, 빌드 성공도 런타임을
  보장하지 않는다.
- `package:jni` 를 쓰는 플러그인은 Dart 가 Java/Kotlin 클래스를 이름 문자열로 찾으므로
  R8 이 지우거나 줄이면 런타임에 멈춘다. `fvm dart run tool/check_jni_keep.dart` 가
  실패하면 `android/app/proguard-rules.pro` 의 "package:jni" 항목에 keep 을 추가한다.

## iOS · macOS 네이티브 의존성 (Swift Package Manager)

- CocoaPods 는 쓰지 않는다(`pubspec.yaml` 의 `flutter: config: enable-swift-package-manager: true`).
  Podfile 을 다시 만들지 말 것. 버전 고정은 `Runner.xcworkspace/xcshareddata/swiftpm/Package.resolved`.
- `firebase_core` 는 4.x 에 묶어 둔다. 5.x(firebase-ios-sdk 13) 는 `google_sign_in_ios`(GoogleSignIn 9.x)와
  `gtm-session-fetcher` 범위가 충돌해 패키지 해석이 실패한다.
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
  - 상세 본문과 댓글 사이 하나 — `DetailAdCard`, 모양 `DetailAdStyle` ↔ `DetailNativeAdFactory.kt`(`detailCard`)
- Dart 스타일과 Kotlin 팩토리는 같은 여백 상수로 높이를 맞춘다(한쪽을 바꾸면 다른 쪽도 함께).
  한 자리에 하나만 두는 광고는 `SingleNativeAd` 를 쓴다.
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
