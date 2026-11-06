// 기기에서 실제 사이트로 목록 → 상세를 열어 보는 확인(릴리스 전 수동 실행).
//
// 위젯 테스트는 가짜 데이터, 사이트 카나리는 파서만 본다. 이 스크립트는 앱을 띄워
// 사이트마다 게시판 → 글 → 끝까지 스크롤을 실제로 하고, 오류 화면 · 렌더 오류를 본다.
// LLM 없이 adb(uiautomator dump · input)만 쓴다.
//
//   fvm dart run tool/device_check.dart                    # debug 빌드 → 설치 → 전체
//   fvm dart run tool/device_check.dart nate clien         # 일부(SiteType 이름)
//   fvm dart run tool/device_check.dart --skip-build       # 깔려 있는 앱으로
//   fvm dart run tool/device_check.dart --serial emulator-5554
//
// debug 빌드를 쓴다: release 는 렌더 오류를 회색 상자로 숨겨 logcat 에 남지 않는다.
// 화면 요소는 글자와 Semantics identifier(Android resource-id)로 찾는다 —
// main_drawer · main_add · add_board_close · drawer_settings · failure_view ·
// detail_footer · flutter_error(위젯 빌드 오류 화면, main.dart).
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

/// logcat 에서 이 줄이 보이면 실패. debug 빌드의 Flutter 오류 보고 형식이다.
final RegExp _flutterError = RegExp(
  r'EXCEPTION CAUGHT BY|Another exception was thrown|RenderFlex overflowed|'
  r'FATAL EXCEPTION',
);

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

  final List<_Result> results = [];
  for (final (SiteType site, String board) in _targets) {
    if (only.isNotEmpty && !only.contains(site.name)) continue;
    results.add(
      await _guard(
        '${site.title} › $board',
        () => _checkSite(adb, site, board),
      ),
    );
  }
  if (only.isEmpty || only.contains('font')) {
    results.add(await _guard('글자 크기 범위', () => _checkFontSize(adb)));
  }

  final List<String> errors = (await adb.run(['logcat', '-d']))
      .split('\n')
      .where(_flutterError.hasMatch)
      .toList();

  stdout.writeln('');
  for (final _Result r in results) {
    stdout.writeln('${r.ok ? '✅' : '❌'} ${r.name}  ${r.detail}');
  }
  if (errors.isNotEmpty) {
    stdout.writeln('❌ logcat 의 Flutter 오류 ${errors.length}줄:');
    errors.take(10).forEach((e) => stdout.writeln('   $e'));
  }
  final int failed = results.where((r) => !r.ok).length;
  stdout.writeln(
    '\n${results.length}개 중 실패 $failed · logcat 오류 ${errors.length} · 스크린샷 $_shots/',
  );
  exit(failed == 0 && errors.isEmpty ? 0 : 1);
}

// ─── 확인 항목 ────────────────────────────────────────────────────────────────

