import 'dart:io';

import 'package:mocl_server/src/radar/clusterer.dart';
import 'package:mocl_server/src/radar/radar_ranker.dart';
import 'package:mocl_server/src/radar/radar_store.dart';
import 'package:sembast/sembast_io.dart';

/// 실제로 쌓인 레이더 글로 묶기 결과를 본다(임계값 튜닝용).
///
///   `dart run bin/radar_eval.dart RADAR_DB [θ ...] [--hours 24] [--all] [--no-merge]`
///   `dart run bin/radar_eval.dart RADAR_DB --rank [--top 30]`
///   `dart run bin/radar_eval.dart RADAR_DB --diff [--hours 24]`
///
/// `--diff` 는 옛 묶기(중심과 근거를 따짐 · 시간 조건 없음)와 지금 묶기의 차이만 찍는다:
/// 옛 이슈 묶음이 갈라진 것 · 지금 이슈 묶음이 옛 묶음 여럿을 합친 것.
///
/// `--rank` 는 지금 랭킹과 옛 방식(합치기 · 속도 · 새로움 · 사이트 감쇠 없음)의 상위
/// 이슈를 나란히 찍는다. 기준 시각은 DB 의 마지막 수집 시각이다.
///
/// 서버에서: docker run --rm -v mocl_mocl_data:/data:ro -v ~/mocl:/src -w /src/server \
///   dart:3.13.7 sh -c "dart pub get >/dev/null && dart run bin/radar_eval.dart /data/radar.db 0.3 0.35 0.45"
Future<void> main(List<String> args) async {
  final String path = args.first;
  final bool all = args.contains('--all');
  final bool merge = !args.contains('--no-merge');
  final int hoursIdx = args.indexOf('--hours');
  final int hours = hoursIdx >= 0 ? int.parse(args[hoursIdx + 1]) : 24;
  final List<double> thresholds = [
    for (final a in args.skip(1))
      if (double.tryParse(a) case final double t when t < 1) t,
  ];

  // 읽기 전용 볼륨일 수 있어 복사본을 연다.
  final File copy = File('${Directory.systemTemp.path}/radar_eval.db');
  File(path).copySync(copy.path);
  final RadarStore store = RadarStore(
    await databaseFactoryIo.openDatabase(copy.path),
  );
  // 기준 시각은 DB 의 마지막 수집 시각(복사해 온 DB 로도 같은 결과가 나오게).
  final List<RadarPost> every = await store.posts();
  final int now = every
      .map((p) => p.lastSeenAt)
      .reduce((a, b) => a > b ? a : b);
  final List<RadarPost> posts = [
    for (final p in every)
      if (now - p.firstSeenAt <= hours * 3600 * 1000) p,
  ];
  final List<ClusterInput> inputs = [
    for (final p in posts) ClusterInput(p.key, p.site, p.title, p.firstSeenAt),
  ];
  stdout.writeln('posts=${posts.length} (최근 $hours시간)');

  if (args.contains('--rank')) {
    final int topIdx = args.indexOf('--top');
    final int top = topIdx >= 0 ? int.parse(args[topIdx + 1]) : 30;
    void show(String label, RadarRanker ranker) {
      final List<ScoredIssue> scored = ranker.score(every, now);
      stdout.writeln('\n===== $label (이슈 ${scored.length})');
      for (final (int i, ScoredIssue s) in scored.take(top).indexed) {
        final int ageMin = (now - s.issue.lastSeenAt) ~/ 60000;
        stdout.writeln(
          '${'${i + 1}'.padLeft(2)}. ${s.issue.score.toStringAsFixed(2).padLeft(6)}'
          ' 새로움 ${s.novelty.toStringAsFixed(2)}'
          ' ${s.issue.sites.length}곳 ${s.issue.posts.length}글 $ageMin분전'
          '${s.issue.trending ? ' ▲' : ''}  ${s.issue.title}',
        );
      }
    }

    show(
      '옛 방식',
      const RadarRanker(
        clusterer: Clusterer(merge: false, memberLink: false),
        siteDecay: 0,
        velocityWeight: 0,
        noveltyWeight: 0,
      ),
    );
    show('지금', const RadarRanker());
    exit(0);
  }

  if (args.contains('--diff')) {
    _diff(inputs, now);
    exit(0);
  }

  for (final double t in thresholds.isEmpty ? const [0.45] : thresholds) {
    final Stopwatch w = Stopwatch()..start();
    final List<Cluster> clusters = Clusterer(
      threshold: t,
      merge: merge,
    ).run(inputs);
    final List<Cluster> multiSite =
        clusters.where((c) => c.sites.length >= 2).toList()
          ..sort((a, b) => b.members.length.compareTo(a.members.length));
    final List<Cluster> multiPost = clusters
        .where((c) => c.members.length >= 2)
        .toList();
    stdout.writeln(
      '\n===== θ=$t  묶음 ${clusters.length} · 2글 이상 ${multiPost.length} · '
      '2사이트 이상 ${multiSite.length} · ${w.elapsedMilliseconds}ms',
    );
    for (final Cluster c in all ? multiPost : multiSite) {
      stdout.writeln('-- [${c.sites.join(',')}] ${c.members.length}글');
      for (final ClusterInput m in c.members.take(8)) {
        stdout.writeln('   ${m.site.padRight(10)} ${m.title}');
      }
    }
  }
  exit(0);
}

