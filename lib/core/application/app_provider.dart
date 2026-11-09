import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/usecases/get_site_type.dart';
import 'package:mocl_flutter/core/domain/usecases/set_site_type.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/settings_page/application/use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentSiteTypeNotifier() extends _$CurrentSiteTypeNotifier {
  @override
  SiteType build() {
    final GetSiteType getSiteType = ref.watch(getSiteTypeProvider);
    return getSiteType(NoParams());
  }

  void changeSiteType(SiteType siteType) {
    if (state != siteType) {
      final SetSiteType setSiteType = ref.read(setSiteTypeProvider);
      setSiteType(siteType);
      state = siteType;
    }
  }
}

/// 상세에서 글을 열었다는 신호(목록 행을 읽음으로 바꾸고 새 댓글 `+N` 을 지운다).
/// 같은 글을 다시 열어도 알리도록 순번을 붙인다.
@riverpod
class ReadableStateNotifier() extends _$ReadableStateNotifier {
  @override
  ({int id, int seq}) build() => (id: -1, seq: 0);

  void update(int newId) => state = (id: newId, seq: state.seq + 1);

  void clear() => state = (id: -1, seq: state.seq);
}

/// 영속화된 테마 모드(시스템/라이트/다크). `AppWidget`의 themeMode 에 연결된다.
@Riverpod(keepAlive: true)
class ThemeModeNotifier() extends _$ThemeModeNotifier {
  @override
  ThemeMode build() => ref.read(getThemeModeProvider)(NoParams());

  void change(ThemeMode mode) {
    if (state == mode) return;
    ref.read(setThemeModeProvider)(mode);
    state = mode;
  }
}

/// 시스템 밝기. 루트에서 `AppWidget`이 Theme 변경에 맞춰 갱신한다.
@Riverpod(keepAlive: true)
class CurrentBrightness() extends _$CurrentBrightness {
  @override
  Brightness build() =>
      WidgetsBinding.instance.platformDispatcher.platformBrightness;

  void update(Brightness brightness) {
    if (state != brightness) state = brightness;
  }
}

/// 영속화된 폰트 크기 델타(step 단위).
/// ProviderScope와 무관하게 앱 전역에서 공유된다.
@Riverpod(keepAlive: true)
class FontSizeDelta() extends _$FontSizeDelta {
  @override
  double build() => ref.read(getFontSizeProvider)(NoParams());

  void update(double step) {
    final double next = ref.read(setFontSizeProvider)(step);
    if (next != state) state = next;
  }

  void reset() {
    ref.read(initFontSizeProvider)(NoParams());
    if (state != 0) state = 0;
  }
}

/// 폰트 스케일이 적용된 앱 텍스트 스타일.
/// 밝기/델타 변화에 따라 자동 재계산된다.
@Riverpod(keepAlive: true, dependencies: [CurrentBrightness, FontSizeDelta])
class AppTextStylesFontSizeNotifier() extends _$AppTextStylesFontSizeNotifier {
  /// 한 스텝 = 5%. `exposure_±1` 아이콘 체감과 맞춘 값.
  static const double _kStep = 0.05;

  @override
  AppTextStyles build() {
    final Brightness brightness = ref.watch(currentBrightnessProvider);
    final double delta = ref.watch(fontSizeDeltaProvider);
    final AppTextStyles base = brightness == Brightness.dark
        ? AppTextStyles.dark
        : AppTextStyles.light;
    return base.scaled(1.0 + delta * _kStep);
  }

  void adjustFontSize(double step) {
    ref.read(fontSizeDeltaProvider.notifier).update(step);
  }

  void resetFontSize() {
    ref.read(fontSizeDeltaProvider.notifier).reset();
  }
}

/// 앱바 타이틀 스타일(폰트 크기 반영). Paper 테마에서 앱바는 밝은 배경 +
/// 잉크 텍스트라 별도 색 지정 없이 기본 잉크색을 굵게 쓴다.
@Riverpod(keepAlive: true, dependencies: [AppTextStylesFontSizeNotifier])
TextStyle appbarTextStyle(Ref ref) => ref.watch(
  appTextStylesFontSizeProvider.select(
    (s) => s.titleTextStyle.copyWith(fontWeight: FontWeight.w800),
  ),
);
