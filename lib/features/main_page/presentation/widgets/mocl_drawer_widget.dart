import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_category.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';

import '../../../../core/presentation/widgets/plain_text.dart';
import '../state/main_event_mixin.dart';
import '../state/main_state_mixin.dart';

/// 사이트를 둘러보고 게시판을 추가하는 통로.
/// 사이트를 고르면 그 사이트의 게시판 선택 화면이 바로 열리고, 고른 게시판은
/// 메인 화면의 즐겨찾기 그룹에 쌓인다(메인은 더 이상 사이트별 화면이 아니다).
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
                  for (final SiteCategory category in kSiteCategories) ...[
                    _SectionHeader(category.label),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        for (final siteType in category.sites)
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
    openAddBoards(ref, context, siteType);
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
