import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/app_shell/presentation/injection.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/main/add_dialog/bloc/main_data_json_bloc.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/main/bloc/main_data_bloc.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/main/bloc/site_type_bloc.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/main/mocl_drawer_widget.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/main/mocl_main_view.dart';
import 'package:mocl_flutter/features/app_shell/presentation/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/features/app_shell/presentation/widgets/message_widget.dart';
import 'package:mocl_flutter/features/settings/presentation/pages/settings/bloc/get_version_cubit.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static Widget withBloc(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => getIt<MainDataJsonBloc>()),
      BlocProvider(
        create: (_) {
          final siteTypeBloc = context.read<SiteTypeBloc>();
          return getIt<MainDataBloc>()..initialize(siteTypeBloc);
        },
      ),
      BlocProvider(create: (_) => getIt<GetVersionCubit>()),
    ],
    child: AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).appBarTheme.systemOverlayStyle!,
      child: const MainPage(),
    ),
  );

  Widget _buildAppBar(BuildContext context) {
    final siteType = context.watch<SiteTypeBloc>();
    final backgroundColor = Theme.of(context).appBarTheme.backgroundColor;

    return SliverAppBar(
      title: MessageWidget(
        message: siteType.title,
        textStyle: Theme.of(context).textTheme.labelMedium,
      ),
      flexibleSpace: Container(color: backgroundColor),
      backgroundColor: backgroundColor,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      floating: true,
      pinned: false,
      centerTitle: false,
      toolbarHeight: 64,
      actions: SiteType.naverCafe == siteType.state
          ? null
          : [
              Builder(
                builder: (BuildContext context) => IconButton(
                  onPressed: () => _handleAddButton(context, siteType.state),
                  icon: const Icon(Icons.add),
                ),
              ),
            ],
    );
  }

  void _handleAddButton(BuildContext context, SiteType siteType) async {
    final List<MainItem>? result = await context.push<List<MainItem>>(
      Routes.setMainDlgFull,
      extra: siteType,
    );
    if (context.mounted && result != null) {
      context.read<MainDataBloc>().addMainList(
        siteType: siteType,
        list: result,
      );
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    drawerEdgeDragWidth: MediaQuery.of(context).size.width,
    drawerEnableOpenDragGesture: true,
    drawer: _buildDrawer(context),
    body: BlocListener<MainDataBloc, MainDataState>(
      listener: (BuildContext context, MainDataState state) async {
        if (state is StateRequireLogin) {
          final result = await context.push<bool>(Routes.login) ?? false;
          if (context.mounted && result) {
            final siteType = context.read<SiteTypeBloc>().state;
            context.read<MainDataBloc>().refresh(siteType);
          }
        }
      },
      child: SafeArea(
        left: false,
        right: false,
        child: RefreshIndicator(
          onRefresh: () async {
            final siteTypeBloc = context.read<SiteTypeBloc>();
            context.read<MainDataBloc>().refresh(siteTypeBloc.state);
          },
          child: CustomScrollView(
            slivers: <Widget>[_buildAppBar(context), const MainView()],
          ),
        ),
      ),
    ),
  );

  Widget _buildDrawer(BuildContext context) => DrawerWidget(
    onChangeSite: (siteType) {
      if (siteType == SiteType.settings) {
        context.push(Routes.settings);
      } else {
        context.read<SiteTypeBloc>().setSiteType(siteType);
      }
    },
  );
}