/// 이슈로 보이는 묶음(랭커와 같은 기준: 2곳 이상 또는 3글 이상).
bool _isIssue(Cluster c) => c.sites.length >= 2 || c.members.length >= 3;

void _diff(List<ClusterInput> inputs, int now) {
  final List<Cluster> before = const Clusterer(memberLink: false).run(inputs);
  final List<Cluster> after = const Clusterer().run(inputs);
  Map<String, Cluster> owner(List<Cluster> cs) => {
    for (final c in cs)
      for (final m in c.members) m.key: c,
  };
  final Map<String, Cluster> oldOf = owner(before);
  final Map<String, Cluster> newOf = owner(after);

  String line(ClusterInput m) {
    final int min = (now - m.at) ~/ 60000;
    return '     -${'${min ~/ 60}'.padLeft(2)}h${'${min % 60}'.padLeft(2, '0')} '
        '${m.site.padRight(10)} ${m.title}';
  }

  void show(String label, Cluster whole, Map<String, Cluster> partOf) {
    final Map<Cluster, List<ClusterInput>> parts = {};
    for (final m in whole.members) {
      (parts[partOf[m.key]!] ??= []).add(m);
    }
    stdout.writeln(
      '\n## $label ${whole.members.length}글 ${whole.sites.length}곳 → ${parts.length}조각',
    );
    for (final (int i, List<ClusterInput> ms) in parts.values.indexed) {
      stdout.writeln('  [${i + 1}] ${ms.length}글');
      for (final m in ms.take(6)) {
        stdout.writeln(line(m));
      }
      if (ms.length > 6) stdout.writeln('     … ${ms.length - 6}글 더');
    }
  }

  int split = 0, merged = 0;
  for (final Cluster c in before.where(_isIssue)) {
    if ({for (final m in c.members) newOf[m.key]}.length < 2) continue;
    split++;
    show('갈라짐(옛 묶음)', c, newOf);
  }
  for (final Cluster c in after.where(_isIssue)) {
    if ({for (final m in c.members) oldOf[m.key]}.length < 2) continue;
    merged++;
    show('합쳐짐(새 묶음)', c, oldOf);
  }
  stdout.writeln(
    '\n===== 이슈 묶음 옛 ${before.where(_isIssue).length} → 새 '
    '${after.where(_isIssue).length} · 갈라짐 $split · 합쳐짐 $merged',
  );
}
