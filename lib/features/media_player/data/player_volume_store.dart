import 'package:shared_preferences/shared_preferences.dart';

/// 플레이어 볼륨(0~1). 기기 볼륨 안에서 영상 소리만 줄이거나 키운다.
///
/// 음소거는 저장하지 않는다. 앱을 다시 켰는데 영상이 소리 없이 나오면 고장으로 보인다.
final class PlayerVolumeStore(final SharedPreferences _prefs) {
  static const String _key = 'media_player_volume';

  double load() => (_prefs.getDouble(_key) ?? 1).clamp(0, 1);

  Future<void> save(double volume) => _prefs.setDouble(_key, volume);
}
