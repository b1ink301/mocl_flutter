import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/domain/usecases/get_site_type.dart';
import 'package:mocl_flutter/core/domain/usecases/set_site_type.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/features/settings_page/application/use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentSiteTypeNotifier extends _$CurrentSiteTypeNotifier {
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

@riverpod
class ReadableStateNotifier extends _$ReadableStateNotifier {
  @override
  int build() => -1;

  void update(int newId) {
    if (state != newId) {
      state = newId;
    }
  }

  void clear() => state = -1;
}

@Riverpod(keepAlive: true)
double screenWidth(Ref ref) => throw UnimplementedError('screenWidth');

/// 시스템 밝기. 루트에서 `AppWidget`이 Theme 변경에 맞춰 갱신한다.
@Riverpod(keepAlive: true)
class CurrentBrightness extends _$CurrentBrightness {
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
class FontSizeDelta extends _$FontSizeDelta {
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
class AppTextStylesFontSizeNotifier extends _$AppTextStylesFontSizeNotifier {
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

/// 앱바 타이틀용 흰색 스타일(폰트 크기 반영).
@Riverpod(keepAlive: true, dependencies: [AppTextStylesFontSizeNotifier])
TextStyle appbarTextStyle(Ref ref) => ref.watch(
  appTextStylesFontSizeProvider.select(
    (s) => s.titleTextStyle.copyWith(color: Colors.white),
  ),
);
