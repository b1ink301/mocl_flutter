import 'package:easy_infinite_pagination/easy_infinite_pagination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/list_view/bloc/list_page_cubit.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_cached_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/cached_item_builder.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';

class ListView extends StatelessWidget {
  const ListView({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ListPageCubit, ListPageState>(
        builder: (context, state) {
          final bloc = context.watch<ListPageCubit>();
          
          return SliverInfiniteListView.separated(
            delegate: PaginationDelegate(
              isLoading: state is LoadingList,
              hasError: state is FailedList,
              hasReachedMax: bloc.hasReachedMax,
              invisibleItemsThreshold: 1,
              itemCount: bloc.listCount,
              itemBuilder: (context, index) {
                final item = bloc.getItem(index);
                return CachedItemBuilder(
                  key: ValueKey(item.item.id),
                  builder: () => CachedListItem(
                    key: ValueKey(item.item.id),
                    item: item.item,
                    isRead: item.isRead,
                    textStyles: bloc.textStyles,
                    onTap: () => bloc.onTap(context, item),
                  ),
                );
              },
              // here we add a custom error screen if the state is an error state.
              // and this screen will be shown if an error occurs while fetching data for the first page.
              // firstPageErrorBuilder: state is FailedList
              //     ? (context, onRetry) => CustomErrorScreen(
              //           errorMessage: state.message,
              //           onRetry: onRetry,
              //         )
              //     : null,
              // this method will be called when the user reaches the end of the list or for the first page.
              onFetchData: () async {
                await bloc.fetchPage();
              },
            ),
            separatorBuilder: (context, index) => const DividerWidget(),
          );
        },
      );
}
