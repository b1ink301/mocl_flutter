// 기기에서 실제 사이트로 목록 → 상세를 열어 보는 확인(릴리스 전 수동 실행).
//
// 위젯 테스트는 가짜 데이터, 사이트 카나리는 파서만 본다. 이 스크립트는 앱을 띄워
// 사이트마다 게시판 → 글 → 끝까지 스크롤을 실제로 하고, 오류 화면을 본다.
// AI 없이 Marionette CLI(위젯 트리 읽기 · 누르기 · scroll-to)와 adb(설치 · 재시작)만 쓴다.
//
//   fvm dart run tool/device_check.dart                    # debug 빌드 → 설치 → 전체
//   fvm dart run tool/device_check.dart nate clien font    # 일부(SiteType 이름, font)
//   fvm dart run tool/device_check.dart --skip-build       # 깔려 있는 앱으로
//   fvm dart run tool/device_check.dart --serial emulator-5554
//
// 준비: `dart pub global activate marionette_cli`(marionette 명령).
// debug 빌드를 쓴다 — Marionette 는 debug 앱의 VM service 에 붙는다(core/dev/marionette_setup.dart).
// 사이트마다 앱을 다시 띄워(adb) 깨끗한 상태에서 시작하고, 로그의 VM service 주소를
// adb forward 로 연결한다. flutter run 은 필요 없다.
//
// 화면 요소는 글자 · Semantics identifier · 위젯 종류로 찾는다. 쓰는 id:
// main_drawer · site_drawer · main_add · add_board_close · tab_settings · detail_footer.
// FailureView(목록/상세 실패)가 보이면 바로 실패하고, 확인마다 앱 로그(get-logs)의
// Flutter 오류(main.dart 가 debug 에서 MoclLogger 로 남김)를 검사한다.
// 스크린샷은 build/device_check/ 에 남는다.
//
// 담은 게시판이 없으면 게시판 추가 화면에서 담는다(기기의 앱 데이터가 바뀐다).
import 'dart:async';
import 'dart:io';

import 'package:mocl_shared/entities/mocl_site_type.dart';

const String _package = 'kr.b1ink.mocl.dev';
const String _activity = '$_package/net.b1ink.mocl_flutter.MainActivity';
const String _apk = 'build/app/outputs/flutter-apk/app-dev-debug.apk';
const String _shots = 'build/device_check';

/// 기기의 VM service 를 이 호스트 포트로 넘긴다.
const int _hostPort = 9102;

/// 사이트마다 여는 게시판(게시판 추가 화면의 이름 그대로). 로그인이 필요한
/// 네이버카페 · 레딧은 넣지 않는다.
const List<(SiteType, String)> _targets = [
  (SiteType.nate, '실시간 인기톡 랭킹'),
  (SiteType.clien, '모두의공원'),
  (SiteType.damoang, '자유게시판'),
  (SiteType.dcinside, '실시간 베스트'),
  (SiteType.ppomppu, '뽐뿌게시판(핫딜)'),
  (SiteType.ruliweb, '전체 베스트'),
  (SiteType.theqoo, '전체'),
  (SiteType.bobaedream, '베스트글'),
  (SiteType.cook82, '자유게시판'),
  (SiteType.dogdrip, '개드립'),
  (SiteType.geekNews, '최신글'),
  (SiteType.instiz, '일상·유머 (전체)'),
  (SiteType.inven, '오픈이슈갤러리'),
  (SiteType.meeco, '자유 게시판'),
  (SiteType.mlbpark, '불펜 (자유게시판)'),
  (SiteType.arcalive, '베스트 라이브'),
];

