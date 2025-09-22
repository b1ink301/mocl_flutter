import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/di/app_provider.dart';
import 'package:mocl_flutter/features/app_shell/presentation/routes/mocl_app_pages.dart';

import 'main_event_mixin.dart';
import 'main_state_mixin.dart';

part 'widgets/mocl_main_widgets.dart';

class MainView extends ConsumerWidget with MainEvent {
  const MainView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      RefreshIndicator.adaptive(
        color: Theme.of(context).focusColor,
        onRefresh: () async => handleRefresh(ref),
        child: CustomScrollView(
          slivers: <Widget>[
            PlatformWidget(
              material: (_, _) => const _MainAppBar(),
              cupertino: (_, _) => const _MainNavigationBar(),
            ),
            const _MainBody(),
          ],
        ),
      );
}
