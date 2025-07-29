import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/app_shell/presentation/injection.dart';
import 'package:mocl_flutter/features/app_shell/presentation/widgets/message_widget.dart';
import 'package:mocl_flutter/features/settings/presentation/pages/settings/bloc/clear_data_cubit.dart';
import 'package:mocl_flutter/features/settings/presentation/pages/settings/bloc/get_version_cubit.dart';
import 'package:mocl_flutter/features/settings/presentation/pages/settings/settings_view.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static Widget withBloc(BuildContext context) => MultiBlocProvider(
    providers: [
      BlocProvider(create: (_) => getIt<GetVersionCubit>()),
      BlocProvider(create: (_) => getIt<ClearDataCubit>()),
    ],
    child: AnnotatedRegion<SystemUiOverlayStyle>(
      value: Theme.of(context).appBarTheme.systemOverlayStyle!,
      child: const SettingsPage(),
    ),
  );

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: Platform.isIOS
        ? AppBar(
            toolbarHeight: 0,
            flexibleSpace: Container(
              color: Theme.of(
                context,
              ).appBarTheme.systemOverlayStyle?.statusBarColor,
            ),
          )
        : null,
    body: SafeArea(
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            title: MessageWidget(
              message: SiteType.settings.title,
              textStyle: Theme.of(context).textTheme.labelMedium,
            ),
            scrolledUnderElevation: 0,
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            titleSpacing: 0,
            pinned: true,
            centerTitle: false,
            toolbarHeight: 64,
          ),
          const SettingsView(),
        ],
      ),
    ),
  );
}
