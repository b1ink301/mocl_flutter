import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_category.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/presentation/widgets/site_avatar.dart';
import 'package:mocl_flutter/features/favorite/presentation/state/favorite_state_mixin.dart';

import '../../../../core/presentation/widgets/plain_text.dart';
import '../state/main_event_mixin.dart';
import '../state/main_state_mixin.dart';

/// 사이트를 고르는 드로어.
///
/// 홈은 '지금 고른 사이트의 담은 게시판'만 보여주므로, 사이트를 바꾸는 자리가
/// 필요하다. 맨 위에는 이미 게시판을 담아둔 사이트를 모아 두어(대부분의 이동이
/// 여기서 끝난다), 그 아래에 전체 사이트를 카테고리별로 펼친다.
class const DrawerWidget({super.key})
    extends ConsumerWidget
    with MainEvent, FavoriteState {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final double bottomPadding = MediaQuery.of(context).padding.bottom;
    final Map<SiteType, int> counts = favoriteCountBySiteState(ref);
    // 담아둔 사이트는 전체 목록과 같은 순서로 위에 모은다.
    final List<SiteType> mine = [
      for (final SiteType siteType in kAllSitesInOrder)
        if ((counts[siteType] ?? 0) > 0) siteType,
    ];

    return Drawer(
      backgroundColor: theme.scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const _DrawerHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(18, 4, 18, 18 + bottomPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (mine.isNotEmpty) ...[
                    const _SectionHeader('담아둔 사이트'),
                    _SiteWrap(sites: mine, counts: counts),
                  ],
                  for (final SiteCategory category in kSiteCategories) ...[
                    _SectionHeader(category.label),
                    _SiteWrap(sites: category.sites, counts: counts),
                  ],
                ],
              ),
            ),
          ),
          _AddBoardButton(bottomPadding: bottomPadding),
        ],
      ),
    );
  }
}

class const _SiteWrap({
  required final List<SiteType> sites,
  required final Map<SiteType, int> counts,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Wrap(
    spacing: 10,
    runSpacing: 10,
    children: [
      for (final SiteType siteType in sites)
        _DrawerSiteTag(siteType: siteType, count: counts[siteType] ?? 0),
    ],
  );
}

class const _SectionHeader(final String label) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = theme.textTheme.bodySmall?.color;
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 18, 4, 10),
      child: PlainText(
        label,
        style: TextStyle(
          fontSize: 11.5,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
          color: color,
        ),
      ),
    );
  }
}

class const _DrawerHeader() extends ConsumerWidget with MainState {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final top = MediaQuery.of(context).padding.top;
    final versionAsync = appVersionState(ref);
    final Color inkColor = theme.textTheme.bodyMedium!.color!;
    final Color subColor = theme.textTheme.bodySmall!.color!;

    // 헤더는 드로어 본문과 같은 종이 배경을 그대로 쓰고(별도 색 없음),
    // 하단 헤어라인으로만 경계를 준다. 강조색은 선택된 사이트 칩에만.
    return Container(
      padding: EdgeInsets.fromLTRB(20, 14 + top, 20, 14),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: theme.dividerColor)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(13),
              border: Border.all(color: theme.dividerColor),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.asset('assets/icon.png', fit: BoxFit.cover),
          ),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PlainText(
                  'Mocl',
                  style: TextStyle(
                    color: inkColor,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 0.2,
                  ),
                ),
                const SizedBox(height: 2),
                versionAsync.maybeWhen(
                  data: (version) => PlainText(
                    version,
                    style: TextStyle(color: subColor, fontSize: 12),
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 사이트 칩 하나. 지금 보고 있는 사이트는 강조색으로 채운다.
class const _DrawerSiteTag({
  required final SiteType siteType,
  required final int count,
}) extends ConsumerWidget with MainState, MainEvent {
  // Paper 팔레트에 맞춘 웜 뉴트럴 칩(비선택). 선택 시엔 강조색으로 채운다.
  static const Color _tagBgLight = Color(0xFFF1EEEA);
  static const Color _tagBorderLight = Color(0xFFE4E1DB);
  static const Color _tagBgDark = Color(0xFF24262B);
  static const Color _tagBorderDark = Color(0xFF31343B);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final bool isSelected = isSiteType(ref, siteType);
    final Color focusColor = theme.focusColor;
    final baseStyle = smallTextStyleState(ref);

    final Color bg = isSelected
        ? focusColor
        : (isDark ? _tagBgDark : _tagBgLight);
    final Color borderColor = isSelected
        ? focusColor
        : (isDark ? _tagBorderDark : _tagBorderLight);
    final Color textColor = isSelected
        ? Colors.white
        : (baseStyle.color ?? theme.textTheme.bodyMedium!.color!);

    return Material(
      color: bg,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: borderColor),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _handleTap(context, ref),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 7, 14, 7),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 이름 두 글자보다 로고가 빨리 읽힌다(로고가 없으면 색 배지).
              SiteAvatar(siteType: siteType, radius: 10),
              const SizedBox(width: 8),
              PlainText(
                siteType.title,
                style: baseStyle.copyWith(
                  color: textColor,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              // 담아둔 게시판이 있는 사이트만 개수를 밝힌다(빈 사이트로 들어가
              // '아무것도 없네' 하고 되돌아 나오는 일을 줄인다).
              if (count > 0) ...[
                const SizedBox(width: 6),
                PlainText(
                  '$count',
                  style: baseStyle.copyWith(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white70
                        : theme.textTheme.bodySmall?.color,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _handleTap(BuildContext context, WidgetRef ref) {
    context.pop();
    changeSiteType(ref, siteType);
  }
}

/// 드로어 맨 아래 '게시판 추가'. 사이트를 둘러보다 담고 싶어지는 자리라
/// 목록 바로 밑에 둔다.
class const _AddBoardButton({required final double bottomPadding})
    extends ConsumerWidget
    with MainEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(16, 10, 16, 10 + bottomPadding),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: TextButton.icon(
        onPressed: () {
          context.pop();
          context.push(Routes.setMainDlgFull);
        },
        icon: const Icon(Icons.add),
        label: const Text('게시판 추가'),
      ),
    );
  }
}
