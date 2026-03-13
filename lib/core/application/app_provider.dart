import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/presentation/models/current_text_styles.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:mocl_flutter/core/domain/usecases/get_site_type.dart';
import 'package:mocl_flutter/core/domain/usecases/set_site_type.dart';
import 'package:mocl_flutter/features/settings_page/application/use_case_provider.dart';

part 'app_provider.g.dart';

mixin AppFontState {
  CurrentTextStyles fontSizeSate(WidgetRef ref) =>
      ref.watch(appTextStylesFontSizeProvider);

  TextStyle titleTextStyleSate(WidgetRef ref) => ref.watch(
    appTextStylesFontSizeProvider.select((state) => state.titleTextStyle),
  );

  (TextStyle, TextStyle) smallTitleAndTitleTextStyleSate(WidgetRef ref) =>
      ref.watch(
        appTextStylesFontSizeProvider.select(
          (style) => (style.smallTextStyle, style.titleTextStyle),
        ),
      );
}

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

@Riverpod(keepAlive: true)
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

@riverpod
TextStyle appbarTextStyle(Ref ref) =>
    throw UnimplementedError('appbarTextStyle');

@Riverpod(keepAlive: true)
double screenWidth(Ref ref) => throw UnimplementedError('screenWidth');

@Riverpod(keepAlive: true)
AppTextStyles appTextStyles(Ref ref) =>
    throw UnimplementedError('appTextStyles');

/// Global font size delta provider.
/// NOT dependent on scoped providers, so changes propagate across ALL
/// ProviderScopes (detail, list, main pages all share this instance).
@Riverpod(keepAlive: true)
class FontSizeDelta extends _$FontSizeDelta {
  @override
  double build() => ref.read(getFontSizeProvider)(NoParams());

  void update(double delta) {
    ref.read(setFontSizeProvider)(delta);
    state = ref.read(getFontSizeProvider)(NoParams());
  }

  void reset() {
    ref.read(initFontSizeProvider)(NoParams());
    state = 0;
  }
}

@Riverpod(keepAlive: true, dependencies: [appTextStyles, FontSizeDelta])
class AppTextStylesFontSizeNotifier extends _$AppTextStylesFontSizeNotifier {
  @override
  CurrentTextStyles build() {
    final textStyles = ref.watch(appTextStylesProvider);
    final fontSize = ref.watch(fontSizeDeltaProvider);

    return CurrentTextStyles(
      titleTextStyle: _changeFontSize(textStyles.titleTextStyle, fontSize),
      readTitleTextStyle: _changeFontSize(
        textStyles.readTitleTextStyle,
        fontSize,
      ),
      smallTextStyle: _changeFontSize(textStyles.smallTextStyle, fontSize),
      readSmallTextStyle: _changeFontSize(
        textStyles.readSmallTextStyle,
        fontSize,
      ),
      badgeTextStyle: _changeFontSize(textStyles.badgeTextStyle, fontSize),
      readBadgeTextStyle: _changeFontSize(
        textStyles.readBadgeTextStyle,
        fontSize,
      ),
    );
  }

  void increaseFontSize({double fontSize = 0.3}) {
    ref.read(fontSizeDeltaProvider.notifier).update(fontSize);
  }

  TextStyle _changeFontSize(TextStyle style, double fontSize) =>
      style.copyWith(fontSize: style.fontSize! + fontSize);

  void decreaseFontSize({double fontSize = -0.3}) {
    ref.read(fontSizeDeltaProvider.notifier).update(fontSize);
  }

  void initFontSize() {
    ref.read(fontSizeDeltaProvider.notifier).reset();
  }

  TextStyle badge(bool isRead) =>
      isRead ? state.readBadgeTextStyle : state.badgeTextStyle;

  TextStyle title(bool isRead) =>
      isRead ? state.readTitleTextStyle : state.titleTextStyle;

  TextStyle smallTitle(bool isRead) =>
      isRead ? state.readSmallTextStyle : state.smallTextStyle;
}
