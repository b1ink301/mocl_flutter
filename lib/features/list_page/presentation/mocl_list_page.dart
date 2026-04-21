import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/list_page/presentation/state/list_event_mixin.dart';

import 'mocl_list_view.dart';

class MoclListPage extends ConsumerWidget {
  const MoclListPage({super.key});

  static Widget init(BuildContext context, MainItem item) =>
      AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).appBarTheme.systemOverlayStyle!,
        child: ProviderScope(
          overrides: ListEvent.overridesProviderScope(context, item),
          child: const MoclListPage(),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = Container(
      color: Theme.of(context).appBarTheme.systemOverlayStyle?.statusBarColor,
      child: SafeArea(
        bottom: false,
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: const MoclListView(),
        ),
      ),
    );

    return !kIsWeb && Platform.isMacOS
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
