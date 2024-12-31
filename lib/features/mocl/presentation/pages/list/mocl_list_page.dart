import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/injection.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/bloc/list_page_cubit.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_list_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/text_styles_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/appbar_dual_text_widget.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/dummy_appbar.dart';

class MoclListPage extends StatelessWidget {
  const MoclListPage({super.key});

  static Widget withBloc(
    BuildContext context,
    MainItem item,
  ) =>
      BlocProvider(
        create: (context) => getIt<ListPageCubit>(param1: item),
        child: Builder(
          builder: (context) => AnnotatedRegion<SystemUiOverlayStyle>(
              value: Theme.of(context).appBarTheme.systemOverlayStyle!,
              child: const MoclListPage()),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final child = Scaffold(
      appBar: buildDummyAppbar(context),
      body: SafeArea(
        left: false,
        right: false,
        child: RefreshIndicator(
          onRefresh: context.read<ListPageCubit>().refresh,
          child: const CustomScrollView(
            slivers: <Widget>[
              _ListAppbar(),
              MoclListView(),
            ],
          ),
        ),
      ),
    );
    return Platform.isMacOS
        ? Listener(
            onPointerDown: (event) {
              if (event.buttons == kSecondaryMouseButton) {
                GoRouter.of(context).pop();
              }
            },
            child: child,
          )
        : child;
  }
}

class _ListAppbar extends StatelessWidget {
  const _ListAppbar();

  @override
  Widget build(BuildContext context) {
    final bloc = context.read<ListPageCubit>();
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
