import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:mocl_flutter/config/routes/mocl_app_pages.dart';
import 'package:mocl_flutter/core/domain/entities/mocl_site_type.dart';
import 'package:mocl_flutter/core/presentation/widgets/app_version_widget.dart';

import '../state/main_event_mixin.dart';
import '../state/main_state_mixin.dart';

class DrawerWidget extends ConsumerWidget with MainEvent {
  const DrawerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => Drawer(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    child: Column(
      children: [
        Container(
          color: Theme.of(context).primaryColor,
          padding: .only(top: MediaQuery.of(context).padding.top),
          height: 220 + MediaQuery.of(context).padding.top,
          child: Center(
            child: ClipOval(
              child: Image.asset('assets/icon.png', width: 80, height: 80),
            ),
          ),
        ),
        Expanded(
          child: ListView(
            shrinkWrap: true,
            padding: .zero,
            children: SiteType.values
                .map(
                  (SiteType siteType) => _DrawerSiteItem(
                    siteType: siteType,
                    onTap: () => _changeSiteType(
                      context,
                      siteType,
                      () => changeSiteType(ref, siteType),
                    ),
                  ),
                )
                .toList(),
          ),
        ),
        const AppVersionWidget(),
        SizedBox(height: MediaQuery.of(context).padding.bottom),
      ],
    ),
  );

  void _changeSiteType(
    BuildContext context,
    SiteType siteType,
    VoidCallback onChangeSiteType,
  ) {
    context.pop();

    if (siteType == .settings) {
      context.push(Routes.settings);
    } else {
      onChangeSiteType();
    }
  }
}

class _DrawerSiteItem extends ConsumerWidget with MainState {
  const _DrawerSiteItem({required this.siteType, required this.onTap});

  final SiteType siteType;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) => Column(
    children: [
      ListTile(
        title: Text(siteType.title),
        titleTextStyle: titleTextStyleState(ref),
        onTap: onTap,
        trailing: isSiteType(ref, siteType)
            ? Icon(Icons.check_outlined, color: Theme.of(context).focusColor)
            : null,
      ),
      const Divider(height: 1, thickness: 1, indent: 12, endIndent: 8),
    ],
  );
}
