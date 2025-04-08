import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/settings/bloc/clear_data_cubit.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/settings/bloc/get_version_cubit.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) => SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocBuilder<GetVersionCubit, GetVersionState>(
              builder: (context, state) => state.maybeMap(
                success: (state) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(
                    state.version,
                    style: TextStyle(
                      fontSize: 17,
                      color: Theme.of(context).indicatorColor,
                    ),
                  ),
                ),
                orElse: () => _buildLoadingView(),
              ),
            ),
            const DividerWidget(),
            BlocBuilder<ClearDataCubit, ClearDataState>(
              builder: (context, state) => state.maybeMap(
                loading: (state) => _buildLoadingView(),
                orElse: () => InkWell(
                  onTap: () => context.read<ClearDataCubit>().clearData(),
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
                ),
              ),
            ),
            const DividerWidget(),
          ],
        ),
      );

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
