import 'package:mocl_flutter/config/accent_palette.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/features/settings_page/application/datasource_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'accent_provider.g.dart';

/// 강조색을 어디서 정하나.
enum AccentMode() {
  /// 기본 코랄.
  coral,

  /// 보고 있는 사이트 색. 목록 · 상세는 그 화면의 사이트 색(`SiteAccentTheme`),
  /// 홈 · 설정 등은 드로어에서 고른 사이트 색.
  site,

  /// 고정 팔레트에서 하나([AccentPalette.custom]).
  custom,
}

typedef AccentSetting = ({AccentMode mode, int custom});

/// 설정 "강조색". 부팅 때 바로 쓰도록 동기 SharedPreferences 에서 읽는다(코랄로 떴다가 바뀌지 않게).
@Riverpod(keepAlive: true)
class AccentSettingNotifier() extends _$AccentSettingNotifier {
  static const String _modeKey = 'accent_mode';
  static const String _customKey = 'accent_custom';

  @override
  AccentSetting build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final AccentMode mode =
        AccentMode.values.asNameMap()[prefs.getString(_modeKey)] ??
        AccentMode.coral;
    final int custom = (prefs.getInt(_customKey) ?? 0).clamp(
      0,
      AccentPalette.custom.length - 1,
    );
    return (mode: mode, custom: custom);
  }

  Future<void> selectMode(AccentMode mode) async {
    if (state.mode == mode) return;
    state = (mode: mode, custom: state.custom);
    await ref.read(sharedPreferencesProvider).setString(_modeKey, mode.name);
  }

  /// 팔레트 색을 고른다(모드도 "직접 고르기" 로).
  Future<void> selectCustom(int index) async {
    state = (mode: AccentMode.custom, custom: index);
    final prefs = ref.read(sharedPreferencesProvider);
    await prefs.setString(_modeKey, AccentMode.custom.name);
    await prefs.setInt(_customKey, index);
  }
}

/// 앱 전체(테마)의 강조색. 사이트 색 모드면 드로어에서 고른 사이트 색.
@Riverpod(keepAlive: true)
AccentColors appAccent(Ref ref) {
  final AccentSetting setting = ref.watch(accentSettingProvider);
  return switch (setting.mode) {
    AccentMode.coral => AccentPalette.coral,
    AccentMode.custom => AccentPalette.custom[setting.custom],
    AccentMode.site => AccentPalette.site(ref.watch(currentSiteTypeProvider)),
  };
}
