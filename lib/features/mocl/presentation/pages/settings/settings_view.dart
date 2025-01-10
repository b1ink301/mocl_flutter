import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverToBoxAdapter(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ref.read(getAppVersionProvider).maybeWhen(
              orElse: () => _buildLoadingView(),
              data: (version) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    version,
                    style: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).indicatorColor,
                    ),
                  ),
                );
              }),
          const DividerWidget(),
          ref.watch(clearDataNotiferProvider).maybeWhen(
              orElse: () => _buildLoadingView(),
              data: (data) {
                return InkWell(
                  onTap: () {
                    ref.read(clearDataNotiferProvider.notifier).clear();
                  },
                  child: Container(
                    width: double.infinity,
                    height: 58,
                    alignment: Alignment.center,
                    child: Text(
                      '캐시 데이터 삭제',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Theme.of(context).indicatorColor,
                          ),
                    ),
                  ),
                );
              }),
          const DividerWidget(),
        ],
      ),
    );
  }

  Widget _buildLoadingView() => const LoadingWidget();

  Widget _buildErrorView(BuildContext context, String message) => Padding(
        padding: const EdgeInsets.all(12.0),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 16,
            color: Theme.of(context).indicatorColor,
          ),
        ),
      );
}
