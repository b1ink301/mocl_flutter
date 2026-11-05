import 'dart:io';

import 'package:mocl_server/src/radar/clusterer.dart';
import 'package:mocl_server/src/radar/radar_store.dart';
import 'package:sembast/sembast_io.dart';

/// 실제로 쌓인 레이더 글로 묶기 결과를 본다(임계값 튜닝용).
///
///   `dart run bin/radar_eval.dart RADAR_DB [θ ...] [--hours 24] [--all]`
///
/// 서버에서: docker run --rm -v mocl_mocl_data:/data:ro -v ~/mocl:/src -w /src/server \
///   dart:3.13.7 sh -c "dart pub get >/dev/null && dart run bin/radar_eval.dart /data/radar.db 0.3 0.35 0.45"
Future<void> main(List<String> args) async {
  final String path = args.first;
  final bool all = args.contains('--all');
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
  final int since = DateTime.now().millisecondsSinceEpoch - hours * 3600 * 1000;
  final List<RadarPost> posts = await store.posts(since: since);
  final List<ClusterInput> inputs = [
    for (final p in posts) ClusterInput(p.key, p.site, p.title, p.firstSeenAt),
  ];
  stdout.writeln('posts=${posts.length} (최근 $hours시간)');

  for (final double t in thresholds.isEmpty ? const [0.45] : thresholds) {
    final Stopwatch w = Stopwatch()..start();
    final List<Cluster> clusters = Clusterer(threshold: t).run(inputs);
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
