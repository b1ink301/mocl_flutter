import 'dart:io';

import 'package:easy_debounce/easy_throttle.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/injection.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/bloc/list_page_cubit.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_list_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/appbar_dual_text_widget.dart';

@immutable
class MoclListPage extends StatelessWidget {
  const MoclListPage({super.key});

  static Widget withBloc(
    BuildContext context,
    MainItem item,
  ) =>
      MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => getIt<ListPageCubit>(param1: item),
          ),
        ],
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: Theme.of(context).appBarTheme.systemOverlayStyle!,
          child: const MoclListPage(),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final ListPageCubit bloc = context.read<ListPageCubit>();
    final Scaffold child = Scaffold(
      body: SafeArea(
        left: false,
        right: false,
        child: RefreshIndicator(
          onRefresh: bloc.refresh,
          child: NotificationListener<ScrollNotification>(
            onNotification: (ScrollNotification scrollInfo) {
              if (scrollInfo is ScrollEndNotification) {
                if (context.mounted && scrollInfo.metrics.extentAfter < 100) {
                  EasyThrottle.throttle(
                    'list-fetch-throttle',
                    const Duration(milliseconds: 1000),
                    bloc.fetchPage,
                  );
                  return true;
                }
              }
              return false;
            },
            child: const CustomScrollView(
              cacheExtent: 500,
              slivers: <Widget>[
                _ListAppbar(),
                MoclListView(),
              ],
            ),
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
    final ListPageCubit bloc = context.read<ListPageCubit>();
    final String smallTitle = bloc.smallTitle;
    final String title = bloc.title;

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
