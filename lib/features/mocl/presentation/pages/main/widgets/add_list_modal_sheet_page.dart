import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/add_dialog/providers/add_list_dlg_providers.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/check_box_list_title_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/loading_widget.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

class AddListModalSheetPage extends SliverWoltModalSheetPage {
  final BuildContext context;

  AddListModalSheetPage({required this.context})
      : super(
          topBarTitle: Text('게시판 선택'),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
          navBarHeight: 64,
          enableDrag: false,
          isTopBarLayerAlwaysVisible: true,
          leadingNavBarWidget: Consumer(
            builder: (context, ref, child) => IconButton(
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
          trailingNavBarWidget: IconButton(
            padding: const EdgeInsets.all(10),
            icon: const Icon(Icons.close),
            onPressed: Navigator.of(context).pop,
          ),
          hasSabGradient: false,
          mainContentSliversBuilder: (context) => [
            Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(addListDlgNotifierProvider);
                final notifier = ref.read(addListDlgNotifierProvider.notifier);

                return state.maybeWhen(
                    data: (data) => SliverList.separated(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            final item = data[index];
                            return CheckBoxListTitleWidget(
                                text: item.mainItem.text,
                                isChecked: item.isChecked,
                                textStyle:
                                    Theme.of(context).textTheme.bodyMedium,
                                onChanged: (bool isChecked) {
                                  notifier.onChanged(isChecked, index);
                                });
                          },
                          separatorBuilder: (_, __) => DividerWidget(),
                        ),
                    orElse: () => SliverToBoxAdapter(child: LoadingWidget()));
              },
            ),
          ],
        );
}
