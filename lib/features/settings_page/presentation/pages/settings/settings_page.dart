import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/presentation/widgets/message_widget.dart';

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

class _SettingsAppBar extends StatelessWidget {
  const _SettingsAppBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final appBarTheme = theme.appBarTheme;
    final textStyle = theme.textTheme.labelMedium;
    return SliverAppBar(
      backgroundColor: appBarTheme.backgroundColor,
      titleSpacing: 0,
      pinned: true,
      centerTitle: false,
      toolbarHeight: 64,
      title: MessageWidget(message: '설정', textStyle: textStyle),
    );
  }
}
