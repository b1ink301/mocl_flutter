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

class MoclListPage extends StatelessWidget {
  const MoclListPage({super.key});

  static Widget init(double width, MainItem item) => ProviderScope(
    overrides: ListEvent.overridesProviderScope(width, item),
    child: const MoclListPage(),
  );

  @override
  Widget build(BuildContext context) {
    const child = _MoclListScaffold();

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

class _MoclListScaffold extends StatelessWidget {
  const _MoclListScaffold();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final systemOverlayStyle =
        theme.appBarTheme.systemOverlayStyle ?? SystemUiOverlayStyle.light;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: const MoclListView(),
      ),
    );
  }
}
