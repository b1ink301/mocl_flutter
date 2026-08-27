import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';

import '../../../../core/presentation/widgets/plain_text.dart';
import '../state/main_event_mixin.dart';
import '../state/main_state_mixin.dart';

/// 드로어 사이트 목록을 카테고리로 묶는다. 각 그룹은 라벨과 사이트 목록을
/// 가지며, 정의된 순서대로 표시된다. (전체 18개 사이트를 모두 포함)
typedef _SiteGroup = ({String label, List<SiteType> sites});

const List<_SiteGroup> _siteGroups = [
  (
    label: '커뮤니티',
    sites: [
      SiteType.clien,
      SiteType.damoang,
      SiteType.arcalive,
      SiteType.cook82,
      SiteType.ppomppu,
      SiteType.instiz,
      SiteType.theqoo,
      SiteType.meeco,
      SiteType.nate,
      SiteType.naverCafe,
    ],
  ),
  (
    label: '취미 · 자동차 · 게임',
    sites: [
      SiteType.bobaedream,
      SiteType.inven,
      SiteType.ruliweb,
      SiteType.dogdrip,
    ],
  ),
  (
    label: '뉴스 · IT · 스포츠',
    sites: [SiteType.geekNews, SiteType.dcinside, SiteType.mlbpark],
  ),
  (label: '해외', sites: [SiteType.reddit]),
];

class const DrawerWidget({super.key}) extends ConsumerWidget with MainEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final scaffoldBackgroundColor = theme.scaffoldBackgroundColor;
    final focusColor = theme.focusColor;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Drawer(
      backgroundColor: scaffoldBackgroundColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _DrawerHeader(
            onFavoritesTap: () {
              context.pop();
              context.push(Routes.favorites);
            },
            onBookmarksTap: () {
              context.pop();
              context.push(Routes.bookmarks);
            },
            onSettingsTap: () {
              context.pop();
              context.push(Routes.settings);
            },
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(18, 4, 18, 18 + bottomPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (final group in _siteGroups) ...[
                    _SectionHeader(group.label),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final siteType in group.sites)
                          _DrawerSiteTag(
                            siteType: siteType,
                            focusColor: focusColor,
                            onTap: () => _handleSiteTap(context, ref, siteType),
                          ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleSiteTap(BuildContext context, WidgetRef ref, SiteType siteType) {
    context.pop();
    changeSiteType(ref, siteType);
  }
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

class const _DrawerHeader({
  required final VoidCallback onFavoritesTap,
  required final VoidCallback onBookmarksTap,
  required final VoidCallback onSettingsTap,
}) extends ConsumerWidget with MainState {
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
      padding: EdgeInsets.fromLTRB(20, 14 + top, 8, 14),
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
          // IconButton(
          //   tooltip: '즐겨찾기',
          //   icon: Icon(Icons.star_border_rounded, color: inkColor),
          //   onPressed: onFavoritesTap,
          // ),
          IconButton(
            tooltip: '스크랩 보기',
            icon: Icon(Icons.bookmark_border, color: inkColor),
            onPressed: onBookmarksTap,
          ),
          IconButton(
            tooltip: '설정',
            icon: Icon(Icons.settings_outlined, color: inkColor),
            onPressed: onSettingsTap,
          ),
        ],
      ),
    );
  }
}

class const _DrawerSiteTag({
  required final SiteType siteType,
  required final Color focusColor,
  required final VoidCallback onTap,
}) extends ConsumerWidget with MainState {
  // Paper 팔레트에 맞춘 웜 뉴트럴 칩(비선택). 선택 시엔 강조색(코랄)으로 채운다.
  static const Color _tagBgLight = Color(0xFFF1EEEA);
  static const Color _tagBorderLight = Color(0xFFE4E1DB);
  static const Color _tagBgDark = Color(0xFF24262B);
  static const Color _tagBorderDark = Color(0xFF31343B);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSelected = isSiteType(ref, siteType);
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
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
          child: PlainText(
            siteType.title,
            style: baseStyle.copyWith(
              color: textColor,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}
