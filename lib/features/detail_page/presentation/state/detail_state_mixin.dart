import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';

import '../../application/detail_providers.dart';

mixin class DetailState {
  AsyncValue<Details> detailState(WidgetRef ref) => ref.watch(detailsProvider);

  String titleState(WidgetRef ref) => ref.watch(detailTitleStateProvider);

  String smallTitleState(WidgetRef ref) => ref.watch(detailSmallTitleProvider);

  double appbarHeight(WidgetRef ref, String title) =>
      ref.watch(detailAppbarHeightProvider(title));
}
