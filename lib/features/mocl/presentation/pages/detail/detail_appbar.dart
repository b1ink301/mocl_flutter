import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/bloc/detail_view_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/appbar_dual_text_widget.dart';

class DetailAppBar extends StatelessWidget {
  const DetailAppBar({super.key});

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
              actions: _buildPopupMenuButton(context),
            );
          },
        ),
      );

  List<Widget> _buildPopupMenuButton(BuildContext context) => [
        PopupMenuButton<int>(
          icon: const Icon(Icons.more_vert),
          onSelected: (int value) {
            switch (value) {
              case 0:
                context.read<DetailViewBloc>().refresh();
                break;
              case 1:
                context.read<DetailViewBloc>().openBrowserByItem();
                break;
              case 2:
                context.read<DetailViewBloc>().shareUri();
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
            PopupMenuItem(
              value: 2,
              enabled: Platform.isAndroid || Platform.isIOS,
              child: const Text('공유하기'),
            ),
          ],
        )
      ];
}
