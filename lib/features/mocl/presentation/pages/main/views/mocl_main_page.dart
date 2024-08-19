import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/providers/main_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';

import '../../../../domain/entities/mocl_site_type.dart';
import '../../../widgets/message_widget.dart';
import 'mocl_drawer_widget.dart';
import 'mocl_main_view.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  Widget _buildTitle(BuildContext context, String title) => MessageWidget(
        message: title,
        textStyle: Theme.of(context).textTheme.labelMedium,
      );

  AppBar _buildAppBar(BuildContext context, String title) => AppBar(
        title: _buildTitle(context, title),
        titleSpacing: 0,
        centerTitle: false,
        toolbarHeight: 64,
        actions: [
          Consumer(
            builder: (BuildContext context, WidgetRef ref, Widget? child) =>
                IconButton(
              onPressed: () async {
                final result = await context.push<List<MainItem>>(
                    '${Routes.MAIN}/${Routes.SET_MAIN_DLG}');

                if (result != null) {
                  await ref
                      .read(mainListStateProvider.notifier)
                      .setList(result);
                }
              },
              icon: const Icon(Icons.add),
            ),
          )
        ],
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // final siteType = ref.watch(currentSiteTypeProvider.select((value) => value));
    final SiteType currentSiteType = ref.watch(currentSiteTypeStateProvider);
    final String appTitle = ref.watch(mainTitleProvider);

    final drawerWidget = DrawerWidget(
      onChangeSite: (siteType) {
        ref.read(currentSiteTypeStateProvider.notifier).setSiteType(siteType);
      },
    );

    return Scaffold(
      drawer: drawerWidget,
      appBar: _buildAppBar(context, appTitle),
      body: MainView(siteType: currentSiteType),
    );
  }
}
