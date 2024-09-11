import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/injection.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/bloc/detail_view_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/mocl_detail_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/appbar_dual_text_widget.dart';

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
      create: (context) => getIt<DetailViewBloc>()
        ..init(item, siteType)
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
          _DetailAppBar(),
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

class _DetailAppBar extends StatelessWidget {
  const _DetailAppBar();

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<DetailViewBloc, DetailViewState>(
        buildWhen: (previous, current) => current is DetailHeight,
        builder: (context, state) => state.maybeWhen(
          orElse: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
          height: (height) {
            final bloc = context.read<DetailViewBloc>();
            return AppbarDualTextWidget(
              title: bloc.title,
              smallTitle: bloc.smallTitle,
              automaticallyImplyLeading: Platform.isMacOS,
              toolbarHeight: height,
              actions: [
                _buildPopupMenuButton(context),
              ],
            );
          },
        ),
      );

  Widget _buildPopupMenuButton(BuildContext context) {
    final bloc = context.read<DetailViewBloc>();
    return PopupMenuButton<int>(
      onSelected: (int value) {
        switch (value) {
          case 0:
            bloc.refresh();
            break;
          case 1:
            bloc.openBrowserByItem();
            break;
        }
      },
      itemBuilder: (BuildContext context) => const [
        PopupMenuItem(
          value: 0,
          child: Text('새로고침'),
        ),
        PopupMenuItem(
          value: 1,
          child: Text('브라우저로 열기'),
        ),
      ],
    );
  }
}
