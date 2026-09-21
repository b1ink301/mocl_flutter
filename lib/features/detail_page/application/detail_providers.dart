import 'dart:io';
import 'dart:math';

import 'package:material_ui/material_ui.dart';
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
class DetailsNotifier() extends _$DetailsNotifier {
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
class DetailTitleStateNotifier() extends _$DetailTitleStateNotifier {
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

/// 큰 타이틀 폰트 크기. 메인/리스트 앱바의 확장 타이틀과 같은 값이라
/// 세 화면이 같은 리듬으로 접히고 펼쳐진다.
const double _kLargeTitleFontSize = 30.0;

/// 큰 타이틀의 좌우 여백(시작 16 + 끝 16). 측정 폭에서 빼야 실제 줄바꿈과
/// 같은 줄 수가 나온다.
const double _kTitleHorizontalInset = 20.0;

/// 타이틀 아래 여백(앱바 하단과의 간격).
const double _kTitleBottomSpace = 4.0;

/// 최소 텍스트 높이(한 줄).
const double _kMinTextHeight = 30.0;

/// 상세 화면 앱바 높이 캐시.
/// text, style, width가 동일하면 TextPainter.layout()을 생략합니다.
final _detailHeightCache = _DetailHeightCache();

class _DetailHeightCache() {
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

    final double height = max(_kMinTextHeight, textPainter.height);
    textPainter.dispose();

    _lastText = text;
    _lastStyle = style;
    _lastWidth = availableWidth;
    _cachedHeight = height;
    return height;
  }
}

/// 확장 영역에 들어갈 큰 타이틀의 높이(툴바 제외).
///
/// 실제로 그려지는 스타일(30pt, w800)과 같은 조건으로 재야 3줄짜리 제목이
/// 툴바 위로 삐져나오지 않는다.
@Riverpod(dependencies: [appbarTextStyle, screenWidth])
double detailAppbarHeight(Ref ref, String text) {
  final TextStyle style = ref
      .watch(appbarTextStyleProvider)
      .copyWith(
        fontSize: _kLargeTitleFontSize,
        fontWeight: FontWeight.w800,
        height: 1.15,
      );
  final double screenWidth = ref.watch(screenWidthProvider);
  final double availableWidth = screenWidth - _kTitleHorizontalInset;

  return _detailHeightCache.getOrCalculate(text, style, availableWidth) +
      _kTitleBottomSpace;
}
