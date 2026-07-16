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

## 아키텍처

- Clean Architecture: `domain → data → application → presentation`
- 사이트 파서는 워커 isolate(`ParserIsolateClient`)에서 실행 — 메인 isolate 차단 금지
- 네트워크: dio, connect/receive/send timeout 모두 15초 통일

## 앱 아이콘 / 스플래시

- 밀도별 리소스를 직접 수정하지 말 것. `branding/` 의 소스 PNG 교체 후 재생성:
  ```bash
  fvm dart run flutter_launcher_icons -f flutter_launcher_icons.yaml
  fvm dart run flutter_native_splash:create --path=flutter_native_splash.yaml
  ```
