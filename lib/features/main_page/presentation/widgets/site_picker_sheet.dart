import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_category.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/favorite/presentation/state/favorite_state_mixin.dart';

import '../../../../core/presentation/widgets/plain_text.dart';
import '../state/main_event_mixin.dart';
import '../state/main_state_mixin.dart';

/// 사이트를 고르는 시트를 띄운다(메인 큰 제목을 누를 때).
///
/// 아래에서 올라오는 시트라 한 손으로 고르기 쉽고, 사이트가 많아도 위로 끌어
/// 펼쳐 본다. 넓은 화면에서는 폭을 묶어 가운데 띄운다.
Future<void> showSitePickerSheet(BuildContext context) {
  // 시트는 루트 Navigator 에 올라가 홈의 ProviderScope 밖에서 그려진다.
  // 홈과 같은 컨테이너를 보도록 넘겨 준다.
  final ProviderContainer container = ProviderScope.containerOf(context);
  final ThemeData theme = Theme.of(context);
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    showDragHandle: true,
    backgroundColor: theme.scaffoldBackgroundColor,
    constraints: const BoxConstraints(maxWidth: 640),
    builder: (_) => UncontrolledProviderScope(
      container: container,
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.6,
        minChildSize: 0.35,
        maxChildSize: 1,
        snap: true,
        snapSizes: const <double>[0.6],
        builder: (_, ScrollController controller) =>
            _SitePickerBody(controller: controller),
      ),
    ),
  );
}

/// 사이트 시트 본문.
///
/// 홈 게시판 탭은 '지금 고른 사이트의 담은 게시판'만 보여주므로, 사이트를 바꾸는
/// 자리가 필요하다. 전체 사이트를 카테고리별로 펼치고, 칩마다 담은 게시판 개수를
/// 붙여 이미 쓰고 있는 사이트를 한눈에 알아보게 한다.
class const _SitePickerBody({required final ScrollController controller})
    extends ConsumerWidget
    with FavoriteState {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double bottomPadding = MediaQuery.paddingOf(context).bottom;
    // 사이트 칩에 담은 게시판 개수를 함께 보여 준다.
    final Map<SiteType, int> counts = favoriteCountBySiteState(ref);
    final TextStyle titleStyle =
        (Theme.of(context).textTheme.titleMedium ?? const TextStyle()).copyWith(
          fontWeight: FontWeight.w700,
        );

    return ListView(
      controller: controller,
      padding: EdgeInsets.fromLTRB(18, 0, 18, 18 + bottomPadding),
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: PlainText('사이트 선택', style: titleStyle),
        ),
        for (final SiteCategory category in kSiteCategories) ...[
          _SectionHeader(category.label),
          _SiteWrap(sites: category.sites, counts: counts),
        ],
      ],
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
    Navigator.of(context).pop();
    changeSiteType(ref, siteType);
  }
}
