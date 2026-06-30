import 'package:flutter/material.dart';
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

class DrawerWidget extends ConsumerWidget with MainEvent {
  const DrawerWidget({super.key});

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

class _SectionHeader extends StatelessWidget {
  const _SectionHeader(this.label);

  final String label;

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

class _DrawerHeader extends ConsumerWidget with MainState {
  const _DrawerHeader({
    required this.onBookmarksTap,
    required this.onSettingsTap,
  });

  final VoidCallback onBookmarksTap;
  final VoidCallback onSettingsTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final primaryColor = Theme.of(context).primaryColor;
    final top = MediaQuery.of(context).padding.top;
    final versionAsync = appVersionState(ref);

    return Container(
      color: primaryColor,
      padding: EdgeInsets.fromLTRB(20, 16 + top, 8, 16),
      child: Row(
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: ClipOval(
              child: Image.asset('assets/icon.png', fit: BoxFit.cover),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const PlainText(
                  'Mocl',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 0.3,
                  ),
                ),
                const SizedBox(height: 3),
                versionAsync.maybeWhen(
                  data: (version) => PlainText(
                    version,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                  orElse: () => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
          IconButton(
            tooltip: '스크랩 보기',
            icon: const Icon(Icons.bookmark_border, color: Colors.white),
            onPressed: onBookmarksTap,
          ),
          IconButton(
            tooltip: '설정',
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: onSettingsTap,
          ),
        ],
      ),
    );
  }
}

class _DrawerSiteTag extends ConsumerWidget with MainState {
  const _DrawerSiteTag({
    required this.siteType,
    required this.focusColor,
    required this.onTap,
  });

  final SiteType siteType;
  final Color focusColor;
  final VoidCallback onTap;

  // 흰색 대신 헤더(#595D66) 와 같은 쿨 슬레이트 계열을 태그 배경으로 사용해
  // 드로어 전체 팔레트를 통일한다. (라이트/다크 각각)
  static const Color _tagBgLight = Color(0xFFE2E4E8);
  static const Color _tagBorderLight = Color(0xFFD2D5DA);
  static const Color _tagBgDark = Color(0xFF3C4046);
  static const Color _tagBorderDark = Color(0xFF4A4E55);

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
