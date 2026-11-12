import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:material_ui/material_ui.dart';
import 'package:mocl_flutter/config/accent_palette.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/core/application/accent_mixin.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';
import 'package:mocl_flutter/core/presentation/widgets/round_text_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/window_size.dart';
import 'package:mocl_shared/entities/mocl_site_type.dart';

/// 설정 → 강조색. 기본(코랄) · 사이트 색 · 직접 고르기.
///
/// 강조색만 바뀐다(종이 배경 · 글자 · 구분선은 그대로). 고르면 바로 앱 전체에 적용되고,
/// 아래 미리보기는 실제 목록 행 · 배지 · 칩 모양으로 그린다.
class const AccentPage({super.key})
    extends ConsumerWidget
    with AppAccentState, AppAccentEvent {
  static String labelOf(AccentSetting setting) => switch (setting.mode) {
    AccentMode.coral => '기본',
    AccentMode.site => '사이트 색',
    AccentMode.custom => '직접 고르기',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final systemOverlayStyle =
        theme.appBarTheme.systemOverlayStyle ?? SystemUiOverlayStyle.light;
    final TextStyle titleStyle = ref.watch(appbarTextStyleProvider);
    final AppTextStyles styles = ref.watch(appTextStylesFontSizeProvider);
    final AccentSetting setting = accentSettingState(ref);
    final Brightness brightness = theme.brightness;
    final double bottom = MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle,
      child: Container(
        color: systemOverlayStyle.statusBarColor,
        child: SafeArea(
          bottom: false,
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: theme.appBarTheme.backgroundColor,
              title: Text('강조색', style: titleStyle),
              scrolledUnderElevation: 0,
              titleSpacing: 0,
            ),
            body: BoxReadableWidth(
              child: ListView(
                padding: EdgeInsets.fromLTRB(16, 8, 16, 24 + bottom),
                children: [
                  _Header('색', style: styles.smallTextStyle),
                  _Card(
                    children: [
                      _ModeTile(
                        id: 'accent_coral',
                        title: '기본',
                        subtitle: 'Mocl 코랄',
                        selected: setting.mode == AccentMode.coral,
                        swatches: [AccentPalette.coral.of(brightness)],
                        onTap: () => selectAccentMode(ref, AccentMode.coral),
                      ),
                      const _Divider(),
                      _ModeTile(
                        id: 'accent_site',
                        title: '사이트 색',
                        subtitle: '보고 있는 사이트마다 그 사이트 색으로',
                        selected: setting.mode == AccentMode.site,
                        swatches: [
                          for (final SiteType s in const [
                            SiteType.clien,
                            SiteType.damoang,
                            SiteType.ppomppu,
                          ])
                            AccentPalette.site(s).of(brightness),
                        ],
                        onTap: () => selectAccentMode(ref, AccentMode.site),
                      ),
                      const _Divider(),
                      _ModeTile(
                        id: 'accent_custom',
                        title: '직접 고르기',
                        subtitle: '아래 색 중 하나',
                        selected: setting.mode == AccentMode.custom,
                        swatches: [
                          AccentPalette.custom[setting.custom].of(brightness),
                        ],
                        onTap: () => selectAccentMode(ref, AccentMode.custom),
                      ),
                    ],
                  ),
                  _Header('직접 고르기', style: styles.smallTextStyle),
                  _Card(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(14),
                        child: Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            for (
                              int i = 0;
                              i < AccentPalette.custom.length;
                              i++
                            )
                              _Swatch(
                                color: AccentPalette.custom[i].of(brightness),
                                selected:
                                    setting.mode == AccentMode.custom &&
                                    setting.custom == i,
                                label: '색 ${i + 1}',
                                onTap: () => selectCustomAccent(ref, i),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  if (setting.mode == AccentMode.site) ...[
                    _Header('사이트 색', style: styles.smallTextStyle),
                    _Card(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(14),
                          child: Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              for (final SiteType s in SiteType.values)
                                _SiteColorChip(
                                  site: s,
                                  color: AccentPalette.site(s).of(brightness),
                                  style: styles.smallTextStyle,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                  _Header('미리보기', style: styles.smallTextStyle),
                  _Preview(styles: styles),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '배경 · 글자 색은 그대로 두고 강조색만 바꿔요. '
                      '사이트 색은 글자가 잘 읽히도록 밝기를 조금 맞춘 색이에요.',
                      style: styles.smallTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class const _Header(final String title, {required final TextStyle style})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(8, 20, 8, 8),
    child: Text(
      title,
      style: style.copyWith(fontWeight: FontWeight.w600, letterSpacing: 0.3),
    ),
  );
}

/// 설정 화면 카드와 같은 모양.
class const _Card({required final List<Widget> children})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF3D3D3D) : const Color(0xFFF6F6F2),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class const _Divider() extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, thickness: 1, indent: 48);
}

class const _ModeTile({
  required final String id,
  required final String title,
  required final String subtitle,
  required final bool selected,
  required final List<Color> swatches,
  required final VoidCallback onTap,
}) extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ThemeData theme = Theme.of(context);
    final AppTextStyles styles = ref.watch(appTextStylesFontSizeProvider);
    return Semantics(
      identifier: id,
      button: true,
      selected: selected,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              _RadioDot(selected: selected, color: theme.colorScheme.primary),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: styles.titleTextStyle),
                    const SizedBox(height: 2),
                    Text(subtitle, style: styles.smallTextStyle),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              for (final Color c in swatches)
                Padding(
                  padding: const EdgeInsets.only(left: 3),
                  child: DecoratedBox(
                    decoration: BoxDecoration(color: c, shape: BoxShape.circle),
                    child: const SizedBox(width: 12, height: 12),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// 라디오 표시(Material Radio 는 그룹 API 가 버전마다 달라 직접 그린다).
class const _RadioDot({
  required final bool selected,
  required final Color color,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color off = Theme.of(context).colorScheme.outline;
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: selected ? color : off, width: 2),
      ),
      alignment: Alignment.center,
      child: selected
          ? DecoratedBox(
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: const SizedBox(width: 10, height: 10),
            )
          : null,
    );
  }
}

class const _Swatch({
  required final Color color,
  required final bool selected,
  required final String label,
  required final VoidCallback onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Color ring = Theme.of(context).colorScheme.onSurface;
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color,
            border: selected ? Border.all(color: ring, width: 2.5) : null,
          ),
          child: selected
              ? const Icon(Icons.check, size: 20, color: Colors.white)
              : null,
        ),
      ),
    );
  }
}

class const _SiteColorChip({
  required final SiteType site,
  required final Color color,
  required final TextStyle style,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(9, 6, 11, 6),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.12),
      borderRadius: BorderRadius.circular(14),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: const SizedBox(width: 9, height: 9),
        ),
        const SizedBox(width: 6),
        Text(
          site.title,
          style: style.copyWith(color: color, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}

/// 미리보기: 목록 행(제목 · 정보 · 댓글 배지) + 칩 + 버튼. 지금 테마의 강조색으로 그린다.
class const _Preview({required final AppTextStyles styles})
    extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ColorScheme scheme = Theme.of(context).colorScheme;
    final TextStyle badge = styles.withAccent(scheme.primary).badgeTextStyle;
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      decoration: BoxDecoration(
        color: scheme.surface,
        border: Border.all(color: scheme.outlineVariant),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('세면대 수전 분리하려는데 공구 추천 부탁드립니다', style: styles.titleTextStyle),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('다모앙 · 13:40', style: styles.smallTextStyle),
              const SizedBox(width: 8),
              RoundTextWidget(
                text: '17',
                textStyle: badge,
                backgroundColor: scheme.primary.withValues(alpha: 0.12),
                borderColor: Colors.transparent,
                borderRadius: 999,
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 1),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  '선택한 칩',
                  style: styles.smallTextStyle.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              FilledButton(onPressed: () {}, child: const Text('버튼')),
            ],
          ),
        ],
      ),
    );
  }
}
