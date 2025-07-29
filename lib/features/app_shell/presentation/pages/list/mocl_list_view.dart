import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/list/bloc/list_item_cubit.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/list/bloc/list_paging_cubit.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/list/mocl_list_item.dart';
import 'package:mocl_flutter/features/app_shell/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/app_shell/presentation/widgets/loading_widget.dart';

@immutable
class MoclListView extends StatelessWidget {
  const MoclListView({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ListPagingCubit, PagingState<int, ListItemCubit>>(
        bloc: context.read<ListPagingCubit>(),
        builder: (context, state) =>
            PagedSliverList<int, ListItemCubit>.separated(
              state: state,
              shrinkWrapFirstPageIndicators: true,
              addSemanticIndexes: false,
              addAutomaticKeepAlives: false,
              fetchNextPage: context.read<ListPagingCubit>().fetchPage,
              builderDelegate: PagedChildBuilderDelegate<ListItemCubit>(
                invisibleItemsThreshold: 1,
                firstPageProgressIndicatorBuilder: (_) =>
                    const Column(children: [LoadingWidget(), DividerWidget()]),
                newPageProgressIndicatorBuilder: (_) => const LoadingWidget(),
                itemBuilder: (_, cubit, _) => BlocProvider.value(
                  value: cubit,
                  child: const MoclListItem(),
                ),
              ),
              separatorBuilder: (_, _) => const DividerWidget(),
            ),
      );
}
