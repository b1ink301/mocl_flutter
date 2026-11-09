import 'dart:math';

import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/large_title_metrics.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_shared/entities/mocl_details.dart';
import 'package:mocl_shared/entities/mocl_list_item.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/detail_page/application/use_case_provider.dart';
import 'package:mocl_flutter/features/detail_page/domain/usecases/set_read_flag.dart';
import 'package:mocl_shared/util/mocl_logger.dart';
import 'package:mocl_shared/util/reply_count.dart';
import 'package:mocl_flutter/features/settings_page/application/settings_providers.dart';
import 'package:mocl_flutter/features/translation/application/translation_providers.dart';
import 'package:mocl_flutter/features/translation/domain/details_translator.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'detail_providers.g.dart';

@riverpod
ListItem listItem(Ref ref) => throw UnimplementedError('listItem');

/// 이 상세 화면이 읽는 사이트.
///
/// 보통은 전역 [currentSiteTypeProvider] 와 같다. 본문 링크로 다른 사이트 글을
/// 열 때는 ProviderScope 에서 그 사이트로 교체한다 — 전역 값을 바꾸면 뒤에 쌓인
/// 목록 화면까지 다른 사이트로 바뀌어 버린다.
@Riverpod(dependencies: [CurrentSiteTypeNotifier])
SiteType detailSiteType(Ref ref) => ref.watch(currentSiteTypeProvider);

@Riverpod(
  dependencies: [
    listItem,
    detailSiteType,
    DetailTitleStateNotifier,
    DetailCategoryStateNotifier,
    _markAsRead,
  ],
)
class DetailsNotifier() extends _$DetailsNotifier {
  @override
  Future<Details> build() async {
    state = const AsyncValue.loading();
    final listItem = ref.watch(listItemProvider);
    final siteType = ref.watch(detailSiteTypeProvider);
    final result = await ref.read(getDetailProvider(siteType))(listItem);
    final data = result.getOrElse((f) => throw f);
    await ref.watch(
      _markAsReadProvider(listItem, _seenReplyCount(listItem, data)).future,
    );
    ref.read(detailTitleStateProvider.notifier).update(data.title);
    ref.read(detailCategoryStateProvider.notifier).update(data.category);
    return data;
  }

  void refresh() => ref.invalidateSelf();
}

/// 상세 번역 상태. [details] 는 지금까지 번역된 글(댓글은 앞에서부터 채워진다).
class const DetailTranslation({
  final Details? details,
  final bool isShowing = false,
  final bool isTranslating = false,
  final bool isComplete = false,
});

/// 원문 ↔ 번역본 전환. 번역은 기기 안에서 하고, 한 번 끝낸 번역은 이 글을 보는
/// 동안 다시 하지 않는다. 새로고침하면 처음부터 다시 번역한다.
@Riverpod(
  dependencies: [DetailsNotifier, DetailTitleStateNotifier, detailSiteType],
)
class DetailTranslationNotifier() extends _$DetailTranslationNotifier {
  /// 진행 중인 번역을 가리킨다. 바뀌면 그 번역의 결과는 버린다.
  int _run = 0;

  @override
  DetailTranslation build() {
    final AsyncValue<Details> details = ref.watch(detailsProvider);
    _run++;
    // 설정 "번역해서 보기"(목록 앱바 번역 버튼)가 켜져 있으면 글을 받자마자 번역한다.
    if (details.hasValue && !details.isLoading && _autoTranslate()) {
      Future.microtask(() async {
        if (!ref.mounted || state.isShowing) return;
        try {
          await toggle();
        } catch (e) {
          MoclLogger.w(() => '[translate] 자동 번역 실패: $e');
        }
      });
    }
    return const DetailTranslation();
  }

  bool _autoTranslate() =>
      ref.read(autoTranslateProvider) &&
      ref.read(
        siteTranslationSupportedProvider(ref.read(detailSiteTypeProvider)),
      );

  /// 번역본과 원문을 오간다. 번역 중에 누르면 멈추고 원문으로 돌아간다.
  /// 번역에 실패하면 원문으로 돌아가고 예외를 다시 던진다(화면이 안내한다).
  Future<void> toggle() async {
    final Details? original = ref.read(detailsProvider).value;
    if (original == null) return;

    if (state.isShowing) {
      if (state.isTranslating) _run++;
      state = DetailTranslation(
        details: state.isComplete ? state.details : null,
        isComplete: state.isComplete,
      );
      _updateTitle(original.title);
      return;
    }
    if (state.isComplete && state.details != null) {
      state = DetailTranslation(
        details: state.details,
        isShowing: true,
        isComplete: true,
      );
      _updateTitle(state.details!.title);
      return;
    }

    final int run = ++_run;
    state = const DetailTranslation(isShowing: true, isTranslating: true);
    try {
      final translator = DetailsTranslator(ref.read(translatorProvider));
      await for (final Details details in translator.translate(original)) {
        if (!ref.mounted || run != _run) return;
        if (state.details == null) _updateTitle(details.title);
        state = DetailTranslation(
          details: details,
          isShowing: true,
          isTranslating: true,
        );
      }
      if (!ref.mounted || run != _run) return;
      state = DetailTranslation(
        details: state.details,
        isShowing: true,
        isComplete: true,
      );
    } catch (_) {
      if (!ref.mounted || run != _run) return;
      state = const DetailTranslation();
      _updateTitle(original.title);
      rethrow;
    }
  }

