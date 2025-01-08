import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/add_dialog/providers/add_list_dlg_providers.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/check_box_list_title_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

class AddListDialog extends ConsumerWidget {
  const AddListDialog({super.key});

  static Widget init(BuildContext context) => const AddListDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addListDlgNotifierProvider);
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return AlertDialog(
      backgroundColor: theme.dialogBackgroundColor,
      elevation: 8,
      titlePadding: EdgeInsets.zero,
      contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
      title: _buildTitle(context),
      content: _buildContent(context, state, size),
      actions: _buildActions(context, theme),
    );
  }

  Widget _buildTitle(BuildContext context) => Column(
        children: [
          const SizedBox(height: 20),
          Text(
            '게시판 선택',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 20),
          const DividerWidget(thickness: 1, indent: 16, endIndent: 16),
        ],
      );

  Widget _buildContent(
    BuildContext context,
    AsyncValue<List<MainItem>> state,
    Size size,
  ) =>
      SizedBox(
        width: size.width * 0.7,
        height: size.height * 0.7,
        child: state.when(
          data: (data) => _buildListView(context, data),
          error: (failure, _) => MessageWidget(message: failure.toString()),
          loading: () => const LoadingWidget(),
        ),
      );

  Widget _buildListView(
    BuildContext context,
    List<MainItem> items,
  ) =>
      Consumer(
        builder: (context, ref, child) {
          final viewModel = ref.read(addListDlgNotifierProvider.notifier);
          return ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: items.length,
            separatorBuilder: (_, __) =>
                const DividerWidget(indent: 0, endIndent: 0),
            itemBuilder: (context, index) {
              final item = items[index];
              return CheckBoxListTitleWidget<MainItem>(
                text: item.text,
                object: item,
                isChecked: viewModel.hasItem(item),
                textStyle: Theme.of(context).textTheme.bodyMedium,
                onChanged: viewModel.onChanged,
              );
            },
          );
        },
      );

  List<Widget> _buildActions(
    BuildContext context,
    ThemeData theme,
  ) =>
      [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(
            '취소',
            style: theme.textTheme.headlineMedium,
          ),
        ),
        Consumer(
          builder: (context, ref, child) {
            final viewModel = ref.read(addListDlgNotifierProvider.notifier);
            return TextButton(
              onPressed: () => context.pop(viewModel.selectedItems),
              child: Text(
                '적용',
                style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.indicatorColor,
                ),
              ),
            );
          },
        ),
      ];
}
