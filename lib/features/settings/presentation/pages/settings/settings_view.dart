import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/di/app_provider.dart';
import 'package:mocl_flutter/core/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/settings/presentation/pages/settings/providers/settings_providers.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => SliverToBoxAdapter(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ref
            .read(getAppVersionProvider)
            .maybeWhen(
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
        ref
            .watch(sizeCacheDirNotifierProvider)
            .maybeWhen(
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
      ],
    ),
  );

  Widget _buildLoadingView(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
    child: Center(
      child: CircularProgressIndicator(color: Theme.of(context).focusColor),
    ),
  );
}