Future<void> main(List<String> args) async {
  String? serial;
  bool build = true;
  final Set<String> only = {};
  for (int i = 0; i < args.length; i++) {
    switch (args[i]) {
      case '--serial':
        serial = args[++i];
      case '--skip-build':
        build = false;
      default:
        only.add(args[i]);
    }
  }

  final String marionette = await _findMarionette();
  final Adb adb = Adb(serial ?? await _pickDevice());
  if (build) {
    await _run('fvm', [
      'flutter',
      'build',
      'apk',
      '--debug',
      '--flavor',
      'dev',
      if (File('ads.json').existsSync()) '--dart-define-from-file=ads.json',
    ]);
    await adb.run(['install', '-r', _apk]);
  }
  Directory(_shots).createSync(recursive: true);
  await adb.run(['logcat', '-c']);

  final Stopwatch watch = Stopwatch()..start();
  final List<_Result> results = [];
  Future<void> check(String name, Future<String> Function(App) body) async {
    stdout.writeln('▶ $name');
    final Stopwatch one = Stopwatch()..start();
    App? app;
    try {
      app = await App.launch(adb, marionette);
      final String detail = await body(app);
      final String error = await app.flutterError();
      results.add(
        error.isEmpty
            ? _Result(name, true, detail, one.elapsed)
            : _Result(name, false, error, one.elapsed),
      );
    } on _Fail catch (e) {
      // 화면에서 막혔어도 원인이 위젯 오류면 그걸 알린다.
      final String error = await app?.flutterError() ?? '';
      results.add(
        _Result(
          name,
          false,
          error.isEmpty ? e.message : '$error (${e.message})',
          one.elapsed,
        ),
      );
    }
  }

  for (final (SiteType site, String board) in _targets) {
    if (only.isNotEmpty && !only.contains(site.name)) continue;
    await check(
      '${site.title} › $board',
      (app) => _checkSite(app, site, board),
    );
  }
  if (only.isEmpty || only.contains('font')) {
    await check('글자 크기 범위', _checkFontSize);
  }

  // 화면은 멀쩡해도 네이티브 쪽에서 죽은 경우.
  final List<String> crashes = (await adb.run(['logcat', '-d']))
      .split('\n')
      .where(
        (l) => l.contains('FATAL EXCEPTION') || l.contains('ANR in $_package'),
      )
      .toList();

  stdout.writeln('');
  for (final _Result r in results) {
    stdout.writeln(
      '${r.ok ? '✅' : '❌'} ${r.name}  ${r.detail}  (${r.took.inSeconds}초)',
    );
  }
  if (crashes.isNotEmpty) {
    stdout.writeln('❌ logcat 크래시 ${crashes.length}줄:');
    crashes.take(10).forEach((e) => stdout.writeln('   $e'));
  }
  final int failed = results.where((r) => !r.ok).length;
  stdout.writeln(
    '\n${results.length}개 중 실패 $failed · 크래시 ${crashes.length} · '
    '${watch.elapsed.inMinutes}분 ${watch.elapsed.inSeconds % 60}초 · 스크린샷 $_shots/',
  );
  exit(failed == 0 && crashes.isEmpty ? 0 : 1);
}

// ─── 확인 항목 ────────────────────────────────────────────────────────────────

/// 사이트 고르기 → 게시판 열기(없으면 담기) → 목록 → 두 번째 글 → 끝까지 스크롤.
Future<String> _checkSite(App app, SiteType site, String board) async {
  await app.tapId('main_drawer');
  // 사이트 드로어의 칩(메인 제목과 글자가 같으므로 위치로 가른다 — 제목은 y 94~122,
  // 드로어 첫 줄 칩은 y 162 근처).
  await app.tap(
    await app.waitFor(
      (e) => e.text == site.title && e.y > 140,
      '사이트 드로어의 ${site.title}',
    ),
  );
  // 드로어(site_drawer)가 닫히고 메인 제목이 바뀔 때까지.
  await app.waitForAll<bool>(
    (els) =>
        !els.any((e) => e.id == 'site_drawer') &&
            els.any((e) => e.text == site.title && e.y < 160)
        ? true
        : null,
    '${site.title} 메인',
  );

  // 메인 큰 제목은 y 94~122, 첫 게시판 행은 y 149 근처.
  bool isBoardRow(El e) => e.text == board && e.y > 130;
  // 담은 게시판은 DB 에서 비동기로 뜬다. 게시판 행 · 빈 안내 · 다른 게시판 중 하나가 보이면 판단.
  final El? row = await app
      .waitForAll<_Maybe<El>>((els) {
        final El? found = els.where(isBoardRow).firstOrNull;
        if (found != null) return _Maybe(found);
        final bool loaded =
            els.any((e) => e.text.contains('담은 게시판이 없어요')) ||
            els.any((e) => e.y > 150 && e.text.isNotEmpty);
        return loaded ? const _Maybe(null) : null;
      }, '${site.title} 메인 목록')
      .then((m) => m.value);
  await app.tap(row ?? await _addBoard(app, board, isBoardRow));

  // 목록: 글 행이 3개 이상(광고 · 글 정보 줄은 빼고).
  final List<El> rows = await app.waitForAll((els) {
    final List<El> titles = els
        .where(
          (e) =>
              e.y > 150 &&
              e.text.length >= 8 &&
              !e.text.contains('읽음') &&
              !e.text.startsWith('Test Ad') &&
              !e.text.contains('광고'),
        )
        .toList();
    return titles.length >= 3 ? titles : null;
  }, '$board 글 목록');
  await app.tap(rows[1]);

  // 상세: 크럼(사이트 › 게시판)은 앱바라 받기 전에도 보인다.
  await app.waitFor((e) => e.text.startsWith('${site.title} ›'), '상세 화면');

  // 하단 줄(detail_footer)은 상세를 다 받은 뒤에만 생긴다. 거기까지 스크롤되면
  // 받기 · 본문 · 댓글이 끝까지 그려진 것. 받는 동안은 실패하므로 잠깐씩 다시 해 본다.
  // (본문이 사진뿐인 글도 있어 본문 글자로는 판단하지 않는다)
  // 댓글 수는 스크롤 전 화면에 "댓글 N" 이 보일 때만 적는다(참고용, 합격 기준 아님).
  String comments = '';
  bool reached = false;
  bool topShot = false;
  final DateTime until = DateTime.now().add(const Duration(seconds: 25));
  while (!reached && DateTime.now().isBefore(until)) {
    final List<El> els = await app.elements();
    if (!topShot && els.any((e) => e.y > 150 && e.text.isNotEmpty)) {
      await app.screenshot('$_shots/${site.name}_top.png');
      topShot = true;
    }
    if (comments.isEmpty) comments = _commentCount(els);
    reached = await app.scrollToId('detail_footer');
    if (!reached) await Future<void>.delayed(const Duration(milliseconds: 700));
  }
  await app.screenshot('$_shots/${site.name}_bottom.png');
  if (!reached) throw const _Fail('상세 끝(하단 줄 detail_footer)에 닿지 못함');
  return '목록 ${rows.length}+ · ${comments.isEmpty ? '댓글 수 미확인' : comments} · 하단 도달';
}

