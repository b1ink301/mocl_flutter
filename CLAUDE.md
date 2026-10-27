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

## 앱 아이콘 / 스플래시

- 밀도별 리소스를 직접 수정하지 말 것. `branding/` 의 소스 PNG 교체 후 재생성:
  ```bash
  fvm dart run flutter_launcher_icons -f flutter_launcher_icons.yaml
  fvm dart run flutter_native_splash:create --path=flutter_native_splash.yaml
  ```

## 광고 (AdMob, 현재 Android 만)

- 자리 세 곳(`features/ads/`), 광고 단위도 자리마다 따로(`AdUnitIds`):
  - 게시판 목록 글 사이 — `ListAdPlacement` · `ListAdSlots`, 모양 `ListAdStyle` ↔ `ListNativeAdFactory.kt`(`listTile`)
  - 메인 게시판 목록 맨 아래 하나 — `MainAdTile`(편집 · 검색 중엔 없음), 모양은 `listTile` 재사용
  - 상세 본문과 댓글 사이 하나 — `DetailAdCard`, 모양 `DetailAdStyle` ↔ `DetailNativeAdFactory.kt`(`detailCard`)
- Dart 스타일과 Kotlin 팩토리는 같은 여백 상수로 높이를 맞춘다(한쪽을 바꾸면 다른 쪽도 함께).
  한 자리에 하나만 두는 광고는 `SingleNativeAd` 를 쓴다.
- ID 는 **저장소에 두지 않는다.** 루트의 `ads.json`(gitignore, 형식은 `ads.example.json`)에 두고
  `--dart-define-from-file=ads.json` 으로 넣는다. 앱 ID 는 `build.gradle.kts` 가 같은
  define(`MOCL_ADMOB_APP_ID`) 또는 `-PmoclAdmobAppId` 에서 읽고, 광고 단위는 `AdUnitIds` 가 읽는다.
  값이 없으면 Google 테스트 ID 로 떨어진다. CI 는 Secrets `ADS_JSON` 으로 `ads.json` 을 만든다.
  debug · profile 은 값이 있어도 테스트 단위만 쓴다. 개발 중 실제 ID 로 노출/클릭하지 말 것(계정 정지).
- 광고 요청은 동의(UMP) 확인 → `canRequestAds()` → SDK 초기화가 끝난 뒤(`mobileAdsReady`)
  에만 한다. 이 순서를 건너뛰고 `NativeAd` 를 만들지 말 것. 동의 화면 문구는 AdMob 콘솔
  "개인 정보 보호 및 메시지" 의 GDPR 메시지로 관리한다.
- play-services-ads 가 끌어오는 room-runtime 2.2.5 는 keep 규칙이 없어
  `proguard-rules.pro` 의 RoomDatabase keep 이 필요하다(빠지면 release 가 시작 즉시 죽는다).
