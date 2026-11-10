import 'package:shared_preferences/shared_preferences.dart';

/// 사용자가 두 손가락으로 맞춘 미니 플레이어 폭(dp).
///
/// 화면 비율이 아니라 dp 로 둔다. 폴드를 펼치거나 돌려도 창 크기가 그대로 보이게.
final class MiniPlayerSizeStore(final SharedPreferences _prefs) {
  static const String _key = 'media_mini_player_width';

  double? load() => _prefs.getDouble(_key);

  Future<void> save(double width) => _prefs.setDouble(_key, width);
}
