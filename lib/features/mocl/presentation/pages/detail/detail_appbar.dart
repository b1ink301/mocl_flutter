import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/injection.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/bloc/detail_view_bloc.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/bloc/get_height_cubit.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/detail_view_util.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/appbar_dual_text_widget.dart';

@immutable
class DetailAppBar extends StatelessWidget {
  const DetailAppBar({super.key});

  @override
  Widget build(BuildContext context) =>
      BlocBuilder<GetHeightCubit, GetHeightState>(
        builder: (BuildContext context, GetHeightState state) {
          switch (state) {
            case SuccessGetHeightState():
              final DetailViewBloc bloc = context.read<DetailViewBloc>();
              return AppbarDualTextWidget(
                title: bloc.title,
                smallTitle: bloc.smallTitle,
                automaticallyImplyLeading: Platform.isMacOS,
                toolbarHeight: state.height,
                actions: _buildPopupMenuButton(context),
              );
            default:
              return const SliverToBoxAdapter(child: SizedBox.shrink());
          }
        },
      );

  List<Widget> _buildPopupMenuButton(BuildContext context) => [
    PopupMenuButton<int>(
      icon: const Icon(Icons.more_vert),
      onSelected: (int value) {
        final DetailViewBloc detailViewBloc = context.read<DetailViewBloc>();
        switch (value) {
          case 0:
            detailViewBloc.refresh();
            break;
          case 1:
            final String url = detailViewBloc.itemUrl;
            getIt<DetailViewUtil>().openBrowserByUrl(url);
            break;
          case 2:
            final String url = detailViewBloc.itemUrl;
            getIt<DetailViewUtil>().shareUrl(url);
            break;
        }
      },
      itemBuilder: (BuildContext context) {
        final TextStyle? textStyle = Theme.of(context).textTheme.headlineSmall;
        return [
          PopupMenuItem(value: 0, child: Text('새로고침', style: textStyle)),
          PopupMenuItem(value: 1, child: Text('브라우저로 열기', style: textStyle)),
          PopupMenuItem(
            value: 2,
            enabled: Platform.isAndroid || Platform.isIOS,
            child: Text('공유하기', style: textStyle),
          ),
        ];
      },
    ),
  ];
}
