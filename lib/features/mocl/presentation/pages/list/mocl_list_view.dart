import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/bloc/list_page_cubit.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/cached_item_builder.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';
import 'package:super_sliver_list/super_sliver_list.dart';

class MoclListView extends StatelessWidget {
  const MoclListView({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ListPageCubit, ListPageState>(
        builder: (context, state) {
          final ListPageCubit bloc = context.read<ListPageCubit>();
          return SuperSliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                if (index == bloc.listCount) {
                  return const Column(
                    children: [LoadingWidget(), DividerWidget()],
                  );
                }
                final item = bloc.getItem(index);
                return CachedItemBuilder(
                  key: item.key,
                  builder: () => Column(
                    children: [
                      MoclListItem(
                        item: item,
                        onTap: () => bloc.onTap(context, item),
                      ),
                      const DividerWidget(),
                    ],
                  ),
                );
              },
              childCount: bloc.listCount + 1,
            ),
          );
        },
      );

  Widget _buildError(String errorMessage, VoidCallback onRetry) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              Icons.error,
              color: Colors.red,
              size: 64.0,
            ),
            const SizedBox(height: 16.0),
            Text(errorMessage),
            const SizedBox(height: 16.0),
            ElevatedButton(onPressed: onRetry, child: const Text('재시도')),
          ],
        ),
      ),
    );
  }
}
