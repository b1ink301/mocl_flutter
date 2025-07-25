import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/di/app_provider.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/list/mocl_list_view.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/list/providers/list_providers.dart';

class MoclListPage extends ConsumerWidget {
  const MoclListPage({super.key});

  static Widget init(BuildContext context, MainItem item) =>
      AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).appBarTheme.systemOverlayStyle!,
        child: ProviderScope(
          overrides: [
            screenWidthProvider.overrideWithValue(
              MediaQuery.of(context).size.width,
            ),
            appbarTextStyleProvider.overrideWithValue(
              Platform.isIOS
                  ? CupertinoTheme.of(
                      context,
                    ).textTheme.navLargeTitleTextStyle.copyWith(height: 1.3)
                  : Theme.of(context).textTheme.labelMedium!,
            ),
            mainItemProvider.overrideWithValue(item),
          ],
          child: const MoclListPage(),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = PlatformScaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const SafeArea(
        top: false,
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
