import 'package:shared_preferences/shared_preferences.dart';

/// 자동 업데이트 안내를 마지막으로 띄운 기록. 사용자가 "나중에" 를 고른
/// 버전을 앱을 켤 때마다 다시 묻지 않도록 한다. (설정에서 직접 누르면 무시)
final class AppUpdatePromptStore(final SharedPreferences _prefs) {
  /// 같은 버전을 다시 묻기까지의 간격. iOS(upgrader) 기본값과 맞춘다.
  static const Duration interval = Duration(days: 3);

  static const String _keyVersion = 'app_update_prompted_version';
  static const String _keyAt = 'app_update_prompted_at';

  /// [version] 을 지금 안내해도 되는지. 처음 보는 버전이면 바로 묻는다.
  bool shouldPrompt(String version, {DateTime? now}) {
    if (_prefs.getString(_keyVersion) != version) return true;
    final int? at = _prefs.getInt(_keyAt);
    if (at == null) return true;
    final DateTime last = DateTime.fromMillisecondsSinceEpoch(at);
    return (now ?? DateTime.now()).difference(last) >= interval;
  }

  Future<void> markPrompted(String version, {DateTime? now}) async {
    await _prefs.setString(_keyVersion, version);
    await _prefs.setInt(_keyAt, (now ?? DateTime.now()).millisecondsSinceEpoch);
  }
}
