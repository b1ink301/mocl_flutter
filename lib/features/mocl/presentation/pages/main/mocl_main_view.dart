import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/bloc/main_data_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;

    return BlocBuilder<MainDataBloc, MainDataState>(
      builder: (context, state) {
        return state.map(
          initial: (_) => const LoadingWidget(),
          loading: (_) => const LoadingWidget(),
          success: (state) {
            if (state.data.isEmpty) {
              final height = MediaQuery.of(context).size.height - 120;
              return SizedBox(
                  height: height,
                  child: Center(
                    child: Text(
                      '항목이 없습니다',
                      style: textStyle,
                    ),
                  ));
            } else {
              return _buildListView(context, state.data, textStyle);
            }
          },
          failure: (state) => _buildErrorView(context, state.message),
        );
      },
    );
  }

  Widget _buildListView(
      BuildContext context, List<MainItem> items, TextStyle? textStyle) {
    return ListView.separated(
      itemCount: items.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemBuilder: (context, index) =>
          _buildListItem(context, items[index], textStyle),
      separatorBuilder: (_, __) => const DividerWidget(),
    );
  }

  Widget _buildListItem(
      BuildContext context, MainItem item, TextStyle? textStyle) {
    return ListTile(
      key: ValueKey(item.board),
      minTileHeight: 68,
      title: Text(item.text, style: textStyle),
      onTap: () => context.push(Routes.list, extra: item),
    );
  }

  Widget _buildErrorView(BuildContext context, String message) {
    return Padding(
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
}
