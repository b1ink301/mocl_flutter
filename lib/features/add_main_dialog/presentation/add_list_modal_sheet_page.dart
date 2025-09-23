import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/presentation/widgets/check_box_list_title_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:wolt_modal_sheet/wolt_modal_sheet.dart';

import 'state/add_event_mixin.dart';
import 'state/add_state_mixin.dart';

class AddListModalSheetPage extends SliverWoltModalSheetPage {
  final BuildContext context;
  final Color color;

  AddListModalSheetPage({required this.context, required this.color})
    : super(
        topBarTitle: const Text('게시판 선택'),
        backgroundColor: color,
        surfaceTintColor: color,
        navBarHeight: 62,
        enableDrag: true,
        isTopBarLayerAlwaysVisible: true,
        trailingNavBarWidget: const _TrailingNavBarWidget(),
        leadingNavBarWidget: IconButton(
          padding: const EdgeInsets.all(10),
          icon: const Icon(Icons.close),
          onPressed: context.pop,
        ),
        hasSabGradient: false,
        mainContentSliversBuilder: (_) => const [_MainContent()],
      );
}

class _TrailingNavBarWidget extends ConsumerWidget with AddEvent {
  const _TrailingNavBarWidget();

  @override
  Widget build(BuildContext context, WidgetRef ref) => IconButton(
    padding: const EdgeInsets.all(10),
    icon: const Icon(Icons.check),
    onPressed: () => pop(ref, context),
  );
}

class _MainContent extends ConsumerWidget with AddState, AddEvent {
  const _MainContent();

  @override
  Widget build(BuildContext context, WidgetRef ref) => addState(ref).maybeWhen(
    data: (data) => SliverList.separated(
      itemCount: data.length,
      itemBuilder: (context, index) {
        final item = data[index];
        return CheckBoxListTitleWidget(
          text: item.mainItem.text,
          isChecked: item.isChecked,
          textStyle: Theme.of(context).textTheme.bodyMedium,
          onChanged: (isChecked) => onChanged(ref, isChecked, index),
        );
      },
      separatorBuilder: (_, _) => const DividerWidget(),
    ),
    error: (error, _) => SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(error.toString()),
      ),
    ),
    orElse: () => const SliverToBoxAdapter(child: LoadingWidget()),
  );
}
