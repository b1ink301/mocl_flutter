import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/features/mocl/presentation/injection.dart';
import 'package:mocl_flutter/features/mocl/presentation/models/readable_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/bloc/detail_view_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/mocl_detail_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/appbar_dual_text_widget.dart';

class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  Widget _buildAppbar() => BlocBuilder<DetailViewBloc, DetailViewState>(
        buildWhen: (previous, current) => current is DetailHeight,
        builder: (context, state) {
          return state.maybeWhen(
              orElse: () => const SliverToBoxAdapter(child: SizedBox.shrink()),
              height: (state) {
                final bloc = context.read<DetailViewBloc>();
                return AppbarDualTextWidget(
                  title: bloc.title,
                  smallTitle: bloc.smallTitle,
                  automaticallyImplyLeading: Platform.isMacOS,
                  toolbarHeight: state,
                  actions: [
                    Builder(builder: (context) {
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
                        itemBuilder: (BuildContext context) => [
                          const PopupMenuItem(
                            value: 0,
                            child: Text('새로고침'),
                          ),
                          const PopupMenuItem(
                            value: 1,
                            child: Text('브라우저로 열기'),
                          ),
                        ],
                      );
                    }),
                  ],
                );
              });
        },
      );

  @override
  Widget build(BuildContext context) {
    final extra = GoRouterState.of(context).extra as List<dynamic>;

    final siteType = extra[0] as SiteType;
    final item = extra[1] as ReadableListItem;
    final textStyle = Theme.of(context).textTheme.labelMedium!;
    final width = MediaQuery.of(context).size.width;

    return BlocProvider(
      create: (context) => getIt<DetailViewBloc>()
        ..init(item, siteType)
        ..add(DetailViewEvent.height(item.item.title, textStyle, width))
        ..add(const DetailViewEvent.details()),
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            _buildAppbar(),
            SliverToBoxAdapter(
              child: DetailView(
                item: item,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
