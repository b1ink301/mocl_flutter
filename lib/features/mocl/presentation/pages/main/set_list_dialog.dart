import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/injection.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/bloc/main_data_json_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/check_box_list_title_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

class SetListDialog extends StatelessWidget {
  const SetListDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final siteType = GoRouterState.of(context).extra as SiteType;

    return BlocProvider(
      child: _buildAlertDialog(context),
      create: (BuildContext context) =>
          getIt<MainDataJsonBloc>()..add(GetListEvent(siteType: siteType)),
    );
  }

  AlertDialog _buildAlertDialog(BuildContext context) => AlertDialog(
        title: Text(
          '게시판 선택',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.65,
          height: MediaQuery.of(context).size.height * 0.6,
          child: BlocBuilder<MainDataJsonBloc, MainDataJsonState>(
            builder: (context, state) {
              final bloc = context.read<MainDataJsonBloc>();
              return state.map(
                initial: (_) => const LoadingWidget(),
                loading: (_) => const LoadingWidget(),
                success: (state) =>
                    _buildListView(context, state.data, bloc.onChanged),
                failure: (state) => MessageWidget(message: state.message),
              );
            },
          ),
        ),
        actions: [
          Builder(
            builder: (context) => TextButton(
              onPressed: () {
                log('[onPressed] mounted = ${context.mounted}');
                if (context.mounted) {
                  final bloc = BlocProvider.of<MainDataJsonBloc>(context);
                  log('[onPressed] =${bloc.selectedItems.length}');
                  context.pop(bloc.selectedItems);
                }
              },
              child: Text(
                '닫기',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
          ),
        ],
      );

  Widget _buildListView(
    BuildContext context,
    List<MainItem> data,
    void Function<T>(bool, T?)? onChanged,
  ) =>
      ListView.separated(
        padding: EdgeInsets.zero,
        itemCount: data.length,
        itemBuilder: (context, index) {
          final item = data[index];
          return CheckBoxListTitleWidget<MainItem>(
            text: item.text,
            object: item,
            isChecked: item.hasItem,
            textStyle: Theme.of(context).textTheme.bodyMedium,
            onChanged: onChanged,
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const DividerWidget(indent: 0, endIndent: 0),
      );
}
