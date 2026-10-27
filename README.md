# mocl_flutter

간단한 눈팅 앱으로 Arcalive, Bobaedream, Clien, Cook82, DCInside, Damoang, Dogdrip,
GeekNews, Instiz, Inven, Meeco, MLBPark, Nate, NaverCafe, Ppomppu, Reddit, Ruliweb, TheQoo
사이트를 제한적으로 지원합니다.

https://play.google.com/store/apps/details?id=kr.b1ink.mocl

## 기술 스택

- **Flutter** >= 3.44.0 / **Dart** ^3.12.0
- **Android 빌드**: Gradle 9.5 / AGP 9.2 / Kotlin 2.3
- **버전 관리**: FVM (`.fvmrc` 로 Flutter 버전 고정)
- **상태관리 & DI**: flutter_riverpod + riverpod_annotation (code gen)
- **아키텍처**: Clean Architecture (domain → data → application → presentation)
- **라우팅**: go_router
- **네트워크**: dio + cookie_jar (timeout 15s 통일)
- **HTML 파서**: html 패키지 (워커 isolate 분리)
- **코드 생성**: freezed, json_serializable, riverpod_generator
- **빌드 플레이버**: dev, prd
- **데이터베이스**: sembast
- **앱 아이콘/스플래시**: flutter_launcher_icons + flutter_native_splash (소스: `branding/`)

## 프로젝트 구조

```
lib/
├── config/                        # 앱 설정 (테마, 라우트)
│   └── routes/                    # GoRouter 설정
├── core/                          # 공통 모듈
│   ├── application/               # 공통 Provider (AppFontState 등)
│   ├── domain/                    # 공통 Entity, Repository(abstract), UseCase
│   ├── data/                      # 공통 Repository(concrete), DataSource
│   ├── error/                     # 에러/Failure 정의
│   ├── presentation/              # 공통 위젯 & 모델
│   └── util/                      # 유틸리티
├── features/                      # 기능 모듈
│   ├── main_page/                 # 메인 화면
│   ├── list_page/                 # 글 목록
│   ├── detail_page/               # 글 상세
│   ├── login_page/                # 로그인 (InAppWebView)
│   ├── add_main_dialog/           # 게시판 추가 다이얼로그
│   ├── settings_page/             # 설정
│   ├── html_parser/               # HTML 파싱
│   ├── database/                  # 로컬 DB (sembast)
│   ├── network/                   # 네트워크 에러 처리
│   └── google_drive/              # 구글 드라이브 백업
└── i18n/                          # 다국어 지원
```

### Feature 모듈 구조 (Clean Architecture)

```
features/{feature_name}/
├── domain/
│   ├── entities/                  # 도메인 모델
│   ├── repositories/              # Repository 인터페이스
│   └── usecases/                  # 비즈니스 로직
├── data/
│   ├── datasources/               # 원격/로컬 데이터소스
│   ├── models/                    # DTO (JSON 변환)
│   └── repositories/              # Repository 구현체
├── application/
│   ├── use_case_provider.dart     # UseCase Provider
│   └── {feature}_providers.dart   # 상태 Provider (@riverpod)
└── presentation/
    ├── state/
    │   ├── {feature}_event_mixin.dart  # Event (ref.read → 상태 변경)
    │   └── {feature}_state_mixin.dart  # State (ref.watch → 상태 조회)
    ├── widgets/                   # 위젯 컴포넌트
    └── {feature}_view.dart        # 화면 진입점
```

## 상태관리 패턴: Mixin Class

Riverpod Provider를 **mixin class를 통해서만** 접근하도록 캡슐화합니다.

### 규칙

- **Event mixin**: `ref.read()`로 상태 변경 (사용자 액션 처리)
- **State mixin**: `ref.watch()`로 상태 조회 (UI 바인딩)
- **위젯**: Provider를 직접 import하지 않고, mixin을 `with`로 합성

### 예시

```dart
// Event — 상태 변경만 담당
mixin class ListEvent {
  void handleRefresh(WidgetRef ref) =>
      ref.read(pageStateProvider.notifier).refresh();
}

// State — 상태 조회만 담당
mixin class ListState {
  (int, bool, String?) listState(WidgetRef ref) => ref.watch(
    pageStateProvider.select(
      (value) => value.when(
        data: (state) => (state.items.length, state.hasReachedMax, state.error),
        loading: () => (0, false, null),
        error: (err, stack) => (0, false, err.toString()),
      ),
    ),
  );
}

// Widget — mixin으로만 Provider 접근
class MoclListView extends ConsumerWidget with ListState, ListEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final (count, hasMax, error) = listState(ref);
    // ...
  }
}
```

