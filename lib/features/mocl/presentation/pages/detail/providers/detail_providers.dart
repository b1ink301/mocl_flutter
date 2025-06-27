import 'dart:io';
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
ListItem listItem(Ref ref) => throw UnimplementedError('listItem');

/*@riverpod
class DetailFontSizeNotifier extends _$DetailFontSizeNotifier {
  @override
  Future<Details> build() async {
    state = const AsyncValue.loading();
    return data;
  }

  void refresh() => ref.invalidateSelf();
}*/

@Riverpod(dependencies: [listItem])
class DetailsNotifier extends _$DetailsNotifier {
  @override
  Future<Details> build() async {
    state = const AsyncValue.loading();
    final ListItem listItem = ref.watch(listItemProvider);
    final Either<Failure, Details> result = await ref.read(getDetailProvider)(
      listItem,
    );
    final Details data = result.getOrElse((f) => throw f);
    ref.read(_markAsReadProvider(listItem));
    ref.read(detailTitleNotifierProvider.notifier).update(data.title);
    return data;
  }

  void refresh() => ref.invalidateSelf();
}

@riverpod
Future<int> _markAsRead(Ref ref, ListItem listItem) async {
  if (!listItem.isRead) {
    final SiteType siteType = ref.read(currentSiteTypeNotifierProvider);
    final SetReadFlagParams params = SetReadFlagParams(
      siteType: siteType,
      boardId: listItem.id,
    );
    final SetReadFlag setReadFlag = ref.read(setReadProvider);
    final int result = await setReadFlag(params);
    ref.read(readableStateNotifierProvider.notifier).update(listItem.id);
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
      currentSiteTypeNotifierProvider.select((siteType) => siteType.title),
    );

    return '$title > $boardTitle';
  }
}

@Riverpod(dependencies: [listItem, detailTitle])
class DetailTitleNotifier extends _$DetailTitleNotifier {
  @override
  String build() => ref.watch(detailTitleProvider);

  void update(String title) {
    if (title.isNotEmpty && state != title) {
      state = title;
    }
  }
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
double _kMinTextHeight = !Platform.isIOS ? 30 : 10; // 최소 텍스트 높이
double _kExtraVerticalSpace = !Platform.isIOS ? 36 : 0; // 추가 수직 공간

@Riverpod(dependencies: [appbarTextStyle, screenWidth])
double detailAppbarHeight(Ref ref, String text) {
  final TextStyle style = ref.watch(appbarTextStyleProvider);
  final double screenWidth = ref.watch(screenWidthProvider);

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

  // 최소 높이와 비교하여 더 큰 값 반환
  return max(_kMinTextHeight, textPainter.height) + _kExtraVerticalSpace;
}