  void _updateTitle(String title) =>
      ref.read(detailTitleStateProvider.notifier).update(title);
}

/// 이번에 본 댓글 수. 목록 값을 기준으로, 상세에서 더 많이 받았으면 그 값으로
/// 올린다(목록이 오래돼 실제로는 더 본 경우 다음 새로 고침에 거짓 `+N` 이 뜨지 않게).
/// 목록 값을 정확히 읽을 수 없으면(스크랩 · 링크로 연 글 등) 남기지 않는다.
int? _seenReplyCount(ListItem listItem, Details details) {
  final int? fromList = parseReplyCount(listItem.reply);
  if (fromList == null) return null;
  return max(fromList, details.comments.length);
}

/// 읽음과 본 댓글 수를 한 번에 남긴다(상세를 받은 뒤 한 번).
@Riverpod(dependencies: [detailSiteType])
Future<int> _markAsRead(Ref ref, ListItem listItem, int? replyCount) async {
  // 이미 읽은 글이고 댓글 수도 모르면 남길 것이 없다.
  if (listItem.isRead && replyCount == null) return -1;
  final siteType = ref.read(detailSiteTypeProvider);
  final params = SetReadFlagParams(
    siteType: siteType,
    boardId: listItem.id,
    replyCount: replyCount,
    alreadyRead: listItem.isRead,
  );
  final int result = await ref.read(setReadFlagProvider(siteType))(params);
  // 목록의 읽음 표시는 같은 사이트일 때만 갱신한다(다른 사이트 글의 id 가
  // 우연히 같으면 엉뚱한 행이 읽음 처리된다).
  if (siteType == ref.read(currentSiteTypeProvider)) {
    ref.read(readableStateProvider.notifier).update(listItem.id);
  }
  return result;
}

/// 툴바 크럼브: `클리앙 › 모두의공원`.
///
/// 큰 제목이 글 제목을 가져가면서 사이트 구분이 화면에서 사라졌다. 목록과
/// 같은 규칙(상위 경로는 툴바에)으로 여기에 되살린다. 게시판 이름을 모르는
/// 경우(스크랩 등 boardTitle 이 빈 항목)에는 사이트만 적는다.
@Riverpod(dependencies: [listItem, detailTitle, detailSiteType])
String detailSmallTitle(Ref ref) {
  final String boardTitle = ref.watch(
    listItemProvider.select((item) => item.boardTitle),
  );
  final String site = ref.watch(
    detailSiteTypeProvider.select((siteType) => siteType.title),
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

/// 상세 제목 위 말머리 태그. 목록 아이템 값으로 시작하고, 상세 파서가 말머리를
/// 찾으면 그 값으로 바꾼다(링크로 연 글처럼 목록 값이 없는 경우).
@Riverpod(dependencies: [listItem])
class DetailCategoryStateNotifier() extends _$DetailCategoryStateNotifier {
  @override
  String build() => ref.watch(listItemProvider.select((item) => item.category));

  void update(String category) {
    if (category.isNotEmpty && state != category) {
      state = category;
    }
  }
}

@Riverpod(dependencies: [listItem])
String detailTitle(Ref ref) =>
    ref.watch(listItemProvider.select((item) => item.title));

@Riverpod(dependencies: [listItem, detailSiteType])
String detailUrl(Ref ref) {
  final siteType = ref.watch(detailSiteTypeProvider);
  final listItem = ref.watch(listItemProvider);
  return switch (siteType) {
    SiteType.naverCafe =>
      'https://m.cafe.naver.com/ca-fe/web/cafes/${listItem.board}/articles/${listItem.id}',
    // 레딧은 url 에 글 id(base36)만 담는다(목록 커서 · 상세 요청에 쓴다).
    SiteType.reddit =>
      'https://www.reddit.com/r/${listItem.board}/comments/${listItem.url}/',
    _ => listItem.url,
  };
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
///
/// [width] 는 화면 폭이 아니라 앱바가 실제로 받은 폭이다. 목록 옆 상세 칸이나
/// 폴드를 접고 펼친 뒤에도 제목 줄 수를 맞게 잰다.
@Riverpod(dependencies: [appbarTextStyle])
double detailAppbarHeight(Ref ref, String text, double width) {
  final TextStyle style = largeTitleStyle(ref.watch(appbarTextStyleProvider));
  final double availableWidth = width - kLargeTitleHorizontalInset;

  return largeTitleExpandedHeight(
    _detailHeightCache.getOrCalculate(text, style, availableWidth),
  );
}