### Import 규칙

위젯에서 `application/` provider 파일을 직접 import하는 것을 금지합니다.

| 파일 위치 | application/ import | 허용 여부 |
|-----------|-------------------|----------|
| `presentation/state/*.dart` (mixin) | Provider 접근 | O |
| `presentation/*.dart` (view) | Provider 직접 접근 | X |
| `presentation/widgets/*.dart` | Provider 직접 접근 | X |

> `core/application/`은 공통 mixin(`AppFontState` 등)이 포함되어 있으므로 예외

```bash
# import 규칙 검사
dart run tool/check_provider_imports.dart
```

## 개발 환경 설정

### Flutter 버전 (FVM)

이 프로젝트는 `.fvmrc` 로 Flutter 버전을 고정합니다.

```bash
# fvm 설치
brew tap leoafarias/fvm
brew install fvm

# 프로젝트 사용 버전 설치
fvm install

# 이후 모든 flutter / dart 명령에 fvm 접두사 사용
fvm flutter pub get
fvm dart run build_runner build
```

`fvm` 미설치 환경에서는 시스템 Flutter 가 `>=3.44.0` 인지 확인.

### 코드 생성 (build_runner)

```bash
fvm dart run build_runner build --delete-conflicting-outputs
```

### 실행

```bash
# 개발
fvm flutter run --flavor dev

# 프로덕션
fvm flutter run --flavor prd

# 프로파일
fvm flutter run --profile --flavor prd
```

### 빌드

```bash
# Android
fvm flutter build apk --flavor prd
fvm flutter build appbundle --flavor prd

# iOS (XCode에서 인증서 세팅 필요)
cd ios && pod install && cd ..
fvm flutter build ipa --flavor prd
```

### 정적 분석

```bash
# Dart 분석
fvm flutter analyze

# Provider import 규칙 검사 (pre-commit hook 에서도 자동 실행)
fvm dart run tool/check_provider_imports.dart
```

## 앱 아이콘 / 스플래시

아이콘·스플래시는 `flutter_launcher_icons` / `flutter_native_splash` 로 자동 생성합니다.
밀도별 리소스(`android/.../mipmap-*`, `drawable-*`, iOS AppIcon 등)를 **직접 수정하지 말고**,
아래 소스 이미지를 교체한 뒤 재생성하세요.

### 소스 이미지 (`branding/`)

| 파일 | 용도 |
|------|------|
| `app_icon.png` | 앱 아이콘 (오렌지 배경 + 흰 m) — iOS/레거시 |
| `icon_foreground.png` | 적응형 아이콘 전경 (투명 + 흰 m) |
| `icon_monochrome.png` | Android 13+ 테마(모노크롬) 아이콘 실루엣 |
| `splash.png` | 스플래시 중앙 아이콘 (투명 + 오렌지 m) |

설정 파일: [`flutter_launcher_icons.yaml`](flutter_launcher_icons.yaml), [`flutter_native_splash.yaml`](flutter_native_splash.yaml)

### 재생성

```bash
fvm dart run flutter_launcher_icons -f flutter_launcher_icons.yaml
fvm dart run flutter_native_splash:create --path=flutter_native_splash.yaml
```

### 동작

- **스플래시 배경**: 라이트 `#FBFAF9` / 다크 `#121316` (m 은 오렌지 공통, 배경색만 테마별 분기)
- **런처 아이콘**: 적응형(Android 8+) + 모노크롬(Android 13+ 테마 아이콘) 지원

## 보안 / 시크릿 관리

### Firebase 설정 파일은 시크릿이 아닙니다

[`lib/firebase_options.dart`](lib/firebase_options.dart), `google-services.json`,
`GoogleService-Info.plist` 에는 `apiKey` 가 평문으로 들어 있고, **의도적으로 커밋합니다.**

