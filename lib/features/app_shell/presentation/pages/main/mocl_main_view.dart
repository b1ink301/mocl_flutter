import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/mocl_text_styles.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/error/failures.dart';
import 'package:mocl_flutter/core/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/core/presentation/widgets/loading_widget.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/main/providers/main_providers.dart';
import 'package:mocl_flutter/features/app_shell/presentation/routes/mocl_routes.dart';

part 'widgets/mocl_main_widgets.dart';

class MainView extends ConsumerStatefulWidget {
  const MainView({super.key});

  @override
  MainViewState createState() => MainViewState();
}

class MainViewState extends ConsumerState<MainView> {
  @override
  Widget build(BuildContext context) => SafeArea(
    child: RefreshIndicator.adaptive(
      color: Theme.of(context).focusColor,
      onRefresh: () async =>
          ref.read(mainItemsNotifierProvider.notifier).refresh(),
      child: CustomScrollView(
        slivers: <Widget>[
          PlatformWidget(
            material: (_, _) => const _MainAppBar(),
            cupertino: (_, _) => const _MainNavigationBar(),
          ),
          const _MainBody(),
        ],
      ),
    ),
  );
}
