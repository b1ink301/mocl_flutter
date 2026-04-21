// ignore_for_file: avoid_print
// presentation/ 위젯 파일에서 application/ provider를 직접 import하는 것을 검사합니다.
// presentation/state/ mixin 파일은 제외합니다.
//
// 사용법: dart run tool/check_provider_imports.dart
import 'dart:io';

void main() {
  final libDir = Directory('lib/features');
  if (!libDir.existsSync()) {
    print('lib/features 디렉토리를 찾을 수 없습니다.');
    exit(1);
  }

  final violations = <String>[];

  for (final file in libDir.listSync(recursive: true)) {
    if (file is! File || !file.path.endsWith('.dart')) continue;

    final path = file.path.replaceAll('\\', '/');

    // presentation/ 하위 파일만 검사
    if (!path.contains('/presentation/')) continue;

    // presentation/state/ mixin 파일은 제외 (provider 접근 허용)
    if (path.contains('/presentation/state/')) continue;

    final lines = file.readAsLinesSync();
    for (var i = 0; i < lines.length; i++) {
      final line = lines[i].trim();

      // import 문만 검사
      if (!line.startsWith('import ')) continue;

      // 빈 줄이나 주석 이후는 더 이상 import가 아님
      if (line.isEmpty && i > 0) break;

      // application/ provider import 감지
      // core/application/은 공통 mixin(AppFontState 등)이 포함되어 있으므로 허용
      if (line.contains('/application/') &&
          !line.contains('core/application/')) {
        violations.add(
          '  $path:${i + 1}\n'
          '    $line\n'
          '    → presentation/state/ mixin을 통해 접근하세요.',
        );
      }
    }
  }

  if (violations.isEmpty) {
    print('No issues found! 🎉');
    print('모든 presentation 파일이 mixin을 통해 provider에 접근하고 있습니다.');
    exit(0);
  }

  print('⚠️  ${violations.length}개의 위반 사항이 발견되었습니다:\n');
  print('규칙: presentation/ 위젯에서 application/ provider를 직접 import 금지\n');
  for (final v in violations) {
    print(v);
    print('');
  }
  exit(1);
}
