import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/presentation/widgets/nick_image_widget.dart';
import 'package:mocl_flutter/core/usecases/usecase.dart';
import 'package:mocl_flutter/di/use_case_provider.dart';
import 'package:mocl_flutter/features/settings/domain/usecases/get_site_type.dart';
import 'package:mocl_flutter/features/settings/domain/usecases/set_site_type.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'app_provider.g.dart';

@Riverpod(keepAlive: true)
class CurrentSiteTypeNotifier extends _$CurrentSiteTypeNotifier {
  @override
  SiteType build() {
    final GetSiteType getSiteType = ref.read(getSiteTypeProvider);
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

@Riverpod(keepAlive: true)
Future<String> getAppVersion(Ref ref) async {
  final PackageInfo info = await PackageInfo.fromPlatform();
  final String version = 'v${info.version}-${info.buildNumber}';
  return version;
}

@riverpod
Future<void> clearData(Ref ref) async {
  await NickImageWidget.clearCache();
  await InAppWebViewController.clearAllCache();

  // CookieManager.instance().deleteAllCookies();
  await Future.delayed(Duration(milliseconds: 300));
}

@riverpod
TextStyle appbarTextStyle(Ref ref) =>
    throw UnimplementedError('appbarTextStyle');

@Riverpod(keepAlive: true)
double screenWidth(Ref ref) => throw UnimplementedError('screenWidth');

@Riverpod(keepAlive: true)
AppTextStyles appTextStyles(Ref ref) =>
    throw UnimplementedError('appTextStyles');

class CurrentTextStyles extends Equatable {
  final TextStyle titleTextStyle;
  final TextStyle readTitleTextStyle;
  final TextStyle smallTextStyle;
  final TextStyle readSmallTextStyle;
  final TextStyle badgeTextStyle;
  final TextStyle readBadgeTextStyle;

  const CurrentTextStyles({
    required this.titleTextStyle,
    required this.readTitleTextStyle,
    required this.smallTextStyle,
    required this.readSmallTextStyle,
    required this.badgeTextStyle,
    required this.readBadgeTextStyle,
  });

  CurrentTextStyles copyWith({
    TextStyle? titleTextStyle,
    TextStyle? readTitleTextStyle,
    TextStyle? smallTextStyle,
    TextStyle? readSmallTextStyle,
    TextStyle? badgeTextStyle,
    TextStyle? readBadgeTextStyle,
  }) => CurrentTextStyles(
    titleTextStyle: titleTextStyle ?? this.titleTextStyle,
    readTitleTextStyle: readTitleTextStyle ?? this.readTitleTextStyle,
    smallTextStyle: smallTextStyle ?? this.smallTextStyle,
    readSmallTextStyle: readSmallTextStyle ?? this.readSmallTextStyle,
    badgeTextStyle: badgeTextStyle ?? this.badgeTextStyle,
    readBadgeTextStyle: readBadgeTextStyle ?? this.readBadgeTextStyle,
  );

  @override
  List<Object?> get props => [
    titleTextStyle,
    readTitleTextStyle,
    smallTextStyle,
    readSmallTextStyle,
    badgeTextStyle,
    readBadgeTextStyle,
  ];
}

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

  void increaseFontSize({double fontSize = 0.5}) {
    state = state.copyWith(
      titleTextStyle: _changeFontSize(state.titleTextStyle, fontSize),
      readTitleTextStyle: _changeFontSize(state.readTitleTextStyle, fontSize),
      smallTextStyle: _changeFontSize(state.smallTextStyle, fontSize),
      readSmallTextStyle: _changeFontSize(state.readSmallTextStyle, fontSize),
      badgeTextStyle: _changeFontSize(state.badgeTextStyle, fontSize),
      readBadgeTextStyle: _changeFontSize(state.readBadgeTextStyle, fontSize),
    );
    ref.read(setFontSizeProvider)(fontSize);
    debugPrint('[increaseFontSize] state=$state');
  }

  TextStyle _changeFontSize(TextStyle style, double fontSize) =>
      style.copyWith(fontSize: style.fontSize! + fontSize);

  void decreaseFontSize({double fontSize = -0.5}) {
    state = state.copyWith(
      titleTextStyle: _changeFontSize(state.titleTextStyle, fontSize),
      readTitleTextStyle: _changeFontSize(state.readTitleTextStyle, fontSize),
      smallTextStyle: _changeFontSize(state.smallTextStyle, fontSize),
      readSmallTextStyle: _changeFontSize(state.readSmallTextStyle, fontSize),
      badgeTextStyle: _changeFontSize(state.badgeTextStyle, fontSize),
      readBadgeTextStyle: _changeFontSize(state.readBadgeTextStyle, fontSize),
    );

    ref.read(setFontSizeProvider)(fontSize);
    debugPrint('[decreaseFontSize] state=$state');
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
