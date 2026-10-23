// ignore_for_file: avoid_print
// release 빌드에서 JNI 로 찾는 Java/Kotlin 클래스가 R8 에 지워지거나
// 이름이 바뀌지 않았는지 mapping.txt 와 대조합니다.
//
// 배경: package:jni 를 쓰는 플러그인(shared_preferences_android 2.5.x,
// path_provider_android 2.3.x 등)은 Dart 쪽에서 'kotlin/coroutines/Continuation'
// 같은 **이름 문자열**로 클래스를 찾는다. R8 은 이 참조를 볼 수 없어 클래스를
// 지우거나 `qu` 처럼 줄이고, 앱은 빌드에 성공한 채 런타임에 멈춘다.
//
// 검사 대상: package:jni 패키지와, package:jni 를 import 하는 의존성 파일 안의
// 클래스 디스크립터 문자열. 기기 부트 클래스패스(java/ · android/ 등)는 제외.
//
// 사용법 (release 빌드 후):
//   dart run tool/check_jni_keep.dart [mapping.txt 경로]
//   기본 경로: build/app/outputs/mapping/devRelease/mapping.txt
import 'dart:convert';
import 'dart:io';

const String defaultMapping =
    'build/app/outputs/mapping/devRelease/mapping.txt';

/// 앱 DEX 가 아니라 기기가 제공하는 클래스. R8 대상이 아니다.
const List<String> platformPrefixes = [
  'java/',
  'javax/',
  'android/',
  'dalvik/',
  'sun/',
  'libcore/',
];

/// `kotlin/Unit`, `Lkotlin/coroutines/Continuation;`, `java/util/Map$Entry` 등.
/// 마지막 조각이 대문자로 시작해야 클래스로 본다(경로 문자열 오탐 방지).
final RegExp descriptor = RegExp(
  r'(?<![A-Za-z0-9_/$.])L?((?:[a-z][a-z0-9_]*/)+[A-Z][A-Za-z0-9_$]*)',
);

void main(List<String> args) {
  final File mappingFile = File(args.isNotEmpty ? args.first : defaultMapping);
  if (!mappingFile.existsSync()) {
    print('mapping.txt 가 없습니다: ${mappingFile.path}');
    print('먼저 release 빌드를 하세요 (isMinifyEnabled = true 일 때만 생성).');
    exit(2);
  }

  final Map<String, Set<String>> referenced = _jniReferences();
  if (referenced.isEmpty) {
    print('package:jni 를 쓰는 의존성이 없습니다. 검사할 것이 없어요.');
    exit(0);
  }

  final Map<String, String> mapping = _readClassMapping(mappingFile);
  final List<String> problems = [];
  for (final MapEntry<String, Set<String>> entry in referenced.entries) {
    final String javaName = entry.key.replaceAll('/', '.');
    final String? mapped = mapping[javaName];
    final String where = entry.value.join(', ');
    if (mapped == null) {
      problems.add('  $javaName  [없음 — R8 이 제거]\n    ← $where');
    } else if (mapped.startsWith(r'R8$$REMOVED')) {
      problems.add('  $javaName  [제거됨 → $mapped]\n    ← $where');
    } else if (mapped != javaName) {
      problems.add('  $javaName  [이름 바뀜 → $mapped]\n    ← $where');
    }
  }

  if (problems.isEmpty) {
    print('JNI 참조 클래스 ${referenced.length}개 모두 이름 그대로 남아 있습니다. ✅');
    exit(0);
  }

  print('⚠️  JNI 로 찾는 클래스 ${problems.length}개가 R8 에 지워졌거나 이름이 바뀌었습니다.');
  print('   런타임에 NoSuchMethodError / ClassNotFoundException 이 납니다.\n');
  problems.forEach(print);
  print('\n→ android/app/proguard-rules.pro 의 "package:jni" 항목에');
  print('  -keep class <이름> { *; } 를 추가하세요.');
  exit(1);
}

/// 클래스 디스크립터 → 그것을 참조한 패키지 이름들.
Map<String, Set<String>> _jniReferences() {
  final File config = File('.dart_tool/package_config.json');
  if (!config.existsSync()) {
    print(
      '.dart_tool/package_config.json 이 없습니다. fvm flutter pub get 을 먼저 하세요.',
    );
    exit(2);
  }
  final List<dynamic> packages =
      (jsonDecode(config.readAsStringSync())
              as Map<String, dynamic>)['packages']
          as List<dynamic>;

  final Map<String, Set<String>> found = {};
  for (final dynamic package in packages) {
    final String name = package['name'] as String;
    final String rootUri = package['rootUri'] as String;
    // 끝에 / 가 없으면 resolve 가 마지막 조각(패키지 폴더)을 갈아 끼운다.
    final Uri root = Uri.parse(rootUri.endsWith('/') ? rootUri : '$rootUri/');
    if (root.scheme != 'file') continue; // 앱 자신(상대 경로)은 제외
    final Directory lib = Directory.fromUri(root.resolve('lib/'));
    if (!lib.existsSync()) continue;

    for (final FileSystemEntity entity in lib.listSync(recursive: true)) {
      if (entity is! File || !entity.path.endsWith('.dart')) continue;
      final String source = entity.readAsStringSync();
      if (name != 'jni' && !source.contains('package:jni/')) continue;

      for (final RegExpMatch match in descriptor.allMatches(source)) {
        final String cls = match.group(1)!;
        if (platformPrefixes.any(cls.startsWith)) continue;
        found.putIfAbsent(cls, () => {}).add(name);
      }
    }
  }
  return found;
}

/// mapping.txt 의 클래스 줄(`원래 -> 바뀐:`)만 읽는다.
Map<String, String> _readClassMapping(File file) {
  final RegExp classLine = RegExp(r'^(\S+) -> (\S+):$');
  final Map<String, String> mapping = {};
  for (final String line in file.readAsLinesSync()) {
    final RegExpMatch? match = classLine.firstMatch(line);
    if (match != null) mapping[match.group(1)!] = match.group(2)!;
  }
  return mapping;
}
