import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/injection.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/bloc/detail_view_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/bloc/get_height_cubit.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/detail_appbar.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/mocl_detail_view.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  static Widget withBloc(
    BuildContext context,
    SiteType siteType,
    ReadableListItem item,
  ) {
    final textStyle = Theme.of(context).textTheme.labelMedium!;
    final textWidth = MediaQuery.of(context).size.width;

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor:
            Theme.of(context).appBarTheme.systemOverlayStyle?.statusBarColor,
        statusBarBrightness: Brightness.dark));

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              getIt<DetailViewBloc>(param1: item, param2: siteType)
                ..add(const DetailViewEvent.details()),
        ),
        BlocProvider(
            create: (context) => getIt<GetHeightCubit>()
              ..getHeight(item.item.title, textStyle, textWidth)),
      ],
      child: const DetailPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    var statusBarColor =
        Theme.of(context).appBarTheme.systemOverlayStyle?.statusBarColor;
    var child = Scaffold(
      appBar: Platform.isIOS
          ? AppBar(
              toolbarHeight: 0,
              flexibleSpace: Container(color: statusBarColor),
            )
          : null,
      body: SafeArea(
        left: false,
        right: false,
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<DetailViewBloc>().refresh();
          },
          child: CustomScrollView(
            slivers: [
              const DetailAppBar(),
              const DetailView(),
            ],
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
