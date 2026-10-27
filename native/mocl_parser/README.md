# mocl_parser (Rust FFI)

Flutter ↔ Rust 브리지를 통해 HTML 파싱을 네이티브에서 수행하기 위한 크레이트.
`flutter_rust_bridge` 2.x + `cargokit` 빌드 파이프라인 사용.

## 디렉토리 구조

```
mocl_flutter/
├─ native/mocl_parser/        # Rust 크레이트 (이 디렉토리)
│  ├─ Cargo.toml
│  └─ src/
│     ├─ lib.rs
│     ├─ frb_generated.rs    # FRB 자동 생성 (수정 금지)
│     └─ api/
│        ├─ mod.rs
│        ├─ simple.rs        # init_app, greet (FRB 템플릿)
│        └─ geek_news.rs     # 긱뉴스 리스트 파서
│
├─ rust_builder/             # Flutter 플러그인 (cargokit 빌드 래퍼)
│  ├─ pubspec.yaml
│  ├─ android/  ios/  macos/  linux/  windows/
│  └─ cargokit/
│
├─ lib/src/rust/             # 자동 생성된 Dart 바인딩 (수정 금지)
│  ├─ frb_generated.dart
│  └─ api/
│     ├─ simple.dart
│     └─ geek_news.dart
│
└─ flutter_rust_bridge.yaml  # 코드젠 설정
```

## 코드 추가/수정 워크플로우

1. `native/mocl_parser/src/api/` 아래 Rust 함수/구조체 작성 또는 수정.
2. 프로젝트 루트에서 코드젠:
   ```bash
   flutter_rust_bridge_codegen generate
   ```
   → `lib/src/rust/` 의 Dart 바인딩과 `src/frb_generated.rs` 가 갱신됨.
3. Dart 코드에서 `package:mocl_flutter/src/rust/api/geek_news.dart` 등으로 import.
4. 빌드:
   - **macOS/iOS/Android**: `flutter run` / `flutter build` 시 cargokit 이 자동 컴파일.
   - 처음 한 번은 다소 오래 걸림 (의존성 크레이트 다운로드+컴파일).

## Dart 측 초기화

`main()` 진입 직후 1회 호출 필요:

```dart
import 'package:mocl_flutter/src/rust/frb_generated.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RustLib.init(); // ← FFI 초기화
  // ... 기존 초기화 ...
  runApp(const MyApp());
}
```

## 사용 예 — 긱뉴스 리스트 파서

```dart
import 'package:mocl_flutter/src/rust/api/geek_news.dart';

final items = await parseGeekNewsList(
  html: response.data as String,
  baseUrl: 'https://news.hada.io',
);
for (final it in items) {
  print('${it.id}  ${it.title}');
}
```

`RustListItem` 의 `id` 는 `PlatformInt64` (web 호환 위해). `int` 로 쓰려면 `.toInt()`.

## 빌드 타깃별 메모

- **iOS**: 첫 빌드 시 `rust_builder/ios/` Pod 가 추가됨. `cd ios && pod install`.
- **Android**: NDK 필요. `~/.gradle/properties` 또는 `local.properties` 에 NDK 경로.
  Rust 타깃: `aarch64-linux-android`, `armv7-linux-androideabi`, `x86_64-linux-android`, `i686-linux-android` (이미 설치됨).
- **macOS desktop**: 호스트 타깃(`aarch64-apple-darwin`) 으로 자동 빌드.

## 다음 후보 작업

- [ ] `clien`, `damoang`, `theqoo`, `meeco` 파서 이식
- [ ] 댓글/상세 파싱도 Rust 로 이전
- [ ] 큰 HTML(>100KB) 대상 zero-copy `Uint8List` 인자 사용 (현재는 `String`)
- [ ] `IsReadsFn` 콜백을 Dart→Rust 로 전달하거나, Rust 가 id 목록만 반환 후 Dart 가 DB 조회

## 참고

- flutter_rust_bridge: https://cjycode.com/flutter_rust_bridge/
- scraper: https://docs.rs/scraper/
