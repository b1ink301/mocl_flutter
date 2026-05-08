# mocl_flutter

간단한 눈팅 앱으로 Clien, Damoang, NaverCafe, Meeco, Reddit, TheKoo 사이트를 제한적으로 지원합니다.

https://play.google.com/store/apps/details?id=kr.b1ink.mocl

## 기술 스택

- **Flutter** >= 3.38.0 / **Dart** >= 3.10.0
- **상태관리 & DI**: flutter_riverpod + riverpod_annotation (code gen)
- **아키텍처**: Clean Architecture (domain → data → application → presentation)
- **라우팅**: go_router
- **네트워크**: dio + cookie_jar
- **코드 생성**: freezed, json_serializable, riverpod_generator
- **빌드 플레이버**: dev, prd
- **데이터베이스**: sembast

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

### 코드 생성 (build_runner)

```bash
dart run build_runner build --delete-conflicting-outputs
```

### 실행

```bash
# 개발
flutter run --flavor dev

# 프로덕션
flutter run --flavor prd

# 프로파일
flutter run --profile --flavor prd
```

### 빌드

```bash
# Android
flutter build apk --flavor prd
flutter build appbundle --flavor prd

# iOS (XCode에서 인증서 세팅 필요)
cd ios && pod install && cd ..
flutter build ipa --flavor prd
```

### 정적 분석

```bash
# Dart 분석
flutter analyze

# Provider import 규칙 검사
dart run tool/check_provider_imports.dart
```
