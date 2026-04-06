import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/util/utilities.dart';

import '../../application/detail_providers.dart';

mixin class DetailEvent {
  const DetailEvent._();

  void handleRefresh(WidgetRef ref) =>
      ref.read(detailsProvider.notifier).refresh();

  double appbarHeight(WidgetRef ref, String title) =>
      ref.watch(detailAppbarHeightProvider(title));

  void increaseFontSize(WidgetRef ref) =>
      ref.read(appTextStylesFontSizeProvider.notifier).increaseFontSize();

  void decreaseFontSize(WidgetRef ref) =>
      ref.read(appTextStylesFontSizeProvider.notifier).decreaseFontSize();

  void initFontSize(WidgetRef ref) =>
      ref.read(appTextStylesFontSizeProvider.notifier).initFontSize();

  Future<bool> handleOpenBrowser(WidgetRef ref) =>
      ref.read(detailUrlProvider).openBrowser();

  Future<bool> handleShareUrl(WidgetRef ref) =>
      ref.read(detailUrlProvider).shareUrl();

  static List<Override> overridesProviderScope(
    BuildContext context,
    ListItem item,
  ) => [
    appTextStylesProvider.overrideWithValue(AppTextStyles.of(context)),
    listItemProvider.overrideWithValue(item),
    screenWidthProvider.overrideWithValue(MediaQuery.of(context).size.width),
    appbarTextStyleProvider.overrideWithValue(
      Platform.isIOS
          ? CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle
          : AppTextStyles.of(
              context,
            ).titleTextStyle.copyWith(color: Colors.white),
    ),
  ];
}
