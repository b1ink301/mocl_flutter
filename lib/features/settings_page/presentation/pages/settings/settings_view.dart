import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/core/presentation/widgets/divider_widget.dart';

import '../../state/settings_event_mixin.dart';
import '../../state/settings_state_mixin.dart';

class SettingsView extends ConsumerWidget with SettingsState, SettingsEvent {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    listenSyncStatus(ref);

    final isSyncing = isSyncingState(ref);
    final theme = Theme.of(context);
    final bodyMedium = theme.textTheme.bodyMedium;
    final focusColor = theme.focusColor;
    final bottom = MediaQuery.of(context).padding.bottom;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: .center,
        children: [
          appVersionState(ref).maybeWhen(
            orElse: () => _buildLoadingView(context),
            data: (version) => SizedBox(
              height: 58,
              child: Center(child: Text('버전 $version', style: bodyMedium)),
            ),
          ),
          const DividerWidget(),
          cacheSizeState(ref).maybeWhen(
            orElse: () => _buildLoadingView(context),
            data: (data) => InkWell(
              onTap: () => handleClearCache(ref),
              child: SizedBox(
                height: 58,
                child: Center(
                  child: Text('캐시 데이터 삭제 ($data)', style: bodyMedium),
                ),
              ),
            ),
          ),
          const DividerWidget(),
          SizedBox(
            height: 58,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('닉 이미지 보기', style: bodyMedium),
                Checkbox(
                  value: showNickImageState(ref),
                  activeColor: focusColor,
                  onChanged: (bool? value) => handleToggleNickImage(ref),
                ),
              ],
            ),
          ),
          const DividerWidget(),
          if (isSyncing)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CircularProgressIndicator(color: focusColor),
                  const SizedBox(height: 8),
                  Text('Google Drive와 동기화 중...', style: bodyMedium),
                ],
              ),
            )
          else
            Column(
              children: [
                InkWell(
                  onTap: isSyncing ? null : () => handleBackup(ref),
                  child: SizedBox(
                    height: 58,
                    child: Center(
                      child: Text('Google Drive로 백업', style: bodyMedium),
                    ),
                  ),
                ),
                const DividerWidget(),
                InkWell(
                  onTap: isSyncing ? null : () => handleRestore(ref),
                  child: SizedBox(
                    height: 58,
                    child: Center(
                      child: Text('Google Drive에서 복원', style: bodyMedium),
                    ),
                  ),
                ),
              ],
            ),
          const DividerWidget(),
          Padding(padding: .only(bottom: bottom)),
        ],
      ),
    );
  }

  Widget _buildLoadingView(BuildContext context) {
    final focusColor = Theme.of(context).focusColor;
    return Padding(
      padding: const .symmetric(horizontal: 0, vertical: 10),
      child: Center(child: CircularProgressIndicator(color: focusColor)),
    );
  }
}