/// 사이트 고르기 → 게시판 열기(없으면 담기) → 목록 → 두 번째 글 → 끝까지 스크롤.
Future<String> _checkSite(Adb adb, SiteType site, String board) async {
  await _restart(adb);
  await adb.tap(await adb.waitFor(byId('main_drawer'), '메뉴 버튼'));
  await adb.tap(
    await adb.waitFor(
      (n) => n.label.startsWith(site.title),
      '드로어의 ${site.title}',
    ),
  );
  // 드로어(머리의 "Mocl")가 닫히고 메인 제목이 바뀔 때까지. 드로어가 열린 채로
  // 읽으면 드로어 항목을 메인 목록으로 착각한다.
  await adb.waitForMany<bool>(
    (nodes) =>
        !nodes.any((n) => n.label == 'Mocl') &&
            nodes.any((n) => n.label == site.title && n.y < 600)
        ? true
        : null,
    '${site.title} 메인(드로어 닫힘)',
  );

  bool isBoardRow(Node n) => n.label == board && n.y > 400;
  // 담은 게시판은 DB 에서 비동기로 뜬다. 게시판 행이나 "담은 게시판이 없습니다" 가
  // 보일 때까지 기다린 뒤 판단한다(먼저 읽으면 담겨 있는 칩을 다시 눌러 빼 버린다).
  Node? row = await adb.waitForMany<Node>(
    (nodes) =>
        nodes.where(isBoardRow).firstOrNull ??
        (nodes.any((n) => n.label.contains('담은 게시판이 없습니다')) ||
                nodes.where((n) => n.y > 400 && n.label.isNotEmpty).length >= 2
            ? const Node('', '', 0, 0)
            : null),
    '${site.title} 메인 목록',
  );
  if (row.label.isEmpty) {
    // 담은 게시판에 없으면 게시판 추가 화면에서 담는다.
    await adb.tap(await adb.waitFor(byId('main_add'), '게시판 추가 버튼'));
    final Node chip = await adb.waitFor(
      (n) => n.label == board && n.x > 300,
      '게시판 칩 $board',
    );
    // 이미 담긴 칩을 누르면 빠진다. 담겨 있는데 메인에 안 보이면 건드리지 않고 멈춘다.
    if (chip.selected) {
      await adb.tap(await adb.waitFor(byId('add_board_close'), '닫기 버튼'));
      throw _Fail('$board 는 이미 담겨 있는데 메인에 보이지 않음');
    }
    await adb.tap(chip);
    await adb.tap(await adb.waitFor(byId('add_board_close'), '닫기 버튼'));
    row = await adb.waitFor(isBoardRow, '메인의 $board');
  }
  await adb.tap(row);

  // 목록: 글 행이 3개 이상(광고 행은 빼고). 오류 화면이면 바로 실패.
  final List<Node> rows = await adb.waitForMany(
    (nodes) => _articleRows(nodes).length >= 3 ? _articleRows(nodes) : null,
    '$board 글 목록',
  );
  await adb.tap(rows[1]);

  // 상세: 위쪽 크럼(사이트 › 게시판)이 보이면 열린 것.
  await adb.waitFor((n) => n.label.startsWith('${site.title} ›'), '상세 화면');
  await adb.screenshot('$_shots/${site.name}_top.png');

  // 끝까지 내려 하단 줄(detail_footer)이 보이면 본문 · 댓글이 끝까지 그려진 것.
  // 스와이프해도 화면이 그대로면 끝에 닿은 것이다(그때도 하단 줄이 없으면 실패).
  String comments = '';
  String previous = '';
  for (int i = 0; i < 80; i++) {
    final List<Node> nodes = await adb.dump();
    _throwIfFailure(nodes, '상세');
    comments =
        nodes
            .map((n) => RegExp(r'^댓글 (\d+)').firstMatch(n.label)?.group(0))
            .nonNulls
            .firstOrNull ??
        comments;
    if (nodes.any((n) => n.id == 'detail_footer' && n.y < 2700)) {
      await adb.screenshot('$_shots/${site.name}_bottom.png');
      return '목록 ${rows.length}+ · ${comments.isEmpty ? '댓글 없음/미표시' : comments} · 하단 도달';
    }
    final String screen = nodes.map((n) => '${n.label}@${n.y}').join('|');
    if (screen == previous) break;
    previous = screen;
    await adb.swipeUp();
  }
  await adb.screenshot('$_shots/${site.name}_bottom.png');
  throw _Fail('상세 끝에 하단 줄(detail_footer)이 없음');
}

/// 설정 → 글자 크기: 계속 키워도 +10, 계속 줄여도 −5 에서 멈추고, 초기화하면 기본.
Future<String> _checkFontSize(Adb adb) async {
  await _restart(adb);
  await adb.tap(await adb.waitFor(byId('main_drawer'), '메뉴 버튼'));
  await adb.tap(await adb.waitFor(byId('drawer_settings'), '설정 버튼'));
  await adb.waitFor((n) => n.label == '글자 크기', '설정의 글자 크기');

  /// 값 표시(기본 · +N · -N)는 "글자 크게" 바로 앞 노드이고, 누르면 초기화된다.
  Future<Node> value() async {
    final List<Node> nodes = await adb.dump();
    final int i = nodes.indexWhere((n) => n.label == '글자 크게');
    if (i <= 0) throw _Fail('글자 크기 조절 버튼을 못 찾음');
    return nodes[i - 1];
  }

  // 글자가 커지면 행이 밀리므로 누를 때마다 위치를 다시 읽는다.
  Future<void> press(String label, int times) async {
    for (int i = 0; i < times; i++) {
      await adb.tap(await adb.waitFor((n) => n.label == label, label));
    }
  }

  await adb.tap(await value());
  await press('글자 크게', 13);
  final String max = (await value()).label;
  await press('글자 작게', 18);
  final String min = (await value()).label;
  await adb.tap(await value());
  final String reset = (await value()).label;

  if (max != '+10' || min != '-5' || reset != '기본') {
    throw _Fail('최대 $max · 최소 $min · 초기화 $reset (기대 +10 · -5 · 기본)');
  }
  return '최대 $max · 최소 $min · 초기화 $reset';
}

// ─── 도우미 ──────────────────────────────────────────────────────────────────

/// 글 목록의 글 행: 긴 글자를 가진 아래쪽 노드. 광고 행은 뺀다.
List<Node> _articleRows(List<Node> nodes) {
  _throwIfFailure(nodes, '목록');
  return nodes
      .where(
        (n) =>
            n.y > 450 &&
            n.y < 2300 &&
            n.label.length >= 8 &&
            !n.label.startsWith('Test Ad') &&
            !n.label.contains('광고'),
      )
      .toList();
}

