import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/presentation/widgets/check_box_list_title_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/main/add_dialog/providers/add_list_dlg_providers.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class AddListModalSheetPage extends SliverWoltModalSheetPage {
  final BuildContext context;

  AddListModalSheetPage({required this.context})
    : super(
        topBarTitle: const Text('게시판 선택'),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
        navBarHeight: 62,
        enableDrag: true,
        isTopBarLayerAlwaysVisible: true,
        trailingNavBarWidget: Consumer(
          builder: (context, ref, _) => IconButton(
            padding: const EdgeInsets.all(10),
            icon: const Icon(Icons.check),
            onPressed: () {
              final selectedItems = ref
                  .read(addListDlgNotifierProvider.notifier)
                  .selectedItems();
              context.pop(selectedItems);
            },
          ),
        ),
        leadingNavBarWidget: IconButton(
          padding: const EdgeInsets.all(10),
          icon: const Icon(Icons.close),
          onPressed: context.pop,
        ),
        hasSabGradient: false,
        mainContentSliversBuilder: (_) => [
          Consumer(
            builder: (context, ref, _) => ref
                .watch(addListDlgNotifierProvider)
                .maybeWhen(
                  data: (data) => SliverList.separated(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final item = data[index];
                      return CheckBoxListTitleWidget(
                        text: item.mainItem.text,
                        isChecked: item.isChecked,
                        textStyle: Theme.of(context).textTheme.bodyMedium,
                        onChanged: (isChecked) => ref
                            .read(addListDlgNotifierProvider.notifier)
                            .onChanged(isChecked, index),
                      );
                    },
                    separatorBuilder: (_, _) => const DividerWidget(),
                  ),
                  orElse: () => const SliverToBoxAdapter(child: LoadingWidget()),
                ),
          ),
        ],
      );
}
