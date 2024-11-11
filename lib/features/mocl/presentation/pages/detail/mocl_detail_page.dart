import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/injection.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/bloc/detail_view_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/detail_appbar.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/mocl_detail_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/divider_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/nick_image_widget.dart';

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

    return BlocProvider(
      create: (context) => getIt<DetailViewBloc>(param1: item, param2: siteType)
        ..add(DetailViewEvent.height(item.item.title, textStyle, textWidth))
        ..add(const DetailViewEvent.details()),
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
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<DetailViewBloc>().refresh();
          },
          child: CustomScrollView(
            slivers: [
              const DetailAppBar(),
              SliverPersistentHeader(
                pinned: true,
                delegate: _HeaderSection(),
              ),
              const SliverToBoxAdapter(child: DetailView()),
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

class _HeaderSection extends SliverPersistentHeaderDelegate {
  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return BlocBuilder<DetailViewBloc, DetailViewState>(
        buildWhen: (previous, current) => current is DetailSuccess,
        builder: (context, state) {
          return state.maybeMap(
            orElse: () => SizedBox(height: Platform.isIOS ? 44 : 45),
            success: (state) => _buildBody(context, state),
          );
        });
  }

  Widget _buildBody(
    BuildContext context,
    DetailSuccess state,
  ) {
    final bodySmall = Theme.of(context).textTheme.bodySmall!;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final likeView =
        state.detail.likeCount.isNotEmpty && state.detail.likeCount != '0'
            ? [
                const SizedBox(width: 10),
                Icon(Icons.favorite_outline, color: bodySmall.color, size: 17),
                const SizedBox(width: 4),
                Text(state.detail.likeCount, style: bodySmall),
                const SizedBox(width: 10),
              ]
            : [];

    return Container(
      color: backgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      if (state.detail.userInfo.nickImage.isNotEmpty &&
                          state.detail.userInfo.nickImage.startsWith('http'))
                        NickImageWidget(url: state.detail.userInfo.nickImage),
                      Flexible(
                        child: Text(state.detail.info, style: bodySmall),
                      ),
                    ],
                  ),
                ),
                ...likeView,
              ],
            ),
          ),
          const DividerWidget(),
        ],
      ),
    );
  }

  @override
  double get maxExtent => Platform.isIOS ? 44 : 45;

  @override
  double get minExtent => Platform.isIOS ? 44 : 45;

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) {
    return false;
  }
}
