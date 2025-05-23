import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/settings/providers/settings_providers.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ref.read(getAppVersionProvider).maybeWhen(
                orElse: () => _buildLoadingView(context),
                data: (version) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: Text(
                        version,
                        style: TextStyle(
                          fontSize: 17,
                          color: Theme.of(context).highlightColor,
                        ),
                      ),
                    )),
            const DividerWidget(),
            ref.watch(sizeCacheDirNotifierProvider).maybeWhen(
                orElse: () => _buildLoadingView(context),
                data: (data) => InkWell(
                      onTap: () => ref
                          .read(sizeCacheDirNotifierProvider.notifier)
                          .clear(),
                      child: Container(
                        width: double.infinity,
                        height: 58,
                        alignment: Alignment.center,
                        child: Text(
                          '캐시 데이터 삭제 ($data)',
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: Theme.of(context).highlightColor,
                                  ),
                        ),
                      ),
                    )),
            const DividerWidget(),
          ],
        ),
      );

  Widget _buildLoadingView(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
        child: Center(
            child: CircularProgressIndicator(
          color: Theme.of(context).highlightColor,
        )),
      );
}