/// 게시판 추가 화면에서 [board] 를 담고 메인의 그 행을 돌려준다.
///
/// 칩의 담김 상태는 트리에 드러나지 않아 머리의 "N개"(이 사이트에 담은 수)로 판단한다.
/// 누른 뒤 수가 줄면 이미 담겨 있던 것 — 다시 눌러 되돌리고 멈춘다.
Future<El> _addBoard(
  App app,
  String board,
  bool Function(El) isBoardRow,
) async {
  await app.tapId('main_add');
  final El chip = await app.waitFor(
    (e) => e.text == board && e.x > 100,
    '게시판 칩 $board',
  );
  int count(List<El> els) =>
      els
          .map((e) => RegExp(r'^(\d+)개$').firstMatch(e.text)?.group(1))
          .nonNulls
          .map(int.parse)
          .firstOrNull ??
      0;
  final int before = count(await app.elements());
  await app.tap(chip);
  final int after = count(await app.elements());
  if (after < before) {
    await app.tap(chip);
    await app.tapId('add_board_close');
    throw _Fail('$board 는 이미 담겨 있는데 메인에 보이지 않음');
  }
  await app.tapId('add_board_close');
  return app.waitFor(isBoardRow, '메인의 $board');
}

/// 설정 → 글자 크기: 계속 키워도 +10, 계속 줄여도 −5 에서 멈추고, 초기화하면 기본.
Future<String> _checkFontSize(App app) async {
  await app.tapId('tab_settings');
  await app.waitFor((e) => e.text == '글자 크기', '설정의 글자 크기');

  /// 값 표시(기본 · +N · -N). 누르면 초기화된다.
  Future<El> value() =>
      app.waitFor((e) => RegExp(r'^(기본|[+-]\d+)$').hasMatch(e.text), '글자 크기 값');

  // 글자가 커지면 행이 밀리므로 누를 때마다 위치를 다시 읽는다(버튼 이름은 Tooltip).
  Future<void> press(String tooltip, int times) async {
    for (int i = 0; i < times; i++) {
      await app.tap(
        await app.waitFor(
          (e) => e.type == 'Tooltip' && e.text == tooltip,
          tooltip,
        ),
      );
    }
  }

  await app.tap(await value());
  await press('글자 크게', 13);
  final String max = (await value()).text;
  await press('글자 작게', 18);
  final String min = (await value()).text;
  await app.tap(await value());
  final String reset = (await value()).text;

  if (max != '+10' || min != '-5' || reset != '기본') {
    throw _Fail('최대 $max · 최소 $min · 초기화 $reset (기대 +10 · -5 · 기본)');
  }
  return '최대 $max · 최소 $min · 초기화 $reset';
}

