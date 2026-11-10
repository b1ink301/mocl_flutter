import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_category.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/favorite/presentation/state/favorite_state_mixin.dart';
import 'package:mocl_flutter/features/settings_page/presentation/state/settings_state_mixin.dart';

import '../../../../core/presentation/widgets/plain_icon.dart';
import '../../../../core/presentation/widgets/plain_text.dart';
import '../state/main_event_mixin.dart';
import '../state/main_state_mixin.dart';

/// 사이트 드로어를 연다(메인 큰 제목 · 빈 게시판 안내의 "다른 사이트").
///
/// 드로어는 홈 셸(`MainPage`)의 Scaffold 에 붙어 있다. 게시판 탭 본문을
/// 오른쪽으로 끌어도 손가락을 따라 열린다.
void openSiteDrawer(BuildContext context) =>
    Scaffold.maybeOf(context)?.openDrawer();

/// 사이트를 고르는 왼쪽 드로어.
///
/// 홈 게시판 탭은 '지금 고른 사이트의 담은 게시판'만 보여주므로, 사이트를 바꾸는
/// 자리가 필요하다. 전체 사이트를 카테고리별로 펼치고, 칩마다 담은 게시판 개수를
/// 붙여 이미 쓰고 있는 사이트를 한눈에 알아보게 한다.
///
/// 스크랩 · 설정 · 지금 이슈는 하단 탭이 맡으므로 여기에 두지 않는다(이동 경로가
/// 두 갈래가 되지 않게). 드로어는 사이트 고르기 하나만 한다.
class const SiteDrawer({super.key}) extends ConsumerWidget with FavoriteState {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final double bottomPadding = MediaQuery.paddingOf(context).bottom;
    // 사이트 칩에 담은 게시판 개수를 함께 보여 준다.
    final Map<SiteType, int> counts = favoriteCountBySiteState(ref);

    // id 는 기기 확인 스크립트(tool/device_check.dart)가 드로어가 닫혔는지 볼 때 쓴다.
    return Semantics(
      identifier: 'site_drawer',
      child: Drawer(
        backgroundColor: theme.scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _DrawerHeader(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(18, 4, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
        _SiteTag(siteType: siteType, count: counts[siteType] ?? 0),
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

/// 로고 · 앱 이름 · 버전. 본문과 같은 종이 배경에 아래 헤어라인으로만 경계를 준다.
class const _DrawerHeader() extends ConsumerWidget with SettingsState {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final top = MediaQuery.paddingOf(context).top;
    final versionAsync = appVersionState(ref);
    final Color inkColor = theme.textTheme.bodyMedium!.color!;
    final Color subColor = theme.textTheme.bodySmall!.color!;

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
        ],
      ),
    );
  }
}

/// 사이트 칩 하나. 지금 보고 있는 사이트는 강조색으로 채운다.
class const _SiteTag({
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
    final Color focusColor = theme.colorScheme.primary;
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
    Scaffold.maybeOf(context)?.closeDrawer();
    changeSiteType(ref, siteType);
  }
}

/// 드로어 맨 아래 '게시판 추가'. 사이트를 둘러보다 담고 싶어지는 자리이고,
/// 엄지가 닿는 아래쪽이다.
class const _AddBoardButton({required final double bottomPadding})
    extends ConsumerWidget
    with MainEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final primaryColor = theme.colorScheme.primary;
    final TextStyle fontStyle = (theme.textTheme.bodySmall ?? const TextStyle())
        .copyWith(color: primaryColor);
    return Container(
      padding: EdgeInsets.fromLTRB(16, 2, 16, 10 + bottomPadding),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: theme.dividerColor)),
      ),
      child: TextButton.icon(
        onPressed: () {
          Scaffold.maybeOf(context)?.closeDrawer();
          handleAddButton(ref, context);
        },
        icon: PlainIcon(Icons.add, color: primaryColor),
        label: PlainText('게시판 추가', style: fontStyle),
      ),
    );
  }
}
