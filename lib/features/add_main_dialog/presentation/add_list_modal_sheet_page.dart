import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/presentation/widgets/check_box_list_title_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';

import 'state/add_event_mixin.dart';
import 'state/add_state_mixin.dart';

class AddListBottomSheet extends ConsumerWidget with AddState, AddEvent {
  const AddListBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = Theme.of(context).scaffoldBackgroundColor;

    return DraggableScrollableSheet(
      initialChildSize: 0.9,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) => Container(
        color: color,
        child: Column(
          children: [
            // 상단 바
            Padding(
              padding: const .symmetric(horizontal: 4),
              child: SizedBox(
                height: 62,
                child: Row(
                  children: [
                    IconButton(
                      padding: const .all(10),
                      icon: const Icon(Icons.close),
                      onPressed: () => context.pop(),
                    ),
                    const Expanded(child: Center(child: Text('게시판 선택'))),
                    IconButton(
                      padding: const .all(10),
                      icon: const Icon(Icons.check),
                      onPressed: () => pop(ref, context),
                    ),
                  ],
                ),
              ),
            ),
            const DividerWidget(),
            // 콘텐츠
            Expanded(
              child: addState(ref).maybeWhen(
                data: (data) => ListView.separated(
                  controller: scrollController,
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final item = data[index];
                    return CheckBoxListTitleWidget(
                      text: item.mainItem.text,
                      isChecked: item.isChecked,
                      textStyle: Theme.of(context).textTheme.bodyMedium,
                      onChanged: (isChecked) =>
                          onChanged(ref, isChecked, index),
                    );
                  },
                  separatorBuilder: (_, _) => const DividerWidget(),
                ),
                error: (error, _) => Padding(
                  padding: const .all(8.0),
                  child: Text(error.toString()),
                ),
                orElse: () => const LoadingWidget(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
