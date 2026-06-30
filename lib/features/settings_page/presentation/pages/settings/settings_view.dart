import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';

import '../../state/settings_event_mixin.dart';
import '../../state/settings_state_mixin.dart';

class SettingsView extends ConsumerWidget with SettingsState, SettingsEvent {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    listenSyncStatus(ref);

    final isSyncing = isSyncingState(ref);
    final theme = Theme.of(context);
    final styles = appTextStylesState(ref);
    final bottom = MediaQuery.of(context).padding.bottom;

    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 24 + bottom),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const _SectionHeader('일반'),
            _SettingsCard(
              children: [
                _SettingsTile(
                  icon: Icons.image_outlined,
                  title: '닉 이미지 보기',
                  onTap: () => handleToggleNickImage(ref),
                  trailing: Switch(
                    value: showNickImageState(ref),
                    activeThumbColor: theme.focusColor,
                    onChanged: (_) => handleToggleNickImage(ref),
                  ),
                ),
                const _TileDivider(),
                _SettingsTile(
                  icon: Icons.brightness_6_outlined,
                  title: '테마',
                  trailing: SegmentedButton<ThemeMode>(
                    showSelectedIcon: false,
                    style: const ButtonStyle(
                      visualDensity: VisualDensity.compact,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    segments: const [
                      ButtonSegment(value: ThemeMode.system, label: Text('시스템')),
                      ButtonSegment(value: ThemeMode.light, label: Text('라이트')),
                      ButtonSegment(value: ThemeMode.dark, label: Text('다크')),
                    ],
                    selected: {themeModeState(ref)},
                    onSelectionChanged: (selected) =>
                        handleChangeThemeMode(ref, selected.first),
                  ),
                ),
                const _TileDivider(),
                _SettingsTile(
                  icon: Icons.format_size,
                  title: '글자 크기',
                  trailing: _FontSizeControl(
                    delta: fontSizeDeltaState(ref),
                    labelStyle: styles.titleTextStyle,
                    focusColor: theme.focusColor,
                    onDecrease: () => handleDecreaseFontSize(ref),
                    onIncrease: () => handleIncreaseFontSize(ref),
                    onReset: () => handleResetFontSize(ref),
                  ),
                ),
              ],
            ),

            const _SectionHeader('데이터'),
            _SettingsCard(
              children: [
                _SettingsTile(
                  icon: Icons.bookmark_outline,
                  title: '스크랩 보기',
                  trailing: const Icon(Icons.chevron_right, size: 22),
                  onTap: () => context.push(Routes.bookmarks),
                ),
                const _TileDivider(),
                _SettingsTile(
                  icon: Icons.block,
                  title: '차단(뮤트) 관리',
                  trailing: const Icon(Icons.chevron_right, size: 22),
                  onTap: () => context.push(Routes.mute),
                ),
                const _TileDivider(),
                cacheSizeState(ref).maybeWhen(
                  orElse: () => const _SettingsTile(
                    icon: Icons.cleaning_services_outlined,
                    title: '캐시 데이터 삭제',
                    trailing: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  data: (data) => _SettingsTile(
                    icon: Icons.cleaning_services_outlined,
                    title: '캐시 데이터 삭제',
                    onTap: () => handleClearCache(ref),
                    trailing: Text(data, style: styles.smallTextStyle),
                  ),
                ),
              ],
            ),

            const _SectionHeader('백업 · 복원'),
            if (isSyncing)
              _SettingsCard(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Column(
                      children: [
                        CircularProgressIndicator(color: theme.focusColor),
                        const SizedBox(height: 12),
                        Text(
                          'Google Drive와 동기화 중...',
                          style: styles.smallTextStyle,
                        ),
                      ],
                    ),
                  ),
                ],
              )
            else
              _SettingsCard(
                children: [
                  _SettingsTile(
                    icon: Icons.cloud_upload_outlined,
                    title: 'Google Drive로 백업',
                    trailing: const Icon(Icons.chevron_right, size: 22),
                    onTap: () => handleBackup(ref),
                  ),
                  const _TileDivider(),
                  _SettingsTile(
                    icon: Icons.cloud_download_outlined,
                    title: 'Google Drive에서 복원',
                    trailing: const Icon(Icons.chevron_right, size: 22),
                    onTap: () => handleRestore(ref),
                  ),
                ],
              ),

            const SizedBox(height: 28),
            Center(
              child: appVersionState(ref).maybeWhen(
                orElse: () => const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                data: (version) =>
                    Text('버전 $version', style: styles.smallTextStyle),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 글자 크기 조절 컨트롤. − / 현재 단계 / + 버튼으로 구성하며,
/// 가운데 값을 탭하면 기본값으로 초기화한다. 단계 범위(-5~+10)는
/// SetFontSize 유스케이스에서 보정되므로 버튼은 항상 활성.
class _FontSizeControl extends StatelessWidget {
  final double delta;
  final TextStyle labelStyle;
  final Color focusColor;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onReset;

  const _FontSizeControl({
    required this.delta,
    required this.labelStyle,
    required this.focusColor,
    required this.onDecrease,
    required this.onIncrease,
    required this.onReset,
  });

  String get _label {
    if (delta == 0) return '기본';
    final int step = delta.toInt();
    return step > 0 ? '+$step' : '$step';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          tooltip: '글자 작게',
          visualDensity: VisualDensity.compact,
          icon: Icon(Icons.remove_circle_outline, color: focusColor),
          onPressed: onDecrease,
        ),
        InkWell(
          onTap: onReset,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            constraints: const BoxConstraints(minWidth: 40),
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            child: Text(
              _label,
              style: labelStyle.copyWith(
                fontWeight: delta == 0 ? FontWeight.normal : FontWeight.bold,
                color: delta == 0 ? null : focusColor,
              ),
            ),
          ),
        ),
        IconButton(
          tooltip: '글자 크게',
          visualDensity: VisualDensity.compact,
          icon: Icon(Icons.add_circle_outline, color: focusColor),
          onPressed: onIncrease,
        ),
      ],
    );
  }
}

class _SectionHeader extends ConsumerWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppTextStyles styles = ref.watch(appTextStylesFontSizeProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 24, 8, 8),
      child: Text(
        title,
        style: styles.smallTextStyle.copyWith(
          fontWeight: FontWeight.w600,
          letterSpacing: 0.3,
        ),
      ),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? const Color(0xFF3D3D3D) : const Color(0xFFF6F6F2);
    return Container(
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _TileDivider extends StatelessWidget {
  const _TileDivider();

  @override
  Widget build(BuildContext context) => const Divider(
        height: 1,
        thickness: 1,
        indent: 52,
      );
}

class _SettingsTile extends ConsumerWidget {
  final IconData icon;
  final String title;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final AppTextStyles styles = ref.watch(appTextStylesFontSizeProvider);
    return InkWell(
      onTap: onTap,
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            children: [
              Icon(icon, size: 22, color: theme.iconTheme.color),
              const SizedBox(width: 14),
              Expanded(
                child: Text(title, style: styles.titleTextStyle),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
