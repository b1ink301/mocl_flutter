import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';

import 'detail_appbar.dart';
import 'mocl_detail_view.dart';
import 'state/detail_event_mixin.dart';
import 'state/detail_state_mixin.dart';

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
    final child = Scaffold(
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
            behavior: .opaque,
            onPointerDown: (event) {
              if (event.kind == .mouse &&
                  event.buttons == kSecondaryMouseButton) {
                context.pop();
              }
            },
            child: child,
          )
        : child;
  }
}
