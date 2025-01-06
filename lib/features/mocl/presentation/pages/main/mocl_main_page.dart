import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/mocl_drawer_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/mocl_main_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/view_model/main_view_model.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/dummy_appbar.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  static Widget withBloc(
    BuildContext context,
  ) =>
      AnnotatedRegion<SystemUiOverlayStyle>(
          value: Theme.of(context).appBarTheme.systemOverlayStyle!,
          child: const MainPage());

  Widget _buildAppBar(
    BuildContext context,
  ) {
    final backgroundColor = Theme.of(context).appBarTheme.backgroundColor;

    return Consumer(
      builder: (context, ref, child) {
        final siteType = ref.watch(currentSiteTypeProvider);
        return SliverAppBar(
          title: _buildTitle(),
          flexibleSpace: Container(color: backgroundColor),
          backgroundColor: backgroundColor,
          titleSpacing: 0,
          floating: true,
          pinned: false,
          centerTitle: false,
          toolbarHeight: 64,
          actions: SiteType.naverCafe == siteType
              ? null
              : [
                  Consumer(builder: (context, ref, child) {
                    final viewModel = ref.read(mainViewModelProvider.notifier);
                    return IconButton(
                      onPressed: () =>
                          viewModel.handleAddButton(context, siteType),
                      icon: const Icon(Icons.add),
                    );
                  })
                ],
        );
      },
    );
  }

  Widget _buildTitle() => Consumer(
        builder: (context, ref, child) {
          final title = ref.watch(currentSiteTypeProvider).title;
          return MessageWidget(
            message: title,
            textStyle: Theme.of(context).textTheme.labelMedium,
          );
        },
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) => Scaffold(
        drawerEdgeDragWidth: MediaQuery.of(context).size.width,
        drawerEnableOpenDragGesture: true,
        drawer: _buildDrawer(),
        appBar: buildDummyAppbar(context),
        body: SafeArea(
          left: false,
          right: false,
          child: RefreshIndicator(
            onRefresh: () async {
              ref.read(mainViewModelProvider.notifier).reload();
            },
            child: CustomScrollView(
              // cacheExtent: 0,
              slivers: <Widget>[
                _buildAppBar(context),
                const MainView(),
              ],
            ),
          ),
        ),
      );

  Widget _buildDrawer() => Consumer(
        builder: (context, ref, child) {
          return DrawerWidget(onChangeSite: (newSiteType) {
            if (newSiteType == SiteType.settings) {
              // Fluttertoast.showToast(
              //     msg: "준비 중입니다.",
              //     toastLength: Toast.LENGTH_LONG,
              //     gravity: ToastGravity.BOTTOM,
              //     timeInSecForIosWeb: 2,
              //     backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
              //     textColor: Colors.white,
              //     fontSize: 16.0
              // );
              context.push(Routes.settings);
            } else {
              ref
                  .read(mainViewModelProvider.notifier)
                  .changeSiteType(newSiteType);
            }
          });
        },
      );
}
