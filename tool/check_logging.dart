// ignore_for_file: avoid_print
// lib/ 안에서 MoclLogger 를 우회하는 콘솔 로그를 검사합니다.
//
// 금지 대상:
//   - print(...)            : 릴리즈에서도 stdout(logcat)으로 출력됨
//   - debugPrint(...)       : 이름과 달리 릴리즈에서 제거되지 않음
//   - import 'dart:developer' 후 bare log(...) 호출
//
// 허용: lib/core/util/mocl_logger.dart (로거 구현체 자신)
//
// 사용법: dart run tool/check_logging.dart
import 'dart:io';

const String loggerImplPath = 'lib/core/util/mocl_logger.dart';

final RegExp _printCall = RegExp(r'(?<![\w.$])print\s*\(');
final RegExp _debugPrintCall = RegExp(r'(?<![\w.$])debugPrint\s*\(');
final RegExp _bareLogCall = RegExp(r'(?<![\w.$])log\s*\(');
final RegExp _developerImport = RegExp(r'''^\s*import\s+'dart:developer';''');

void main() {
  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    print('lib 디렉토리를 찾을 수 없습니다.');
    exit(1);
  }

  final violations = <String>[];

  for (final entity in libDir.listSync(recursive: true)) {
    if (entity is! File || !entity.path.endsWith('.dart')) continue;

    final path = entity.path.replaceAll('\\', '/');
    if (path == loggerImplPath) continue;
    if (path.endsWith('.g.dart') || path.endsWith('.freezed.dart')) continue;

    final lines = entity.readAsLinesSync();
    // 별칭 없는 dart:developer import 가 있는 파일에서만 bare log() 를 문제 삼는다.
    // (dart:math 의 log() 오탐 방지)
    final hasDeveloperImport = lines.any(_developerImport.hasMatch);

    for (var i = 0; i < lines.length; i++) {
      final line = lines[i];
      final trimmed = line.trim();
      if (trimmed.startsWith('//') || trimmed.startsWith('///')) continue;

      void report(String rule, String hint) => violations.add(
        '  $path:${i + 1}  [$rule]\n'
        '    $trimmed\n'
        '    → $hint',
      );

      if (_developerImport.hasMatch(line)) {
        report(
          'dart:developer',
          "MoclLogger 를 사용하세요. (import 'package:mocl_flutter/core/util/mocl_logger.dart')",
        );
      }
      if (_printCall.hasMatch(line)) {
        report('print', '릴리즈에서도 출력됩니다. MoclLogger.d/i/w/e 로 바꾸세요.');
      }
      if (_debugPrintCall.hasMatch(line)) {
        report('debugPrint', '릴리즈에서 제거되지 않습니다. MoclLogger.d/i/w/e 로 바꾸세요.');
      }
      if (hasDeveloperImport && _bareLogCall.hasMatch(line)) {
        report('log', 'MoclLogger.d(() => ...) 로 바꾸세요.');
      }
    }
  }

  if (violations.isEmpty) {
    print('No issues found! 🎉');
    print('모든 로그가 MoclLogger 를 통해 출력됩니다.');
    exit(0);
  }

  print('⚠️  ${violations.length}개의 위반 사항이 발견되었습니다:\n');
  print('규칙: lib/ 안의 콘솔 로그는 MoclLogger 를 통해서만 출력\n');
  for (final v in violations) {
    print(v);
    print('');
  }
  exit(1);
}
