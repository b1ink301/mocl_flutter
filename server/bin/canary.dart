import 'dart:io';

import 'package:mocl_server/src/canary/canary.dart';
import 'package:mocl_server/src/crawl/site_fetcher.dart';

/// 실제 사이트에서 목록 · 상세를 받아 파서가 아직 읽는지 확인한다.
///
///   dart run bin/canary.dart                      # 전체
///   dart run bin/canary.dart clien ppomppu        # 일부(SiteType 이름)
///   dart run bin/canary.dart --summary out.md     # 마크다운 표도 쓴다(GitHub 요약)
///
/// 종료 코드: 고장(broken)이 하나라도 있으면 1. 막힘(unreachable)은 경고로만 남긴다
/// — 실행한 곳의 IP 를 사이트가 막은 것이라 파서 문제인지 알 수 없다.
Future<void> main(List<String> args) async {
  String? summaryPath;
  final List<String> sites = [];
  for (int i = 0; i < args.length; i++) {
    if (args[i] == '--summary' && i + 1 < args.length) {
      summaryPath = args[++i];
    } else {
      sites.add(args[i]);
    }
  }

  final SiteFetcher fetcher = SiteFetcher();
  final Canary canary = Canary(fetcher: fetcher);
  final List<CanaryResult> results = [];
  for (final CanaryTarget target in canaryTargets) {
    if (sites.isNotEmpty && !sites.contains(target.site.name)) continue;
    final CanaryResult r = await canary.check(target);
    results.add(r);
    stdout.writeln(
      '${_label(r.status).padRight(5)} ${target.site.name.padRight(10)} '
      '${target.board.padRight(12)} n=${r.listCount}  ${r.message}'
      '${r.sampleTitle.isEmpty ? '' : '  "${_short(r.sampleTitle)}"'}',
    );
  }
  fetcher.close();

  final int broken = results
      .where((r) => r.status == CanaryStatus.broken)
      .length;
  final int unreachable = results
      .where((r) => r.status == CanaryStatus.unreachable)
      .length;
  stdout.writeln('\n${results.length}개 중 고장 $broken · 막힘 $unreachable');

  if (summaryPath != null) {
    File(summaryPath).writeAsStringSync(
      _markdown(results, broken, unreachable),
      mode: FileMode.append,
    );
  }
  exit(broken == 0 ? 0 : 1);
}

String _label(CanaryStatus s) => switch (s) {
  CanaryStatus.ok => 'OK',
  CanaryStatus.unreachable => 'BLOCK',
  CanaryStatus.broken => 'FAIL',
};

String _short(String s) => s.length > 30 ? '${s.substring(0, 30)}…' : s;

String _markdown(List<CanaryResult> results, int broken, int unreachable) {
  final StringBuffer b = StringBuffer()
    ..writeln('## 사이트 카나리')
    ..writeln()
    ..writeln('${results.length}개 중 고장 **$broken** · 막힘 $unreachable')
    ..writeln()
    ..writeln('| 상태 | 사이트 | 게시판 | 목록 | 내용 |')
    ..writeln('|---|---|---|---|---|');
  for (final CanaryResult r in results) {
    final String icon = switch (r.status) {
      CanaryStatus.ok => '✅',
      CanaryStatus.unreachable => '⚠️ 막힘',
      CanaryStatus.broken => '❌ 고장',
    };
    final String text = r.message.replaceAll('|', r'\|');
    b.writeln(
      '| $icon | ${r.target.site.name} | ${r.target.board} | '
      '${r.listCount} | $text |',
    );
  }
  return b.toString();
}
