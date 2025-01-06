import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/add_dialog/add_list_dlg_view_model.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/check_box_list_title_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

class AddListDialog extends StatelessWidget {
  const AddListDialog({super.key});

  static Widget withRiverpod(
    BuildContext context,
    SiteType siteType,
  ) =>
      const AddListDialog();

  @override
  Widget build(BuildContext context) => _buildAlertDialog(context);

  AlertDialog _buildAlertDialog(BuildContext context) => AlertDialog(
        backgroundColor: Theme.of(context).dialogBackgroundColor,
        title: Column(
          children: [
            const SizedBox(height: 20),
            Text(
              '게시판 선택',
              style: Theme.of(context).textTheme.headlineMedium,
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
          child: Consumer(
              builder: (BuildContext context, WidgetRef ref, Widget? child) {
            final state = ref.watch(addListDlgViewModelProvider);
            return state.when(
              data: (data) => _buildListView(context, data,
                  ref.read(addListDlgViewModelProvider.notifier).onChanged),
              error: (failure, stackTrace) =>
                  MessageWidget(message: failure.toString()),
              loading: () => const LoadingWidget(),
            );
          }),
        ),
        actions: [
          TextButton(
            onPressed: () {
              if (context.mounted) {
                context.pop();
              }
            },
            child: Text(
              '취소',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
          Consumer(
            builder: (context, ref, child) => TextButton(
              onPressed: () {
                if (context.mounted) {
                  final viewModel =
                      ref.read(addListDlgViewModelProvider.notifier);
                  context.pop(viewModel.selectedItems);
                }
              },
              child: Text(
                '적용',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(color: Theme.of(context).indicatorColor),
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
      Consumer(
        builder: (context, ref, child) {
          return ListView.separated(
            padding: EdgeInsets.zero,
            itemCount: data.length,
            itemBuilder: (context, index) {
              final item = data[index];
              return CheckBoxListTitleWidget<MainItem>(
                text: item.text,
                object: item,
                isChecked: ref
                    .read(addListDlgViewModelProvider.notifier)
                    .hasItem(item),
                textStyle: Theme.of(context).textTheme.bodyMedium,
                onChanged: onChanged,
              );
            },
            separatorBuilder: (BuildContext context, int index) =>
                const DividerWidget(indent: 0, endIndent: 0),
          );
        },
      );
}
