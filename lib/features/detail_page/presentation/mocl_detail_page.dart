import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/detail_page/presentation/widgets/detail_scope.dart';

import '../../../config/mocl_text_styles.dart';
import '../../../core/application/app_provider.dart';
import '../../../core/util/utilities.dart';
import 'widgets/detail_appbar.dart';
import 'mocl_detail_view.dart';
import 'state/detail_event_mixin.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  static Widget init(double width, ListItem item) => ProviderScope(
    overrides: DetailEvent.overridesProviderScope(width, item),
    child: const DetailPage(),
  );

  @override
  Widget build(BuildContext context) {
    const child = _DetailScaffold();

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
}

class _DetailScaffold extends ConsumerWidget with DetailEvent {
  const _DetailScaffold();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final systemOverlayStyle =
        Theme.of(context).appBarTheme.systemOverlayStyle ??
        SystemUiOverlayStyle.light;

    final String hexColor = Theme.of(context).focusColor.stringHexColor;
    final AppTextStyles styles = ref.watch(appTextStylesFontSizeProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle,
      child: Container(
        color: systemOverlayStyle.statusBarColor,
        child: DetailStyleScope(
          styles: styles,
          hexColor: hexColor,
          child: SafeArea(
            bottom: false,
            child: Scaffold(
              body: RefreshIndicator.adaptive(
                color: Theme.of(context).focusColor,
                onRefresh: () async => handleRefresh(ref),
                child: const CustomScrollView(
                  // cacheExtent: 500,
                  slivers: [DetailAppBar(), DetailView()],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
