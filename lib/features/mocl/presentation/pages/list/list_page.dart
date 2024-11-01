import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_main_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/injection.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/bloc/list_page_cubit.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/list_view.dart'
    as listview;
import 'package:mocl_flutter/features/mocl/presentation/pages/list/mocl_text_styles.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/text_styles_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/appbar_dual_text_widget.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  static Widget withBloc(
    BuildContext context,
    MainItem item,
  ) {
    // final textStyles = TextStyles.getTextStyles(context);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor:
          Theme.of(context).appBarTheme.systemOverlayStyle?.statusBarColor,
    ));

    return BlocProvider(
      create: (context) => getIt<ListPageCubit>(param1: item),
      child: Builder(
        builder: (context) {
          final textStyles = TextStyles.getTextStyles(context);
          return TextStylesProvider(
            textStyles: textStyles,
            child: const ListPage(),
          );
        },
      ),
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
      body: const SafeArea(
        child: CustomScrollView(
          cacheExtent: 200,
          slivers: <Widget>[
            _ListAppbar(),
            listview.ListView(),
          ],
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

class _ListAppbar extends StatelessWidget {
  const _ListAppbar({super.key});

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
