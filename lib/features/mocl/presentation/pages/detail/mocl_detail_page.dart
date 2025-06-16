import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/injection.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/bloc/detail_view_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/bloc/get_height_cubit.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/detail_appbar.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/mocl_detail_view.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  static Widget withBloc(
    BuildContext context,
    SiteType siteType,
    ListItem item,
  ) {
    final textStyle = Theme.of(context).textTheme.labelMedium!;
    final textWidth = MediaQuery.of(context).size.width;

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<DetailViewBloc>(param1: item, param2: siteType)
                ..add(const DetailViewEvent.details()),
        ),
        BlocProvider(
          create: (context) =>
              getIt<GetHeightCubit>()
                ..getHeight(item.title, textStyle, textWidth),
        ),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: Theme.of(context).appBarTheme.systemOverlayStyle!,
        child: const DetailPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final child = Scaffold(
      body: SafeArea(
        left: false,
        right: false,
        child: RefreshIndicator(
          onRefresh: () async => context.read<DetailViewBloc>().refresh(),
          child: const CustomScrollView(
            slivers: [DetailAppBar(), DetailView()],
          ),
        ),
      ),
    );

    return Platform.isMacOS
        ? Listener(
            onPointerDown: (event) {
              if (event.buttons == kSecondaryMouseButton) {
                Navigator.of(context).pop();
              }
            },
            child: child,
          )
        : child;
  }
}
