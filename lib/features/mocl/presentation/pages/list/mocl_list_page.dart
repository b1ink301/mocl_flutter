import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_list_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/pagination_notifier_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/dummy_appbar_widget.dart';

class MoclListPage extends ConsumerWidget {
  const MoclListPage({super.key});

  static Widget init(
    BuildContext context,
    MainItem item,
  ) =>
      AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).appBarTheme.systemOverlayStyle!,
        child: ProviderScope(
          overrides: [
            paginationNotifierProvider
                .overrideWith(() => PaginationNotifier()..initialize(item)),
            // currentMainItemProvider.overrideWith(() => CurrentMainItem()..setItem(item)),
          ],
          child: const MoclListPage(),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = Scaffold(
      appBar: DummyAppBarWidget.buildDummyAppbar(),
      body: const SafeArea(
        left: false,
        right: false,
        child: MoclListView(),
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
