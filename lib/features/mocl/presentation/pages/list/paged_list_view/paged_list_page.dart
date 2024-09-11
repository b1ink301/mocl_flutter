import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/injection.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/paged_list_view/bloc/paged_list_cubit.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/paged_list_view/paged_list_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/appbar_dual_text_widget.dart';

class PagedListPage extends StatelessWidget {
  const PagedListPage({super.key});

  static Widget withBloc(
    BuildContext context,
    MainItem item,
  ) {
    final textStyles = TextStyles.getTextStyles(context);

    return BlocProvider(
      create: (context) =>
          getIt<PagedListCubit>(param1: item, param2: textStyles),
      child: const PagedListPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    const child = Scaffold(
      body: CustomScrollView(
        slivers: <Widget>[
          _ListAppbar(),
          PagedListView(),
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

class _ListAppbar extends StatelessWidget {
  const _ListAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<PagedListCubit>();
    final smallTitle = bloc.smallTitle;
    final title = bloc.title;

    return AppbarDualTextWidget(
      smallTitle: smallTitle,
      title: title,
      automaticallyImplyLeading: Platform.isMacOS,
      actions: [
        IconButton(
          onPressed: bloc.refresh,
          icon: const Icon(Icons.refresh),
        )
      ],
    );
  }
}
