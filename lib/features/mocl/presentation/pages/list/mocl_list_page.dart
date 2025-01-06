import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_view_model.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_list_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/appbar_dual_text_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/dummy_appbar.dart';

class MoclListPage extends ConsumerWidget {
  const MoclListPage({super.key});

  static Widget withRiverpod(
    BuildContext context,
    MainItem item,
  ) =>
      AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).appBarTheme.systemOverlayStyle!,
        child: ProviderScope(
          overrides: [
            listViewModelProvider
                .overrideWith(() => ListViewModel()..initialize(item)),
          ],
          child: const MoclListPage(),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = Scaffold(
      appBar: buildDummyAppbar(context),
      body: SafeArea(
        left: false,
        right: false,
        child: RefreshIndicator(
          onRefresh: () async {},
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo is ScrollEndNotification) {
                if (context.mounted && scrollInfo.metrics.extentAfter < 800) {
                  ref.read(listViewModelProvider.notifier).fetchNextPage();
                }
              }
              return true;
            },
            child: const CustomScrollView(
              slivers: <Widget>[
                _ListAppbar(),
                MoclListView(),
              ],
            ),
          ),
        ),
      ),
    );

    return Platform.isMacOS
        ? Listener(
            onPointerDown: (event) {
              if (event.buttons == kSecondaryMouseButton) {
                GoRouter.of(context).pop();
              }
            },
            child: child,
          )
        : child;
  }
}

class _ListAppbar extends ConsumerWidget {
  const _ListAppbar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.read(listViewModelProvider.notifier);
    final smallTitle = viewModel.smallTitle;
    final title = viewModel.title;

    return AppbarDualTextWidget(
      smallTitle: smallTitle,
      title: title,
      automaticallyImplyLeading: Platform.isMacOS,
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.refresh),
        )
      ],
    );
  }
}
