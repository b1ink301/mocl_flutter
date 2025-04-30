import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/bloc/list_page_cubit.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/cached_item_builder.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';

@immutable
class MoclListView extends StatelessWidget {
  const MoclListView({super.key});

  @override
  Widget build(BuildContext context) {
    final ListPageCubit cubit = context.read<ListPageCubit>();
    return BlocBuilder<ListPageCubit, ListPageState>(
      builder: (BuildContext context, ListPageState state) =>
          SliverList.separated(
        addAutomaticKeepAlives: false,
        addRepaintBoundaries: true,
        addSemanticIndexes: false,
        separatorBuilder: (BuildContext context, int index) =>
            const DividerWidget(),
        itemBuilder: (BuildContext context, int index) {
          if (index == state.count) {
            if (state.error != null) {
              return _buildError(state.error!, cubit.fetchPage);
            } else if (state.hasReachedMax) {
              return const SizedBox.shrink();
            } else {
              return const Column(
                children: [LoadingWidget(), DividerWidget()],
              );
            }
          } else {
            final ReadableListItem item = cubit.getItem(index);
            return CachedItemBuilder(
              builder: () => ReadableListItemProvider(
                key: item.key,
                model: item,
                onTap: () => cubit.onTap(context, index),
                child: const MoclListItem(),
              ),
            );
          }
        },
        itemCount: state.count + 1,
      ),
    );
  }

  Widget _buildError(String errorMessage, VoidCallback onRetry) => Center(
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
