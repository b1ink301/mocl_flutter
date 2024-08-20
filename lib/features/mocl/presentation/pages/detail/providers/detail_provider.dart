import 'dart:math';

import 'package:flutter/material.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/use_case_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../domain/entities/mocl_list_item.dart';
import '../../../../domain/entities/mocl_result.dart';

part 'detail_provider.g.dart';

@riverpod
class DetailState extends _$DetailState {
  late final ListItem _listItem;

  @override
  FutureOr<Result> build(ListItem item) {
    _listItem = item;
    return _getDetail(item);
  }

  Future<Result> _getDetail(ListItem item) {
    final getDetail = ref.read(getDetailProvider);
    final result = getDetail(item);

    ref.read(isReadStateProvider.notifier).setRead();

    // if (result is ResultSuccess<Details>){
    //   var aa = result as ResultSuccess<Details>;
    //   aa.data.title;

    // ref.read(appBarHeightStateProvider());
    // }
    return result;
  }

  void refresh() {
    state = const AsyncValue.loading();
    _getDetail(_listItem).then((data) {
      state = AsyncValue.data(data);
    }).catchError((error) {
      state = AsyncValue.error(
          ResultFailure(failure: GetDetailFailure()), StackTrace.current);
    });
  }
}

@riverpod
class AppBarHeightState extends _$AppBarHeightState {
  @override
  double build(BuildContext context, String text) {
    return _calculateTitleHeight(context, text);
  }

  double _calculateTitleHeight(BuildContext context, String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    )..layout(
        minWidth: 0,
        maxWidth:
            MediaQuery.of(context).size.width - (24 * 2 + 16 * 4 + 16 + 4));

    final titleHeight = textPainter.height;
    debugPrint('titleHeight = $titleHeight');

    return max(30, titleHeight) + 34; // 텍스트 높이 반환
  }
}
