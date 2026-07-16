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
