import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_read_flag.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/use_case_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'detail_providers.g.dart';

@riverpod
ListItem listItem(ref) => throw UnimplementedError('listItem');

@Riverpod(dependencies: [listItem])
class DetailsNotifier extends _$DetailsNotifier {
  @override
  Future<Details> build() async {
    state = const AsyncValue.loading();
    final ListItem listItem = ref.watch(listItemProvider);
    final Either<Failure, Details> result =
        await ref.read(getDetailProvider)(listItem);
    final Details data = result.getOrElse((f) => throw f);
    ref.read(_markAsReadProvider(listItem));
    return data;
  }

  void refresh() => ref.invalidateSelf();
}

@riverpod
Future<int> _markAsRead(Ref ref, ListItem listItem) async {
  if (!listItem.isRead) {
    final SiteType siteType = ref.read(currentSiteTypeNotifierProvider);
    final SetReadFlagParams params =
        SetReadFlagParams(siteType: siteType, boardId: listItem.id);
    final SetReadFlag setReadFlag = ref.read(setReadProvider);
    final int result = await setReadFlag(params);
    ref.read(readableStateNotifierProvider.notifier).update(listItem.id);
    return result;
  }
  return -1;
}

@Riverpod(dependencies: [listItem, detailTitle])
String detailSmallTitle(Ref ref) {
  final String title = ref.watch(
      currentSiteTypeNotifierProvider.select((siteType) => siteType.title));
  final String boardTitle =
      ref.watch(listItemProvider.select((item) => item.boardTitle));
  return '$title > $boardTitle';
}

@Riverpod(dependencies: [listItem])
String detailTitle(Ref ref) {
  final String title = ref.watch(listItemProvider.select((item) => item.title));
  return title;
}

@Riverpod(dependencies: [listItem, CurrentSiteTypeNotifier])
String detailUrl(Ref ref) {
  final SiteType siteType = ref.watch(currentSiteTypeNotifierProvider);
  final ListItem listItem = ref.watch(listItemProvider);
  return siteType == SiteType.naverCafe
      ? 'https://m.cafe.naver.com/ca-fe/web/cafes/${listItem.board}/articles/${listItem.id}'
      : listItem.url;
}

const double _kMoreIconSize = 48.0; // more 아이콘의 크기
const double _kHorizontalPadding = 16.0; // 좌우 패딩
const double _kMinTextHeight = 30.0; // 최소 텍스트 높이
const double _kExtraVerticalSpace = 36.0; // 추가 수직 공간

@Riverpod(dependencies: [appbarTextStyle, screenWidth])
double detailAppbarHeight(
  Ref ref,
  String text,
) {
  final TextStyle style = ref.watch(appbarTextStyleProvider);
  final double screenWidth = ref.watch(screenWidthProvider);

  final double availableWidth =
      screenWidth - _kMoreIconSize - (_kHorizontalPadding * 2); // 좌우 패딩

  final TextPainter textPainter = TextPainter(
    text: TextSpan(
      text: text,
      style: style,
    ),
    maxLines: 3,
    textDirection: TextDirection.ltr,
  )..layout(
      minWidth: 0,
      maxWidth: availableWidth,
    );

  // 최소 높이와 비교하여 더 큰 값 반환
  return max(_kMinTextHeight, textPainter.height) + _kExtraVerticalSpace;
}
