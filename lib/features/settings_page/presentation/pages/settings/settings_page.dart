import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/application/app_provider.dart';
import '../../../../../core/presentation/widgets/plain_text.dart';
import 'settings_view.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static Widget init(BuildContext context) => const SettingsPage();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;
    final systemOverlayStyle = appBarTheme.systemOverlayStyle;

    final child = Container(
      color: systemOverlayStyle?.statusBarColor,
      child: SafeArea(
        bottom: false,
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value:
              systemOverlayStyle ??
              (theme.brightness == Brightness.dark
                  ? SystemUiOverlayStyle.light
                  : SystemUiOverlayStyle.dark),
          child: const Scaffold(
            body: CustomScrollView(
              slivers: <Widget>[_SettingsAppBar(), SettingsView()],
            ),
          ),
        ),
      ),
    );

    if (Platform.isMacOS) {
      return Listener(
        onPointerDown: (event) {
          if (event.buttons == kSecondaryMouseButton) {
            context.pop();
          }
        },
        child: child,
      );
    }

    return child;
  }
}

class _SettingsAppBar extends ConsumerWidget {
  const _SettingsAppBar();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;
    final titleStyle = ref.watch(appbarTextStyleProvider);

    return SliverAppBar(
      backgroundColor: appBarTheme.backgroundColor,
      // automaticallyImplyLeading: Platform.isMacOS,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      floating: true,
      toolbarHeight: kToolbarHeight,
      pinned: true,
      title: PlainText('설정', style: titleStyle),
    );
  }
}
