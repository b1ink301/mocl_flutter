import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/injection.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/bloc/detail_view_bloc.dart';
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

    return BlocProvider(
      create: (context) => getIt<DetailViewBloc>(param1: item, param2: siteType)
        ..add(DetailViewEvent.height(item.item.title, textStyle, textWidth))
        ..add(const DetailViewEvent.details()),
      child: const DetailPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    const child = Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          DetailAppBar(),
          SliverToBoxAdapter(child: DetailView()),
        ],
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
