import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/misc.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/util/utilities.dart';

import '../../application/detail_providers.dart';

mixin class DetailEvent {
  void handleRefresh(WidgetRef ref) =>
      ref.read(detailsProvider.notifier).refresh();

  void adjustFontSize(WidgetRef ref, double step) =>
      ref.read(appTextStylesFontSizeProvider.notifier).adjustFontSize(step);

  void resetFontSize(WidgetRef ref) =>
      ref.read(appTextStylesFontSizeProvider.notifier).resetFontSize();

  Future<bool> handleOpenBrowser(WidgetRef ref) =>
      ref.read(detailUrlProvider).openBrowser();

  Future<bool> handleShareUrl(WidgetRef ref) =>
      ref.read(detailUrlProvider).shareUrl();

  static List<Override> overridesProviderScope(
    BuildContext context,
    ListItem item,
  ) => [
    listItemProvider.overrideWithValue(item),
    screenWidthProvider.overrideWithValue(MediaQuery.of(context).size.width),
  ];
}
