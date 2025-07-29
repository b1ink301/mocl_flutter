import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/injection.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/settings/bloc/clear_data_cubit.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/settings/bloc/get_version_cubit.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/settings/settings_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/message_widget.dart';

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
