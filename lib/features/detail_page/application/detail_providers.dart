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
double _kMinTextHeight = 30; // 최소 텍스트 높이
double _kExtraVerticalSpace = 24; // 추가 수직 공간(크럼브+여백)

/// 상세 화면 앱바 높이 캐시.
/// text, style, width가 동일하면 TextPainter.layout()을 생략합니다.
final _detailHeightCache = _DetailHeightCache();

class _DetailHeightCache {
  String? _lastText;
  TextStyle? _lastStyle;
  double? _lastWidth;
  double? _cachedHeight;

  double getOrCalculate(String text, TextStyle style, double availableWidth) {
    if (_lastText == text &&
        _lastStyle == style &&
        _lastWidth == availableWidth &&
        _cachedHeight != null) {
      return _cachedHeight!;
    }

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 3,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: availableWidth);

    final double height =
        max(_kMinTextHeight, textPainter.height) + _kExtraVerticalSpace;
    textPainter.dispose();

    _lastText = text;
    _lastStyle = style;
    _lastWidth = availableWidth;
    _cachedHeight = height;
    return height;
  }
}

@Riverpod(dependencies: [appbarTextStyle, screenWidth])
double detailAppbarHeight(Ref ref, String text) {
  final TextStyle style = ref.watch(appbarTextStyleProvider);
  final double screenWidth = ref.watch(screenWidthProvider);

  final double availableWidth =
      screenWidth -
      (!Platform.isIOS ? _kMoreIconSize + _kHorizontalPadding * 2 : 32);

  return _detailHeightCache.getOrCalculate(text, style, availableWidth);
}
