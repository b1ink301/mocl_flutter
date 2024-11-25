import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_main_list.dart';
import 'package:mocl_flutter/features/mocl/presentation/injection.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/add_dialog/bloc/main_data_json_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/bloc/main_data_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/bloc/site_type_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/mocl_drawer_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/mocl_main_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/settings/bloc/get_version_cubit.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  static Widget withBloc(
    BuildContext context,
  ) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          Theme.of(context).appBarTheme.systemOverlayStyle?.statusBarColor,
    ));
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<MainDataJsonBloc>()),
        BlocProvider(
          create: (_) {
            final siteTypeBloc = context.read<SiteTypeBloc>();
            return getIt<MainDataBloc>()..initialize(siteTypeBloc);
          },
        ),
        BlocProvider(create: (_) {
          return getIt<GetVersionCubit>()..getVersion();
        }),
      ],
      child: const MainPage(),
    );
  }

  Widget _buildAppBar(
    BuildContext context,
  ) {
    final siteType = context.watch<SiteTypeBloc>();
    var backgroundColor = Theme.of(context).appBarTheme.backgroundColor;
    return SliverAppBar(
      title: _buildTitle(context, siteType.title),
      flexibleSpace: Container(color: backgroundColor),
      backgroundColor: backgroundColor,
      titleSpacing: 0,
      centerTitle: false,
      toolbarHeight: 64,
      actions: SiteType.naverCafe == siteType.state
          ? null
          : [
              Builder(
                  builder: (context) => IconButton(
                        onPressed: () =>
                            _handleAddButton(context, siteType.state),
                        icon: const Icon(Icons.add),
                      ))
            ],
    );
  }

  void _handleAddButton(BuildContext context, SiteType siteType) async {
    final result = await context.push<List<MainItem>>(
      Routes.setMainDlgFull,
      extra: siteType,
    );
    if (context.mounted && result != null) {
      context
          .read<MainDataBloc>()
          .addMainList(siteType: siteType, list: result);
    }
  }

  Widget _buildTitle(BuildContext context, String title) => MessageWidget(
        message: title,
        textStyle: Theme.of(context).textTheme.labelMedium,
      );

  @override
  Widget build(BuildContext context) {
    var statusBarColor =
        Theme.of(context).appBarTheme.systemOverlayStyle?.statusBarColor;

    return Scaffold(
      drawer: _buildDrawer(context),
      appBar: Platform.isIOS
          ? AppBar(
              toolbarHeight: 0,
              flexibleSpace: Container(color: statusBarColor),
            )
          : null,
      body: BlocListener<MainDataBloc, MainDataState>(
        listener: (BuildContext context, MainDataState state) {
          if (state is StateRequireLogin) {
            context.push(Routes.login);
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
              // cacheExtent: 0,
              slivers: <Widget>[
                _buildAppBar(context),
                const MainView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) =>
      DrawerWidget(onChangeSite: (siteType) {
        if (siteType == SiteType.settings) {
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
          context.read<SiteTypeBloc>().setSiteType(siteType);
        }
      });
}
