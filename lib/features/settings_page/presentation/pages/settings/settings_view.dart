import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/application/app_provider.dart';

import '../../state/settings_event_mixin.dart';
import '../../state/settings_state_mixin.dart';

class const SettingsView({super.key})
    extends ConsumerWidget
    with SettingsState, SettingsEvent {
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
                  trailing: _ThemeModeSelector(
                    mode: themeModeState(ref),
                    onChanged: (mode) => handleChangeThemeMode(ref, mode),
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

            const _SectionHeader('내 게시판'),
            _SettingsCard(
              children: [
                _SettingsTile(
                  icon: Icons.account_circle_outlined,
                  title: '게시판 아이콘 보기',
                  onTap: () => handleToggleBoardIcon(ref),
                  trailing: Switch(
                    value: showBoardIconState(ref),
                    activeThumbColor: theme.focusColor,
                    onChanged: (_) => handleToggleBoardIcon(ref),
                  ),
                ),
                const _TileDivider(),
                _SettingsTile(
                  icon: Icons.swipe_vertical_outlined,
                  title: '사이트 빠른 이동',
                  onTap: () => handleToggleQuickJump(ref),
                  trailing: Switch(
                    value: showQuickJumpState(ref),
                    activeThumbColor: theme.focusColor,
                    onChanged: (_) => handleToggleQuickJump(ref),
                  ),
                ),
              ],
            ),

            const _SectionHeader('데이터'),
            _SettingsCard(
              children: [
                // 스크랩은 하단 탭에서 바로 갈 수 있어 여기 두지 않는다.
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
                    // 크기만 적어 두면 눌리는 항목인지 안 보여서, 값은 칩으로
                    // 감싸고 뒤에 화살표를 둬 다른 이동 타일과 결을 맞춘다.
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _ValueChip(text: data, style: styles.smallTextStyle),
                        const SizedBox(width: 4),
                        const Icon(Icons.chevron_right, size: 22),
                      ],
                    ),
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
              child: appVersionState(ref).when(
                loading: () => const SizedBox(
                  height: 16,
                  width: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
                // 버전 조회가 실패해도 로딩만 돌지 않도록 자리만 비워 둔다.
                error: (_, _) => const SizedBox(height: 16),
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

/// 테마 선택 컨트롤. Material 기본 SegmentedButton 은 강조색이 앱 테마(포인트
/// 색)와 어긋나고 라벨 세 개가 타일 폭을 크게 잡아먹어, 아이콘 세 개짜리
/// 알약형 트랙으로 직접 그린다. 선택 표시는 트랙 위를 미끄러지듯 움직인다.
class const _ThemeModeSelector({
  required final ThemeMode mode,
  required final ValueChanged<ThemeMode> onChanged,
}) extends StatelessWidget {
  static const List<({ThemeMode mode, IconData icon, String label})> _options =
      [
        (
          mode: ThemeMode.system,
          icon: Icons.brightness_auto_outlined,
          label: '시스템',
        ),
        (mode: ThemeMode.light, icon: Icons.light_mode_outlined, label: '라이트'),
        (mode: ThemeMode.dark, icon: Icons.dark_mode_outlined, label: '다크'),
      ];

  static const double _segmentWidth = 44;
  static const double _height = 34;
  static const Duration _duration = Duration(milliseconds: 200);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final Color focusColor = theme.focusColor;
    final int index = _options.indexWhere((o) => o.mode == mode);
    final int selected = index < 0 ? 0 : index;

    return Container(
      height: _height,
      width: _segmentWidth * _options.length,
      decoration: BoxDecoration(
        // 카드 위에 얹히므로 배경은 카드보다 살짝 눌린 정도로만 준다.
        color: isDark
            ? Colors.white.withValues(alpha: 0.07)
            : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(_height / 2),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: _duration,
            curve: Curves.easeOutCubic,
            left: _segmentWidth * selected,
            top: 0,
            bottom: 0,
            width: _segmentWidth,
            child: Container(
              margin: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                color: focusColor.withValues(alpha: isDark ? 0.30 : 0.16),
                borderRadius: BorderRadius.circular(_height / 2),
              ),
            ),
          ),
          Row(
            children: [
              for (final option in _options)
                _ThemeModeSegment(
                  option: option,
                  isSelected: option.mode == mode,
                  width: _segmentWidth,
                  onTap: () => onChanged(option.mode),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class const _ThemeModeSegment({
  required final ({ThemeMode mode, IconData icon, String label}) option,
  required final bool isSelected,
  required final double width,
  required final VoidCallback onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color tint = isSelected ? theme.focusColor : theme.hintColor;

    return Tooltip(
      message: option.label,
      child: SizedBox(
        width: width,
        child: Material(
          type: MaterialType.transparency,
          child: InkResponse(
            onTap: onTap,
            radius: width / 2,
            child: Center(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Icon(
                  option.icon,
                  key: ValueKey<bool>(isSelected),
                  size: 19,
                  color: tint,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// 글자 크기 조절 컨트롤. 같은 카드의 테마 선택과 시각 언어를 맞추기 위해,
/// 동그란 아이콘 버튼 대신 − / 현재 단계 / + 를 하나의 알약 트랙에 담는다.
/// 가운데 값을 탭하면 기본값으로 초기화한다. 단계 범위(-5~+10)는 SetFontSize
/// 유스케이스에서 보정되므로 버튼은 항상 활성.
class const _FontSizeControl({
  required final double delta,
  required final TextStyle labelStyle,
  required final Color focusColor,
  required final VoidCallback onDecrease,
  required final VoidCallback onIncrease,
  required final VoidCallback onReset,
}) extends StatelessWidget {
  static const double _height = 34;

  String get _label {
    if (delta == 0) return '기본';
    final int step = delta.toInt();
    return step > 0 ? '+$step' : '$step';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    final bool isDefault = delta == 0;

    return Container(
      height: _height,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.07)
            : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(_height / 2),
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        type: MaterialType.transparency,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _FontSizeButton(
              icon: Icons.remove,
              tooltip: '글자 작게',
              color: focusColor,
              onTap: onDecrease,
            ),
            InkWell(
              onTap: onReset,
              child: Container(
                constraints: const BoxConstraints(minWidth: 46),
                height: _height,
                alignment: Alignment.center,
                child: Text(
                  _label,
                  style: labelStyle.copyWith(
                    fontWeight: isDefault ? FontWeight.w500 : FontWeight.bold,
                    color: isDefault ? theme.hintColor : focusColor,
                  ),
                ),
              ),
            ),
            _FontSizeButton(
              icon: Icons.add,
              tooltip: '글자 크게',
              color: focusColor,
              onTap: onIncrease,
            ),
          ],
        ),
      ),
    );
  }
}

class const _FontSizeButton({
  required final IconData icon,
  required final String tooltip,
  required final Color color,
  required final VoidCallback onTap,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Tooltip(
    message: tooltip,
    child: InkWell(
      onTap: onTap,
      child: SizedBox(
        width: 40,
        height: _FontSizeControl._height,
        child: Icon(icon, size: 19, color: color),
      ),
    ),
  );
}

/// 타일 오른쪽에 값을 담는 작은 칩(캐시 크기 등).
class const _ValueChip({
  required final String text,
  required final TextStyle style,
}) extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.07)
            : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(text, style: style),
    );
  }
}

class const _SectionHeader(final String title) extends ConsumerWidget {
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

class const _SettingsCard({required final List<Widget> children})
    extends StatelessWidget {
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

class const _TileDivider() extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      const Divider(height: 1, thickness: 1, indent: 52);
}

class const _SettingsTile({
  required final IconData icon,
  required final String title,
  final Widget? trailing,
  final VoidCallback? onTap,
}) extends ConsumerWidget {
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
              Expanded(child: Text(title, style: styles.titleTextStyle)),
              if (trailing != null) ...[const SizedBox(width: 8), trailing!],
            ],
          ),
        ),
      ),
    );
  }
}