String _commentCount(List<El> els) =>
    els
        .map((e) => RegExp(r'^댓글 \d+').firstMatch(e.text)?.group(0))
        .nonNulls
        .firstOrNull ??
    '';

// ─── Marionette · adb ────────────────────────────────────────────────────────

/// 위젯 트리의 요소 하나(Marionette `get-interactive-elements` 한 줄). 좌표는 논리 픽셀.
class const El(
  final String type,
  final String text,
  final String id,
  final double x,
  final double y,
  final double width,
  final double height,
);

/// 띄운 앱 하나에 붙은 Marionette.
class App(final String _marionette, final String _uri) {
  static const Duration _timeout = Duration(seconds: 20);

  /// 앱을 새로 띄우고 VM service 에 붙는다.
  static Future<App> launch(Adb adb, String marionette) async {
    final RegExp vm = RegExp(
      r'Dart VM service is listening on http://127\.0\.0\.1:(\d+)/([^/\s]+)/',
      caseSensitive: false,
    );
    Future<List<Match>> vmLines() async => vm
        .allMatches(await adb.run(['logcat', '-d', '-s', 'flutter']))
        .toList();

    final int seen = (await vmLines()).length;
    await adb.shell(['am', 'force-stop', _package]);
    await adb.shell(['am', 'start', '-W', '-n', _activity]);

    final DateTime until = DateTime.now().add(_timeout);
    List<Match> lines = await vmLines();
    while (lines.length <= seen) {
      if (DateTime.now().isAfter(until)) {
        throw const _Fail('앱 로그에 VM service 주소가 없음(debug 빌드인지 확인)');
      }
      await Future<void>.delayed(const Duration(milliseconds: 500));
      lines = await vmLines();
    }
    final Match last = lines.last;
    await adb.run(['forward', 'tcp:$_hostPort', 'tcp:${last[1]}']);
    final App app = App(marionette, 'ws://127.0.0.1:$_hostPort/${last[2]}/ws');
    await app.waitFor((e) => e.id == 'main_drawer', '앱 첫 화면');
    return app;
  }

  Future<ProcessResult> _cli(List<String> args) =>
      Process.run(_marionette, ['--uri', _uri, ...args]);

  Future<void> _must(List<String> args) async {
    final ProcessResult r = await _cli(args);
    if (r.exitCode != 0) {
      throw _Fail(
        'marionette ${args.join(' ')}: ${'${r.stdout}${r.stderr}'.trim()}',
      );
    }
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }

  Future<void> tapId(String id) => _must(['tap', '--identifier', id]);

  /// 앱 로그(get-logs)에 남은 첫 문제: Flutter 오류(main.dart 가 debug 에서 남김)나
  /// 화면 데이터 실패(`Provider 실패: …`, 예: 사이트가 403 으로 막음). 없으면 빈 문자열.
  /// Marionette 자신의 scroll-to 실패(`Widget not found`)는 앱 오류가 아니라 뺀다.
  Future<String> flutterError() async {
    final ProcessResult r = await _cli(['get-logs']);
    if (r.exitCode != 0) return '';
    for (final Match m in RegExp(
      r'(FlutterError: .*|Provider 실패: .*)',
    ).allMatches(r.stdout as String)) {
      final String line = m[1]!.trim();
      if (line.contains('Widget not found')) continue;
      return line;
    }
    return '';
  }

  Future<void> tap(El e) => _must([
    'tap',
    '--x',
    (e.x + e.width / 2).toStringAsFixed(0),
    '--y',
    (e.y + e.height / 2).toStringAsFixed(0),
  ]);

  /// [id] 가 보일 때까지 스크롤한다. 끝까지 가도 없으면 false.
  Future<bool> scrollToId(String id) async =>
      (await _cli(['scroll-to', '--identifier', id])).exitCode == 0;

  Future<void> screenshot(String path) =>
      _must(['take-screenshots', '--no-open', '--output', path]);

  /// 지금 화면의 요소. 실패 화면(FailureView)이 보이면 바로 실패.
  Future<List<El>> elements() async {
    final ProcessResult r = await _cli(['get-interactive-elements']);
    if (r.exitCode != 0) return const [];
    final List<El> els = _parse(r.stdout as String);
    final El? error = els.where((e) => e.type == 'FailureView').firstOrNull;
    if (error != null) {
      final String text = els
          .where((e) => e.y >= error.y && e.text.isNotEmpty)
          .take(3)
          .map((e) => e.text)
          .join(' / ');
      throw _Fail(
        '실패 화면: '
        '${text.length > 140 ? text.substring(0, 140) : text}',
      );
    }
    return els;
  }

