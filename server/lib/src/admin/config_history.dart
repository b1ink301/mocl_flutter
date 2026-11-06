import 'dart:io';

/// 관리 화면이 설정을 바꾸기 전 파일 내용을 남겨 두는 곳.
///
/// 파일 이름은 저장한 시각(ms)이다. [keep] 개를 넘으면 오래된 것부터 지운다.
/// 데이터 볼륨(`DATA_DIR`)에 두어 매일 백업(`ops/backup.sh`)에 함께 묶인다.
class ConfigHistory(final Directory dir, {final int keep = 50}) {
  static final RegExp _id = RegExp(r'^\d{13,16}$');

  /// 최신부터. `(id, 크기)`.
  List<({String id, int bytes})> list() {
    if (!dir.existsSync()) return const [];
    final List<({String id, int bytes})> entries = [
      for (final FileSystemEntity e in dir.listSync())
        if (e is File && e.path.endsWith('.json'))
          if (_idOf(e) case final String id) (id: id, bytes: e.lengthSync()),
    ];
    entries.sort((a, b) => int.parse(b.id).compareTo(int.parse(a.id)));
    return entries;
  }

  /// [id] 의 내용. 없거나 id 가 이상하면 null(경로 조작 방지).
  String? read(String id) {
    if (!_id.hasMatch(id)) return null;
    final File file = File('${dir.path}/$id.json');
    return file.existsSync() ? file.readAsStringSync() : null;
  }

  /// [text] 를 [nowMs] 시각으로 남기고 id 를 돌려준다.
  String add(String text, int nowMs) {
    dir.createSync(recursive: true);
    int stamp = nowMs;
    while (File('${dir.path}/$stamp.json').existsSync()) {
      stamp++;
    }
    File('${dir.path}/$stamp.json').writeAsStringSync(text, flush: true);
    for (final ({String id, int bytes}) old in list().skip(keep)) {
      File('${dir.path}/${old.id}.json').deleteSync();
    }
    return '$stamp';
  }

  String? _idOf(File file) {
    final String name = file.uri.pathSegments.last;
    final String id = name.substring(0, name.length - '.json'.length);
    return _id.hasMatch(id) ? id : null;
  }
}
