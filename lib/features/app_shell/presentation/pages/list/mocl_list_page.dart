import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/app_shell/presentation/injection.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/list/bloc/list_paging_cubit.dart';
import 'package:mocl_flutter/features/app_shell/presentation/pages/list/mocl_list_view.dart';
import 'package:mocl_flutter/features/app_shell/presentation/widgets/appbar_dual_text_widget.dart';

@immutable
class MoclListPage extends StatelessWidget {
  const MoclListPage({super.key});

  static Widget withBloc(BuildContext context, MainItem item) =>
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (_) => getIt<ListPagingCubit>(param1: item),
          ),
        ],
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: Theme.of(context).appBarTheme.systemOverlayStyle!,
          child: const MoclListPage(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final Scaffold child = Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: context.read<ListPagingCubit>().refresh,
          child: const CustomScrollView(
            cacheExtent: 1000,
            slivers: <Widget>[_ListAppbar(), MoclListView()],
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

@immutable
class _ListAppbar extends StatelessWidget {
  const _ListAppbar();

  @override
  Widget build(BuildContext context) {
    final ListPagingCubit bloc = context.read<ListPagingCubit>();
    return AppbarDualTextWidget(
      smallTitle: bloc.smallTitle,
      title: bloc.title,
      automaticallyImplyLeading: Platform.isMacOS,
      actions: [
        IconButton(onPressed: bloc.refresh, icon: const Icon(Icons.refresh)),
      ],
    );
  }
}
