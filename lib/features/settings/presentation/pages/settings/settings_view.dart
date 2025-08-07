import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/di/app_provider.dart';
import 'package:mocl_flutter/core/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/google_drive/presentation/providers/google_drive_providers.dart';
import 'package:mocl_flutter/features/settings/presentation/pages/settings/providers/settings_providers.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<SyncStatus>(googleDriveSyncNotifierProvider, (previous, next) {
      // You can listen to the state and show dialogs or other widgets here if needed
    });

    final syncStatus = ref.watch(googleDriveSyncNotifierProvider);
    final isSyncing = syncStatus == SyncStatus.syncing;

    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ref.read(getAppVersionProvider).maybeWhen(
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
          ref.watch(sizeCacheDirNotifierProvider).maybeWhen(
                orElse: () => _buildLoadingView(context),
                data: (data) => InkWell(
                  onTap: () =>
                      ref.read(sizeCacheDirNotifierProvider.notifier).clear(),
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
                  value: ref.watch(showNickImageNotifierProvider),
                  activeColor: Theme.of(context).focusColor,
                  onChanged: (bool? value) => {
                    ref.read(showNickImageNotifierProvider.notifier).toggle(),
                  },
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
                      color: Theme.of(context).focusColor),
                  const SizedBox(height: 8),
                  Text('Google Drive와 동기화 중...',
                      style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            )
          else
            Column(
              children: [
                InkWell(
                  onTap: isSyncing
                      ? null
                      : () => ref
                          .read(googleDriveSyncNotifierProvider.notifier)
                          .backup(),
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
                  onTap: isSyncing
                      ? null
                      : () => ref
                          .read(googleDriveSyncNotifierProvider.notifier)
                          .restore(),
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
