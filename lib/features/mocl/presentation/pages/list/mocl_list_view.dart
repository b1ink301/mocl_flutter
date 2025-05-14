import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/bloc/list_item_cubit.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/bloc/list_paging_cubit.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/cached_item_builder.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';

@immutable
class MoclListView extends StatelessWidget {
  const MoclListView({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<ListPagingCubit, PagingState<int, ListItemCubit>>(
        bloc: context.read<ListPagingCubit>(),
        builder:
            (context, state) => SliverPadding(
              padding: const EdgeInsets.only(left: 15, right: 8),
              sliver: PagedSliverList<int, ListItemCubit>.separated(
                state: state,
                shrinkWrapFirstPageIndicators: true,
                fetchNextPage: context.read<ListPagingCubit>().fetchPage,
                builderDelegate: PagedChildBuilderDelegate<ListItemCubit>(
                  firstPageProgressIndicatorBuilder:
                      (_) => const Column(
                        children: [
                          LoadingWidget(),
                          DividerWidget(indent: 0, endIndent: 0),
                        ],
                      ),
                  newPageProgressIndicatorBuilder: (_) => const LoadingWidget(),
                  itemBuilder:
                      (_, cubit, _) => CachedItemBuilder(
                        builder:
                            () => BlocProvider.value(
                              key: cubit.state.key,
                              value: cubit,
                              child: const MoclListItem(),
                            ),
                      ),
                ),
                separatorBuilder:
                    (_, _) => const DividerWidget(indent: 0, endIndent: 0),
              ),
            ),
      );
}