Firebase API 키는 프로젝트와 앱을 **식별**할 뿐 권한을 부여하지 않습니다. 실제 인가는
Google Cloud IAM · Firebase Security Rules · App Check 가 담당합니다
([공식 문서](https://firebase.google.com/docs/projects/api-keys)).

또한 이 값들은 빌드 산출물에 반드시 포함되므로, APK/IPA 에 `strings` 만 돌려도 그대로
추출됩니다. **`.gitignore` 로 감추거나 난독화해도 보안상 이득은 없고 빌드만 깨집니다.**
방어선은 "키를 숨기는 것"이 아니라 **"키로 할 수 있는 일을 제한하는 것"** 입니다.

### 커밋 가능 여부

| 커밋해도 되는 것 | 절대 커밋하면 안 되는 것 |
|---|---|
| `lib/firebase_options.dart` | 서비스 계정 JSON (Admin SDK) |
| `android/app/google-services.json` | 릴리스 키스토어 (`*.jks`), `key.properties` |
| `{ios,macos}/Runner/GoogleService-Info.plist` | OAuth **client secret**, 서버 API 키 |
| OAuth client **ID** | Play / App Store Connect API 키 |

우변에 해당하는 값이 실수로 커밋되면 히스토리를 되돌리는 것만으로는 부족합니다.
**해당 자격증명을 즉시 폐기하고 재발급**해야 합니다.

### 서명 키 취급

릴리스 서명 정보는 저장소 **바깥**에 두고 주입합니다
([android/app/build.gradle.kts](android/app/build.gradle.kts) 참고).

| 환경 | `key.properties` 위치 |
|------|----------------------|
| 로컬 | `../../keystore/key.properties` (저장소 밖) |
| GitHub Actions | `android/key.properties` (시크릿에서 워크플로가 생성, 커밋 안 함) |

### Firebase 프로젝트 운영 체크리스트

키가 공개돼 있는 만큼, 보호는 콘솔 설정으로 합니다.

1. **미사용 서비스 잠그기 (최우선)** — 앱은 `firebase_core` + `firebase_crashlytics`
   만 사용합니다. Realtime Database · Cloud Storage 를 쓰지 않으면 **삭제**하고,
   남긴다면 규칙을 잠급니다. `firebase_options.dart` 에 `databaseURL` 과
   `storageBucket` 이 공개돼 있으므로, 테스트 모드 규칙이 켜져 있으면 그대로 뚫립니다.

   ```
   // RTDB
   { "rules": { ".read": false, ".write": false } }
   ```
   ```
   // Cloud Storage
   rules_version = '2';
   service firebase.storage {
     match /b/{bucket}/o { match /{allPaths=**} { allow read, write: if false; } }
   }
   ```

2. **API 키 제한** — GCP Console → API 및 서비스 → 사용자 인증 정보에서 키마다 설정.

   | 키 | 애플리케이션 제한 |
   |---|---|
   | Android | Android 앱 → 패키지명 + 릴리스/디버그 SHA-1 지문 |
   | iOS | iOS 앱 → 번들 ID (`net.b1ink.moclFlutter`) |
   | Web | HTTP 리퍼러 (웹 미배포 시 항목 자체를 제거하는 편이 낫다) |

   API 제한은 실제 사용하는 Firebase API 만 허용합니다.
   **유료 API(Maps, Gemini 등)는 공개 키의 허용 목록에 넣지 마세요** — 과금 남용으로 직결됩니다.

3. **App Check** — Play Integrity(Android) / App Attest(iOS). 현재는 사용 서비스가 적어
   급하지 않지만, Firestore·Functions 를 도입하는 시점에는 필수입니다.

4. **예산 알림** — Cloud Billing 예산 알림을 걸어두어 남용을 청구서보다 먼저 인지합니다.

## 운영 메모

- **Dio timeout**: 백그라운드 → 포그라운드 복귀 시 소켓 사망으로 멈추는 현상을
  방지하기 위해 connect/receive/send timeout 모두 15 초로 통일.
  `_buildDio()` ([network_provider.dart](lib/features/network/application/network_provider.dart)) 참고.
- **PagingController 복구**: 리스트 화면은 `AppLifecycleState.resumed` 시
  `ListPagingController.kickIfStale()` 을 호출해 멈춘 fetch 를 강제 재시작
  ([mocl_list_view.dart](lib/features/list_page/presentation/mocl_list_view.dart)).
- **사이트별 파서**: `lib/features/html_parser/data/datasources/{site}/`
  하위에 `*_api.dart` (HTTP) 와 `*_parser.dart` (HTML → Entity) 가 한 쌍.
  파서는 워커 isolate (`ParserIsolateClient`) 에서 실행되어 메인 isolate 를 차단하지 않음.