  Future<El> waitFor(bool Function(El) test, String what) =>
      waitForAll((els) => els.where(test).firstOrNull, what);

  /// [pick] 이 null 이 아닌 값을 줄 때까지 화면을 다시 읽는다.
  Future<T> waitForAll<T extends Object>(
    T? Function(List<El>) pick,
    String what,
  ) async {
    final DateTime until = DateTime.now().add(_timeout);
    while (true) {
      final T? found = pick(await elements());
      if (found != null) return found;
      if (DateTime.now().isAfter(until)) {
        throw _Fail('${_timeout.inSeconds}초 안에 "$what" 이(가) 보이지 않음');
      }
      await Future<void>.delayed(const Duration(milliseconds: 400));
    }
  }

  /// `Type: X, Text: "...", identifier: "...", bounds: {...}` 줄들을 읽는다.
  /// 글자 안에 줄바꿈이 있을 수 있어 "Type: " 로 시작하는 줄로 나눈다.
  static List<El> _parse(String out) {
    final RegExp bounds = RegExp(
      r'bounds: \{"x":([\d.-]+),"y":([\d.-]+),"width":([\d.]+),"height":([\d.]+)\}',
    );
    final RegExp textRe = RegExp(
      r'Text: "(.*?)"(?:, [A-Za-z]+: |, bounds)',
      dotAll: true,
    );
    final List<El> els = [];
    for (final String chunk
        in out.split(RegExp(r'^Type: ', multiLine: true)).skip(1)) {
      final Match? b = bounds.firstMatch(chunk);
      if (b == null) continue;
      final int comma = chunk.indexOf(',');
      els.add(
        El(
          (comma < 0 ? chunk : chunk.substring(0, comma)).trim(),
          textRe
                  .firstMatch(chunk)
                  ?.group(1)
                  ?.replaceAll(RegExp(r'\s+'), ' ')
                  .trim() ??
              '',
          RegExp(r'identifier: "([^"]*)"').firstMatch(chunk)?.group(1) ?? '',
          double.parse(b[1]!),
          double.parse(b[2]!),
          double.parse(b[3]!),
          double.parse(b[4]!),
        ),
      );
    }
    return els;
  }
}

class Adb(final String serial) {
  Future<String> run(List<String> args) async {
    final ProcessResult r = await Process.run('adb', ['-s', serial, ...args]);
    if (r.exitCode != 0) throw _Fail('adb ${args.join(' ')}: ${r.stderr}');
    return r.stdout as String;
  }

  Future<String> shell(List<String> args) => run(['shell', ...args]);
}

// ─── 도우미 ──────────────────────────────────────────────────────────────────

Future<String> _findMarionette() async {
  final String home = Platform.environment['HOME'] ?? '';
  for (final String path in ['$home/.pub-cache/bin/marionette', 'marionette']) {
    try {
      if ((await Process.run(path, ['--help'])).exitCode == 0) return path;
    } on ProcessException {
      continue;
    }
  }
  stderr.writeln(
    'marionette 명령이 없습니다: fvm dart pub global activate marionette_cli',
  );
  exit(2);
}

Future<String> _pickDevice() async {
  final String out = (await Process.run('adb', ['devices'])).stdout as String;
  final List<String> devices = [
    for (final String line in out.split('\n').skip(1))
      if (line.trim().endsWith('\tdevice')) line.split('\t').first,
  ];
  if (devices.length != 1) {
    stderr.writeln('기기가 ${devices.length}대입니다. --serial 로 지정하세요: $devices');
    exit(2);
  }
  return devices.single;
}

Future<void> _run(String cmd, List<String> args) async {
  final Process p = await Process.start(
    cmd,
    args,
    mode: ProcessStartMode.inheritStdio,
  );
  if (await p.exitCode != 0) {
    stderr.writeln('실패: $cmd ${args.join(' ')}');
    exit(1);
  }
}

class const _Result(
  final String name,
  final bool ok,
  final String detail,
  final Duration took,
);

class const _Fail(final String message) implements Exception;

/// "찾았는데 없음"(null)과 "아직 모름"을 가르는 상자.
class const _Maybe<T>(final T? value);
