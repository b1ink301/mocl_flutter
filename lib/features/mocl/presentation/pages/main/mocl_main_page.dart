import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/domain/usecases/set_main_list.dart';
import 'package:mocl_flutter/features/mocl/presentation/injection.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/bloc/main_data_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/bloc/main_data_json_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/bloc/site_type_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/mocl_drawer_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/main/mocl_main_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  AppBar _buildAppBar(
    BuildContext context,
  ) {
    final siteType = context.watch<SiteTypeBloc>();
    return AppBar(
      title: _buildTitle(context, siteType.title),
      titleSpacing: 0,
      centerTitle: false,
      toolbarHeight: 64,
      actions: [
        Builder(
            builder: (context) => IconButton(
                  onPressed: () => handleAddButton(context, siteType.state),
                  icon: const Icon(Icons.add),
                ))
      ],
    );
  }

  void handleAddButton(BuildContext context, SiteType siteType) async {
    final result = await context.push<List<MainItem>>(
        '${Routes.MAIN}/${Routes.SET_MAIN_DLG}',
        extra: siteType);
    if (context.mounted && result != null) {
      final bloc = context.read<MainDataBloc>();
      final params = SetMainParams(siteType: siteType, list: result);
      bloc.setMainListWithParams(params);
    }
  }

  Widget _buildTitle(BuildContext context, String title) => MessageWidget(
        message: title,
        textStyle: Theme.of(context).textTheme.labelMedium,
      );

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<SiteTypeBloc>()),
        BlocProvider(create: (_) => getIt<MainDataJsonBloc>()),
        BlocProvider(
          create: (_) {
            final siteTypeBloc = context.read<SiteTypeBloc>();
            final dataBloc = getIt<MainDataBloc>();
            // final dataJsonBloc = getIt<MainDataJsonBloc>();
            log('[BlocProvider] siteType=$siteTypeBloc');

            siteTypeBloc.stream.listen((siteType) {
              dataBloc.add(MainDataEvent.getList(siteType: siteType));
            });

            dataBloc.add(MainDataEvent.getList(siteType: siteTypeBloc.state));
            return dataBloc;
          },
        ),
      ],
      child: Scaffold(
        drawer: _buildDrawer(context),
        appBar: _buildAppBar(context),
        body: const MainView(),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return DrawerWidget(onChangeSite: (siteType) {
      log('[onChangeSite] siteType=$siteType');
      context.read<SiteTypeBloc>().setSiteType(siteType);
    });
  }
}
