import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_view_model.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/cached_item_builder.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class MoclListView extends ConsumerWidget {
  const MoclListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(listViewModelProvider);
    final viewModel = ref.read(listViewModelProvider.notifier);

    return SuperSliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          // 현재 데이터의 마지막 인덱스인 경우
          if (index == viewModel.listCount) {
            return state.when(
              loaded: () => const LoadingWidget(),
              failed: (error) => _buildError(error, viewModel.refresh),
              loading: () => Column(
                children: [const LoadingWidget(), const DividerWidget()],
              ),
            );
          }

          // 일반 리스트 아이템 표시
          final item = viewModel.getItem(index);
          return CachedItemBuilder(
            key: item.key,
            builder: () => Column(
              children: [
                MoclListItem(
                  item: item,
                  onTap: () {
                    viewModel.handleItemTap(context, item);
                  },
                ),
                const DividerWidget(),
              ],
            ),
          );
        },
        childCount: viewModel.listCount + 1,
      ),
    );
  }

  Widget _buildError(String errorMessage, VoidCallback onRetry) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(errorMessage),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: onRetry,
                child: const Text('재시도'),
              ),
            ],
          ),
        ),
        const DividerWidget(),
      ],
    );
  }
}
