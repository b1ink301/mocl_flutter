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

  static Widget init(
    BuildContext context,
    MainItem item,
    double statusBarHeight,
  ) => AnnotatedRegion<SystemUiOverlayStyle>(
    value: Theme.of(context).appBarTheme.systemOverlayStyle!,
    child: ProviderScope(
      overrides: ListEvent.overridesProviderScope(context, item),
      child: Stack(
        children: [
          const Positioned.fill(child: MoclListPage()),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: statusBarHeight,
              color: const Color(0x22000000),
            ),
          ),
        ],
      ),
    ),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const MoclListView(),
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
