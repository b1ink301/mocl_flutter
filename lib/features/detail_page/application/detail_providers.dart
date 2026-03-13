import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_details.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/detail_page/application/use_case_provider.dart';
import 'package:mocl_flutter/features/detail_page/domain/usecases/set_read_flag.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'detail_providers.g.dart';

@riverpod
ListItem listItem(Ref ref) => throw UnimplementedError('listItem');

@Riverpod(dependencies: [listItem, DetailTitleStateNotifier, _markAsRead])
class DetailsNotifier extends _$DetailsNotifier {
  @override
  Future<Details> build() async {
    state = const AsyncValue.loading();
    final listItem = ref.watch(listItemProvider);
    final result = await ref.read(getDetailProvider)(listItem);
    final data = result.getOrElse((f) => throw f);
    await ref.watch(_markAsReadProvider(listItem).future);
    ref.read(detailTitleStateProvider.notifier).update(data.title);
    return data;
  }

  void refresh() => ref.invalidateSelf();
}

@riverpod
Future<int> _markAsRead(Ref ref, ListItem listItem) async {
  if (!listItem.isRead) {
    final siteType = ref.read(currentSiteTypeProvider);
    final params = SetReadFlagParams(siteType: siteType, boardId: listItem.id);
    final int result = await ref.read(setReadFlagProvider)(params);
    ref.read(readableStateProvider.notifier).update(listItem.id);
    return result;
  }
  return -1;
}

@Riverpod(dependencies: [listItem, detailTitle])
String detailSmallTitle(Ref ref) {
  final String boardTitle = ref.watch(
    listItemProvider.select((item) => item.boardTitle),
  );
  if (Platform.isIOS) {
    return boardTitle;
  } else {
    final String title = ref.watch(
      currentSiteTypeProvider.select((siteType) => siteType.title),
    );

    return '$title > $boardTitle';
  }
}

@Riverpod(dependencies: [listItem, detailTitle])
class DetailTitleStateNotifier extends _$DetailTitleStateNotifier {
  @override
  String build() => ref.watch(detailTitleProvider);

  void update(String title) {
    if (title.isNotEmpty && state != title) {
      state = title;
    }
  }
}

@Riverpod(dependencies: [listItem])
String detailTitle(Ref ref) =>
    ref.watch(listItemProvider.select((item) => item.title));

@Riverpod(dependencies: [listItem, CurrentSiteTypeNotifier])
String detailUrl(Ref ref) {
  final siteType = ref.watch(currentSiteTypeProvider);
  final listItem = ref.watch(listItemProvider);
  return siteType == SiteType.naverCafe
      ? 'https://m.cafe.naver.com/ca-fe/web/cafes/${listItem.board}/articles/${listItem.id}'
      : listItem.url;
}

const double _kMoreIconSize = 48.0; // more 아이콘의 크기
const double _kHorizontalPadding = 16.0; // 좌우 패딩
double _kMinTextHeight = !Platform.isIOS ? 30 : 10; // 최소 텍스트 높이
double _kExtraVerticalSpace = !Platform.isIOS ? 36 : 0; // 추가 수직 공간

@Riverpod(dependencies: [appbarTextStyle, screenWidth, FontSizeDelta])
double detailAppbarHeight(Ref ref, String text) {
  final TextStyle baseStyle = ref.watch(appbarTextStyleProvider);
  final double fontSizeDelta = ref.watch(fontSizeDeltaProvider);
  final double screenWidth = ref.watch(screenWidthProvider);

  // fontSizeDelta를 반영한 실제 렌더링 스타일로 높이 계산
  final TextStyle style = fontSizeDelta != 0
      ? baseStyle.copyWith(fontSize: (baseStyle.fontSize ?? 14) + fontSizeDelta)
      : baseStyle;

  final double availableWidth =
      screenWidth -
      (!Platform.isIOS
          ? _kMoreIconSize + _kHorizontalPadding * 2
          : 32); // 좌우 패딩

  final TextPainter textPainter = TextPainter(
    text: TextSpan(text: text, style: style),
    maxLines: 3,
    textDirection: TextDirection.ltr,
  )..layout(minWidth: 0, maxWidth: availableWidth);

  final double height =
      max(_kMinTextHeight, textPainter.height) + _kExtraVerticalSpace;
  textPainter.dispose();
  return height;
}
