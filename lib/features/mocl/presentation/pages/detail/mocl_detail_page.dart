import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/detail_appbar.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/mocl_detail_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/providers/detail_providers.dart';
import 'package:mocl_flutter/features/mocl/presentation/widgets/dummy_appbar_widget.dart';

class DetailPage extends ConsumerWidget {
  const DetailPage({super.key});

  static Widget init(
    BuildContext context,
    ListItem item,
  ) =>
      ProviderScope(
        overrides: [
          listItemProvider.overrideWithValue(item),
          screenWidthProvider
              .overrideWithValue(MediaQuery.of(context).size.width),
          appbarTextStyleProvider
              .overrideWithValue(Theme.of(context).textTheme.labelMedium!),
        ],
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: Theme.of(context).appBarTheme.systemOverlayStyle!,
          child: const DetailPage(),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = Scaffold(
      appBar: DummyAppBarWidget.buildDummyAppbar(),
      body: SafeArea(
        left: false,
        right: false,
        child: RefreshIndicator(
          onRefresh: () async =>
              ref.read(detailsNotifierProvider.notifier).refresh(),
          child: const CustomScrollView(
            slivers: [
              DetailAppBar(),
              DetailView(),
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
