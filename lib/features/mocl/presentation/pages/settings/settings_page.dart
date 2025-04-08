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

  static Widget withBloc(
    BuildContext context,
  ) =>
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => getIt<GetVersionCubit>()..getVersion()),
          BlocProvider(create: (_) => getIt<ClearDataCubit>()),
        ],
        child: AnnotatedRegion<SystemUiOverlayStyle>(
            value: Theme.of(context).appBarTheme.systemOverlayStyle!,
            child: const SettingsPage()),
      );

  Widget _buildAppBar(
    BuildContext context,
  ) {
    final backgroundColor = Theme.of(context).appBarTheme.backgroundColor;
    return SliverAppBar(
      title: _buildTitle(context, SiteType.settings.title),
      // flexibleSpace: Container(color: backgroundColor),
      scrolledUnderElevation: 0,
      backgroundColor: backgroundColor,
      titleSpacing: 0,
      pinned: true,
      centerTitle: false,
      toolbarHeight: 64,
    );
  }

  Widget _buildTitle(BuildContext context, String title) => MessageWidget(
        message: title,
        textStyle: Theme.of(context).textTheme.labelMedium,
      );

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: Platform.isIOS
            ? AppBar(
                toolbarHeight: 0,
                flexibleSpace: Container(
                    color: Theme.of(context)
                        .appBarTheme
                        .systemOverlayStyle
                        ?.statusBarColor),
              )
            : null,
        body: SafeArea(
          child: CustomScrollView(
            slivers: <Widget>[
              _buildAppBar(context),
              const SettingsView(),
            ],
          ),
        ),
      );
}
