import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/domain/entities/mocl_list_item.dart';
import 'package:mocl_flutter/features/mocl/presentation/di/app_provider.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/detail_appbar.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/mocl_detail_view.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/detail/providers/detail_providers.dart';

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
          appbarTextStyleProvider.overrideWithValue(Platform.isIOS
              ? CupertinoTheme.of(context).textTheme.navLargeTitleTextStyle
              : Theme.of(context).textTheme.labelMedium!),
        ],
        child: AnnotatedRegion<SystemUiOverlayStyle>(
          value: Theme.of(context).appBarTheme.systemOverlayStyle!,
          child: const DetailPage(),
        ),
      );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final child = PlatformScaffold(
      appBar: isCupertino(context)
          ? PlatformAppBar(
              cupertino: (BuildContext context, PlatformTarget platform) =>
                  CupertinoNavigationBarData(
                      previousPageTitle: ref.watch(detailSmallTitleProvider),
                      backgroundColor:
                          Theme.of(context).scaffoldBackgroundColor,
                      trailing: _buildPopupMenuButton(context, ref)),
            )
          : null,
      body: SafeArea(
        left: false,
        right: false,
        child: RefreshIndicator.adaptive(
          color: Theme.of(context).indicatorColor,
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

  Widget _buildPopupMenuButton(BuildContext context, WidgetRef ref) =>
      PlatformPopupMenu(
        icon: Icon(
          size: 24,
          context.platformIcon(
            material: Icons.more_vert_rounded,
            cupertino: CupertinoIcons.ellipsis,
          ),
        ),
        options: [
          PopupMenuOption(
            label: '새로고침',
            onTap: (_) => ref.read(detailsNotifierProvider.notifier).refresh(),
          ),
          PopupMenuOption(
            label: '브라우저로 열기',
            onTap: (_) {
              final String url = ref.read(detailUrlProvider);
              ref.read(openBrowserByUrlProvider(url));
            },
          ),
          PopupMenuOption(
            label: '공유하기',
            onTap: (_) {
              final String url = ref.read(detailUrlProvider);
              ref.read(shareUrlProvider(url));
            },
          ),
        ],
      );
}
