import 'package:mocl_shared/entities/mocl_main_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// 게시판마다 최근 검색어를 기기에 둔다(최신이 앞, 최대 [limit] 개).
final class SearchHistoryStore(final SharedPreferences _prefs) {
  static const int limit = 10;
  static const String _prefix = 'search_history';

  static String _key(MainItem board) =>
      '${_prefix}_${board.siteType.name}_${board.board}';

  List<String> load(MainItem board) =>
      _prefs.getStringList(_key(board)) ?? const [];

  /// [keyword] 를 맨 앞에 둔다(이미 있으면 옮긴다). 바뀐 목록을 돌려준다.
  List<String> add(MainItem board, String keyword) {
    final String word = keyword.trim();
    if (word.isEmpty) return load(board);
    final List<String> next = [
      word,
      ...load(board).where((w) => w != word),
    ].take(limit).toList();
    _prefs.setStringList(_key(board), next);
    return next;
  }

  List<String> remove(MainItem board, String keyword) {
    final List<String> next = load(board).where((w) => w != keyword).toList();
    _prefs.setStringList(_key(board), next);
    return next;
  }

  void clear(MainItem board) => _prefs.remove(_key(board));
}
