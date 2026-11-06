import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';

typedef ListFetch = Future<List<ListItem>> Function(
  SiteType site, {
  required String board,
  required String url,
  String boardTitle,
});

/// 같은 게시판을 짧은 시간에 두 번 받지 않게 한다(키워드 알림 · 레이더가 같은
/// 게시판을 볼 때). 실패는 저장하지 않는다.
class BoardCache(
  final ListFetch _fetch, {
  final Duration ttl = const Duration(seconds: 150),
  final DateTime Function() clock = DateTime.now,
}) {
  final Map<String, (DateTime, Future<List<ListItem>>)> _entries = {};

  Future<List<ListItem>> fetch(
    SiteType site, {
    required String board,
    required String url,
    String boardTitle = '',
  }) {
    final String key = '${site.name}|$board';
    final DateTime now = clock();
    final (DateTime, Future<List<ListItem>>)? hit = _entries[key];
    if (hit != null && now.difference(hit.$1) < ttl) return hit.$2;

    final Future<List<ListItem>> future = _fetch(
      site,
      board: board,
      url: url,
      boardTitle: boardTitle,
    );
    _entries[key] = (now, future);
    // 실패한 결과는 바로 버려 다음 호출이 다시 받게 한다.
    future.catchError((Object _) {
      if (identical(_entries[key]?.$2, future)) _entries.remove(key);
      return const <ListItem>[];
    });
    _entries.removeWhere((_, v) => now.difference(v.$1) >= ttl * 4);
    return future;
  }
}
