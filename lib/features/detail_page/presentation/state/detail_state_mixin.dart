import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';

import '../../../../config/mocl_text_styles.dart';
import '../../../../core/application/app_provider.dart';
import '../../application/detail_providers.dart';

mixin class DetailState {
  AppTextStyles appTextStyles(WidgetRef ref) => ref.watch(appTextStylesFontSizeProvider);

  AsyncValue<Details> detailState(WidgetRef ref) => ref.watch(detailsProvider);

  String titleState(WidgetRef ref) => ref.watch(detailTitleStateProvider);

  String smallTitleState(WidgetRef ref) => ref.watch(detailSmallTitleProvider);

  double appbarHeight(WidgetRef ref, String title) =>
      ref.watch(detailAppbarHeightProvider(title));
}
