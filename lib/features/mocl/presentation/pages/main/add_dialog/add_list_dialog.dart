import 'package:dartx/dartx.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/injection.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/add_dialog/bloc/main_data_json_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/check_box_list_title_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

class AddListDialog extends StatelessWidget {
  const AddListDialog({super.key});

  static Widget withBloc(BuildContext context, SiteType siteType) =>
      BlocProvider(
        child: const AddListDialog(),
        create: (BuildContext context) =>
            getIt<MainDataJsonBloc>()..add(GetListEvent(siteType: siteType)),
      );

  @override
  Widget build(BuildContext context) => _buildAlertDialog(context);

  AlertDialog _buildAlertDialog(BuildContext context) => AlertDialog(
    backgroundColor: DialogTheme.of(context).backgroundColor,
    title: Padding(
      padding: const EdgeInsets.only(left: 24, top: 20),
      child: Text(
        '게시판 선택',
        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
          color: Theme.of(context).focusColor,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    elevation: 12,
    contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
    titlePadding: EdgeInsets.zero,
    content: SizedBox(
      width: MediaQuery.of(context).size.width * 0.75,
      height: MediaQuery.of(context).size.height * 0.65,
      child: BlocBuilder<MainDataJsonBloc, MainDataJsonState>(
        builder: (BuildContext context, MainDataJsonState state) =>
            switch (state) {
              StateSuccess() => _buildListView(
                context,
                state.data,
                context.read<MainDataJsonBloc>().onChanged,
              ),
              StateFailure() => MessageWidget(message: state.message),
              _ => const LoadingWidget(),
            },
      ),
    ),
    actionsPadding: const EdgeInsets.only(right: 16, bottom: 12),
    buttonPadding: EdgeInsets.zero,
    actions: [
      TextButton(
        onPressed: () {
          if (context.mounted) {
            context.pop();
          }
        },
        child: Text('취소', style: Theme.of(context).textTheme.headlineMedium),
      ),
      TextButton(
        onPressed: () {
          if (context.mounted) {
            final bloc = context.read<MainDataJsonBloc>();
            context.pop(bloc.selectedItems.sortedBy((item) => item.orderBy));
          }
        },
        child: Text(
          '적용',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Theme.of(context).focusColor,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    ],
  );

  Widget _buildListView(
    BuildContext context,
    List<MainItem> data,
    void Function<T>(bool, T?)? onChanged,
  ) => ListView.separated(
    padding: EdgeInsets.zero,
    itemCount: data.length,
    itemBuilder: (context, index) {
      final item = data[index];
      return CheckBoxListTitleWidget<MainItem>(
        text: item.text,
        object: item,
        isChecked: context.read<MainDataJsonBloc>().hasItem(item),
        textStyle: Theme.of(context).textTheme.bodyMedium,
        onChanged: onChanged,
      );
    },
    separatorBuilder: (BuildContext context, int index) =>
        const DividerWidget(indent: 8, endIndent: 8),
  );
}
