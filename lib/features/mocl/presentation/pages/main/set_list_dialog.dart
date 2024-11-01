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

  static Widget withBloc(
    BuildContext context,
    SiteType siteType,
  ) =>
      BlocProvider(
        child: const SetListDialog(),
        create: (BuildContext context) =>
            getIt<MainDataJsonBloc>()..add(GetListEvent(siteType: siteType)),
      );

  @override
  Widget build(BuildContext context) => _buildAlertDialog(context);

  AlertDialog _buildAlertDialog(BuildContext context) => AlertDialog(
        title: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              '게시판 선택',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            const DividerWidget(thickness: 1, indent: 16, endIndent: 16),
          ],
        ),
        elevation: 8,
        contentPadding:
            const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        titlePadding: EdgeInsets.zero,
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.7,
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
                '적용',
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
          final bloc = context.read<MainDataJsonBloc>();
          return CheckBoxListTitleWidget<MainItem>(
            text: item.text,
            object: item,
            isChecked: bloc.hasItem(item),
            textStyle: Theme.of(context).textTheme.bodyMedium,
            onChanged: onChanged,
          );
        },
        separatorBuilder: (BuildContext context, int index) =>
            const DividerWidget(indent: 0, endIndent: 0),
      );
}
