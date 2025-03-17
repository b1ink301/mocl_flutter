import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/settings/settings_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static Widget init(
    BuildContext context,
  ) =>
      AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).appBarTheme.systemOverlayStyle!,
        child: const SettingsPage(),
      );

  Widget _buildAppBar(BuildContext context) {
    final Color? backgroundColor =
        Theme.of(context).appBarTheme.backgroundColor;
    return PlatformSliverAppBar(
      backgroundColor: backgroundColor,
      material: (_, __) => MaterialSliverAppBarData(
        flexibleSpace: Container(color: backgroundColor),
        titleSpacing: 0,
        pinned: true,
        centerTitle: false,
        toolbarHeight: 64,
        title: _buildTitle(context, SiteType.settings.title),
      ),
      cupertino: (_, __) => CupertinoSliverAppBarData(
        heroTag: 'settings-appbar',
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: PlatformText(SiteType.settings.title),
        previousPageTitle: '이전',
      ),
    );
  }

  Widget _buildTitle(BuildContext context, String title) => MessageWidget(
        message: title,
        textStyle: isCupertino(context)
            ? null
            : Theme.of(context).textTheme.labelMedium,
      );

  @override
  Widget build(BuildContext context) {
    final child = PlatformScaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            _buildAppBar(context),
            const SettingsView(),
          ],
        ),
      ),
      material: (context, platform) => MaterialScaffoldData(),
      cupertino: (context, platform) => CupertinoPageScaffoldData(),
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
