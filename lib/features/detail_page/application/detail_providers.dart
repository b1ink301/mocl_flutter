import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/large_title_metrics.dart';
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

/// 툴바 크럼브: `클리앙 › 모두의공원`.
///
/// 큰 제목이 글 제목을 가져가면서 사이트 구분이 화면에서 사라졌다. 목록과
/// 같은 규칙(상위 경로는 툴바에)으로 여기에 되살린다. 게시판 이름을 모르는
/// 경우(스크랩 등 boardTitle 이 빈 항목)에는 사이트만 적는다.
@Riverpod(dependencies: [listItem, detailTitle])
String detailSmallTitle(Ref ref) {
  final String boardTitle = ref.watch(
    listItemProvider.select((item) => item.boardTitle),
  );
  final String site = ref.watch(
    currentSiteTypeProvider.select((siteType) => siteType.title),
  );

  return boardTitle.isEmpty ? site : '$site$kAppbarCrumbSeparator$boardTitle';
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

/// 상세 앱바 높이 캐시.
///
/// 제목 · 스타일 · 폭이 같으면 TextPainter.layout() 을 생략한다. 상세를 오가며
/// 뒤로 돌아오는 흐름이 흔해서 한 칸만 두면 번번이 다시 재게 된다.
final _detailHeightCache = _DetailHeightCache();

class _DetailHeightCache() {
  static const int _kCapacity = 3;

  /// 삽입 순서를 유지하는 LRU. 오래된 항목부터 밀어낸다.
  final Map<({String text, TextStyle style, double width}), double> _entries =
      {};

  double getOrCalculate(String text, TextStyle style, double availableWidth) {
    final key = (text: text, style: style, width: availableWidth);
    final double? hit = _entries.remove(key);
    if (hit != null) {
      return _entries[key] = hit; // 최근 사용으로 끌어올린다
    }

    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: kDetailTitleMaxLines,
      textDirection: TextDirection.ltr,
    )..layout(minWidth: 0, maxWidth: availableWidth);

    final double height = max(kLargeTitleLineHeight, textPainter.height);
    textPainter.dispose();

    if (_entries.length >= _kCapacity) {
      _entries.remove(_entries.keys.first);
    }
    return _entries[key] = height;
  }
}

/// 상세 앱바의 expandedHeight.
///
/// 제목이 최대 3줄까지 늘어나므로 글마다 앱바 높이가 다르다. 실제로 그려지는
/// 것과 같은 스타일 · 같은 폭으로 재야 제목이 툴바 위로 삐져나오지 않는다.
/// 치수는 렌더 쪽(LargeTitleFlexibleSpace)과 같은 상수를 쓴다.
@Riverpod(dependencies: [appbarTextStyle, screenWidth])
double detailAppbarHeight(Ref ref, String text) {
  final TextStyle style = largeTitleStyle(ref.watch(appbarTextStyleProvider));
  final double screenWidth = ref.watch(screenWidthProvider);
  final double availableWidth = screenWidth - kLargeTitleHorizontalInset;

  return largeTitleExpandedHeight(
    _detailHeightCache.getOrCalculate(text, style, availableWidth),
  );
}
