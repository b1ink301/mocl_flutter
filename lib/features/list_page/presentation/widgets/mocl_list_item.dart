import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/core/presentation/widgets/category_tag.dart';
import 'package:mocl_flutter/core/presentation/widgets/list_detail_layout.dart';
import 'package:mocl_flutter/core/presentation/widgets/nick_image_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/plain_text.dart';
import 'package:mocl_flutter/core/presentation/widgets/round_text_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/list_page/domain/list_density.dart';
import 'package:mocl_flutter/features/list_page/presentation/state/list_event_mixin.dart';
import 'package:mocl_flutter/features/list_page/presentation/state/list_state_mixin.dart';

import '../../../../core/presentation/widgets/author_info_text.dart';
import 'list_scope.dart';

class const MoclListItem({super.key}) extends StatelessWidget with ListEvent {
  @override
  Widget build(BuildContext context) {
    // InheritedWidget 으로부터 item 직접 획득 (Riverpod 경유 없음)
    final item = ListItemScope.of(context);
    // 스타일은 폰트 크기 등 글로벌 설정이라 Riverpod 으로 watch
    final styles = ListStyleScope.of(context);
    final isRead = item.isRead;
    final showCategory = ListStyleScope.showCategoryOf(context);

    final titleStyle = styles.title(isRead);
    final infoStyle = styles.smallTitle(isRead);

    final CompactSpacing? compact = ListStyleScope.compactOf(context);
    // 컴팩트는 닉 이미지를 그리지 않는다(행이 낮아 자리가 없고, 넘길 때 이미지 요청도 준다).
    final hasNickImage = compact == null && item.userInfo.nickImage.isNotEmpty;
    final hasReply = item.reply.isNotEmpty && item.reply != '0';

    // 답글 배지는 코랄 톤의 필드 칩(강조색 12% 배경, 테두리 없음).
    // 배지 스타일/배경색은 답글이 있는 행에서만 계산한다(불필요한 Color 할당 방지).
    Widget? replyBadge;
    if (hasReply) {
      final badgeStyle = styles.badge(isRead);
      final badgeBg =
          (badgeStyle.color ?? Theme.of(context).colorScheme.primary)
              .withValues(alpha: 0.12);
      final int newReplies = isRead ? item.newReplyCount : 0;
      replyBadge = newReplies > 0
          ? _NewReplyBadge(
              reply: item.reply,
              newReplies: newReplies,
              style: badgeStyle,
              background: badgeBg,
              accentStyle: styles.badge(false),
            )
          : RoundTextWidget(
              text: item.reply,
              textStyle: badgeStyle,
              backgroundColor: badgeBg,
              borderColor: Colors.transparent,
              borderRadius: 999,
              padding: _badgePadding(badgeStyle, left: 7, right: 7),
            );
    }

    // 넓은 화면에서 옆 칸에 열려 있는 글은 강조한다.
    final bool selected = ListDetailScope.isSelected(context, item.id);

    final Widget row = InkWell(
      onTap: () => handleItemTap(context, item),
      child: compact != null
          ? _CompactRow(
              spacing: compact,
              title: _ListTitle(
                title: item.title,
                category: showCategory ? item.category : '',
                style: titleStyle,
                brightness: styles.brightness,
                dimmed: isRead,
                maxLines: 1,
                highlight: SearchHighlightScope.of(context),
              ),
              info: item.info.isEmpty
                  ? null
                  : AuthorInfoText(
                      info: item.info,
                      nickName: item.userInfo.nickName,
                      style: infoStyle,
                    ),
              badge: replyBadge,
            )
          : Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 10,
                top: 14,
                bottom: 14,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title (말머리가 있으면 첫 줄 앞에 태그)
                  _ListTitle(
                    title: item.title,
                    category: showCategory ? item.category : '',
                    style: titleStyle,
                    brightness: styles.brightness,
                    dimmed: isRead,
                    highlight: SearchHighlightScope.of(context),
                  ),

                  // Bottom Info (Merged for performance)
                  if (item.info.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        children: [
                          if (hasNickImage)
                            Padding(
                              padding: const EdgeInsets.only(right: 6.0),
                              child: NickImageWidget(
                                url: item.userInfo.nickImage,
                              ),
                            ),
                          Expanded(
                            child: AuthorInfoText(
                              info: item.info,
                              nickName: item.userInfo.nickName,
                              style: infoStyle,
                            ),
                          ),
                          ?replyBadge,
                        ],
                      ),
                    ),
                ],
              ),
            ),
    );

    // 잉크가 강조색 위에 보이도록 Material 로 칠한다(강조할 때만 만든다).
    return selected
        ? Material(
            color: Theme.of(context).colorScheme.primary
                .withValues(alpha: 0.08),
            child: row,
          )
        : row;
  }
}

