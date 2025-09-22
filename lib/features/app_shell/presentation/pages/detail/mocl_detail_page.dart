import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';

import 'detail_appbar.dart';
import 'detail_event_mixin.dart';
import 'detail_state_mixin.dart';
import 'mocl_detail_view.dart';

class DetailPage extends ConsumerWidget with DetailState, DetailEvent {
  const DetailPage({super.key});

  static Widget init(
    BuildContext context,
    ListItem item,
    double statusBarHeight,
  ) => ProviderScope(
    overrides: DetailEvent.overridesProviderScope(context, item),
    child: AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).appBarTheme.systemOverlayStyle!,
      child: Stack(
        children: [
          const Positioned.fill(child: DetailPage()),
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
    final child = PlatformScaffold(
      appBar: isCupertino(context)
          ? PlatformAppBar(
              cupertino: (BuildContext context, PlatformTarget platform) =>
                  CupertinoNavigationBarData(
                    previousPageTitle: smallTitleState(ref),
                    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                    trailing: _buildPopupMenuButton(context, ref),
                  ),
            )
          : null,
      body: RefreshIndicator.adaptive(
        color: Theme.of(context).focusColor,
        onRefresh: () async => handleRefresh(ref),
        child: const CustomScrollView(
          cacheExtent: 1600,
          slivers: [DetailAppBar(), DetailView()],
        ),
      ),
    );

    return Platform.isMacOS || Platform.isAndroid
        ? Listener(
            behavior: HitTestBehavior.opaque,
            onPointerDown: (event) {
              if (event.kind == PointerDeviceKind.mouse &&
                  event.buttons == kSecondaryMouseButton) {
                context.pop();
              }
            },
            child: child,
          )
        : child;
  }

  Widget _buildPopupMenuButton(BuildContext context, WidgetRef ref) =>
      PlatformPopupMenu(
        icon: Icon(
          size: 24,
          context.platformIcon(
            material: Icons.more_vert_rounded,
            cupertino: CupertinoIcons.ellipsis,
          ),
        ),
        options: [
          PopupMenuOption(label: '새로고침', onTap: (_) => handleRefresh(ref)),
          PopupMenuOption(
            label: '브라우저로 열기',
            onTap: (_) => handleOpenBrowser(ref),
          ),
          PopupMenuOption(label: '공유하기', onTap: (_) => handleShareUrl(ref)),
        ],
      );
}
