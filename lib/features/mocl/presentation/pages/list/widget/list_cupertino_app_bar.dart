import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/mocl/presentation/pages/list/providers/list_providers.dart';

class ListCupertinoAppBar extends ConsumerWidget {
  const ListCupertinoAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      CupertinoSliverNavigationBar(
        heroTag: 'list-appbar',
        transitionBetweenRoutes: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        previousPageTitle: ref.watch(listSmallTitleProvider),
        largeTitle: Text(ref.watch(listTitleProvider)),
        padding: const EdgeInsetsDirectional.only(start: 5, end: 10),
        trailing: PlatformPopupMenu(
          icon: Icon(
            color: Theme.of(context).highlightColor,
            size: 24,
            context.platformIcon(
              material: Icons.more_vert_rounded,
              cupertino: CupertinoIcons.ellipsis,
            ),
          ),
          options: [
            PopupMenuOption(
              label: '새로고침',
              onTap: (_) =>
                  ref.read(listStateNotifierProvider.notifier).refresh(),
            ),
          ],
        ),
      );
}
