import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';
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

class const DetailPage({super.key}) extends StatelessWidget {
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

class const _DetailScaffold() extends ConsumerWidget with DetailEvent {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final systemOverlayStyle =
        theme.appBarTheme.systemOverlayStyle ?? SystemUiOverlayStyle.light;

    final String hexColor = theme.focusColor.stringHexColor;
    final focusColor = theme.focusColor;
    final AppTextStyles styles = ref.watch(appTextStylesFontSizeProvider);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: systemOverlayStyle,
      child: DetailStyleScope(
        styles: styles,
        hexColor: hexColor,
        child: Scaffold(
          body: RefreshIndicator.adaptive(
            color: focusColor,
            onRefresh: () async => handleRefresh(ref),
            child: const CustomScrollView(
              // cacheExtent: 500,
              slivers: [DetailAppBar(), DetailView()],
            ),
          ),
        ),
      ),
    );
  }
}