/// 댓글 배지 여백. 숫자는 아래 꼬리(디센더)가 없는데 글자 칸은 그 자리까지 잡아서
/// 위아래를 같게 주면 숫자가 알약 가운데보다 아래로 처진다(S24 Ultra 실측 약 0.7dp,
/// 글자 크기의 6~7%). 위를 그만큼 덜고 아래에 더해 높이는 그대로 두고 가운데로 올린다.
EdgeInsets _badgePadding(
  TextStyle style, {
  required double left,
  required double right,
}) {
  const double vertical = 1.5;
  final double lift = (style.fontSize ?? 11) * _digitLift;
  return EdgeInsets.fromLTRB(left, vertical - lift, right, vertical + lift);
}

/// 숫자를 올릴 비율(글자 크기 대비).
const double _digitLift = 0.065;

/// 읽은 글에 새 댓글이 붙었을 때의 배지: `[ 17 | +3 ]` 한 덩어리.
/// 왼쪽(댓글 수)은 읽은 행처럼 흐리게, 오른쪽(+N)은 안 읽은 글의 댓글 배지와 같은
/// 모양(강조색 글자 · 12% 배경)으로 그려 "새로 읽을 것" 으로 보이게 한다. 꽉 채운
/// 강조색은 목록에서 너무 튀어서 쓰지 않는다.
/// `+` 는 뜻만 남기고 작고 가늘게 그려 두 칸의 폭 · 무게가 비슷해 보이게 한다.
class const _NewReplyBadge({
  required final String reply,
  required final int newReplies,
  required final TextStyle style,
  required final Color background,
  required final TextStyle accentStyle,
}) extends StatelessWidget {
  /// `+` 크기(숫자 대비).
  static const double _plusScale = 0.75;

  @override
  Widget build(BuildContext context) {
    // 안 읽은 글의 댓글 배지(RoundTextWidget)와 같은 글자 · 배경.
    final Color accentBg =
        (accentStyle.color ?? Theme.of(context).colorScheme.primary).withValues(
          alpha: 0.12,
        );
    final TextStyle newStyle = accentStyle.fontFamily == null
        ? accentStyle.copyWith(fontFamily: kAppFontFamily)
        : accentStyle;
    final TextStyle plusStyle = newStyle.copyWith(
      fontSize: (newStyle.fontSize ?? 11) * _plusScale,
      fontWeight: FontWeight.w400,
    );
    return Semantics(
      label: '댓글 $reply개, 새 댓글 $newReplies개',
      excludeSemantics: true,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(999),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            ColoredBox(
              color: background,
              child: Padding(
                padding: _badgePadding(style, left: 7, right: 5),
                child: PlainText(reply, maxLines: 1, style: style),
              ),
            ),
            ColoredBox(
              color: accentBg,
              child: Padding(
                padding: _badgePadding(newStyle, left: 3, right: 7),
                child: RichText(
                  textDirection: TextDirection.ltr,
                  maxLines: 1,
                  text: TextSpan(
                    style: newStyle,
                    children: [
                      TextSpan(text: '+', style: plusStyle),
                      TextSpan(text: '$newReplies'),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 행 제목. 번역을 켰으면 번역문을 보인다(행 데이터는 원문 그대로라 스크랩 ·
/// 뮤트 · 상세는 원문 기준). 번역이 끝난 행만 다시 그린다.
class const _ListTitle({
  required final String title,
  required final String category,
  required final TextStyle style,
  required final Brightness brightness,
  required final bool dimmed,
  final int maxLines = 3,
  final String highlight = '',
}) extends ConsumerWidget with ListState {
  @override
  Widget build(BuildContext context, WidgetRef ref) => CategoryTitleText(
    title: displayTitleState(ref, title),
    category: category,
    style: style,
    brightness: brightness,
    dimmed: dimmed,
    maxLines: maxLines,
    highlight: highlight,
    highlightColor: highlight.isEmpty
        ? null
        : Theme.of(context).colorScheme.primary,
  );
}

/// 컴팩트 행: `[제목 한 줄 … 배지]` / 정보 한 줄. 위아래 여백 · 줄 사이는 화면 높이에 맞춘
/// [spacing](`compactSpacingFor`).
///
/// 광고 칸(`ListAdStyle.from(compact:)` ↔ `ListNativeAdFactory.kt`)이 같은 값을 쓴다 —
/// 한쪽을 바꾸면 다른 쪽도 같이.
class const _CompactRow({
  required final CompactSpacing spacing,
  required final Widget title,
  required final Widget? info,
  required final Widget? badge,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.only(
      left: 16,
      right: 10,
      top: spacing.padding,
      bottom: spacing.padding,
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: title),
            if (badge case final Widget badge) ...[
              const SizedBox(width: 8),
              badge,
            ],
          ],
        ),
        if (info case final Widget info)
          Padding(
            padding: EdgeInsets.only(top: spacing.gap),
            child: info,
          ),
      ],
    ),
  );
}
