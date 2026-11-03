import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/presentation/widgets/list_detail_layout.dart';
import 'package:mocl_flutter/features/detail_page/presentation/mocl_detail_page.dart';
import 'package:mocl_flutter/features/list_page/presentation/state/list_event_mixin.dart';

import 'mocl_list_view.dart';

class const MoclListPage({super.key}) extends StatelessWidget {
  static Widget init(MainItem item) => ProviderScope(
    overrides: ListEvent.overridesProviderScope(item),
    child: const MoclListPage(),
  );

  @override
  Widget build(BuildContext context) {
    // 넓은 화면(태블릿 가로 · 펼친 폴드 · iPad)에서는 목록 옆에 상세를 둔다.
    final child = ListDetailLayout<ListItem>(
      list: const _MoclListScaffold(),
      detailBuilder: (_, item) => DetailPage.init(item),
      pushDetail: (context, item) =>
          context.push<void>(Routes.detail, extra: item),
      keyOf: (item) => item.id,
      detailRoutePath: Routes.detail,
    );

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

class const _MoclListScaffold() extends StatelessWidget {
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
