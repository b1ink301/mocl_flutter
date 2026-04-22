import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/presentation/widgets/message_widget.dart';

import 'settings_view.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static Widget init(BuildContext context) =>
      AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).appBarTheme.systemOverlayStyle!,
        child: const SettingsPage(),
      );

  @override
  Widget build(BuildContext context) {
    final child = Container(
      color: Theme.of(context).appBarTheme.systemOverlayStyle?.statusBarColor,
      child: const SafeArea(
        bottom: false,
        child: Scaffold(
          body: CustomScrollView(
            slivers: <Widget>[_SettingsAppBar(), SettingsView()],
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

class _SettingsAppBar extends ConsumerWidget {
  const _SettingsAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final backgroundColor = Theme.of(context).appBarTheme.backgroundColor;
    return SliverAppBar(
      backgroundColor: backgroundColor,
      flexibleSpace: Container(color: backgroundColor),
      titleSpacing: 0,
      pinned: true,
      centerTitle: false,
      toolbarHeight: 64,
      title: _buildTitle(context, SiteType.settings.title),
    );
  }

  Widget _buildTitle(BuildContext context, String title) => MessageWidget(
    message: title,
    textStyle: Theme.of(context).textTheme.labelMedium,
  );
}