void _throwIfFailure(List<Node> nodes, String where) {
  if (nodes.any((n) => n.id == 'flutter_error')) {
    throw _Fail('$where 위젯 빌드 오류 화면(flutter_error)');
  }
  if (nodes.any((n) => n.id == 'failure_view')) {
    final String text = nodes
        .where((n) => n.label.isNotEmpty)
        .map((n) => n.label)
        .join(' / ');
    throw _Fail(
      '$where 오류 화면: ${text.length > 120 ? text.substring(0, 120) : text}',
    );
  }
}

Future<void> _restart(Adb adb) async {
  await adb.shell(['am', 'force-stop', _package]);
  await adb.shell(['am', 'start', '-W', '-n', _activity]);
}

bool Function(Node) byId(String id) =>
    (n) => n.id == id;

Future<_Result> _guard(String name, Future<String> Function() body) async {
  stdout.writeln('▶ $name');
  try {
    return _Result(name, true, await body());
  } on _Fail catch (e) {
    return _Result(name, false, e.message);
  }
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

class const _Result(final String name, final bool ok, final String detail);

class const _Fail(final String message) implements Exception;

/// UI 트리의 노드 하나. [label] 은 text 와 content-desc 를 합친 것.
class const Node(
  final String label,
  final String id,
  final int x,
  final int y, {
  final bool selected = false,
});

class Adb(final String serial) {
  static const Duration _timeout = Duration(seconds: 20);

  Future<String> run(List<String> args) async {
    final ProcessResult r = await Process.run('adb', ['-s', serial, ...args]);
    if (r.exitCode != 0) throw _Fail('adb ${args.join(' ')}: ${r.stderr}');
    return r.stdout as String;
  }

  Future<String> shell(List<String> args) => run(['shell', ...args]);

  Future<List<Node>> dump() async {
    await shell(['uiautomator', 'dump', '/sdcard/device_check.xml']);
    final String xml = await run([
      'exec-out',
      'cat',
      '/sdcard/device_check.xml',
    ]);
    final RegExp attr = RegExp(r'([\w-]+)="([^"]*)"');
    final List<Node> nodes = [];
    for (final Match m in RegExp(r'<node ([^>]*)>').allMatches(xml)) {
      final Map<String, String> a = {
        for (final Match am in attr.allMatches(m[1]!))
          am[1]!: _unescape(am[2]!),
      };
      final List<int> b = RegExp(r'\d+')
          .allMatches(a['bounds'] ?? '')
          .map((e) => int.parse(e[0]!))
          .toList();
      if (b.length != 4) continue;
      final String label = [a['text'], a['content-desc']]
          .whereType<String>()
          .where((s) => s.trim().isNotEmpty)
          .join(' ')
          // 아이콘 글리프(사용자 정의 영역 문자, 예: 행 끝 화살표)는 이름이 아니다.
          .replaceAll(RegExp('[\uE000-\uF8FF]'), '')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      nodes.add(
        Node(
          label,
          a['resource-id'] ?? '',
          (b[0] + b[2]) ~/ 2,
          (b[1] + b[3]) ~/ 2,
          selected: a['selected'] == 'true',
        ),
      );
    }
    return nodes;
  }

  Future<Node> waitFor(bool Function(Node) test, String what) =>
      waitForMany((nodes) => nodes.where(test).firstOrNull, what);

  /// [pick] 이 null 이 아닌 값을 줄 때까지 화면을 다시 읽는다.
  Future<T> waitForMany<T extends Object>(
    T? Function(List<Node>) pick,
    String what,
  ) async {
    final DateTime until = DateTime.now().add(_timeout);
    while (true) {
      final List<Node> nodes = await dump();
      // 위젯 빌드 오류 화면(main.dart _tagErrorWidget)은 어디서든 바로 실패.
      if (nodes.any((n) => n.id == 'flutter_error')) {
        throw _Fail('"$what" 을(를) 기다리는 중 위젯 빌드 오류 화면(flutter_error)');
      }
      final T? found = pick(nodes);
      if (found != null) return found;
      if (DateTime.now().isAfter(until)) {
        throw _Fail('${_timeout.inSeconds}초 안에 "$what" 이(가) 보이지 않음');
      }
      await Future<void>.delayed(const Duration(milliseconds: 700));
    }
  }

  Future<void> tap(Node n) async {
    await shell(['input', 'tap', '${n.x}', '${n.y}']);
    await Future<void>.delayed(const Duration(milliseconds: 600));
  }

  Future<void> swipeUp() async {
    await shell(['input', 'swipe', '640', '2400', '640', '500', '150']);
    await Future<void>.delayed(const Duration(milliseconds: 400));
  }

  Future<void> screenshot(String path) async {
    final ProcessResult r = await Process.run('adb', [
      '-s',
      serial,
      'exec-out',
      'screencap',
      '-p',
    ], stdoutEncoding: null);
    File(path).writeAsBytesSync(r.stdout as List<int>);
  }

  static String _unescape(String s) => s
      .replaceAll('&#10;', '\n')
      .replaceAll('&quot;', '"')
      .replaceAll('&apos;', "'")
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&amp;', '&');
}
