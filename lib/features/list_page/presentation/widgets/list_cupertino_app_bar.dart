import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mocl_flutter/features/list_page/presentation/state/list_event_mixin.dart';

import '../state/list_state_mixin.dart';

class ListCupertinoAppBar extends ConsumerWidget with ListState, ListEvent {
  const ListCupertinoAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      CupertinoSliverNavigationBar(
        heroTag: 'list-appbar',
        transitionBetweenRoutes: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        previousPageTitle: smallTitleState(ref),
        largeTitle: Text(titleState(ref)),
        padding: const EdgeInsetsDirectional.only(start: 5, end: 10),
        trailing: PlatformPopupMenu(
          icon: Icon(
            color: Theme.of(context).focusColor,
            size: 24,
            context.platformIcon(
              material: Icons.more_vert_rounded,
              cupertino: CupertinoIcons.ellipsis,
            ),
          ),
          options: [
            PopupMenuOption(label: '새로고침', onTap: (_) => handleRefresh(ref)),
          ],
        ),
      );
}
