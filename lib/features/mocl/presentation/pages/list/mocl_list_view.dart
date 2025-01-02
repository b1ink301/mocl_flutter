import 'package:easy_infinite_pagination/easy_infinite_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/bloc/list_page_cubit.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/cached_item_builder.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';

class MoclListView extends StatelessWidget {
  const MoclListView({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ListPageCubit, ListPageState>(
        builder: (context, state) {
          final ListPageCubit bloc = context.read<ListPageCubit>();
          return SliverInfiniteListView.separated(
            enableShrinkWrapForFirstPageIndicators: true,
            delegate: PaginationDelegate(
              isLoading: state is LoadingList,
              hasError: state is FailedList,
              hasReachedMax: bloc.hasReachedMax,
              itemCount: bloc.listCount,
              loadMoreLoadingBuilder: (_) => const LoadingWidget(),
              firstPageLoadingBuilder: (_) => const Column(
                children: [LoadingWidget(), DividerWidget()],
              ),
              itemBuilder: (context, index) {
                final item = bloc.getItem(index);
                return CachedItemBuilder(
                    key: ObjectKey(item),
                    builder: () => MoclListItem(
                          item: item,
                          onTap: () => bloc.onTap(context, item),
                        ));
              },
              firstPageErrorBuilder: state is FailedList
                  ? (context, onRetry) => _buildError(
                        state.message,
                        onRetry,
                      )
                  : null,
              onFetchData: bloc.fetchPage,
            ),
            separatorBuilder: (_, __) => const DividerWidget(),
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
