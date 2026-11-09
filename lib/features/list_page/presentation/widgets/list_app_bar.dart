import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/large_title_metrics.dart';
import 'package:mocl_shared/entities/sort_type.dart';
import 'package:mocl_flutter/features/keyword_alerts/domain/keyword_alert_expiry.dart';
import 'package:mocl_flutter/features/keyword_alerts/presentation/state/keyword_alert_state_mixin.dart';
import 'package:mocl_flutter/features/keyword_alerts/presentation/widgets/keyword_alert_editor.dart';
import 'package:mocl_flutter/features/list_page/presentation/state/list_event_mixin.dart';
import 'package:mocl_shared/alerts/keyword_alerts.dart';
import 'package:mocl_shared/entities/mocl_main_item.dart';

import '../../../../core/presentation/widgets/appbar_actions_icon_theme.dart';
import '../../../../core/presentation/widgets/large_title_flexible_space.dart';
import '../../../../core/presentation/widgets/plain_icon.dart';
import '../../../../core/presentation/widgets/plain_icon_button.dart';
import '../../../../core/presentation/widgets/plain_popup_menu_button.dart';
import '../../../../core/presentation/widgets/plain_text.dart';
import '../../../../core/presentation/widgets/scroll_to_top_title.dart';
import '../state/list_state_mixin.dart';
import 'list_scope.dart';

class const ListAppBar({super.key}) extends ConsumerWidget with ListState {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final styleScope = ListStyleScope.of(context);
    final crumbStyle = appbarCrumbStyle(styleScope.smallTextStyle);
    final titleStyle = largeTitleStyle(styleScope.titleTextStyle);

    return SliverAppBar(
      expandedHeight: kLargeTitleExpandedHeightSingleLine,
      automaticallyImplyLeading: true,
      // 툴바에는 상위 경로만(= 사이트). 큰 제목은 게시판 이름을 쓴다.
      title: ScrollToTopTitle(
        child: PlainText(
          smallTitleState(ref),
          style: crumbStyle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      titleSpacing: kAppbarCrumbTitleSpacing,
      flexibleSpace: LargeTitleFlexibleSpace(
        title: titleState(ref),
        style: titleStyle,
      ),
      toolbarHeight: kToolbarHeight,
      floating: true,
      pinned: false,
      centerTitle: false,
      actions: const [
        AppbarActionsIconTheme(
          children: [
            _TranslateButton(),
            _KeywordAlertButton(),
            _SearchButton(),
            _SortButton(),
            _MoreButton(),
          ],
        ),
      ],
    );
  }
}

/// 목록 제목 번역 토글(레딧). 켜 두면 상세도 열자마자 번역한다(설정으로 기억).
class const _TranslateButton()
    extends ConsumerWidget
    with ListState, ListEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!listTranslationSupportedState(ref)) return const SizedBox.shrink();
    final Color primary = Theme.of(context).colorScheme.primary;
    final bool on = listTranslationOnState(ref);

    return PlainIconButton(
      semanticLabel: on ? '제목 번역 끄기' : '제목 번역하기',
      onPressed: () async {
        final bool ok = await toggleListTranslation(ref);
        if (ok || !context.mounted) return;
        ScaffoldMessenger.maybeOf(context)
          ?..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              content: Text('번역하지 못했어요. 처음이면 번역 언어를 받을 인터넷 연결이 필요해요.'),
              behavior: SnackBarBehavior.floating,
            ),
          );
      },
      icon: on && isTranslatingTitlesState(ref)
          ? SizedBox.square(
              dimension: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: primary),
            )
          : PlainIcon(Icons.translate_rounded, color: on ? primary : null),
    );
  }
}

/// 이 게시판 키워드 알림(종). 알림을 받을 수 있는 게시판에서만 보인다.
/// 걸려 있으면 채운 종으로 보이고, 누르면 키워드를 고치거나 끈다.
class const _KeywordAlertButton()
    extends ConsumerWidget
    with ListState, KeywordAlertState {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!keywordAlertsAvailableState(ref)) return const SizedBox.shrink();
    final MainItem board = currentBoardState(ref);
    if (board.parentBoard.isNotEmpty ||
        !KeywordAlerts.sites.contains(board.siteType) ||
        !KeywordAlerts.isAllowedBoardUrl(board.siteType, board.url)) {
      return const SizedBox.shrink();
    }
    final AlertSubscription? sub = keywordAlertForState(
      ref,
      board.siteType,
      board.board,
    );
    final bool expired =
        sub != null &&
        KeywordAlertExpiry.of(
          sub,
          keywordAlertTtlState(ref),
          DateTime.now(),
        ).isExpired;
    final bool on = sub != null && !expired;

    return PlainIconButton(
      semanticLabel: on
          ? '키워드 알림 고치기'
          : expired
          ? '키워드 알림 다시 켜기'
          : '키워드 알림 켜기',
      onPressed: () => KeywordAlertFlow.edit(
        context,
        ref,
        AlertSubscription(
          site: board.siteType,
          board: board.board,
          url: board.url,
          title: board.text,
          keywords: const [],
        ),
      ),
      icon: PlainIcon(
        on
            ? Icons.notifications_active
            : expired
            ? Icons.notifications_off_outlined
            : Icons.notifications_none,
        color: on ? Theme.of(context).colorScheme.primary : null,
      ),
    );
  }
}

// 2. 검색 버튼 분리 (Theme/IconTheme 의존 없는 PlainIconButton 사용)
// 검색을 지원하지 않는 사이트(긱뉴스 · 네이버카페 · 보배드림)에서는 숨긴다.
class const _SearchButton() extends ConsumerWidget with ListState, ListEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (!listSearchSupportedState(ref)) return const SizedBox.shrink();
    return PlainIconButton(
      semanticLabel: '글 검색',
      semanticsId: 'list_search',
      icon: const PlainIcon(Icons.search),
      onPressed: () => handleShowSearch(ref, context),
    );
  }
}

// 3. 정렬 버튼 분리 (상태 변화에만 반응하도록 함)
class const _SortButton() extends ConsumerWidget with ListState, ListEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      PlainPopupMenuButton<SortType>(
        icon: const PlainIcon(Icons.sort),
        onSelected: (SortType value) => handleChangeSortType(ref, value),
        itemBuilder: (BuildContext context) => [
          CheckedPopupMenuItem<SortType>(
            value: SortType.recent,
            checked: isRecentState(ref), // 이 상태가 변할 때만 이 위젯이 리빌드됨
            child: const Text('최신순'),
          ),
          CheckedPopupMenuItem<SortType>(
            value: SortType.recommend,
            checked: isRecommendState(ref),
            child: const Text('추천순'),
          ),
        ],
      );
}

// 4. 더보기 버튼 분리 (PlainPopupMenuButton 사용)
class const _MoreButton() extends ConsumerWidget with ListEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      PlainPopupMenuButton<int>(
        icon: const PlainIcon(Icons.more_vert),
        onSelected: (int value) {
          if (value == 0) handleRefresh(ref);
        },
        itemBuilder: (BuildContext context) => [
          const PopupMenuItem(value: 0, child: Text('새로고침')),
        ],
      );
}
