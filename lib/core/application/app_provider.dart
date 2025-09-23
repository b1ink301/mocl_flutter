import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/presentation/models/current_text_styles.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/settings_page/application/use_case_provider.dart';
import '../../features/settings_page/domain/usecases/get_site_type.dart';
import '../../features/settings_page/domain/usecases/set_site_type.dart';

part 'app_provider.g.dart';

mixin AppFontState {
  CurrentTextStyles fontSizeSate(WidgetRef ref) =>
      ref.watch(appTextStylesFontSizeProvider);

  TextStyle titleTextStyleSate(WidgetRef ref) => ref.watch(
    appTextStylesFontSizeProvider.select((state) => state.titleTextStyle),
  );

  (TextStyle, TextStyle) smallTitleAndTitleTextStyleSate(WidgetRef ref) => ref.watch(
    appTextStylesFontSizeProvider.select(
          (style) => (style.smallTextStyle, style.titleTextStyle),
    ),
  );
}
//
// mixin class SiteTypeState {
//   SiteType siteType(WidgetRef ref) => ref.watch(currentSiteTypeProvider);
// }
//
// mixin class SiteTypeEvent {
//   void changeSiteType(WidgetRef ref, SiteType siteType) =>
//       ref.read(currentSiteTypeProvider.notifier).changeSiteType(siteType);
// }


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

    debugPrint('[changeSiteType] siteType=$siteType, state=$state');
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

@Riverpod(keepAlive: true, dependencies: [appTextStyles])
class AppTextStylesFontSizeNotifier extends _$AppTextStylesFontSizeNotifier {
  @override
  CurrentTextStyles build() {
    final textStyles = ref.watch(appTextStylesProvider);
    final fontSize = ref.read(getFontSizeProvider)(NoParams());

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
    state = state.copyWith(
      titleTextStyle: _changeFontSize(state.titleTextStyle, fontSize),
      readTitleTextStyle: _changeFontSize(state.readTitleTextStyle, fontSize),
      smallTextStyle: _changeFontSize(state.smallTextStyle, fontSize),
      readSmallTextStyle: _changeFontSize(state.readSmallTextStyle, fontSize),
      badgeTextStyle: _changeFontSize(state.badgeTextStyle, fontSize),
      readBadgeTextStyle: _changeFontSize(state.readBadgeTextStyle, fontSize),
    );

    ref.read(setFontSizeProvider)(fontSize);
  }

  TextStyle _changeFontSize(TextStyle style, double fontSize) =>
      style.copyWith(fontSize: style.fontSize! + fontSize);

  void decreaseFontSize({double fontSize = -0.3}) {
    state = state.copyWith(
      titleTextStyle: _changeFontSize(state.titleTextStyle, fontSize),
      readTitleTextStyle: _changeFontSize(state.readTitleTextStyle, fontSize),
      smallTextStyle: _changeFontSize(state.smallTextStyle, fontSize),
      readSmallTextStyle: _changeFontSize(state.readSmallTextStyle, fontSize),
      badgeTextStyle: _changeFontSize(state.badgeTextStyle, fontSize),
      readBadgeTextStyle: _changeFontSize(state.readBadgeTextStyle, fontSize),
    );

    ref.read(setFontSizeProvider)(fontSize);
  }

  void initFontSize() {
    final textStyles = ref.read(appTextStylesProvider);
    state = state.copyWith(
      titleTextStyle: textStyles.titleTextStyle,
      readTitleTextStyle: textStyles.readTitleTextStyle,
      smallTextStyle: textStyles.smallTextStyle,
      readSmallTextStyle: textStyles.readSmallTextStyle,
      badgeTextStyle: textStyles.badgeTextStyle,
      readBadgeTextStyle: textStyles.readBadgeTextStyle,
    );

    ref.read(initFontSizeProvider)(NoParams());
  }

  TextStyle badge(bool isRead) =>
      isRead ? state.readBadgeTextStyle : state.badgeTextStyle;

  TextStyle title(bool isRead) =>
      isRead ? state.readTitleTextStyle : state.titleTextStyle;

  TextStyle smallTitle(bool isRead) =>
      isRead ? state.readSmallTextStyle : state.smallTextStyle;
}
