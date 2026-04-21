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

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          appVersionState(ref).maybeWhen(
            orElse: () => _buildLoadingView(context),
            data: (version) => SizedBox(
              height: 58,
              child: Center(
                child: Text(
                  '버전 $version',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),
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
                  child: Text(
                    '캐시 데이터 삭제 ($data)',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
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
                Text('닉 이미지 보기', style: Theme.of(context).textTheme.bodyMedium),
                Checkbox(
                  value: showNickImageState(ref),
                  activeColor: Theme.of(context).focusColor,
                  onChanged: (bool? value) => {handleToggleNickImage(ref)},
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
                  CircularProgressIndicator(
                    color: Theme.of(context).focusColor,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Google Drive와 동기화 중...',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
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
                      child: Text(
                        'Google Drive로 백업',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
                const DividerWidget(),
                InkWell(
                  onTap: isSyncing ? null : () => handleRestore(ref),
                  child: SizedBox(
                    height: 58,
                    child: Center(
                      child: Text(
                        'Google Drive에서 복원',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          const DividerWidget(),
        ],
      ),
    );
  }

  Widget _buildLoadingView(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
    child: Center(
      child: CircularProgressIndicator(color: Theme.of(context).focusColor),
    ),
  );
}
