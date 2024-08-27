import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/view_model_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/check_box_list_title_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

class SetListDialog extends StatelessWidget {
  const SetListDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        '게시판 선택',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
      content: Consumer(
        builder: (context, ref, child) {
          final viewModel = ref.watch(mainDlgViewModelProvider.notifier);
          final data =
              ref.watch(mainDlgViewModelProvider.select((vm) => vm.data));

          return SizedBox(
            width: MediaQuery.of(context).size.width * 0.65,
            height: MediaQuery.of(context).size.height * 0.6,
            child: data.when(
              data: (result) => ListView.separated(
                padding: EdgeInsets.zero,
                itemCount: result.length,
                itemBuilder: (context, index) {
                  final item = result[index];
                  return CheckBoxListTitleWidget<MainItem>(
                    text: item.text,
                    object: item,
                    isChecked: item.hasItem,
                    textStyle: Theme.of(context).textTheme.bodyMedium,
                    onChanged: viewModel.onChanged,
                  );
                },
                separatorBuilder: (BuildContext context, int index) =>
                    const Divider(),
              ),
              error: (Object error, StackTrace stackTrace) =>
                  MessageWidget(message: 'message ${stackTrace.toString()}'),
              loading: () => const LoadingWidget(),
            ),
          );
        },
      ),
      actions: [
        Consumer(
          builder: (context, ref, child) {
            return TextButton(
              onPressed: () =>
                  ref.watch(mainDlgViewModelProvider.notifier).pop(context),
              child: Text(
                '닫기',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            );
          },
        ),
      ],
    );
  }
}
