import 'package:shared_preferences/shared_preferences.dart';

/// 본 이슈 id. 목록에서 흐리게 보여 준다. 최근 [limit] 개만 둔다(이슈는 하루면 지나간다).
final class IssueReadStore(final SharedPreferences _prefs) {
  static const String _key = 'issue_radar_read';
  static const int limit = 300;

  Set<String> load() => (_prefs.getStringList(_key) ?? const []).toSet();

  Future<Set<String>> add(String id) async {
    final List<String> ids = [
      ...(_prefs.getStringList(_key) ?? const <String>[]).where((e) => e != id),
      id,
    ];
    final List<String> kept = ids.length > limit
        ? ids.sublist(ids.length - limit)
        : ids;
    await _prefs.setStringList(_key, kept);
    return kept.toSet();
  }
}
