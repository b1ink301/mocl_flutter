import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/presentation/widgets/check_box_list_title_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/message_widget.dart';
import 'package:mocl_flutter/features/app_shell/presentation/models/checkable_main_item.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/main/add_dialog/providers/add_list_dlg_providers.dart';

import '../../../../../../config/mocl_text_styles.dart';

class AddListDialog extends ConsumerWidget {
  const AddListDialog({super.key});

  static Widget init(BuildContext context) => const AddListDialog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addListDlgNotifierProvider);
    final size = MediaQuery.of(context).size;

    return PlatformAlertDialog(
      material: (_, _) => MaterialAlertDialogData(
        elevation: 8,
        title: _buildTitle(context),
        titlePadding: EdgeInsets.zero,
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 16,
        ),
      ),
      cupertino: (_, _) =>
          CupertinoAlertDialogData(title: PlatformText('게시판 선택')),
      content: _buildContent(context, state, size),
      actions: _buildActions(context),
    );
  }

  Widget _buildTitle(BuildContext context) => Column(
    children: [
      const SizedBox(height: 20),
      PlatformText('게시판 선택', style: Theme.of(context).textTheme.headlineMedium),
      const SizedBox(height: 20),
      const DividerWidget(thickness: 1, indent: 16, endIndent: 16),
    ],
  );

  Widget _buildContent(
    BuildContext context,
    AsyncValue<List<CheckableMainItem>> state,
    Size size,
  ) => SizedBox(
    width: size.width * 0.7,
    height: size.height * 0.6,
    child: state.when(
      data: (data) => _buildListView(context, data),
      error: (failure, _) => MessageWidget(message: failure.toString()),
      loading: () => const LoadingWidget(),
    ),
  );

  Widget _buildListView(BuildContext context, List<CheckableMainItem> items) =>
      Consumer(
        builder: (_, ref, _) => ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: items.length,
          separatorBuilder: (_, _) =>
              const DividerWidget(indent: 0, endIndent: 0),
          itemBuilder: (context, index) {
            final item = items[index];
            return CheckBoxListTitleWidget(
              text: item.mainItem.text,
              isChecked: item.isChecked,
              textStyle: MoclTextStyles.of(context).titleTextStyle,
              onChanged: (isChecked) => ref
                  .read(addListDlgNotifierProvider.notifier)
                  .onChanged(isChecked, index),
            );
          },
        ),
      );

  List<Widget> _buildActions(BuildContext context) => [
    PlatformDialogAction(
      onPressed: context.pop,
      child: PlatformText(
        '취소',
        style: Theme.of(context).textTheme.headlineMedium,
      ),
    ),
    Consumer(
      builder: (context, ref, _) => PlatformDialogAction(
        onPressed: () => context.pop(
          ref.read(addListDlgNotifierProvider.notifier).selectedItems(),
        ),
        child: PlatformText(
          '적용',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: Theme.of(context).focusColor,
          ),
        ),
      ),
    ),
  ];
}
